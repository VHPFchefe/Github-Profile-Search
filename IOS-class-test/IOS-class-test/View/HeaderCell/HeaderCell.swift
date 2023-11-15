import UIKit

class HeaderCell : UIView {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var login: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var followCount: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var starsCount: UILabel!
    
    @IBOutlet weak var reposCount: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    func configuraView(image : UIImage, user : User, repos : [Repository]){
        self.userImage.image = image
        self.userName.text = user.name
        self.login.text = user.login
        self.location.text = user.location
        self.followCount.text = "\(user.following)"
        self.followersCount.text = "\(user.followers)"
        self.starsCount.text = "\(repos.reduce(0) { $0 + $1.stargazersCount })"
        self.reposCount.text = "\(user.publicRepos)"
        self.bio.text = user.bio
        userImage.layer.cornerRadius = min(userImage.frame.width, userImage.frame.height) / 2
        userImage.layer.masksToBounds = true
    }
}


