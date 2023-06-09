//
//  ParkingStandardData.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

struct ParkingStandardData: Endpoint {
    var baseURL: String = "https://www.data.go.kr"
    var path: String = "/download/15012896/standard.do"
    var queryItems: [String : String]? = ["dataType": "json"]
    var httpHeaders: [String : String]?
    var httpMethod: HTTPMethod = .get
}
