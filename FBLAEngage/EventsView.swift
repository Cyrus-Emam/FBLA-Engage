//
//  EventsView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct EventsView: View {
    @Environment(AppStore.self) private var store
    @State private var showAdd = false
    @State private var showScan = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.events.sorted(by: { $0.startDate < $1.startDate })) { e in
                    NavigationLink {
                        EventDetailView(event: e)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(e.title).font(.headline)
                            Text("\(e.startDate.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { idx in
                    store.events.remove(atOffsets: idx)
                    store.persist()
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button { showScan = true } label: { Image(systemName: "viewfinder") }
                    Button { showAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAdd) { AddEventView() }
            .sheet(isPresented: $showScan) { FlyerScanCreateEventView() }
        }
    }
}
