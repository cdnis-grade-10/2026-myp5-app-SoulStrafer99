//
//  ViewControllerFourViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import UIKit

class ViewControllerFourViewController: UIViewController {

    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var hourlyRateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "Summary", image: UIImage(systemName: "sum"), tag: 0)
        calculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculate()
    }
    
    var allEntries: [task] = []

    func calculate() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "SavedHistory"),
           let decoded = try? JSONDecoder().decode([task].self, from: data) {
            allEntries = decoded
        } else {
            allEntries = []
        }


        let totalEarnings = allEntries.reduce(0) { $0 + $1.earnings }
        totalEarningsLabel.text = String(format: "$%.2f", totalEarnings)

        
        var totalSeconds = 0
        for entry in allEntries {
            totalSeconds += convertDurationToSeconds(duration: entry.timeSpent)
        }
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        totalTimeLabel.text = "\(hours)h \(minutes)m"


        if totalSeconds > 0 {
            let totalHoursDouble = Double(totalSeconds) / 3600.0
            let hourlyRate = totalEarnings / totalHoursDouble
            hourlyRateLabel.text = String(format: "$%.2f/hr", hourlyRate)
        } else {
            hourlyRateLabel.text = "$0.00/hr"
        }
    }
    
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
}
