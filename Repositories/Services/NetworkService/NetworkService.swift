//
//  NetworkService.swift
//  Repositories
//
//  Created by Ильяс on 15/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

class NetworkService {
    
    let baseUrl = "https://api.github.com/search/repositories"
    
    func getRepositories(successHundler: @escaping (NSArray) -> Void,
                         errorHundler: @escaping (Error) -> Void) {
        let parameters = "?q=stars:0..*&sort=stars"
        let url = baseUrl + parameters
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    errorHundler(error)
                }
            case .success:
                if let result = response.result.value as? NSDictionary  {
                    if let arraySchedule = result["items"] as! NSArray? {
                        DispatchQueue.main.async {
                            successHundler(arraySchedule)
                        }
                    }
                }
            }
        }
    }
}
