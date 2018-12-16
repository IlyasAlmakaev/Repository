//
//  RepositoryInfoViewController.swift
//  Repositories
//
//  Created by Ильяс on 17/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import UIKit

class RepositoryInfoViewController: UIViewController {
    
    var repositoryInfo: RepositoryInfo?
    @IBOutlet var fullName: UILabel!
    @IBOutlet var repositoryDescription: UILabel!
    @IBOutlet var homepage: UITextView!
    @IBOutlet var language: UILabel!
    @IBOutlet var watch: UILabel!
    @IBOutlet var star: UILabel!
    @IBOutlet var fork: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullName.text = repositoryInfo?.fullName
        repositoryDescription.text = repositoryInfo?.description
        homepage.text = repositoryInfo?.homepage
        language.text = repositoryInfo?.language
        watch.text = "Watch " + String(repositoryInfo?.watchers ?? 0)
        star.text = "Star " + String(repositoryInfo?.stargazersCount ?? 0)
        fork.text = "Fork " + String(repositoryInfo?.forks ?? 0)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
