//
//  shareTabBarMacIpadIphone_18App.swift
//  Shared
//
//  Created by emm on 03/02/2021.
//

import SwiftUI

@main
struct shareTabBarMacIpadIphone_18App: App {
    var body: some Scene {
        
        // hiding Window for only mc os
        #if os(iOS)
        WindowGroup {
            ContentView()
        }
        #else
        WindowGroup {
            ContentView()
        }
        .windowStyle((HiddenTitleBarWindowStyle()))
        #endif
        
    }
}
