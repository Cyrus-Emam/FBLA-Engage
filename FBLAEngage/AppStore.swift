//
//  AppStore.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import Foundation
import Observation

@Observable
final class AppStore {
    var profile: MemberProfile
    var events: [FBLAEvent]
    var resources: [ResourceDoc]
    var announcements: [Announcement]
    var socialLinks: [SocialLink]

    private let storage = LocalJSONStorage()

    init() {
        // Load if exists; otherwise seed sample data
        if let loaded: PersistedData = storage.load(PersistedData.self, filename: PersistedData.filename) {
            self.profile = loaded.profile
            self.events = loaded.events
            self.resources = loaded.resources
            self.announcements = loaded.announcements
            self.socialLinks = loaded.socialLinks
        } else {
            self.profile = MemberProfile(
                name: "Student Name",
                chapter: "Woodinville HS",
                role: .member,
                preferredLanguageCode: "en-US",
                largeText: false
            )


            self.events = [
                FBLAEvent(
                    title: "Chapter Meeting",
                    details: "Monthly meeting with announcements and deadlines.",
                    startDate: Date().addingTimeInterval(60*60*24*2),
                    endDate: Date().addingTimeInterval(60*60*24*2 + 60*60),
                    location: "Room 204",
                    createdFromScan: false
                )
            ]

            self.resources = [
                ResourceDoc(title: "Competitive Events Guide", category: "Competition", summary: "Quick access to event categories, rubrics, and rules.", localFilename: nil, isSavedOffline: true),
                ResourceDoc(title: "Officer Handbook", category: "Leadership", summary: "Roles, responsibilities, and chapter operations.", localFilename: nil, isSavedOffline: true)
            ]

            self.announcements = [
                Announcement(level: .chapter, title: "Sign up for events", body: "Please submit your competition selections by Friday.", date: Date(), isSaved: false),
                Announcement(level: .state, title: "State Conference Update", body: "Registration timeline and deadlines are now posted.", date: Date().addingTimeInterval(-60*60*24*2), isSaved: false)
            ]

            self.socialLinks = [
                SocialLink(platform: "Instagram", urlString: "https://instagram.com"),
                SocialLink(platform: "TikTok", urlString: "https://tiktok.com"),
                SocialLink(platform: "YouTube", urlString: "https://youtube.com")
            ]

            persist()
        }
    }

    func persist() {
        let data = PersistedData(profile: profile, events: events, resources: resources, announcements: announcements, socialLinks: socialLinks)
        storage.save(data, filename: PersistedData.filename)
    }
}

struct PersistedData: Codable {
    static let filename = "fbla_engage_data.json"
    var profile: MemberProfile
    var events: [FBLAEvent]
    var resources: [ResourceDoc]
    var announcements: [Announcement]
    var socialLinks: [SocialLink]
}

final class LocalJSONStorage {
    private func url(for filename: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(filename)
    }

    func save<T: Encodable>(_ value: T, filename: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url(for: filename), options: [.atomic])
        } catch {
            print("Save error:", error)
        }
    }

    func load<T: Decodable>(_ type: T.Type, filename: String) -> T? {
        do {
            let data = try Data(contentsOf: url(for: filename))
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
}
