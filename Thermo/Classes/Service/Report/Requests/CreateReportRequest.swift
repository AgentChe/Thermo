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
    private let records: [Record]
    
    init(email: String,
         member: Member,
         records: [Record]) {
        self.email = email
        self.member = member
        self.records = records
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/email_report"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let name: String
        let type: String
        
        switch member.unit {
        case .me(let human):
            name = human.name
            type = "me"
        case .child(let human):
            name = human.name
            type = "child"
        case .parent(let human):
            name = human.name
            type = "parent"
        case .other(let human):
            name = human.name
            type = "other"
        case .animal(let animal):
            name = animal.name
            type = "animal"
        case .object(let object):
            name = object.name
            type = "object"
        }
        
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "name": name,
            "type": type
        ]
        
        params["data"] = records
            .compactMap {record -> [String: Any]? in
                if let humanRecord = record as? HumanRecord {
                    return data(from: humanRecord)
                }
                
                // TODO: animals and objects
                
                return nil
            }
        
        return params
    }
}

// MARK: Private
private extension CreateReportRequest {
    func data(from humanRecord: HumanRecord) -> [String: Any] {
        [
            "temp": humanRecord.temperature.value,
            "timestamp": humanRecord.date.timeIntervalSince1970,
            "feeling": String(describing: humanRecord.overallFeeling),
            "symtoms": humanRecord.symptoms.map { $0.id },
            "meds": humanRecord.medicines.map { $0.id }
        ]
    }
}
