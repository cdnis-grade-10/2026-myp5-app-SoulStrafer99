//
//  VisualViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import UIKit

class VisualViewController: UIViewController {
    
    var currentGoal: Double = 1.0 // Default goal

    @IBOutlet var calendar: UIView!
    @IBOutlet var daySquares: [UIView]!

    var allEntries: [task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        updateCalendar()
    }

        
        func loadData() {
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "SavedTasks"),
               let decoded = try? JSONDecoder().decode([task].self, from: data) {
                allEntries = decoded
            } else {
                allEntries = []
            }
        }
        
        func updateCalendar() {
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
        self.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 0)
        
        loadData()
        updateCalendar()
        
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
    
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        calendar.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendar.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendar.bottomAnchor)
        ])
    }
    
        }

extension VisualViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selectedDate = dateComponents?.date else { return }
        
        let calendar = Calendar.current
        var totalEarnings: Double = 0.0
    
        for entry in allEntries {
            if calendar.isDate(entry.date, inSameDayAs: selectedDate) {
                totalEarnings += entry.earnings
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: selectedDate)
        
        let alert = UIAlertController(
            title: "Earnings for \(dateString)",
            message: "You earned: $\(String(format: "%.2f", totalEarnings))",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
}
