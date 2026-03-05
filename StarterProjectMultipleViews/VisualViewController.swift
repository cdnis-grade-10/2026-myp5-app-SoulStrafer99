//
//  VisualViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import UIKit

class VisualViewController: UIViewController {
    
    @IBOutlet var daySquares: [UIView]!
    
    var allEntries: [task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        updateHeatmap()
        updateProgressBar()
        updateTaskBreakdown()
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "SavedHistory"),
           let decoded = try? JSONDecoder().decode([task].self, from: data) {
            allEntries = decoded
        } else {
            allEntries = []
        }
    }
    
    func updateHeatmap() {
        let calendar = Calendar.current
        var earningsByDay: [Int: Double] = [:]

        for entry in allEntries {
            let day = calendar.component(.weekday, from: entry.date)
            earningsByDay[day, default: 0] += entry.earnings
        }

        // Safety: prevent division by zero
        let maxDayEarnings = earningsByDay.values.max() ?? 1.0
        let divisor = maxDayEarnings == 0 ? 1.0 : maxDayEarnings

        for square in daySquares {
            let day = square.tag // Ensure tags are 1-7 in Storyboard!
            let dayEarnings = earningsByDay[day] ?? 0
            
            // FIX: Convert to Double before dividing to get decimals (e.g., 0.5)
            let intensity = CGFloat(Double(dayEarnings) / Double(divisor))
            
            if dayEarnings > 0 {
                // Stronger green based on earnings
                square.backgroundColor = UIColor.systemGreen.withAlphaComponent(intensity + 0.2)
            } else {
                // Light gray so you can actually see the "empty" squares
                square.backgroundColor = .systemGray5
            }
            square.layer.cornerRadius = 5
        }
    }
    
    func updateProgressBar() {
        let totalEarnings = allEntries.reduce(0) { $0 + $1.earnings }
        let goal: Double = 500.0 // Set your own goal here
        
        // This calculates how much of the screen the bar should fill
        let percentage = min(CGFloat(totalEarnings / goal), 1.0)
        
        // Assuming you have an IBOutlet for a 'ProgressBar' UIView
        // You can animate it here:
        UIView.animate(withDuration: 1.0) {
            // If you aren't using constraints, you can adjust the frame:
            // self.earningsBar.frame.size.width = (self.view.frame.width - 40) * percentage
        }
    }

    func updateTaskBreakdown() {
        var taskTimes: [String: Int] = [:]
        var totalSeconds = 0
        
        for entry in allEntries {
            let seconds = convertDurationToSeconds(duration: entry.timeSpent)
            taskTimes[entry.taskName, default: 0] += seconds
            totalSeconds += seconds
        }
        
        // This prints the breakdown to the console so you can check your math
        print("Task Breakdown: \(taskTimes)")
    }

    // Helper to turn your "00 : 00 : 00" string back into numbers
    func convertDurationToSeconds(duration: String) -> Int {
        let components = duration.components(separatedBy: " : ")
        if components.count == 3 {
            let hours = Int(components[0]) ?? 0
            let minutes = Int(components[1]) ?? 0
            let seconds = Int(components[2]) ?? 0
            return (hours * 3600) + (minutes * 60) + seconds
        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "Visuals", image: UIImage(systemName: "graph.2d"), tag: 0)
        loadData()
        updateHeatmap()
        updateProgressBar()
        updateTaskBreakdown()
    }
}
