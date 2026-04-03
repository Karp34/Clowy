//
//  UserMapper.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Swift

enum UserMapper {
    static func toDomain(_ dto: UserDTO) -> User {
        User(
            id: dto.id,
            username: dto.username,
            userIcon: dto.userIcon,
            config: dto.config,
            didOnboarding: dto.didOnboarding,
            preferedStyle: dto.preferedStyle,
            hatTemperature: dto.hatTemperature,
            isTshirtUnder: dto.isTshirtUnder,
            excludedClothes: dto.excludedClothes,
            skirtPairings: dto.skirtPairings,
            skirtWeather: dto.skirtWeather,
            dressPairings: dto.dressPairings,
            dressWeather: dto.dressWeather
        )
    }

    static func toDTO(_ user: User) -> UserDTO {
        UserDTO(
            id: user.id,
            username: user.username,
            userIcon: user.userIcon,
            config: user.config,
            didOnboarding: user.didOnboarding,
            preferedStyle: user.preferedStyle,
            hatTemperature: user.hatTemperature,
            isTshirtUnder: user.isTshirtUnder,
            excludedClothes: user.excludedClothes,
            skirtPairings: user.skirtPairings,
            skirtWeather: user.skirtWeather,
            dressPairings: user.dressPairings,
            dressWeather: user.dressWeather
        )
    }
}
