//
//  RootTabsView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct RootTabsView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "rectangle.grid.2x2") }

            EventsView()
                .tabItem { Label("Events", systemImage: "calendar") }

            ResourcesView()
                .tabItem { Label("Resources", systemImage: "folder") }

            NewsFeedView()
                .tabItem { Label("News", systemImage: "newspaper") }

            SocialView()
                .tabItem { Label("Social", systemImage: "person.2") }

            ToolsView()
                .tabItem { Label("Tools", systemImage: "wand.and.stars") }
        }
    }
}
