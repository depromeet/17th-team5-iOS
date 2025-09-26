//
//  PrinciplesDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol PrinciplesDataSource {
    /// 주식 검색
    func fetch() async throws -> PrinciplesResponseDTO
}
