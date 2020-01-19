//
//  Date+TaskManager.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation

extension Date {
    func uiString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)
    }
}


