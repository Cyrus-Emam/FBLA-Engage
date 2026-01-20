//
//  AddEventView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct AddEventView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var details = ""
    @State private var location = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(60*60)

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Location", text: $location)
                TextField("Details", text: $details, axis: .vertical)
                DatePicker("Start", selection: $startDate)
                DatePicker("End", selection: $endDate)
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.events.append(
                            FBLAEvent(title: title, details: details, startDate: startDate, endDate: endDate, location: location, createdFromScan: false)
                        )
                        store.persist()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
