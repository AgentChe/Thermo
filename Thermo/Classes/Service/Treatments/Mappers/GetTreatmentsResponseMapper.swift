//
//  GetTreatmentsResponseMapper.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

final class GetTreatmentsResponseMapper {
    static func map(from response: Any) -> [TreatmentCondition] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let conditions = data["conditions"] as? [[String: Any]]
        else {
            return []
        }
        
        return conditions
            .compactMap { json -> TreatmentCondition? in
                guard
                    let name = json["name"] as? String,
                    let status = json["status"] as? String,
                    let score = json["score"] as? Double,
                    let detail = json["detail"] as? String,
                    let treatment = json["treatment"] as? String
                else {
                    return nil
                }
                
                return TreatmentCondition(name: name,
                                          status: status,
                                          score: score,
                                          detail: detail,
                                          treatment: treatment)
            }
    }
}
