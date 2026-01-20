//
//  NewsFeedView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI
import AVFoundation

struct NewsFeedView: View {
    @Environment(AppStore.self) private var store
    @State private var filter: AnnouncementLevel? = nil
    @State private var tts = AVSpeechSynthesizer()

    var filtered: [Announcement] {
        if let filter { return store.announcements.filter { $0.level == filter }.sorted(by: { $0.date > $1.date }) }
        return store.announcements.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Level", selection: $filter) {
                        Text("All").tag(AnnouncementLevel?.none)
                        ForEach(AnnouncementLevel.allCases) { lvl in
                            Text(lvl.rawValue.capitalized).tag(AnnouncementLevel?.some(lvl))
                        }
                    }
                }

                ForEach(filtered) { a in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(a.title).font(.headline)
                            Spacer()
                            Text(a.level.rawValue.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Text(a.body).font(.subheadline)
                        Text(a.date, style: .date).font(.caption).foregroundStyle(.secondary)

                        HStack {
                            Button(a.isSaved ? "Saved" : "Save") {
                                if let idx = store.announcements.firstIndex(where: { $0.id == a.id }) {
                                    store.announcements[idx].isSaved.toggle()
                                    store.persist()
                                }
                            }

                            Button("Listen") {
                                let utterance = AVSpeechUtterance(string: "\(a.title). \(a.body)")
                                utterance.rate = 0.5
                                tts.speak(utterance)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("News")
        }
    }
}
