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
            
            
            let totalEarnings = allEntries.reduce(0.0) { $0 + $1.earnings }
            //reduce is used to sum up the earning values in the array
            //(0) means initial value of the sum, $0 is the total so far, and $1 is the current task the loop is looping at, so it will repeat for the whole array to get the sum
            totalEarningsLabel.text = String(format: "$%.2f", totalEarnings)
            //get the totalEarnings and format it
            /* formatting:
             $: money sign
             %: formatting rule
             .2: always show two numbers after decimal point
             f: decimal (floating point)
             */
            
            
            var totalSeconds = 0
            for entry in allEntries {
                totalSeconds += convertToSeconds(duration: entry.timeSpent)
                //for loop going to all entries in allEntries, but needs a function to convert the duration like 00:00:00 to seconds for calculations, all adding up to the totalSeconds
            }
            
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            totalTimeLabel.text = "\(hours)h \(minutes)m"
            //convert it back to hours and minutes
            
            
            if totalSeconds > 0 {
                //prevent divide by 0
                let totalHoursDouble = Double(totalSeconds) / 3600.0
                //convert seconds into a double for more accurate calculations
                let hourlyRate = totalEarnings / totalHoursDouble
                //divide earnings by hours to get hourly rate
                hourlyRateLabel.text = String(format: "$%.2f/hr", hourlyRate)
                //get the hourly rate and format it
                /* formatting:
                 $: money sign
                 %: formatting rule
                 .2: always show two numbers after decimal point
                 f: decimal (floating point)
                 /hr: per hour
                 */
            } else {
                hourlyRateLabel.text = "$0.00/hr"
                //for ones that didn't record time
            }
        }
        
        func convertToSeconds(duration: String) -> Int {
            //taking string and outputting as Int
            let unconvertedTime = duration.components(separatedBy: " : ")
            //special method (or function) to seperate unconvertedTime like 00:00:00 into three parts, seperated by the ":"
            if unconvertedTime.count == 3 {
                //check if the components are formatted weirdly to prevent crashing like (05:10)
                let hours = Int(unconvertedTime[0]) ?? 0
                let minutes = Int(unconvertedTime[1]) ?? 0
                let seconds = Int(unconvertedTime[2]) ?? 0
                //takes the Int of the unconvertedTime, piece by piece so now hours, minutes and seconds are all just one number
                //takes 0 to prevent crashing (??)
                return (hours * 3600) + (minutes * 60) + seconds
                //convert everything to seconds, (eg. now its 1 hour 1 minute 1 second, so it will be 3600+60+1)
            }
            return 0
        }
    }
}
