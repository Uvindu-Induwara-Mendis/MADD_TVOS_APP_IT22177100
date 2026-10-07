//
//  UvinduApp.swift
//  Uvindu
//
//  Created by Janith Kavinda on 2026-10-06.
//

import SwiftUI
import CoreData

@main
struct UvinduApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
