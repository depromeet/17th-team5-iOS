//
//  SocialLoginResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct SocialLoginResponseDTO: Decodable {
    public let userId: Int
    public let nickname: String?
    public let email: String?
    public let profileImageUrl: String?
//    public let isNewUser: Bool
    public let accessToken: String
    public let refreshToken: String
}
