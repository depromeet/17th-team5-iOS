//
//  PrincipleGroup.swift
//  PrinciplesDomainInterface
//
//  Created by 이중엽 on 11/1/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct PrincipleGroup: Equatable, Hashable {
    
    public enum GroupType {
        case system
        case custom
    }
    
    public let id: Int
    public let groupName: String
    public let principleType: String
    public let groupType: GroupType
    public let displayOrder: Int
    public let principles: [Principle]
    
    public init(
        id: Int,
        groupName: String,
        principleType: String,
        groupType: GroupType,
        displayOrder: Int,
        principles: [Principle]
    ) {
        self.id = id
        self.groupName = groupName
        self.principleType = principleType
        self.groupType = groupType
        self.displayOrder = displayOrder
        self.principles = principles
    }
}

extension PrincipleGroup {
    
    public static var systemItemForSell: Self {
        PrincipleGroup(
            id: 0,
            groupName: "초보자를 위한 매도 원칙",
            principleType: "SELL",
            groupType: .system,
            displayOrder: 1,
            principles: [
                Principle(
                    id: 1,
                    groupId: 0,
                    groupName: "초보자를 위한 매도 원칙",
                    principleType: "SELL",
                    principle: "리스크를 알고 사기",
                    description: "잃을 수 있는 금액 안에서만 투자하세요. 손실 가능성을 모르면 결정도 불안해져요.",
                    displayOrder: 1
                ),
                Principle(
                    id: 2,
                    groupId: 0,
                    groupName: "초보자를 위한 매도 원칙",
                    principleType: "SELL",
                    principle: "이해되는 기업만 사기",
                    description: "무엇을 파는 회사인지 설명할 수 있어야 해요. 모르면 공부부터 하는 게 진짜 투자예요.",
                    displayOrder: 2
                ),
                Principle(
                    id: 3,
                    groupId: 0,
                    groupName: "초보자를 위한 매도 원칙",
                    principleType: "SELL",
                    principle: "확신이 들 때 사기",
                    description: "주가 급등이나 뉴스에 흔들리지 마세요. 확신이 들 때까지 기다리는 게 오히려 유리해요.",
                    displayOrder: 3
                ),
                Principle(
                    id: 4,
                    groupId: 0,
                    groupName: "초보자를 위한 매도 원칙",
                    principleType: "SELL",
                    principle: "분할 매수하기",
                    description: "한 번에 전부 사지 말고, 나눠서 진입하면 평균 매입가를 안정적으로 만들 수 있어요.",
                    displayOrder: 4
                ),
                Principle(
                    id: 5,
                    groupId: 0,
                    groupName: "초보자를 위한 매도 원칙",
                    principleType: "SELL",
                    principle: "목표를 정하고 사기",
                    description: "단기 수익, 장기 보유 등 목적을 먼저 정해두세요. 목표가 있으면 흔들릴 때도 중심을 잡을 수 있어요.",
                    displayOrder: 5
                )
            ]
        )
    }
}
