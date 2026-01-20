//
//  EventDetailView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct EventDetailView: View {
    let event: FBLAEvent
    @State private var statusText: String?

    var body: some View {
        List {
            Section {
                Text(event.details)
                Text("Location: \(event.location)")
                Text("Start: \(event.startDate.formatted(date: .abbreviated, time: .shortened))")
                Text("End: \(event.endDate.formatted(date: .abbreviated, time: .shortened))")
                if event.createdFromScan {
                    Text("Created from flyer scan").foregroundStyle(.secondary)
                }
            }

            Section("Actions") {
                Button("Add to Apple Calendar") {
                    Task {
                        do {
                            try await CalendarService().addToCalendar(title: event.title,
                                                                     notes: event.details,
                                                                     start: event.startDate,
                                                                     end: event.endDate,
                                                                     location: event.location)
                            statusText = "Added to Calendar ✅"
                        } catch {
                            statusText = "Calendar error: \(error.localizedDescription)"
                        }
                    }
                }
                if let statusText { Text(statusText).foregroundStyle(.secondary) }
            }
        }
        .navigationTitle(event.title)
    }
}
