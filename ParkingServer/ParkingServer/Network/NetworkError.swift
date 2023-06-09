//
//  NetworkError.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

enum NetworkError: LocalizedError {
    case transportError(Error)
    case invalidServerResponse
    case invalidData
    case invalidURL
    case parseError

    var errorDescription: String? {
        switch self {
        case .transportError(let error):
            return "에러: \(error.localizedDescription)"
        case .invalidServerResponse:
            return "서버 에러"
        case .invalidData:
            return "유효하지 않은 데이터"
        case .invalidURL:
            return "유효하지 않은 URL"
        case .parseError:
            return "파싱에 실패"
        }
    }
}
