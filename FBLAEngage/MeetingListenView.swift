//
//  MeetingListenView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI
import Speech
import AVFoundation

struct MeetingListenView: View {
    @Environment(AppStore.self) private var store

    @State private var isRunning = false
    @State private var service: SpeechTranscriptionService?

    // This is the only transcript shown. It only ever grows unless user clears it.
    @State private var transcript: String = ""

    // Track the recognizer’s last partial string to compute deltas safely.
    @State private var lastPartial: String = ""

    @State private var showClearConfirm = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Live Captions")
                .font(.title2)
                .bold()

            ScrollViewReader { proxy in
                ScrollView {
                    Text(transcript.isEmpty
                         ? "Tap Start to begin live transcription…\n\nText will keep scrolling and will not disappear unless you Clear it."
                         : transcript)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .id("BOTTOM")
                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onChange(of: transcript.count) { _ in
                    // Auto-scroll as transcript grows
                    withAnimation {
                        proxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }

            HStack(spacing: 10) {
                Button(isRunning ? "Stop" : "Start") {
                    if isRunning {
                        stopListening()
                    } else {
                        startListening()
                    }
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: transcript.isEmpty ? " " : transcript) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
                .disabled(transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Button(role: .destructive) {
                showClearConfirm = true
            } label: {
                Label("Clear Transcript", systemImage: "trash")
            }
            .buttonStyle(.bordered)
            .disabled(isRunning || transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .confirmationDialog("Clear transcript?", isPresented: $showClearConfirm, titleVisibility: .visible) {
                Button("Clear", role: .destructive) {
                    transcript = ""
                    lastPartial = ""
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will remove the transcript from the screen. This cannot be undone.")
            }

            Text("On-device speech-to-text • Language: \(store.profile.preferredLanguageCode)")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Meeting Mode")
        .onDisappear {
            if isRunning { stopListening() }
        }
    }

    private func startListening() {
        service = SpeechTranscriptionService(languageCode: store.profile.preferredLanguageCode)
        lastPartial = "" // reset delta tracker for this session

        Task {
            do {
                try await service?.start { newPartial, isFinal in
                    appendOnlyUpdate(with: newPartial, isFinal: isFinal)
                }
                isRunning = true
            } catch {
                // Append error (never clear existing transcript)
                if !transcript.isEmpty { transcript += "\n" }
                transcript += "Speech error: \(error.localizedDescription)"
                isRunning = false
            }
        }
    }

    private func stopListening() {
        service?.stop()
        isRunning = false

        // Commit a newline between sessions for readability (optional)
        let trimmed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !transcript.hasSuffix("\n") {
            transcript += "\n"
        }

        lastPartial = ""
    }

    /// Core logic: NEVER delete text.
    /// Only append when newPartial extends lastPartial.
    /// Ignore rewrites/shorter partials.
    private func appendOnlyUpdate(with newPartial: String, isFinal: Bool) {
        let a = lastPartial
        let b = newPartial

        // If recognizer extends the previous partial, append only the delta.
        if !a.isEmpty, b.hasPrefix(a), b.count > a.count {
            let delta = String(b.dropFirst(a.count))
            transcript += delta
        } else if a.isEmpty, !b.isEmpty, transcript.isEmpty {
            // First words of a brand-new transcript
            transcript = b
        } else if a.isEmpty, !b.isEmpty, !transcript.isEmpty {
            // New session started but transcript already has text:
            // add a space/newline if needed, then append all.
            if !transcript.hasSuffix("\n") && !transcript.hasSuffix(" ") {
                transcript += " "
            }
            transcript += b
        } else {
            // Recognizer rewrite/shortening/noise — ignore so nothing “disappears”.
        }

        lastPartial = b

        if isFinal {
            // Finalize with a newline so it reads like a running log.
            if !transcript.hasSuffix("\n") {
                transcript += "\n"
            }
            lastPartial = ""
        }
    }
}

// MARK: - Speech Service (on-device, language-aware)

final class SpeechTranscriptionService {
    private let recognizer: SFSpeechRecognizer
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    init(languageCode: String) {
        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))!
    }

    func start(onUpdate: @escaping (_ partial: String, _ isFinal: Bool) -> Void) async throws {
        let auth = await SFSpeechRecognizer.requestAuthorizationAsync()
        guard auth == .authorized else {
            throw NSError(domain: "Speech", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Speech permission not granted"])
        }

        let micGranted = await AVAudioSession.sharedInstance().requestRecordPermissionAsync()
        guard micGranted else {
            throw NSError(domain: "Mic", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Microphone permission not granted"])
        }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement)
        try session.setActive(true)

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.requiresOnDeviceRecognition = true
        request?.shouldReportPartialResults = true

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        task = recognizer.recognitionTask(with: request!) { result, error in
            if let result {
                onUpdate(result.bestTranscription.formattedString, result.isFinal)
            }
            if error != nil {
                self.stop()
            }
        }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        try? AVAudioSession.sharedInstance().setActive(false)

        request = nil
        task = nil
    }
}

// MARK: - Async helpers

extension SFSpeechRecognizer {
    static func requestAuthorizationAsync() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { cont in
            requestAuthorization { cont.resume(returning: $0) }
        }
    }
}

extension AVAudioSession {
    func requestRecordPermissionAsync() async -> Bool {
        await withCheckedContinuation { cont in
            requestRecordPermission { cont.resume(returning: $0) }
        }
    }
}
