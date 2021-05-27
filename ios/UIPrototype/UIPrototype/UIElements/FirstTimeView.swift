//
//  ContentView.swift
//  UIPrototype
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct DIDTopicView: View {
    var body: some View {
        Text("Add a DID.")
            .font(.subheadline)
    }
}

struct FirstTimeView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 23) {
                funkyTitle(text: "Start with tocq.io ##", size: 72)
                    .padding(.bottom, 48)
                NavigationLink(
                    destination: CreateTopicView()
                ) {
                    funkyButton(text: "New Topic", imageName: "bolt.fill")
                }
                NavigationLink(
                    destination: ScannerView()
                ) {
                    funkyButton(text: "Scan QR Topic", imageName: "bolt.fill")
                }
                NavigationLink(
                    destination: DIDTopicView()
                ) {
                    funkyButton(text: "Import DID Topic", imageName: "person.badge.plus")
                }
                Spacer()
            }
            .background(funkyBackground())
        }
    }
}

struct FirstTimeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
