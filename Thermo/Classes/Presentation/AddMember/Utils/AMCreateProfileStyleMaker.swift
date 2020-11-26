//
//  AMCreateProfileStyleMaker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

final class AMCreateProfileStyleMaker {
    static func make(at unit: AMMemberUnit) -> AMCreateProfileView.Style {
        switch unit {
        case .me, .child, .parent, .other:
            return .withImage
        case .animal, .object:
            return .withoutImage
        }
    }
}
