//
//  FlyerScanCreateEventView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI
import VisionKit

struct FlyerScanCreateEventView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var scannedText: String = ""
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var details: String = ""
    @State private var startDate: Date = Date().addingTimeInterval(60*60*24)
    @State private var endDate: Date = Date().addingTimeInterval(60*60*25)

    var body: some View {
        NavigationStack {
            List {
                Section("1) Scan Flyer") {
                    DataScannerViewRepresentable(recognizedText: $scannedText)
                        .frame(height: 320)
                }

                Section("2) Extracted Text") {
                    Text(scannedText.isEmpty ? "Scan a flyer to capture text…" : scannedText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("3) Suggested Event") {
                    TextField("Title", text: $title)
                    TextField("Location", text: $location)
                    TextField("Details", text: $details, axis: .vertical)
                    DatePicker("Start", selection: $startDate)
                    DatePicker("End", selection: $endDate)

                    Button("Auto-Fill from Text") {
                        let suggestion = FlyerParser.suggest(from: scannedText)
                        title = suggestion.title
                        details = suggestion.details
                        location = suggestion.location
                        startDate = suggestion.start
                        endDate = suggestion.end
                    }
                    .disabled(scannedText.isEmpty)
                }
            }
            .navigationTitle("Flyer Scan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        store.events.append(
                            FBLAEvent(title: title.isEmpty ? "New FBLA Event" : title,
                                      details: details,
                                      startDate: startDate,
                                      endDate: endDate,
                                      location: location,
                                      createdFromScan: true)
                        )
                        store.persist()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FlyerParser {
    static func suggest(from text: String) -> (title: String, details: String, location: String, start: Date, end: Date) {
        // Very lightweight, competition-safe heuristic (improve later)
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = cleaned.split(separator: "\n").first.map(String.init) ?? "FBLA Event"
        let details = cleaned

        // TODO: Upgrade parsing with date detector / regex for judge wow-factor.
        let start = Date().addingTimeInterval(60*60*24*3)
        let end = start.addingTimeInterval(60*60)

        return (title, details, "TBD", start, end)
    }
}
