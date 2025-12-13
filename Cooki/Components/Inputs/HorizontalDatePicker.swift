//
//  DateItem.swift
//  Cooki
//
//  Created by Neth Botheju on 8/12/2025.
//
import SwiftUI

struct DateItem: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let dayName: String
    let dayNumber: String
    
    static func == (lhs: DateItem, rhs: DateItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct HorizontalDatePicker: View {
    @State private var dates: [DateItem] = []
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dates) { item in
                            DateCell(
                                dayName: item.dayName,
                                dayNumber: item.dayNumber,
                                isSelected: Calendar.current.isDate(item.date, inSameDayAs: selectedDate)
                            )
                            .id(item.id)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDate = item.date
                                    proxy.scrollTo(item.id, anchor: .center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width / 2 - 25)
                    .padding(.vertical, 16)
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.15),
                            .init(color: .black, location: 0.85),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .onChange(of: dates) { _ in
                    if let todayItem = dates.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
                        DispatchQueue.main.async {
                            proxy.scrollTo(todayItem.id, anchor: .center)
                        }
                    }
                }
            }
        }
        .onAppear {
            generateDates()
        }
    }
    
    func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        dates = (-7...30).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let dayName = formatter.string(from: date).uppercased()
            
            let dayNumber = calendar.component(.day, from: date)
            
            return DateItem(
                date: date,
                dayName: dayName,
                dayNumber: "\(dayNumber)"
            )
        }
    }
}

struct DateCell: View {
    let dayName: String
    let dayNumber: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(dayNumber)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textGreyDark)
        }
        .frame(width: 50, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.secondaryPurple.opacity(0.3) : Color.white)
        )
    }
}

// MARK: - Preview
struct HorizontalDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HorizontalDatePicker()
        }
    }
}
