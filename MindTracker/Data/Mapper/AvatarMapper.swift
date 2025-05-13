//
//  AvatarMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

enum AvatarMapper {

    static func map(from dto: AvatarDTO) -> Avatar {
        return Avatar(data: dto.data)
    }

    static func map(from domain: Avatar) -> AvatarDTO {
        return AvatarDTO(data: domain.data ?? Data())
    }
}
