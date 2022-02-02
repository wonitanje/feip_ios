import Foundation
import Charts

class ProfileCharts: LineChartView {
    
    var activitiesData: [ActivitiesTableModel] = []
    var distance: Double = 0
    var duration: Double = 0
    
    func initCharts() {
        stylizeCharts()
        loadCharts()
    }
    
    private func stylizeCharts() {
        self.dragEnabled = false
        self.doubleTapToZoomEnabled = false

        self.rightAxis.drawLabelsEnabled = false

        self.xAxis.labelPosition = .bottom
    }
    
    private func loadCharts() {
        fetchLocalActivities()

        let dateDay = DateFormatter()
        dateDay.dateFormat = "dd"
        guard let currentDay = Int(dateDay.string(from: Date())) else {
            return
        }

        var entries: [ChartDataEntry] = Array(0...6).map {
            ChartDataEntry(x: Double(currentDay - 6 + $0), y: 0)
        }

        activitiesData.enumerated().forEach { ind, activities in
            guard let entryDay = Int(dateDay.string(from: activities.date)) else {
                return
            }
            let entryPos = 6 - (currentDay - entryDay)
            entries[entryPos] = ChartDataEntry(x: Double(entryDay),
                                               y: activities.activities.reduce(0, { sum, activity in
                                                   sum + activity.distance / 1000
                                               }))
        }

        let lineChartDataSet = LineChartDataSet(entries: entries, label: nil)
        let color = UIColor.orange
        lineChartDataSet.setColor(color)
        lineChartDataSet.setCircleColor(color)
        lineChartDataSet.fillColor = color
        lineChartDataSet.highlightColor = color
        lineChartDataSet.drawCircleHoleEnabled = true
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)

        self.data = lineChartData

        self.setVisibleYRange(minYRange: 0, maxYRange: self.chartYMax * 1.5, axis: .left)
    }
    
    private func fetchLocalActivities() {
        let context = FEFUCoreDataContainer.instance.context
        let request = CDActivity.fetchRequest()

        do {
            let rawActivities = try context.fetch(request)
            let activities: [ActivityTableCellModel] = rawActivities.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                distance += activity.distance
                duration += activity.duration
                return ActivityTableCellModel(distance: activity.distance,
                                              duration: activity.duration,
                                              type: activity.type,
                                              icon: image,
                                              startDate: activity.startDate,
                                              stopDate: activity.stopDate,
                                              name: "")
            }
            
            let sortedActivities = activities.sorted { $0.startDate > $1.startDate }
            let grouppedActivities = Dictionary(grouping: sortedActivities, by: { $0.startDate.callendarDate() }).sorted(by: { $0.key > $1.key })

            activitiesData = grouppedActivities.map { (date, activities) in
                return ActivitiesTableModel(date: date, activities: activities)
            }
        } catch {
            print("Error", error)
        }
    }
}
