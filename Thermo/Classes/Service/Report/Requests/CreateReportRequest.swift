//
//  CreateReportRequest.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 23.11.2020.
//

import Alamofire

struct CreateReportRequest: APIRequestBody {
    private let email: String
    private let member: Member
    private let temperatures: [Temperature]
    
    init(email: String,
         member: Member,
         temperatures: [Temperature]) {
        self.email = email
        self.member = member
        self.temperatures = temperatures
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/email_report"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "name": member.name,
            "type": String(describing: member.unit)
        ]
        
        params["data"] = temperatures
            .map { temperature -> [String: Any] in
                [
                    "temp": temperature.value,
                    "timestamp": temperature.date.timeIntervalSince1970,
                    "feeling": String(describing: temperature.overallFeeling),
                    "symtoms": temperature.symptoms.map { $0.id },
                    "meds": temperature.medicines.map { $0.id }
                ]
            }
        
        return params
    }
}
