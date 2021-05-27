//
//  Funky.swift
//  UIPrototype
//
//  Created by Philipp on 20.05.21.
//

import SwiftUI

class TopicCharCounter: ObservableObject {
    
    @Published var limitedText: String = "" {
        didSet {
            if limitedText.count > characterLimit {
                limitedText = String(limitedText.prefix(characterLimit))
            }
        }
    }
    
    let characterLimit: Int

    init(limit: Int = 24){
        characterLimit = limit
    }
}

func funkyButton(text: String, imageName: String) -> some View {
    return HStack {
        Image(systemName: imageName)
            .font(.title)
        Text(text)
            .fontWeight(.semibold)
            .font(.title)
    }
    .padding()
    .foregroundColor(.white)
    .background(LinearGradient(gradient: Gradient(colors: [funkyPurpure(), funkyViolet()]), startPoint: .leading, endPoint: .trailing))
    .cornerRadius(40)
}

func funkyBackground() -> some View {
    // image from www.rawpixel.com
    return Image("FunkyBG")
        .resizable()
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
}

func funkyPurpure(opacity: Double = 1.0) -> Color {
    return Color(red: 1.0, green: 0.2, blue: 0.4, opacity: opacity)
}

func funkyViolet(opacity: Double = 1.0) -> Color {
    return Color(red: 0.4, green: 0.2, blue: 1.0, opacity: opacity)
}

func funkySuperLightGrey(opacity: Double = 0.98) -> Color {
    return Color.init(red: 0.97, green: 0.9, blue: 0.94, opacity: opacity)
}

func funkySuperDarkGrey(opacity: Double = 0.54) -> Color {
    return Color.init(red: 0.26, green: 0.21, blue: 0.25, opacity: opacity)
}

func funkyTitle(text: String, size: CGFloat) -> some View {
    return Text(text)
        // possibly make size dynamic with https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-dynamic-type-with-a-custom-font
        .font(.system(size: size))
        .fontWeight(.heavy)
        .foregroundColor(funkyPurpure(opacity: 0.85))
        .multilineTextAlignment(.leading)
}

func funkyTextField(defaultText: String, textCharCounter: Binding<String>) -> some View {
    return TextField(defaultText, text: textCharCounter)
        .disableAutocorrection(true)
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .font(Font.system(size: 24, weight: .semibold))
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(funkySuperLightGrey()))
        .foregroundColor(funkySuperDarkGrey())
        .padding(.all)
}
