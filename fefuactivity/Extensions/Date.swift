import Foundation

extension Date {
    func days(_ date: Date = Date()) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: date).day
    }
    
    func shift(unit: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: unit, value: value, to: self)
    }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        return formatter.localizedString(for: self, relativeTo: Date())
    }

    func clockDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: self)
    }

    func callendarDate() -> Date {
        let calendar = Calendar.current
        let date = calendar.dateComponents([.year, .month, .day], from: self)

        return calendar.date(from: date) ?? self
    }
    
    func callendarDisplay() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM y"

        return formatter.string(from: self)
    }
}
