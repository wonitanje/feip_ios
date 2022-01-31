import Foundation
import Charts

//class ChartXAxisFormatter: NSObject {
//
//    fileprivate var dateFormatter: DateFormatter?
//    fileprivate var referenceTimeInterval: TimeInterval?
//
//    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
//        self.init()
//        self.referenceTimeInterval = referenceTimeInterval
//        self.dateFormatter = dateFormatter
//    }
//}
//
//
//extension ChartXAxisFormatter: IAxisValueFormatter {
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        guard let dateFormatter = dateFormatter,
//        let referenceTimeInterval = referenceTimeInterval
//        else {
//            return ""
//        }
//
//        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
//        return dateFormatter.string(from: date)
//    }
//}

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    private var dates: [Date]?
    
    lazy private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        return dateFormatter
    }()

    convenience init(dates: [Date]) {
        self.init()
        self.dates = dates
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)

        guard let dates = dates, index < dates.count else {
            return "?"
        }
        
        return dateFormatter.string(from: dates[index])
    }
}
