import UIKit

struct ActivityTableCellModel {
    let distance: Double
    let duration: Double
    let type: String
    let icon: UIImage
    let startDate: Date
    let stopDate: Date
    let name: String

    func timeAgo() -> String {
        return startDate.timeAgoDisplay()
    }
    func startTime() -> String {
        return startDate.clockDisplay()
    }
    func stopTime() -> String {
        return stopDate.clockDisplay()
    }
    func formattedDistance() -> String {
        return String(format: "%.2f", distance / 1000) + " км"
    }
    func formattedDuration() -> String {
        return duration.stringFormat()
    }
}
