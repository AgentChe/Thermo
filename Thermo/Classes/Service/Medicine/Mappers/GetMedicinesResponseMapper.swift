//
//  GetMedicinesResponseMapper.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

final class GetMedicinesResponseMapper {
    static func map(response: Any) -> [Medicine] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let meds = data["meds"] as? [[String: Any]]
        else {
            return []
        }
        
        return meds
            .compactMap {
                guard
                    let id = $0["id"] as? Int,
                    let name = $0["name"] as? String
                else {
                    return nil
                }
                
                return Medicine(id: id, name: name)
            }
    }
}
