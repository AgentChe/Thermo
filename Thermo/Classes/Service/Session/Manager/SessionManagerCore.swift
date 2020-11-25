//
//  SessionManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import RxCocoa

final class SessionManagerCore: SessionManager {
    struct Constants {
        static let sessionCacheKey = "session_manage_core_session_cache_key"
    }
}

// MARK: API
extension SessionManagerCore {
    func store(session: Session) {
        guard let data = try? JSONEncoder().encode(session) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.sessionCacheKey)
    }
    
    func getSession() -> Session? {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.sessionCacheKey),
            let session = try? JSONDecoder().decode(Session.self, from: data)
        else {
            return nil
        }

        return session
    }
}
