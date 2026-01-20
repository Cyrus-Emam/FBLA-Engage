//
//  Models.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import Foundation

enum MemberRole: String, Codable, CaseIterable, Identifiable {
    case member, officer
    var id: String { rawValue }
}

enum AnnouncementLevel: String, Codable, CaseIterable, Identifiable {
    case national, state, chapter
    var id: String { rawValue }
}

struct MemberProfile: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var chapter: String
    var role: MemberRole

    // Inclusion & Accessibility (simplified)
    var preferredLanguageCode: String   // e.g. "en-US", "ru-RU"
    var largeText: Bool
}

struct FBLAEvent: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var details: String
    var startDate: Date
    var endDate: Date
    var location: String
    var createdFromScan: Bool
}

struct ResourceDoc: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var summary: String
    var localFilename: String?
    var isSavedOffline: Bool
}

struct Announcement: Codable, Identifiable {
    var id: UUID = UUID()
    var level: AnnouncementLevel
    var title: String
    var body: String
    var date: Date
    var isSaved: Bool
}

struct SocialLink: Codable, Identifiable {
    var id: UUID = UUID()
    var platform: String
    var urlString: String
}
