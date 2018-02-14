//
//  MovieRepository.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MovieRepository {
    
    var apiUrl: String {get}
    
    func discoverMovies(completionHandler: @escaping (JSON?, Error?) -> ())
    
    
    
    func discoverPeople(completionHandler: @escaping (JSON?, Error?) -> ())
}
