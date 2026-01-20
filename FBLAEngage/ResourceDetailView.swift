//
//  ResourceDetailView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct ResourceDetailView: View {
    @Environment(AppStore.self) private var store
    let resourceID: UUID

    // Find the resource in the store by ID (so changes persist correctly)
    private var resourceIndex: Int? {
        store.resources.firstIndex(where: { $0.id == resourceID })
    }

    var body: some View {
        Group {
            if let idx = resourceIndex {
                let r = store.resources[idx]

                List {
                    Section("Resource") {
                        Text(r.title)
                            .font(.headline)

                        HStack {
                            Text("Category")
                            Spacer()
                            Text(r.category)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Summary")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(r.summary)
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Offline Access") {
                        Toggle("Saved Offline", isOn: Binding(
                            get: { store.resources[idx].isSavedOffline },
                            set: { newVal in
                                store.resources[idx].isSavedOffline = newVal
                                store.persist()
                            }
                        ))
                    }

                    Section("Prototype Note") {
                        Text("This prototype demonstrates how FBLA resources are organized, searched, and saved for offline access. Official documents would be viewable here in a full deployment.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Details")
            } else {
                ContentUnavailableView("Resource Not Found", systemImage: "doc.text.magnifyingglass")
            }
        }
    }
}
