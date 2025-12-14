//
//  MeasurementUnit.swift
//  Cooki
//
//  Created by Neth Botheju on 14/12/2025.
//
import SwiftUI

enum MeasurementUnit: String, Codable, CaseIterable {
    
    // MARK: - Weight
    case grams = "g"
    case kilograms = "kg"
    case ounces = "oz"
    case pounds = "lb"
    
    // MARK: - Volume
    case milliliters = "ml"
    case liters = "l"
    case teaspoons = "tsp"
    case tablespoons = "tbsp"
    case cups = "cup"
    case fluidOunces = "fl oz"
    
    // MARK: - Count
    case pieces = "pcs"
    
    // MARK: - Energy
    case calories = "cal"
    case kilojoules = "kJ"
}
