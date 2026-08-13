//
//  HeaderView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        
        
        VStack {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 50, weight: .bold, design: .rounded))
            
            
            //Title
            Text(title)
                .font(.system(size: 40, weight: .bold, design: .rounded))
            
            // Subtitle
            Text(subtitle)
                .font(.system(size: 20, weight: .bold, design: .rounded))
        }
    }
}

#Preview {
    HeaderView(title: "Test", subtitle: "This is a test", icon: "wallet.bifold.fill")
}
