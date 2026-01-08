//
//  FirebaseDailyIntakeService.swift
//  Cooki
//
//  Created by Rohit Valanki on 6/1/2026.
//

import Foundation
import FirebaseFirestore

@MainActor
class FirebaseDailyIntakeService: DailyIntakeServiceProtocol {

    private let db = Firestore.firestore()
    private let calendar = Calendar.current

    /// Fetch daily intakes from startDate → endDate
    func fetchDailyIntakes(from startDate: Date, to endDate: Date) async throws -> [DailyIntake] {
        guard let uid = CurrentUser.shared.user?.id else { return [] }

        var intakes: [DailyIntake] = []
        var date = calendar.startOfDay(for: startDate)

        while date <= endDate {
            let dateId = date.yyyMMdd
            let docRef = db.collection("users")
                .document(uid)
                .collection("dailyIntake")
                .document(dateId)

            let snapshot = try await docRef.getDocument()

            if let data = snapshot.data() {
                let intake = try Firestore.Decoder().decode(DailyIntake.self, from: data)
                intakes.append(intake)
            } else {
                // Create empty intake
                let emptyIntake = createEmptyIntake(forDate: date)
                try await docRef.setData(Firestore.Encoder().encode(emptyIntake))
                intakes.append(emptyIntake)
            }

            guard let next = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = next
        }

        return intakes
    }

    /// Empty daily intake with all zeros
    private func createEmptyIntake(forDate date: Date) -> DailyIntake {
        let totalIntake = IntakeProgress(units: .calories, userGoal: 2500, currentValue: 0)
        let macros = MacroType.allCases.map {
            Macro(macroType: $0, currentIntake: IntakeProgress(units: .grams, userGoal: 0, currentValue: 0))
        }
        return DailyIntake(id: date.yyyMMdd, date: date, totalIntake: totalIntake, macros: macros)
    }
}
