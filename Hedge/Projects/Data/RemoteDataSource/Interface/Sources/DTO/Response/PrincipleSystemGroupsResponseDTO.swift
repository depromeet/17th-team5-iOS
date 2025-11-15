import Foundation

import PrinciplesDomainInterface

public struct PrincipleSystemGroupsResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: PrincipleSystemGroupsDataDTO
}

public struct PrincipleSystemGroupsDataDTO: Decodable {
    public let recommended: [PrincipleSystemGroupDTO]
    public let defaults: [PrincipleSystemGroupDTO]
}

public struct PrincipleSystemGroupDTO: Decodable {
    public let id: Int
    public let groupName: String
    public let thumbnail: String
    public let principleType: String?
    public let principleCount: Int?
    public let imageId: Int?
    public let investorName: String?
}

public struct PrincipleGroupDetailResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: PrincipleGroupResponseDTO
}

public extension PrincipleGroupDetailResponseDTO {
    func toDomain(groupType: PrincipleGroup.GroupType, imageId: Int? = nil, investorName: String? = nil) -> PrincipleGroup {
        data.toDomain(groupType, imageId: imageId, investorName: investorName)
    }
}

