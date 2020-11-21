//
//  GetSymptomsRequest.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import Alamofire

struct GetSymptomsRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domainUrl + "/api/symptoms"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
}
