//
//  View+ErrorHandling.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 18/02/2024.
//

import Foundation
import SwiftUI

// View Extension for displaying error alerts to the user

extension View {
    func errorAlert(error: Binding<AlertError?>, buttonTitle: String = "OK") -> some View {
        return alert(isPresented: .constant(error.wrappedValue != nil), error: error.wrappedValue) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil // clear error
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
