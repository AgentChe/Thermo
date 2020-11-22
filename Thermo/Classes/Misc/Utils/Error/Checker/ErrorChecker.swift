//
//  ErrorChecker.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSError

final class ErrorChecker {}

extension ErrorChecker {
    @discardableResult
    static func throwErrorIfHas(from response: Any) throws -> Any {
        guard let json = response as? [String: Any] else {
            throw NSError(domain: "Response can't parse to json", code: 404)
        }
        
        if let needPayment = json["_need_payment"] as? Bool, needPayment {
            throw PaymentError.needPayment
        }
        
        guard let code = json["_code"] as? Int else {
            throw NSError(domain: "Response has't code variable", code: 404)
        }
        
        if code < 200 && code > 299 {
            throw ApiError.serverNotAvailable
        }
        
        return response
    }
    
    static func hasError(in response: Any) -> Bool {
        let response = try? throwErrorIfHas(from: response)
        
        let hasResponse = response != nil
        
        return !hasResponse
    }
    
    static func needPayment(in error: Error) -> Bool {
        if let paymentError = error as? PaymentError, paymentError == .needPayment {
            return true
        }

        if let signError = error as? SignError, signError == .tokenNotFound {
            return true
        }
        
        return false
    }
}
