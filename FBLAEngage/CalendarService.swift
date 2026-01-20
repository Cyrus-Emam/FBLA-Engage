//
//  CalendarService.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import EventKit

final class CalendarService {
    private let store = EKEventStore()

    func addToCalendar(title: String, notes: String, start: Date, end: Date, location: String) async throws {
        let granted = try await store.requestFullAccessToEvents()
        guard granted else { throw NSError(domain: "Calendar", code: 1, userInfo: [NSLocalizedDescriptionKey: "Calendar permission not granted"]) }

        let event = EKEvent(eventStore: store)
        event.title = title
        event.notes = notes
        event.location = location
        event.startDate = start
        event.endDate = end
        event.calendar = store.defaultCalendarForNewEvents

        try store.save(event, span: .thisEvent)
    }
}
