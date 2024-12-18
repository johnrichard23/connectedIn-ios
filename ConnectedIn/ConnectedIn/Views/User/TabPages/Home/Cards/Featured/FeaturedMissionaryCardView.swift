//
//  FeaturedMissionaryCardView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 10/3/24.
//

import SwiftUI

struct FeaturedMissionaryCardView: View {
    let missionary: Missionary

        var body: some View {
            VStack(alignment: .leading) {
                Image(missionary.avatarUrl)
                    .resizable()
                    .frame(width: 71, height: 71)
                    .cornerRadius(10)
                    .shadow(radius: 3)

                Text(missionary.name)
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding(.top, 5)

                Text(missionary.location)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .frame(width: 90)
            
        }
}

//#Preview {
//    FeaturedMissionaryCardView(missionary: Missionary(id: 1, name: "John Doe This", location: "Thailand", imageUrl: "missionary1"))
//}
