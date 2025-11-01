//
//  FetchPrinciples.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct FetchPrinciples: FetchPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute(_ tradeType: String) async throws -> [PrincipleGroup] {
        return try await repository.fetch()
            .filter { group in
                group.principleType == tradeType
            }
    }
}

public struct MockFetchPrinciples: FetchPrinciplesUseCase {
    public init() {}
    
    public func execute(_ tradeType: String) async throws -> [PrincipleGroup] {
        return [
            PrincipleGroup(
                id: 1,
                groupName: "초보자를 위한 매도 원칙",
                principleType: tradeType,
                displayOrder: 1,
                principles: [
                    Principle(
                        id: 1,
                        groupId: 1,
                        groupName: "초보자를 위한 매도 원칙1",
                        principleType: tradeType,
                        principle: "안전마진을 확보하라",
                        displayOrder: 1
                    ),
                    Principle(
                        id: 2,
                        groupId: 1,
                        groupName: "초보자를 위한 매도 원칙2",
                        principleType: tradeType,
                        principle: "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
                        displayOrder: 2
                    ),
                    Principle(
                        id: 3,
                        groupId: 1,
                        groupName: "초보자를 위한 매도 원칙3",
                        principleType: tradeType,
                        principle: "정책 민감도가 높은 주식은 정책 잘 살펴보고 매매",
                        displayOrder: 3
                    )
                ]
            ),
            PrincipleGroup(
                id: 2,
                groupName: "초보자를 위한 매수 원칙",
                principleType: tradeType,
                displayOrder: 2,
                principles: [
                    Principle(
                        id: 4,
                        groupId: 2,
                        groupName: "초보자를 위한 매수 원칙1",
                        principleType: tradeType,
                        principle: "손실 구간에서 감정적 판단하지 말고 체계적으로 판단하라",
                        displayOrder: 1
                    ),
                    Principle(
                        id: 5,
                        groupId: 2,
                        groupName: "초보자를 위한 매수 원칙2",
                        principleType: tradeType,
                        principle: "분산투자를 통한 리스크 관리",
                        displayOrder: 2
                    )
                ]
            ),
            PrincipleGroup(
                id: 3,
                groupName: "이건 좀 지키자 제발",
                principleType: "CUSTOM",
                displayOrder: 1,
                principles: [
                    Principle(
                        id: 6,
                        groupId: 3,
                        groupName: "이건 좀 지키자 제발1",
                        principleType: "CUSTOM",
                        principle: "안전마진을 확보하라",
                        displayOrder: 1
                    ),
                    Principle(
                        id: 7,
                        groupId: 3,
                        groupName: "이건 좀 지키자 제발2",
                        principleType: "CUSTOM",
                        principle: "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
                        displayOrder: 2
                    ),
                    Principle(
                        id: 8,
                        groupId: 3,
                        groupName: "이건 좀 지키자 제발3",
                        principleType: "CUSTOM",
                        principle: "정책 민감도가 높은 주식은 정책 잘 살펴보고 매매",
                        displayOrder: 3
                    )
                ]
            )
        ]
    }
}
