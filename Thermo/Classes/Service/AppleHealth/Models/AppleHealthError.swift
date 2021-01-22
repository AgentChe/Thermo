//
//  AppleHealthError.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

struct AppleHealthError: Error {
    enum Code {
        case notAvailable
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
