//
//  Petition.swift
//  Project7
//
//  Created by Hafizh Caesandro Kevinoza on 07/04/22.
//

import Foundation

// Codable = A type that can convert itself into and out of an external representation.
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
