//
//  LinkRepository.swift
//  LinkDomainInterface
//
//  Created by 이중엽 on 10/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol LinkRepository {
    func fetch(urlString: String) async throws -> LinkMeta
}
