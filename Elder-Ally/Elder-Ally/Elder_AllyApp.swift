//
//  Elder_AllyApp.swift
//  Elder-Ally
//
//  Created by Stella Luna on 2025.07.30.
//

import SwiftUI

@main
struct Elder_AllyApp: App {
    @StateObject private var userAuth = UserAuthManager()
    @StateObject private var userRole = UserRoleManager()
    @StateObject private var frameworkReady = FrameworkReadyManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userAuth)
                .environmentObject(userRole)
                .environmentObject(frameworkReady)
                .onAppear {
                    frameworkReady.setReady()
                }
        }
    }
}
