//
//  ClientError.swift
//  Shared
//
//  Created by Junyoung on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public enum ClientError: Error {
    /// 인터넷 연결이 전혀 없는 상태 (Wi-Fi/LTE 꺼짐, 비행기 모드 등)
    case notConnectedToInternet
    
    /// 요청이 타임아웃됨 (서버 응답이 일정 시간 내 도착하지 않음)
    case timeout
    
    /// 요청 도중 네트워크 연결이 끊김 (예: Wi-Fi ↔ LTE 전환, 지하철 진입 등)
    case networkConnectionLost
    
    /// DNS에서 호스트 이름을 찾지 못함 (도메인 주소를 해석할 수 없음)
    case cannotFindHost
    
    /// IP는 찾았지만 대상 호스트와 TCP 연결을 맺을 수 없음 (서버가 다운됐거나 방화벽 차단 등)
    case cannotConnectToHost
    
    /// SSL/TLS 보안 연결 설정 실패 (인증서 문제, 암호화 프로토콜 미지원 등)
    case secureConnectionFailed
    
    /// 요청이 클라이언트 쪽에서 취소됨 (사용자가 중단하거나 Task 취소 시)
    case cancelled
    
    /// Decoding 과정 실패
    case decoding(DecodingError)
    
    /// 데이터 없는 에러
    case emptyData
    
    /// 알 수 없는 에러
    case unknown(URLError)
}
