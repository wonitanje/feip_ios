import UIKit

struct ActivityTableCellModel {
    let distance: String
    let duration: String
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
}
