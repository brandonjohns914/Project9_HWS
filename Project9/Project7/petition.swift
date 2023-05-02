//
//  petition.swift
//  Project7
//
//  Created by Brandon Johns on 4/27/23.
//

import Foundation


struct Petition: Codable                                                //Codable allows json to be decodable
{
    var title: String
    var body: String
    var signatureCount: Int
    
}
