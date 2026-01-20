# FBLA Engage

FBLA Engage is an iOS mobile application designed to improve FBLA member engagement by centralizing communication, events, resources, and chapter connections in one secure and accessible platform.

This project was developed for the **FBLA Mobile Application Development Competitive Event (2025–2026)**.

---

## Problem Statement

FBLA information is often distributed across multiple platforms such as emails, documents, websites, and social media. This fragmentation can result in missed deadlines, disconnected members, and accessibility barriers for students with disabilities or language challenges.

---

## Solution Overview

FBLA Engage addresses these challenges by providing:
- A centralized hub for FBLA communication and resources
- Chapter-verified access using school codes and moderator approval
- Built-in accessibility tools for inclusive participation
- Engagement features that support meetings, events, and chapter connection

---

## Core Features

### Member Access & Security
- Name-based member profiles
- School code entry for chapter verification
- Moderator approval for controlled access
- Chapter-specific content visibility

### FBLA Functionality
- Events calendar with reminders for meetings and competitions
- News feed for announcements and updates
- Access to FBLA resources and documents
- Chapter-managed social media links (Instagram, TikTok, etc.)

### Accessibility & Inclusion
- Live captions (Meeting Mode) for real-time accessibility
- Scan-to-text functionality for flyers and printed materials
- Support for 10+ languages to reduce language barriers

### Engagement Tools
- QR code check-in for meetings and events
- Chapter social hub linking official platforms
- Designed to encourage consistent participation

---

## Code Architecture

The codebase is organized by **responsibility and feature grouping**, using modular SwiftUI views, shared state management, and service layers.

---

### App Entry & Navigation
Defines how the app launches and how users move through core sections.

- **FBLAEngageApp.swift** — App entry point (`@main`), initializes the app.
- **ContentView.swift** — Initial container view and routing logic.
- **RootTabsView.swift** — Main tab navigation shell.
- **DashboardView.swift** — Home overview screen with summary components (`StatCard`, `UpcomingRow`).

---

### Data Models & Shared State
Reusable data and global state accessed across views.

- **Models.swift** — Core data models (events, resources, members).
- **AppStore.swift** — Centralized app state manager (`ObservableObject`).
- **CalendarService.swift** — Handles event and reminder scheduling logic.
- **SupportedLanguage.swift** — Defines supported languages and localization logic.

---

### Events & Calendar (Deadlines & Competitions)
Supports event awareness and deadline tracking.

- **EventsView.swift** — Events list and calendar screen.
- **EventDetailView.swift** — Detailed view of a single event.
- **AddEventView.swift** — Manual event creation interface.
- **FlyerScanCreateEventView.swift** — Event creation using scanned flyer text.

---

### Resources & Documents
Provides access to FBLA documents and materials.

- **ResourcesView.swift** — Resource library browsing interface.
- **ResourceDetailView.swift** — Detailed resource display.

---

### News & Announcements
Handles chapter and organization updates.

- **NewsFeedView.swift** — Announcement and updates feed.

---

### Social Media Integration
Supports chapter-managed social engagement.

- **SocialView.swift** — Social hub with links to chapter platforms.

---

### Accessibility & Engagement Tools
Advanced features that exceed baseline competition requirements.

- **ToolsView.swift** — Central hub for engagement and accessibility tools.
- **MeetingListenView.swift** — Live captions / meeting accessibility mode.
- **ScanToTextOCRView.swift** — OCR scan-to-text interface.
- **DataScannerViewRepresentable.swift** — UIKit scanner integration for SwiftUI.
- **QRCheckInView.swift** — QR code scanning for meeting/event check-in.

---

### High-Level View Flow

FBLAEngageApp
- ContentView
- RootTabsView
- DashboardView
- EventsView → EventDetailView / AddEventView
- ResourcesView → ResourceDetailView
- NewsFeedView
- SocialView
- ToolsView → MeetingListenView / ScanToTextOCRView / QRCheckInView


Shared across multiple views:
- `AppStore`
- `Models`
- `CalendarService`
- `SupportedLanguage`

---

## User Experience Design

- Simple, intuitive navigation with minimal steps
- Consistent visual hierarchy and layout
- Clear input validation and user feedback
- Accessibility-first design across core features

---

## Technical Details

- **Platform:** iOS  
- **Language:** Swift  
- **Framework:** SwiftUI  
- **Tools:** Xcode  
- **Architecture:** Modular views, reusable components, shared state management

The application runs standalone on a smartphone and does not require App Store distribution.

---

## Planning Process

1. Problem identification based on common FBLA engagement challenges  
2. Feature-to-rubric mapping to ensure full requirement coverage  
3. UX wireframing and user-flow planning  
4. Iterative development, testing, and refinement  

---

## Data Handling

- Validated user input (e.g., school codes, required fields)
- Structured data handling to maintain integrity
- Controlled access through moderator approval

---

## Documentation & Compliance

- Source code documented within this repository
- No copyrighted material used without attribution
- Developed for educational purposes only
- Not affiliated with or endorsed by FBLA

---

## Version

**v1.0** — Initial tagged release for competition submission
