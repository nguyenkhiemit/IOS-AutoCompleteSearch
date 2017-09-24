//
//  Repository.swift
//  RxAlamofileTest
//
//  Created by Nguyen on 9/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
    
    var identifier: Int!
    var language: Int!
    var url: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
