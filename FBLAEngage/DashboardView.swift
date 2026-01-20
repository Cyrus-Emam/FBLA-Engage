//
//  DashboardView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store

    private var upcomingEvents: [FBLAEvent] {
        store.events.sorted { $0.startDate < $1.startDate }
    }

    private var nextEvent: FBLAEvent? {
        upcomingEvents.first
    }

    private var savedAnnouncementsCount: Int {
        store.announcements.filter { $0.isSaved }.count
    }

    private var offlineResourcesCount: Int {
        store.resources.filter { $0.isSavedOffline }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {

                    // MARK: - Branded Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FBLA Engage")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Inclusive Member Companion")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 4)
                    .padding(.bottom, 4)

                    // MARK: - Member Hero Card
                    NavigationLink {
                        ProfileSettingsView()
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Welcome")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)

                                    Text(store.profile.name)
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    Text("\(store.profile.chapter) • \(store.profile.role.rawValue.capitalized)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 34))
                                    .foregroundStyle(.secondary)
                            }

                            HStack(spacing: 10) {
                                Label("Settings", systemImage: "gearshape")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)

                                Spacer()

                                Label("Profile", systemImage: "person.text.rectangle")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(14)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    // MARK: - Quick Stats Row
                    HStack(spacing: 10) {
                        StatCard(
                            title: "Upcoming",
                            value: "\(min(upcomingEvents.count, 3))",
                            systemImage: "calendar"
                        )

                        StatCard(
                            title: "Saved",
                            value: "\(savedAnnouncementsCount)",
                            systemImage: "bookmark.fill"
                        )

                        StatCard(
                            title: "Offline",
                            value: "\(offlineResourcesCount)",
                            systemImage: "arrow.down.circle.fill"
                        )
                    }

                    // MARK: - Next Event Highlight
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Next Event")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "bell.badge")
                                .foregroundStyle(.secondary)
                        }

                        if let e = nextEvent {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(e.title)
                                    .font(.title3)
                                    .fontWeight(.semibold)

                                HStack(spacing: 8) {
                                    Label(
                                        e.startDate.formatted(date: .abbreviated, time: .omitted),
                                        systemImage: "calendar"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                    Spacer()

                                    Text(e.startDate.formatted(date: .omitted, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                if !e.location.isEmpty {
                                    Label(e.location, systemImage: "mappin.and.ellipse")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(14)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        } else {
                            Text("No upcoming events yet. Add an event to get started.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                    }

                    // MARK: - Upcoming List Preview
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Upcoming")
                                .font(.headline)
                            Spacer()
                            Text("Top 3")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        VStack(spacing: 10) {
                            ForEach(upcomingEvents.prefix(3)) { e in
                                UpcomingRow(event: e)
                            }

                            if upcomingEvents.isEmpty {
                                Text("No events scheduled.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(14)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    // MARK: - Saved Summary
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Saved Items")
                            .font(.headline)

                        HStack {
                            Label("Saved announcements", systemImage: "bookmark")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(savedAnnouncementsCount)")
                                .fontWeight(.semibold)
                        }

                        HStack {
                            Label("Offline resources", systemImage: "arrow.down.circle")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(offlineResourcesCount)")
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(14)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    Spacer(minLength: 8)
                }
                .padding()
            }
        }
        .environment(\.dynamicTypeSize, store.profile.largeText ? .xxxLarge : .large)
    }
}

// MARK: - Components

private struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)

            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct UpcomingRow: View {
    let event: FBLAEvent

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 4) {
                Text(event.startDate.formatted(.dateTime.month(.abbreviated)))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(event.startDate.formatted(.dateTime.day()))
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(width: 56)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text(event.startDate.formatted(date: .omitted, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
