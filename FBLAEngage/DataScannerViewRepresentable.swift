//
//  DataScannerViewRepresentable.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI
import VisionKit

struct DataScannerViewRepresentable: UIViewControllerRepresentable {
    @Binding var recognizedText: String

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedText: String
        init(recognizedText: Binding<String>) { _recognizedText = recognizedText }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case .text(let textItem) = item {
                recognizedText += (recognizedText.isEmpty ? "" : "\n") + textItem.transcript
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            let lines = allItems.compactMap { item -> String? in
                if case .text(let t) = item { return t.transcript }
                return nil
            }
            recognizedText = Array(Set(lines)).sorted().joined(separator: "\n")
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didBecomeUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            recognizedText = "Scanner unavailable: \(error)"
        }
    }
}
