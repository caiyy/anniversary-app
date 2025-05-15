//
//  JnDay2App.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI
import SwiftData

@main
struct JnDay2App: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: Anniversary.self)
    }
}
