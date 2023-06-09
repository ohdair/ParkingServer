//
//  NaverGeocodingDTO.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

struct NaverGeocodingDTO: Decodable {
    let status: String
    let meta: NaverGeocodingMetaDTO?
    let addresses: [NaverGeocodingAddressDTO]?
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case status
        case meta
        case addresses
        case errorMessage
    }
}

extension NaverGeocodingDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        meta = try container.decode(NaverGeocodingMetaDTO?.self, forKey: .meta)
        addresses = try container.decode([NaverGeocodingAddressDTO]?.self, forKey: .addresses)
        errorMessage = try container.decode(String?.self, forKey: .errorMessage)
    }
}

extension NaverGeocodingDTO {
    func convert() -> Coordinate {
        let address = addresses?.first
        let latitude = address?.latitude ?? ""
        let longitude = address?.longitude ?? ""
        return Coordinate(latitude: Double(latitude) ?? 0,
                                    longitude: Double(longitude) ?? 0)
    }
}
