//
//  GradientOutlinedText.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//

import SwiftUI

struct 

ProcessorReaderProcessor: View {
    let text: String
    let fontName: String
    let size: CGFloat
    var strokeWidth: Double = 15

    var body: some View {
        let base = Text(text)
            .font(.custom(fontName, size: size))
            .fixedSize()

        let fill = LinearGradient(
            colors: [Color(hex: 0xFFFFFF), Color(hex: 0xFF9759)],
            startPoint: .top, endPoint: .bottom
        )
        .mask(base)

        var a = AttributedString(text)
        a.font = .custom(fontName, size: size)
        a.foregroundColor = .clear
        a.strokeColor = .white
        a.strokeWidth = strokeWidth

        let stroked = Text(a).fixedSize()

        let outline = LinearGradient(
            colors: [Color(hex: 0xDF5B0C), Color(hex: 0x3F1C07)],
            startPoint: .top, endPoint: .bottom
        )
        .mask(stroked)

        return ZStack { fill; outline }
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >>  8) & 0xFF) / 255,
                  blue:  Double((hex      ) & 0xFF) / 255,
                  opacity: alpha)
    }
}
