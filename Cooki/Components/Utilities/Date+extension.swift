//
//  Date+extension.swift
//  Cooki
//
//  Created by Neth Botheju on 22/11/2025.
//
import SwiftUI

extension Date {
    var day: String {
        formatted(.dateTime.weekday(.abbreviated))
    }
}
