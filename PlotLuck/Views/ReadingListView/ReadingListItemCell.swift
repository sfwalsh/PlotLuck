//
//  ReadingListItemCell.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import SwiftUI

struct ReadingListItemCell: View {
    
    let titleText: String
    let subtitleText: String
    let footnoteText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 20) {
                // Icon
                Rectangle()
                    .frame(width: 55, height: 80)
                
                // Text
                VStack(alignment: .leading) {
                    Text(titleText)
                        .font(.headline)
                        .fontDesign(.serif)
                    
                    Text(subtitleText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .fontDesign(.serif)
                        .opacity(0.8)
                    
                    Spacer()
                    
                    Text(footnoteText)
                        .font(.footnote)
                        .opacity(0.8)
                }
                .padding(.vertical, 6)
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            
            Divider()
                .frame(height: 0.5)
                .overlay(Color.primary)
                .opacity(0.4)
                .padding(.horizontal, 12)
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    List {
        ReadingListItemCell(
            titleText: "Circe",
            subtitleText: "Madeline Miller",
            footnoteText: "Unread"
        )
    }.listStyle(.plain)
}
