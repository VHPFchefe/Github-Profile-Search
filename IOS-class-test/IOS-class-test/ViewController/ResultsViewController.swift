//
//  ResultsViewController.swift
//  IOS-class-test
//
//  Created by Vinicius Floriano on 10/11/23.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var repos : Repository?
    var userName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*        Task{
            await loadRepos()
        }*/
    }

    @IBOutlet weak var userProfileImage: UIImageView!
    
}
