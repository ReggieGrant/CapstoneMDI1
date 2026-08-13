//
//  UploadView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//
import SwiftUI

struct UploadView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.rain.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "667eea"))
            Text("Share Your Weather Moment")
                .font(.title2.bold())
            Text("Upload feature coming soon")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Share")
    }
}
