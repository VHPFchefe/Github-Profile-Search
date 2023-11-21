import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterCellDelegate, UITextFieldDelegate {
    var user: User?
    var repos : [Repository]?
    var tempRepos: [Repository]?
    var login : String = "The login will be replaced"
    var image : UIImage = UIImage()
    var repositoryName: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.register(UINib(nibName: "CellView", bundle: nil), forCellReuseIdentifier: "CellView")
        tableView.delegate = self
        tableView.dataSource = self
        Task {
            await loadUser()
            await loadRepos()
            await loadImage()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func reloadReposData(name : String) async {
        repos = tempRepos?.filter({$0.name.lowercased().contains(name.lowercased())})
        if let count = repos?.count, count > 0 {
            DispatchQueue.main.async {
                    self.tableView.reloadSections( IndexSet(integer: 1), with: UITableView.RowAnimation.none)
            }
        }
    }
    
    func loadUser() async {
        do {
            self.user = try await getUser(login : login)
        } catch GitHubError.invalidData {
            print("Invalid User Data!")
        } catch GitHubError.invalidURL {
            print("Invalid User URL!")
        } catch {
            print("Unexpected User Error!")
        }
    }
    
    func loadImage() async {
        do {
            guard let avatarURL = user?.avatarUrl else { throw GitHubError.invalidData }
            self.image = try await getUserImage(url: avatarURL)
        } catch GitHubError.invalidData {
            print("Invalid Image Data!")
        } catch GitHubError.invalidURL {
            print("Invalid Image URL!")
        } catch {
            print("Unexpected Image Error!")
        }
    }
    
    func loadRepos() async {
        do {
            guard let reposUrl = user?.reposUrl else { throw GitHubError.invalidData }
            repos =  try await getRepos(endPointRepos: reposUrl)
            tempRepos = repos
        } catch GitHubError.invalidData {
            print("Invalid Repository Data!")
        } catch GitHubError.invalidResponse {
            print("Invalid Repository Response!")
        } catch GitHubError.invalidURL {
            print("Invalid Repository URL!")
        } catch {
            print("Unexpected Repository Error!")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
            if let count = repos?.count{
                return count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell else {
                return FilterCell()
            }
            cell.delegate = self
            cell.configFilterCell()
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellView") as? CellView else {
                return CellView()
            }
            //if let repos = repos {
              //  print(repos.count)
            //}else {
              //  print("havent repos")
            //}
            
            let index = indexPath.row
            if(index >= 0) {
                print(index)
                guard let repos = repos?[index] else {
                    return CellView()
                }
                cell.configuraCell(repository: repos)
                return cell
            }else {
                return CellView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 50
        }else{
            return 186
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 250
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0) {
            let headerView = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as? HeaderCell
            if let user = self.user, let repos = self.repos {
                headerView?.configuraView(image: self.image, user: user, repos: repos)
            }
            return headerView
        }
        return HeaderCell()
    }
    
    func didTapButton(_ sender: UIButton, on cell: FilterCell) {
        performSegue(withIdentifier: "segueOptionsAndFilters", sender: sender)
        
        /*
         let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
         storyboard.modalPresentationStyle = .overFullScreen
         self.navigationController?.pushViewController(storyboard, animated: true)*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didEndOnExit(_ sender: Any){
        self.view.endEditing(true)
    }
    
    func editingChanged(_ sender: UITextField) {
        //print(sender.text ?? "Empty")
        if let repositoryName = sender.text {
            Task {
                if(!repositoryName.isEmpty){
                    await reloadReposData(name: repositoryName)
                }
                else{
                    DispatchQueue.main.async {
                        self.repos = self.tempRepos
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}



