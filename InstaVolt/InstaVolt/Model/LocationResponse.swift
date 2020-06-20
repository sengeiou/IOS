//
//  LocationResponse.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct LocationResponse : Codable
{
    let message : Generic?
    let data : LocationData?

    enum CodingKeys: String, CodingKey
    {
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(Generic.self, forKey: .message)
        data = try values.decodeIfPresent(LocationData.self, forKey: .data)
    }
}

struct LocationData : Codable
{
    let count : Generic?
    let rows : [Location]?

    enum CodingKeys: String, CodingKey
    {
        case count = "count"
        case rows = "rows"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Generic.self, forKey: .count)
        rows = try values.decodeIfPresent([Location].self, forKey: .rows)
    }
}

struct Location : Codable
{
    let id : Generic?
    let cp_id : Generic?
    let type_id : Generic?
    let type : Type?
    let name : Generic?
    let address : Generic?
    let city : Generic?
    let postal_code : Generic?
    let country : Generic?
    var latitude : Generic?
    var longitude : Generic?
    let directions : Generic?
    let time_zone : Generic?
    let last_updated : Generic?
    let charging_when_closed : Generic?
    let auth_id_type : Generic?
    let is_public : Generic?
    let plugin_dependency : Generic?
    let stations_has_restrictions : Generic?
    let station_usage_restrictions : Generic?
    let support_name : Generic?
    let support_phone : Generic?
    let is_green_energy : Generic?
    let supplier_name : Generic?
    let energy_product_name : Generic?
    let twentyfourseven : Generic?
    let modified_date : Generic?
    let available_stations : Generic?
    let in_use_stations : Generic?
    let distance : Generic?
    let max_charging_power : Generic?
    let max_charging_power_unit : Generic?
    let facilities : [Facilities]?
    let charge_location_images : [Charge_location_images]?

    enum CodingKeys: String, CodingKey
    {
        case id = "id"
        case cp_id = "cp_id"
        case type_id = "type_id"
        case type = "type"
        case name = "name"
        case address = "address"
        case city = "city"
        case postal_code = "postal_code"
        case country = "country"
        case latitude = "latitude"
        case longitude = "longitude"
        case directions = "directions"
        case time_zone = "time_zone"
        case last_updated = "last_updated"
        case charging_when_closed = "charging_when_closed"
        case auth_id_type = "auth_id_type"
        case is_public = "is_public"
        case plugin_dependency = "plugin_dependency"
        case stations_has_restrictions = "stations_has_restrictions"
        case station_usage_restrictions = "station_usage_restrictions"
        case support_name = "support_name"
        case support_phone = "support_phone"
        case is_green_energy = "is_green_energy"
        case supplier_name = "supplier_name"
        case energy_product_name = "energy_product_name"
        case twentyfourseven = "twentyfourseven"
        case modified_date = "modified_date"
        case available_stations = "available_stations"
        case in_use_stations = "in_use_stations"
        case distance = "distance"
        case max_charging_power = "max_charging_power"
        case max_charging_power_unit = "max_charging_power_unit"
        case facilities = "facilities"
        case charge_location_images = "charge_location_images"
    }
    
    init(from latitude : Generic, longitude : Generic)
    {
        self.latitude = latitude
        self.longitude = longitude
        self.id = 0
        self.cp_id = 0
        self.type_id = 0
        self.type = nil
        self.name = 0
        self.address = 0
        self.city = 0
        self.postal_code = 0
        self.country = 0
        self.directions = 0
        self.time_zone = 0
        self.last_updated = 0
        self.charging_when_closed = 0
        self.auth_id_type = 0
        self.is_public = 0
        self.plugin_dependency = 0
        self.stations_has_restrictions = 0
        self.station_usage_restrictions = 0
        self.support_name = 0
        self.support_phone = 0
        self.is_green_energy = 0
        self.supplier_name = 0
        self.energy_product_name = 0
        self.twentyfourseven = 0
        self.modified_date = 0
        self.available_stations = 0
        self.in_use_stations = 0
        self.distance = 0
        self.max_charging_power = 0
        self.max_charging_power_unit = 0
        self.facilities = [Facilities]()
        self.charge_location_images = [Charge_location_images]()
        self.latitude = 0
        self.longitude = 0
     }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Generic.self, forKey: .id)
        cp_id = try values.decodeIfPresent(Generic.self, forKey: .cp_id)
        type_id = try values.decodeIfPresent(Generic.self, forKey: .type_id)
        type = try values.decodeIfPresent(Type.self, forKey: .type)
        name = try values.decodeIfPresent(Generic.self, forKey: .name)
        address = try values.decodeIfPresent(Generic.self, forKey: .address)
        city = try values.decodeIfPresent(Generic.self, forKey: .city)
        postal_code = try values.decodeIfPresent(Generic.self, forKey: .postal_code)
        country = try values.decodeIfPresent(Generic.self, forKey: .country)
        latitude = try values.decodeIfPresent(Generic.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Generic.self, forKey: .longitude)
        directions = try values.decodeIfPresent(Generic.self, forKey: .directions)
        time_zone = try values.decodeIfPresent(Generic.self, forKey: .time_zone)
        last_updated = try values.decodeIfPresent(Generic.self, forKey: .last_updated)
        charging_when_closed = try values.decodeIfPresent(Generic.self, forKey: .charging_when_closed)
        auth_id_type = try values.decodeIfPresent(Generic.self, forKey: .auth_id_type)
        is_public = try values.decodeIfPresent(Generic.self, forKey: .is_public)
        plugin_dependency = try values.decodeIfPresent(Generic.self, forKey: .plugin_dependency)
        stations_has_restrictions = try values.decodeIfPresent(Generic.self, forKey: .stations_has_restrictions)
        station_usage_restrictions = try values.decodeIfPresent(Generic.self, forKey: .station_usage_restrictions)
        support_name = try values.decodeIfPresent(Generic.self, forKey: .support_name)
        support_phone = try values.decodeIfPresent(Generic.self, forKey: .support_phone)
        is_green_energy = try values.decodeIfPresent(Generic.self, forKey: .is_green_energy)
        supplier_name = try values.decodeIfPresent(Generic.self, forKey: .supplier_name)
        energy_product_name = try values.decodeIfPresent(Generic.self, forKey: .energy_product_name)
        twentyfourseven = try values.decodeIfPresent(Generic.self, forKey: .twentyfourseven)
        modified_date = try values.decodeIfPresent(Generic.self, forKey: .modified_date)
        available_stations = try values.decodeIfPresent(Generic.self, forKey: .available_stations)
        in_use_stations = try values.decodeIfPresent(Generic.self, forKey: .in_use_stations)
        distance = try values.decodeIfPresent(Generic.self, forKey: .distance)
        max_charging_power = try values.decodeIfPresent(Generic.self, forKey: .max_charging_power)
        max_charging_power_unit = try values.decodeIfPresent(Generic.self, forKey: .max_charging_power_unit)
        facilities = try values.decodeIfPresent([Facilities].self, forKey: .facilities)
        charge_location_images = try values.decodeIfPresent([Charge_location_images].self, forKey: .charge_location_images)
    }
}


struct Type : Codable
{
    let id : Generic?
    let name : Generic?
    let code : Generic?

    enum CodingKeys: String, CodingKey
    {
        case id = "id"
        case name = "name"
        case code = "code"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Generic.self, forKey: .id)
        name = try values.decodeIfPresent(Generic.self, forKey: .name)
        code = try values.decodeIfPresent(Generic.self, forKey: .code)
    }
}

struct Charge_location_images : Codable
{
    let id : Generic?
    let charge_location_id : Generic?
    let charge_location_business_id : Generic?
    let category : Generic?
    let url : Generic?
    let thumbnail : Generic?
    let type : Generic?
    let width : Generic?
    let height : Generic?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case charge_location_id = "charge_location_id"
        case charge_location_business_id = "charge_location_business_id"
        case category = "category"
        case url = "url"
        case thumbnail = "thumbnail"
        case type = "type"
        case width = "width"
        case height = "height"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Generic.self, forKey: .id)
        charge_location_id = try values.decodeIfPresent(Generic.self, forKey: .charge_location_id)
        charge_location_business_id = try values.decodeIfPresent(Generic.self, forKey: .charge_location_business_id)
        category = try values.decodeIfPresent(Generic.self, forKey: .category)
        url = try values.decodeIfPresent(Generic.self, forKey: .url)
        thumbnail = try values.decodeIfPresent(Generic.self, forKey: .thumbnail)
        type = try values.decodeIfPresent(Generic.self, forKey: .type)
        width = try values.decodeIfPresent(Generic.self, forKey: .width)
        height = try values.decodeIfPresent(Generic.self, forKey: .height)
    }

}

struct Facilities : Codable
{
    let name : Generic?
    let code : Generic?
    let image : Generic?
    let description : Generic?

    enum CodingKeys: String, CodingKey
    {
        case name = "name"
        case code = "code"
        case image = "image"
        case description = "description"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(Generic.self, forKey: .name)
        code = try values.decodeIfPresent(Generic.self, forKey: .code)
        image = try values.decodeIfPresent(Generic.self, forKey: .image)
        description = try values.decodeIfPresent(Generic.self, forKey: .description)
    }
}

