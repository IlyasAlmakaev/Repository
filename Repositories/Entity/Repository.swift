//
//  Repository.swift
//  Repositories
//
//  Created by Ильяс on 15/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import Foundation

class Repository {

    var id: Int?
    var fullName: String?
    var language: String?
    var stargazersCount: Int?
    
    init() {}
    
    required init(map: AnyObject?) {
        guard let map = map as? [String: AnyObject] else { return }
        self.id = map["id"] as? Int
        self.fullName = map["full_name"] as? String
        self.language = map["language"] as? String
        self.stargazersCount = map["stargazers_count"] as? Int
    }
}
