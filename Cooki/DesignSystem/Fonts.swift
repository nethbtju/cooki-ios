//
//  Fonts.swift
//  Cooki
//
//  Created by Neth Botheju on 6/9/2025.
//
import SwiftUI

struct AppFonts {
    static func heading() -> Font {
        .custom("Inter-Regular_Black", size: 26)
    }
    static func heading2() -> Font {
        .custom("Inter-Regular_Black", size: 16)
    }
    static func lightBody() -> Font {
        .custom("Inter-Regular", size: 14)
    }
    static func buttonFont() -> Font {
        .custom("Inter-Regular_Bold", size: 14)
    }
    static func subheading() -> Font {
        .custom("Inter-Regular", size: 20)
    }
    static func smallBody() -> Font {
        .custom("Inter-Regular", size: 10)
    }
    static func regularBody() -> Font {
        .custom("Inter-Regular", size: 12)
    }
}
