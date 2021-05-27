//
//  BaseBackView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI

struct BaseBackView<Content>: View where Content: View {
    private let bgImage = Image("FunkyBG")
    private let content: Content

    @Environment(\.presentationMode) private var presentation

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body : some View {
        VStack {
            content
        }
        .background(funkyBackground())
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem (placement: .automatic)  {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .foregroundColor(funkyPurpure())
                    .font(Font.system(size: 36))
                    .onTapGesture {
                        // code to dismiss the view
                        self.presentation.wrappedValue.dismiss()
                    }
            }
        })
    }
}

