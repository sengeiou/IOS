//
//  LocationJSON.swift
//  InstaVolt
//
//  Created by PCQ111 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
struct JSONObjectLocation {
    static let LocationDetails: [String: Any] = [
        "message":"location details successful",
        "data":[
            "count" : 5,
            "rows"  : [
                [
                    "id":1,
                    "cp_id":"asdf1234",
                    "type_id":1,
                    "type":[
                        "id":1,
                        "name":"On Street",
                        "code":"ON_STREET"
                    ],
                    "name":"Ireland Charging Location 1",
                    "address":"An Cnoc agus Draighneach",
                    "city":"Ireland City",
                    "postal_code":"47545",
                    "country":"Ireland",
                    "latitude":"53.557701",
                    "longitude":"-8.561364",
                    "directions":"directions",
                    "time_zone":"Europe/Ireland",
                    "last_updated":"null",
                    "charging_when_closed":false,
                    "auth_id_type":"null",
                    "is_public":true,
                    "plugin_dependency":"null",
                    "stations_has_restrictions":true,
                    "station_usage_restrictions":true,
                    "support_name":"Test",
                    "support_phone":"123456789",
                    "is_green_energy":true,
                    "supplier_name":"Test",
                    "energy_product_name":"Test",
                    "twentyfourseven":true,
                    "modified_date":"null",
                    "available_stations":2,
                    "in_use_stations":1,
                    "distance":"13 mi away",
                    "max_charging_power":125,
                    "max_charging_power_unit":"mW (DC)",
                    "facilities":[
                        [
                            "name":"Hotel",
                            "code":"HOTEL",
                            "image":"/images/hotel.png",
                            "description":"This is hotel location"
                        ]
                    ]
                ],
                [
                    "id":2,
                    "cp_id":"asdf12345",
                    "type_id":1,
                    "type":[
                        "id":1,
                        "name":"On Street",
                        "code":"ON_STREET"
                    ],
                    "name":"Ireland Charging Location 2",
                    "address":"An Cnoc agus Draighneach",
                    "city":"Ireland City",
                    "postal_code":"47545",
                    "country":"Ireland",
                    "latitude":"53.327628",
                    "longitude":"-8.243768",
                    "directions":"directions",
                    "time_zone":"Europe/Ireland",
                    "last_updated":"null",
                    "charging_when_closed":false,
                    "auth_id_type":"null",
                    "is_public":true,
                    "plugin_dependency":"null",
                    "stations_has_restrictions":true,
                    "station_usage_restrictions":true,
                    "support_name":"Test",
                    "support_phone":"123456789",
                    "is_green_energy":true,
                    "supplier_name":"Test",
                    "energy_product_name":"Test",
                    "twentyfourseven":true,
                    "modified_date":"null",
                    "available_stations":1,
                    "in_use_stations":1,
                    "distance":"13 mi away",
                    "max_charging_power":125,
                    "max_charging_power_unit":"mW (DC)",
                    "facilities":[
                        [
                            "name":"Hotel",
                            "code":"HOTEL",
                            "image":"/images/hotel.png",
                            "description":"This is hotel location"
                        ]
                    ]
                ],
                [
                    "id":3,
                    "cp_id":"asdf1234",
                    "type_id":1,
                    "type":[
                        "id":1,
                        "name":"On Street",
                        "code":"ON_STREET"
                    ],
                    "name":"Ireland Charging Location 3",
                    "address":"An Cnoc agus Draighneach",
                    "city":"Ireland City",
                    "postal_code":"47545",
                    "country":"Ireland",
                    "latitude":"53.459681",
                    "longitude":"-8.055937",
                    "directions":"directions",
                    "time_zone":"Europe/Ireland",
                    "last_updated":"null",
                    "charging_when_closed":false,
                    "auth_id_type":"null",
                    "is_public":true,
                    "plugin_dependency":"null",
                    "stations_has_restrictions":true,
                    "station_usage_restrictions":true,
                    "support_name":"Test",
                    "support_phone":"123456789",
                    "is_green_energy":true,
                    "supplier_name":"Test",
                    "energy_product_name":"Test",
                    "twentyfourseven":true,
                    "modified_date":"null",
                    "available_stations":5,
                    "in_use_stations":2,
                    "distance":"13 mi away",
                    "max_charging_power":125,
                    "max_charging_power_unit":"mW (DC)",
                    "facilities":[
                        [
                            "name":"Hotel",
                            "code":"HOTEL",
                            "image":"/images/hotel.png",
                            "description":"This is hotel location"
                        ]
                    ]
                ],
                [
                    "id":4,
                    "cp_id":"asdf12346",
                    "type_id":1,
                    "type":[
                        "id":1,
                        "name":"On Street",
                        "code":"ON_STREET"
                    ],
                    "name":"Ireland Charging Location 1",
                    "address":"An Cnoc agus Draighneach",
                    "city":"Ireland City",
                    "postal_code":"47545",
                    "country":"Ireland",
                    "latitude":"53.668482",
                    "longitude":"-7.915861",
                    "directions":"directions",
                    "time_zone":"Europe/Ireland",
                    "last_updated":"null",
                    "charging_when_closed":false,
                    "auth_id_type":"null",
                    "is_public":true,
                    "plugin_dependency":"null",
                    "stations_has_restrictions":true,
                    "station_usage_restrictions":true,
                    "support_name":"Test",
                    "support_phone":"123456789",
                    "is_green_energy":true,
                    "supplier_name":"Test",
                    "energy_product_name":"Test",
                    "twentyfourseven":true,
                    "modified_date":"null",
                    "available_stations":0,
                    "in_use_stations":0,
                    "distance":"10 mi away",
                    "max_charging_power":125,
                    "max_charging_power_unit":"mW (DC)",
                    "facilities":[
                        [
                            "name":"Cafe",
                            "code":"CAFE",
                            "image":"/images/hotel.png",
                            "description":"This is hotel location"
                        ],
                        [
                            "name":"Bar",
                            "code":"BAR",
                            "image":"/images/bar.png",
                            "description":"This is barlocation"
                        ]
                    ]
                ],
                [
                    "id":5,
                    "cp_id":"asdf123dfd",
                    "type_id":1,
                    "type":[
                        "id":1,
                        "name":"On Street",
                        "code":"ON_STREET"
                    ],
                    "name":"Ireland Charging Location 1",
                    "address":"An Cnoc agus Draighneach",
                    "city":"Ireland City",
                    "postal_code":"47545",
                    "country":"Ireland",
                    "latitude":"53.788725",
                    "longitude":"-8.456938",
                    "directions":"directions",
                    "time_zone":"Europe/Ireland",
                    "last_updated":"null",
                    "charging_when_closed":false,
                    "auth_id_type":"null",
                    "is_public":true,
                    "plugin_dependency":"null",
                    "stations_has_restrictions":true,
                    "station_usage_restrictions":true,
                    "support_name":"Test",
                    "support_phone":"123456789",
                    "is_green_energy":true,
                    "supplier_name":"Test",
                    "energy_product_name":"Test",
                    "twentyfourseven":true,
                    "modified_date":"null",
                    "available_stations":2,
                    "in_use_stations":1,
                    "distance":"13 mi away",
                    "max_charging_power":125,
                    "max_charging_power_unit":"mW (DC)",
                    "facilities":[
                        [
                            "name":"Cafe",
                            "code":"CAFE",
                            "image":"/images/hotel.png",
                            "description":"This is hotel location"
                        ],
                        [
                            "name":"Bar",
                            "code":"BAR",
                            "image":"/images/bar.png",
                            "description":"This is barlocation"
                        ],
                        [
                            "name":"Wifi",
                            "code":"WIFI",
                            "image":"/images/wifi.png",
                            "description":"This is wifilocation"
                        ]
                    ]
                ]
            ]
        ]
    ]
}
