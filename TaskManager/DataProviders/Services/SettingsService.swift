//
//  SettingsService.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import Combine

enum SettingsKeys: String {
    case alphabeticalOrder
    case notifications
}

struct Settings {
    var alphabeticalSort: Bool
    var notificationsEnabled: Bool
}

class SettingsService {

    static public let didChange = PassthroughSubject<Settings, Never>()

    class func settings() -> Settings {
        return Settings(alphabeticalSort: UserDefaults.standard.bool(forKey: SettingsKeys.alphabeticalOrder.rawValue),
                        notificationsEnabled: UserDefaults.standard.bool(forKey: SettingsKeys.notifications.rawValue))
    }

    class func toggle(key: SettingsKeys) {
        let value = UserDefaults.standard.bool(forKey: key.rawValue)
        UserDefaults.standard.set(!value, forKey: key.rawValue)

        didChange.send(settings())
    }
}
