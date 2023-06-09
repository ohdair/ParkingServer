//
//  NaverGeoCodingAPI.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

struct NaverGeocodingAPI: Endpoint {
    let baseURL: String = "https://naveropenapi.apigw.ntruss.com"
    let path: String = "/map-geocode/v2/geocode"
    var queryItems: [String : String]?
    var httpHeaders: [String : String]?
    var httpMethod: HTTPMethod = .get

    init(from address: String) {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "NMFClientId") as? String,
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_MAP_SECRET") as? String else {
            return
        }

        httpHeaders = ["X-NCP-APIGW-API-KEY-ID": clientID,
                       "X-NCP-APIGW-API-KEY": clientSecret]
        queryItems = ["query": address]
    }
}
