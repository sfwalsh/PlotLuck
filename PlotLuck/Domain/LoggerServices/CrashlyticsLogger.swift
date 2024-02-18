//
//  CrashlyticsErrorLogger.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation
import FirebaseCrashlytics

struct CrashlyticsLogger: ErrorLogger {
    func log(for error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
