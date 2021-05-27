//
//  UIPrototypeApp.swift
//  UIPrototype
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

@main
struct UIPrototypeApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            FirstTimeView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            if PersistenceController.isEmpty {
                FirstTimeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                StartView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
