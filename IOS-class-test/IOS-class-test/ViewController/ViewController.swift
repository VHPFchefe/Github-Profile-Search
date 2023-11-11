import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userNameTextView: UITextField?
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func searchUser(_ sender: Any) {
        if let userName = userNameTextView?.text, !userName.isEmpty {
            print("There is userName")
            print(userName)
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            storyboard.userName = userName
            
            self.navigationController?.pushViewController(storyboard, animated: true)
            
        } else {
            // add a message for the user
        }
        
    }
}
