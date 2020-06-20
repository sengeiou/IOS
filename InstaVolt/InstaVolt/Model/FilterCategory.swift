//
//  FilterCategory.swift
//  InstaVolt
//
//  Created by PCQ177 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

class FilterCategory
{
    var id: Int?
    var name: String?
    var subCategoryName: [FilterSubCategoryDetail]?
    var isSelected: Bool = false
    
    init(id: Int,name: String, subCategoryArray: [FilterSubCategoryDetail]) {
        self.id = id
        self.name = name
        subCategoryName = subCategoryArray
    }
}
