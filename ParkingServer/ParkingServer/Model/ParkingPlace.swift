//
//  ParkingPlace.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

class ParkingPlace: Codable {
    let number: Int
    let name: String
    var roadAddress: String
    var jibunAddress: String
    let weekdayOperating: Bool
    let saturdayOperating: Bool
    let holidayOperating: Bool
    let weekdayOpenTime: String
    let weekdayCloseTime: String
    let saturdayOpenTime: String
    let saturdayCloseTime: String
    let holidayOpenTime: String
    let holidayCloseTime: String
    let chargeType: Int
    let baseChargeTime: Int
    let baseChargeAmount: Int
    let additionalChargeTime: Int
    let additionalChargeAmount: Int
    var latitude: Double
    var longitude: Double
    let contactNumber: String

    init(number: Int, name: String, roadAddress: String, jibunAddress: String, weekdayOperating: Bool, saturdayOperating: Bool, holidayOperating: Bool, weekdayOpenTime: String, weekdayCloseTime: String, saturdayOpenTime: String, saturdayCloseTime: String, holidayOpenTime: String, holidayCloseTime: String, chargeType: Int, baseChargeTime: Int, baseChargeAmount: Int, additionalChargeTime: Int, additionalChargeAmount: Int, latitude: Double, longitude: Double, contactNumber: String) {
        self.number = number
        self.name = name
        self.roadAddress = roadAddress
        self.jibunAddress = jibunAddress
        self.weekdayOperating = weekdayOperating
        self.saturdayOperating = saturdayOperating
        self.holidayOperating = holidayOperating
        self.weekdayOpenTime = weekdayOpenTime
        self.weekdayCloseTime = weekdayCloseTime
        self.saturdayOpenTime = saturdayOpenTime
        self.saturdayCloseTime = saturdayCloseTime
        self.holidayOpenTime = holidayOpenTime
        self.holidayCloseTime = holidayCloseTime
        self.chargeType = chargeType
        self.baseChargeTime = baseChargeTime
        self.baseChargeAmount = baseChargeAmount
        self.additionalChargeTime = additionalChargeTime
        self.additionalChargeAmount = additionalChargeAmount
        self.latitude = latitude
        self.longitude = longitude
        self.contactNumber = contactNumber
    }
}

extension ParkingPlace {
    func interpolate() async {
        guard self.latitude.isZero,
              self.longitude.isZero else {
            return
        }

        let address = jibunAddress.isEmpty ? roadAddress : jibunAddress
        let endpoint = NaverGeocodingAPI(from: address)

        do {
            let request = try endpoint.urlRequest
            if let data = try await NetworkRouter().fetchItem(with: request, model: NaverGeocodingDTO.self) {
                let coordinate = data.convert()
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
            }
        } catch {
            print(error)
        }
    }
}
