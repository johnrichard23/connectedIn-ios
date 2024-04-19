//
//  OnboardingPage.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/3/24.
//

import SwiftUI

struct OnboardingPage: View {
    var title: String
    var subtitle: String
    var imageName: String
    
    var body: some View {
        ZStack {
            VStack{
                Image(imageName)
                    .resizable()
                    .opacity(2.0)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(.vertical, 40)
                    .brightness(-0.5)
            }
            VStack {
                Spacer()
                Text(title)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
            }.padding(.vertical, 20)
        }
        .padding(.vertical, 30)
    }
}
