//
//  ViewController.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        view.backgroundColor = .white

        Task {

            //MARK: - Firebase Data를 확인
            let firebaseSnapshot = try await ref.getData()
            guard let firebaseDictionary = firebaseSnapshot.value as? [String: [String]],
                  let firebaseData = firebaseDictionary["데이터"] else {
                return
            }
            print("Firebase Data 갯수 : ", firebaseData.count)

            //MARK: - 주차장공공데이터.json 저장 및 데이터 가공
            let parkingPlaceRequest = try ParkingStandardData().urlRequest
            guard let parkingPlaceData = try await NetworkRouter().fetchItem(with: parkingPlaceRequest, model: ParkingPlaceDTO.self) else {
                return
            }
            print("주차장공공데이터 Data 갯수 : ", parkingPlaceData.records.count)

            //MARK: - 공공데이터와 서버에 있는 데이터 확인
            guard parkingPlaceData.records.count != firebaseData.count else {
                print("공공데이터와 서버의 데이터 갯수가 동일합니다.")
                return
            }

            //MARK: - 공공데이터를 가공
            let parkingPlaces: [ParkingPlace] = parkingPlaceData.records.map { DTO in
                return DTO.convert()
            }

            var realDATA = [String]()
            let totalProgress = Double(parkingPlaces.count)
            var currentProgress = 0.0

            for parkingPlace in parkingPlaces {
                await parkingPlace.interpolate()
                currentProgress += 1
                print(String(format: "%.2f", currentProgress / totalProgress * 100) + "%..")

                let jsonData = try JSONEncoder().encode(parkingPlace)
                let uploadData = String(data: jsonData, encoding: .utf8)!
                realDATA.append(uploadData)
            }

            try await self.ref.child("데이터").setValue(realDATA)
        }
    }
}
