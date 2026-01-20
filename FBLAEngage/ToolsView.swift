//
//  ToolsView.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

import SwiftUI

struct ToolsView: View {
    var body: some View {
        List {
            NavigationLink {
                ScanToTextOCRView()
            } label: {
                Label("Scan to Text (OCR)", systemImage: "text.viewfinder")
            }

            NavigationLink {
                MeetingListenView()
            } label: {
                Label("Meeting Mode (Live Captions)", systemImage: "waveform")
            }

            NavigationLink {
                QRCheckInView()
            } label: {
                Label("QR Check-In", systemImage: "qrcode.viewfinder")
            }
        }
        .navigationTitle("Tools")
    }
}
