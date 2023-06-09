//
//  ParkingPlaceDTO.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

struct ParkingPlaceDTO: Decodable {
    let fields: [ParkingPlaceFieldDTO]
    let records: [ParkingPlaceItemDTO]

    enum CodingKeys: String, CodingKey {
        case fields
        case records
    }
}

extension ParkingPlaceDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        records = try container.decode([ParkingPlaceItemDTO].self, forKey: .records)
        fields = try container.decode([ParkingPlaceFieldDTO].self, forKey: .fields)
    }
}
