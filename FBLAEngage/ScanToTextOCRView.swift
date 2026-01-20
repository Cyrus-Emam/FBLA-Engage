//
//  ScanToTextOCRView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/4/26.
//

import SwiftUI
import VisionKit

struct ScanToTextOCRView: View {
    @State private var showScanner = false
    @State private var extractedText: String = ""

    var body: some View {
        VStack(spacing: 14) {
            Text("Scan to Text")
                .font(.title2)
                .bold()

            Text("Use the iPhone camera to capture printed text and convert it into editable text.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            ScrollView {
                Text(extractedText.isEmpty ? "No text captured yet." : extractedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing: 10) {
                Button {
                    showScanner = true
                } label: {
                    Label("Open Scanner", systemImage: "text.viewfinder")
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: extractedText.isEmpty ? " " : extractedText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
                .disabled(extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Button(role: .destructive) {
                extractedText = ""
            } label: {
                Label("Clear", systemImage: "trash")
            }
            .buttonStyle(.bordered)
            .disabled(extractedText.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Scan to Text")
        .sheet(isPresented: $showScanner) {
            OCRScannerControllerRepresentable(
                recognizedText: $extractedText
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - UIKit wrapper around DataScannerViewController

struct OCRScannerControllerRepresentable: UIViewControllerRepresentable {
    @Binding var recognizedText: String

    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        // If device doesn’t support scanning, show a friendly screen.
        guard DataScannerViewController.isSupported else {
            return UIHostingController(rootView:
                ContentUnavailableView("Scanner Not Supported", systemImage: "camera.fill", description: Text("This device does not support Live Text scanning."))
                    .padding()
            )
        }

        // Configure scanner for text
        let vc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )

        vc.delegate = context.coordinator

        // Start scanning immediately
        try? vc.startScanning()

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedText: String

        init(recognizedText: Binding<String>) {
            _recognizedText = recognizedText
        }

        // Called when new items are recognized
        func dataScanner(_ dataScanner: DataScannerViewController,
                         didAdd addedItems: [RecognizedItem],
                         allItems: [RecognizedItem]) {
            for item in addedItems {
                switch item {
                case .text(let textItem):
                    let cleaned = textItem.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !cleaned.isEmpty else { continue }

                    if recognizedText.isEmpty {
                        recognizedText = cleaned
                    } else {
                        recognizedText += "\n" + cleaned
                    }

                default:
                    break
                }
            }
        }
    }
}
