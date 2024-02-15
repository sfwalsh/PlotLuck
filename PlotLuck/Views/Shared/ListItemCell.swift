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
    let imageURLString: String?
    let footnoteText: String?
    
    var body: some View {
        HStack(alignment: .center) {
            // Icon
            buildImageContent()
            
            // Text
            VStack(alignment: .leading) {
                Text(titleText)
                    .font(.title3)
                    .fontDesign(.serif)
                    .padding(.bottom, 2)
                
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
    
    @ViewBuilder
    private func buildImageContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            if let imageURLString = imageURLString,
                let imageURL = URL(string: imageURLString) {
                // Image
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    createImagePlaceholder()
                }
                .frame(width: 55, height: 80)
                .clipped()
            } else {
                // Placeholder only
                createImagePlaceholder()
            }
        }.padding(.trailing, 12)
    }
    
    @ViewBuilder
    private func createImagePlaceholder() -> some View {
        Image(systemName: "book.pages")
            .scaledToFill()
            .frame(width: 55, height: 80)
            .background(RoundedRectangle(cornerSize: CGSize(width: 2, height: 2)).opacity(0.2))
    }
}

#Preview {
    List {
        ListItemCell(
            titleText: "Circe",
            subtitleText: "Madeline Miller", 
            imageURLString: "http://books.google.com/books/content?id=dyikEAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
            footnoteText: "Unread"
        )
    }.listStyle(.plain)
}
