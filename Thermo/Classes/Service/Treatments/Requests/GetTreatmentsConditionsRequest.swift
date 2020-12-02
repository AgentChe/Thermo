//
//  GetTreatmentsConditionsRequest.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import Alamofire

struct GetTreatmentsConditionsRequest: APIRequestBody {
    private let userToken: String
    private let gender: String
    private let age: Int
    private let symptomsIds: [Int]
    private let medicinesIds: [Int]
    
    init(userToken: String,
        gender: String,
        age: Int,
        symptomsIds: [Int],
        medicinesIds: [Int]) {
        self.userToken = userToken
        self.gender = gender
        self.age = age
        self.symptomsIds = symptomsIds
        self.medicinesIds = medicinesIds
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/analyze"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "gender": gender,
            "age": age,
            "symptomsIds": symptomsIds,
            "medicinesIds": medicinesIds
        ]
    }
}
