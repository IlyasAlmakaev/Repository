//
//  RepositoryInfo.swift
//  Repositories
//
//  Created by Ильяс on 17/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import Foundation

class RepositoryInfo {
    
    var id: Int?
    var fullName: String?
    var description: String?
    var homepage: String?
    var language: String?
    var watchers: Int?
    var stargazersCount: Int?
    var forks: Int?
    
    init() {}
    
    required init(map: AnyObject?) {
        guard let map = map as? [String: AnyObject] else { return }
        self.id = map["id"] as? Int
        self.fullName = map["full_name"] as? String
        self.description = map["description"] as? String
        self.homepage = map["homepage"] as? String
        self.language = map["language"] as? String
        self.watchers = map["watchers"] as? Int
        self.stargazersCount = map["stargazers_count"] as? Int
        self.forks = map["forks"] as? Int
    }
}
