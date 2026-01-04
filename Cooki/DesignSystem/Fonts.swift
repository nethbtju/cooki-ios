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
        .custom("Inter-Regular_Black", size: 18)
    }
    static func heading3() -> Font {
        .custom("Poppins-Bold", size: 28)
    }
    static func heading4() -> Font {
        .custom("Poppins-Bold", size: 14)
    }
    static func lightBody() -> Font {
        .custom("Inter-Regular", size: 14)
    }
    static func buttonFont() -> Font {
        .custom("Inter-Regular_Bold", size: 14)
    }
    static func buttonFontSmall() -> Font {
        .custom("Inter-Regular_Bold", size: 12)
    }
    static func notifFont() -> Font {
        .custom("Inter-Regular_Bold", size: 16)
    }
    static func subheading() -> Font {
        .custom("Inter-Regular", size: 20)
    }
    static func cardTitle() -> Font {
        .custom("Inter-Regular_Bold", size: 14)
    }
    static func smallBody() -> Font {
        .custom("Inter-Regular", size: 10)
    }
    static func smallBody2() -> Font {
        .custom("Inter-Regular", size: 8)
    }
    static func regularBody() -> Font {
        .custom("Inter-Regular", size: 12)
    }
    static func macroText() -> Font {
        .custom("Inter-SemiBold", size: 10)
    }
    static func progressMacroText() -> Font {
        .custom("Inter-Regular", size: 8)
    }
}
