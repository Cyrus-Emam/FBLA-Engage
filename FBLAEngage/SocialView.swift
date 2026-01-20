//
//  SocialView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct SocialView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.socialLinks) { link in
                    if let url = URL(string: link.urlString) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "arrow.up.right.square")
                                Text(link.platform)
                                Spacer()
                                Text(url.host() ?? "")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                    } else {
                        Text("\(link.platform): invalid URL")
                    }
                }
            }
            .navigationTitle("Social")
        }
    }
}
