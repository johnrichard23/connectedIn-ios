//
//  FloatingTextField.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 4/18/24.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    let isSecure: Bool
    
    @Binding var text: String
    @State private var isShowPassword: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                Group {
                    if isSecure {
                        if isShowPassword {
                            TextField("", text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.black)
                        } else {
                            SecureField("", text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.black)
                        }

                    } else {
                        TextField("", text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(.black)
                    }
                }
            }
            if isSecure {
                Button(action: {
                    self.isShowPassword.toggle()
                    }) {
                        Image(systemName: self.isShowPassword ?  "eye" : "eye.slash")
                            .accentColor(.black)
                    }

            }

        } // hstack
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        .background(Color.white)
        .overlay(
                RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1)
            )
    }}
