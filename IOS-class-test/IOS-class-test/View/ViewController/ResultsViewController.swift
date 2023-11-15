import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var repos : [Repository]?
    var numberOfRows : Int = 0
    var login : String = "The login will be replaced"
    var image : UIImage = UIImage()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellView", bundle: nil), forCellReuseIdentifier: "CellView")
        tableView.delegate = self
        tableView.dataSource = self
        Task {
            await loadUser()
            await loadRepos()
            await loadImage()
            await getNuberOfRows()
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    
    func getNuberOfRows() async {
        if let count = repos?.count {
            numberOfRows = count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellView") as? CellView else {
            return CellView()
        }
        
        guard let repos = repos?[indexPath.row] else {
            return CellView()
        }
        
        cell.configuraCell(repository: repos)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 186  : 475
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as? HeaderCell
        if let user = self.user, let repos = self.repos {
            headerView?.configuraView(image: self.image, user: user, repos: repos)
        }
        return headerView
    }
    
    
    @IBAction func openMenuFilterAndOrder(_ sender: Any) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}



