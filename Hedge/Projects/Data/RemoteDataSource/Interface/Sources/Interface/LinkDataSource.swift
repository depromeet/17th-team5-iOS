//
//  LinkDataSource.swift
//  RemoteDataSource
//
//  Created by 이중엽 on 10/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol LinkDataSource {
    /// 주식 검색
    func fetch(urlString: String) async throws -> LinkMetaDTO
}
