//
//  RaisedButton.swift
//  FitBB
//
//  Created by Акбар Уметов on 19/4/22.
//

import SwiftUI

struct RaisedButton: View {
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(buttonText)
                .raisedButtonTextStyle()
        })
        .buttonStyle(RaisedButtonStyle())
    }
}

struct RaisedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(y: configuration.isPressed ? 2 : 0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .buttonPress(configuration.isPressed)
            .animation(.none, value: 0.0)
    }
}

struct RaisedButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RaisedButton(buttonText: "Continue") {
                print("Continue")
            }
        }
        .buttonStyle(RaisedButtonStyle())
        .background(Color("background"))
        .previewLayout(.sizeThatFits)
        
        ZStack {
            RaisedButton(buttonText: "Continue") {
                print("Continue")
            }
        }
        .padding()
        .buttonStyle(RaisedButtonStyle())
        .background(Color("Color2"))
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

extension Text {
    func raisedButtonTextStyle() -> some View {
        self
            .font(.system(.body, design: .rounded))
            .fontWeight(.bold)
            .kerning(0.7)
    }
}

private extension View {
    func buttonPress(_ isPressed: Bool) -> some View {
        self
            .background(
                !isPressed ? AnyView(normal()) : AnyView(pressed())
            )
    }
    
    func normal() -> some View {
        Capsule()
            .shadow(color: Color("drop-shadow"), radius: 8, x: 6, y: 6)
            .shadow(color: Color("drop-highlight"), radius: 8, x: -6, y: -6)
            .foregroundColor(Color("background"))
    }
    
    func pressed() -> some View {
        Capsule()
            .inset(by: -4)
            .stroke(Color("background"), lineWidth: 8)
            .shadow(color: Color("drop-shadow"), radius: 4, x: 6, y: 6)
            .shadow(color: Color("drop-highlight"), radius: 4, x: -6, y: -6)
            .foregroundColor(Color("background"))
            .clipShape(Capsule())
    }
}
