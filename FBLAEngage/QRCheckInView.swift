//
//  QRCheckInView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI
import AVFoundation

struct QRCheckInView: View {
    @State private var scanned: String = "Scan a QR code to check in."
    @State private var isShowingScanner = false

    var body: some View {
        VStack(spacing: 16) {
            Text("QR Check-In")
                .font(.title2).bold()

            Text(scanned)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Button("Open Scanner") { isShowingScanner = true }
                .buttonStyle(.borderedProminent)

            Text("Use case: fast attendance tracking without paperwork.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Check-In")
        .sheet(isPresented: $isShowingScanner) {
            QRScannerSheet(resultText: $scanned)
        }
    }
}

struct QRScannerSheet: UIViewControllerRepresentable {
    @Binding var resultText: String

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = QRScannerViewController()
        vc.onCode = { code in
            resultText = "Checked in ✅\n\(code)"
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

final class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onCode: ((String) -> Void)?

    private let session = AVCaptureSession()
    private let preview = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        if session.canAddInput(input) { session.addInput(input) }

        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) { session.addOutput(output) }
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]

        preview.session = session
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.addSublayer(preview)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let string = obj.stringValue else { return }
        onCode?(string)
        dismiss(animated: true)
    }
}
