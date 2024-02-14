//
//  ListItemCell.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import SwiftUI

struct ListItemCell: View {
    
    let titleText: String
    let subtitleText: String
    let footnoteText: String?
    
    var body: some View {
        HStack(alignment: .center) {
            // Icon
//            Rectangle()
//                .frame(width: 55, height: 80)
            
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
                
                if let footnoteText = footnoteText {
                    Spacer()
                    Text(footnoteText)
                        .font(.footnote)
                        .opacity(0.8)
                }
            }
            .padding(.vertical, 6)
        }
    }
}

#Preview {
    List {
        ListItemCell(
            titleText: "Circe",
            subtitleText: "Madeline Miller",
            footnoteText: "Unread"
        )
    }.listStyle(.plain)
}
