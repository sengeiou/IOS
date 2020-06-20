//
//  FilterSubCategory.swift
//  InstaVolt
//
//  Created by PCQ177 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct FilterSubCategory: Codable {

    let data    : FilterSubCategoryData?
    
    enum CodingKeys: String, CodingKey {
        case data   = "data"
    }
}

struct FilterSubCategoryData: Codable {
    let distance : [FilterSubCategoryDetail]?
    let status : [FilterSubCategoryDetail]?
    let amenities : [FilterSubCategoryDetail]?
    let power_types : [FilterSubCategoryDetail]?
    let connector_types : [FilterSubCategoryDetail]?
    let network : [FilterSubCategoryDetail]?

    enum CodingKeys: String, CodingKey {
        case distance = "distance"
        case status = "status"
        case amenities = "amenities"
        case power_types = "power_types"
        case connector_types = "connector_types"
        case network = "network"
    }
}
class FilterSubCategoryDetail: Codable {
    let id : Generic?
    let name : Generic?
    let code : Generic?
    let description : Generic?
    let image : Generic?
    let lookupId : Generic?
    let color : Generic?
    let active : Generic?
    let defaultSearch : Generic?
    let from : Generic?
    let to : Generic?
    
    var isSelected  : Bool = false

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case code = "code"
        case description = "description"
        case lookupId   = "lookup_id"
        case image = "image"
        case color = "color"
        case active = "active"
        case defaultSearch = "default_search"
        case from = "from"
        case to = "to"
    }
}
