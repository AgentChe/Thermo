//
//  GetSymptomsResponseMapper.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

final class GetSymptomsResponseMapper {
    static func map(response: Any) -> [Symptom] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let symptoms = data["symptoms"] as? [[String: Any]]
        else {
            return []
        }
        
        return symptoms
            .compactMap {
                guard
                    let id = $0["id"] as? Int,
                    let name = $0["name"] as? String
                else {
                    return nil
                }
                
                return Symptom(id: id, name: name)
            }
    }
}
