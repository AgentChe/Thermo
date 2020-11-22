//
//  Session.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

struct Session: Codable {
    let userId: Int
    let userToken: String
    let activeSubscription: Bool
}

// MARK: Make
extension Session {
    init(response: ReceiptValidateResponse) {
        self.userId = response.userId
        self.userToken = response.userToken
        self.activeSubscription = response.activeSubscription
    }
}
