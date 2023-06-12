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

            //MARK: - 주차장공공데이터.json 저장 및 데이터 가공
            print("주차장 공공데이터를 확인 중입니다")
            let parkingPlaceRequest = try ParkingStandardData().urlRequest
            guard let parkingPlaceData = try await NetworkRouter().fetchItem(with: parkingPlaceRequest, model: ParkingPlaceDTO.self) else {
                return
            }

            //MARK: - Firebase Data를 확인
            print("Firebase 데이터를 확인 중입니다")
            let firebaseSnapshot = try await ref.child("data").getData()

            //MARK: - 공공데이터와 서버에 있는 데이터 확인
            if let firebaseData = firebaseSnapshot.value as? [String] {
                guard parkingPlaceData.records.count != firebaseData.count else {
                    print("서버는 최신 상태입니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                    return
                }
            }

            //MARK: - 파이어베이스에 데이터 삭제
            try await ref.child("data").removeValue()
            print("데이터 삭제 완료!")

            //MARK: - 공공데이터를 가공
            print("데이터 가공을 시작합니다")
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

            //MARK: - 파이어베이스에 데이터 저장
            try await self.ref.child("data").setValue(realDATA)
            print("Firebase 데이터 저장")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
}
