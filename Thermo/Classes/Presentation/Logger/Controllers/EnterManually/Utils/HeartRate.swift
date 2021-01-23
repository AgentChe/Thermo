//
//  HeartRate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 23.01.2021.
//

final class HeartRate {
    private lazy var model: HeartRateDetectionModel = {
        let model = HeartRateDetectionModel()
        model.delegate = self
        return model
    }()
    
    private var bpms = [Int32]()
    
    private let calculatedBPM: ((Int32) -> Void)
    
    init(calculatedBPM: @escaping ((Int32) -> Void)) {
        self.calculatedBPM = calculatedBPM
    }
}

// MARK: API
extension HeartRate {
    func start() {
        model.startDetection()
    }
    
    func stop() {
        model.stopDetection()
    }
}

// MARK: HeartRateDetectionModelDelegate
extension HeartRate: HeartRateDetectionModelDelegate {
    func heartRateUpdate(_ bpm: Int32, atTime seconds: Int32) {
        bpms.append(bpm)
        
        if seconds >= 10 {
            stop()
            
            let average = bpms.reduce(0, +) / Int32(bpms.count)
            
            calculatedBPM(average)
        }
    }
}
