//
//  ResourcesView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct ResourcesView: View {
    @Environment(AppStore.self) private var store
    @State private var search = ""

    private var filtered: [ResourceDoc] {
        let s = search.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return store.resources }
        return store.resources.filter {
            $0.title.lowercased().contains(s) || $0.category.lowercased().contains(s)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { r in
                    NavigationLink {
                        ResourceDetailView(resourceID: r.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(r.title).font(.headline)
                            Text(r.category).foregroundStyle(.secondary)
                            Text(r.summary)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }

                if filtered.isEmpty {
                    ContentUnavailableView("No Resources Found", systemImage: "doc.text.magnifyingglass")
                }
            }
            .navigationTitle("Resources")
            .searchable(text: $search)
        }
    }
}
