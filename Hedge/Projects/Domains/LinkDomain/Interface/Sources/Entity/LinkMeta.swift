//
//  LinkMeta.swift
//  LinkDomainInterface
//
//  Created by 이중엽 on 10/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct LinkMeta: Equatable, Hashable {
    public let id: UUID = UUID()
    public let title: String
    public let imageURL: String?
    public let newsSource: String
    
    public init(title: String, imageURL: String?, newsSource: String) {
        self.title = title
        self.imageURL = imageURL
        self.newsSource = newsSource
    }
}
