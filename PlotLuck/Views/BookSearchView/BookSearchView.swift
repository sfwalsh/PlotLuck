//
//  BookSearchView.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import SwiftUI

struct BookSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }.toolbar {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.bold)
            }
            
        }
    }
}

#Preview {
    BookSearchView()
}
