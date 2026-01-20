//
//  ProfileSettingsView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        Form {

            Section("Profile") {
                TextField("Name", text: Binding(
                    get: { store.profile.name },
                    set: { store.profile.name = $0; store.persist() }
                ))

                TextField("Chapter", text: Binding(
                    get: { store.profile.chapter },
                    set: { store.profile.chapter = $0; store.persist() }
                ))

                Picker("Role", selection: Binding(
                    get: { store.profile.role },
                    set: { store.profile.role = $0; store.persist() }
                )) {
                    ForEach(MemberRole.allCases) { role in
                        Text(role.rawValue.capitalized).tag(role)
                    }
                }
            }

            Section("Inclusion & Accessibility") {

                Picker("Preferred Language", selection: Binding(
                    get: {
                        SupportedLanguage(rawValue: store.profile.preferredLanguageCode) ?? .english
                    },
                    set: { newLang in
                        store.profile.preferredLanguageCode = newLang.rawValue
                        store.persist()
                    }
                )) {
                    ForEach(SupportedLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }

                Toggle("Large Text", isOn: Binding(
                    get: { store.profile.largeText },
                    set: {
                        store.profile.largeText = $0
                        store.persist()
                    }
                ))

                Text("Only languages that support on-device speech-to-text are shown.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
