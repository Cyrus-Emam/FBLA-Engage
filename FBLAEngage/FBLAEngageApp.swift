//
//  FBLAEngageApp.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

@main
struct FBLAEngageApp: App {
    @State private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootTabsView()
                .environment(store)
                .environment(
                    \.dynamicTypeSize,
                    store.profile.largeText ? .xxxLarge : .large
                )
        }
    }
}


