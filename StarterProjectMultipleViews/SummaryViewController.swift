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
        /* setting up the tab bar on the bottom of the screen, title as summary and using the image sum from Xcode, tag is like a number to determine which screen the user looks at (0 means first screen); self just means this current screen */
        calculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculate()
        //everytime the user switches to this tab bar, the calculate function is ran
    }
    
    var allEntries: [task] = []
    //array is in terms of the struct so has four key elements
    
    func calculate() {
        let defaults = UserDefaults.standard
        // UserDefaults is a built in database
        // Declaring defaults as the database
        if let data = defaults.data(forKey: "SavedTasks") {
            // if let prevents crashes for the app to skip this step if it doesn't work
            //finds the "folder" SavedHistory in the UserDefaults database
            if let decodedTasks = try? JSONDecoder().decode([task].self, from: data) {
                //try is does similar thing as if let
                //from data is the constant just declared, basically getting this piece of data and putting it into JSONDecoder
                //JSON is a type of data to save in UserDefaults, decoder just turns it back to readable array of "task"
                allEntries = decodedTasks
                //fills the allEntries array with old tasks called up in the UserDefaults SavedHistoryFolder
            } else {
                allEntries = []
                // if this doesn't work then clear array
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
}
