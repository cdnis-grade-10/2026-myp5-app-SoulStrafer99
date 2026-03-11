//
//  VisualViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import UIKit

class VisualViewController: UIViewController {


    @IBOutlet var calendar: UIView!
    @IBOutlet var daySquares: [UIView]!

    var allEntries: [task] = []
    //setting up the array for tasks
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        updateHeatmap()
    }

        
        func loadData() {
            let defaults = UserDefaults.standard
            // UserDefaults is a built in database
            // Declaring defaults as the database
            if let data = defaults.data(forKey: "SavedTasks"),
               // if let prevents crashes for the app to skip this step if it doesn't work
               //finds the "folder" SavedHistory in the UserDefaults database
               let decoded = try? JSONDecoder().decode([task].self, from: data) {
                //try is does similar thing as if let
                //from data is the constant just declared, basically getting this piece of data and putting it into JSONDecoder
                //JSON is a type of data to save in UserDefaults, decoder just turns it back to readable array of "task"
                allEntries = decoded
                //fills the allEntries array with old tasks called up in the UserDefaults SavedHistoryFolder
            } else {
                allEntries = []
                // if this doesn't work then clear array
            }
        }
        
        func updateHeatmap() {
            let calendar = Calendar.current
            //getting the user's calendar, such as timezone
            var earningsByDay: [Int: Double] = [:]
            //creates a dictionary, the Int is the day (like 1, 2, 3), double is for the earnings of that day, [:] means the array starts empty
            for entry in allEntries {
                //loops through all tasks in the allEntries array
                let day = calendar.component(.weekday, from: entry.date)
                //get the calendar from above and get the weekdate (date just means that it comes in a format like 1, 2, 3 for mon, tue, wed etc.
                earningsByDay[day, default: 0] += entry.earnings
                //finds the day in the array and adds the earnings from the task (entry) to it
                //default 0 just means that it starts from 0 to prevent crashing as the app might return nil
            }
        
            let maximumDayEarnings = earningsByDay.values.max() ?? 1.0
            //find the maximum day earned
            //to prevent crashing, if theres nothing for that day 1.0 is the placeholder
            let divisor = maximumDayEarnings == 0 ? 1.0 : maximumDayEarnings
            //if maximumDayEarnings are 0 then use 1 for calculating to prevent crashing
            //if not then use maximum day's earnings
            //making the divisor to sort the days in heatmap
            
            for square in daySquares {
                //looping the squares in the heatmap one by one
                let day = square.tag
                //for each square view (7 in total), there is a tag from 1 (sun) to 7 (sat), this corresponds to the weekday
                let dayEarnings = earningsByDay[day] ?? 0.0
                //look into the dictionary to find the earnings of the specific day, if nothing then use 0 to prevent crashing
                let colorDepth = CGFloat(Double(dayEarnings) / Double(divisor))
                //CGFloat is the value for color
                //Basically this code creates the intensity of the color by dividing the day's earnings by the maximum day. Lets say the maximum day the person earned 100. if the day he earned 50, then the color wont be as intense as the the day he earned 70.
                if dayEarnings > 0 {
                    //still add a green color if they worked
                    square.backgroundColor = UIColor.systemGreen.withAlphaComponent(colorDepth + 0.2)
                    //make the background color green
                    //withAlphaComponent uses the intensity to set the color transparency, the higher the number the more solid the color is (in this case its green)
                } else {
                    square.backgroundColor = .systemGray5
                    //if didn't work then put it grey
                }
                square.layer.cornerRadius = 5
                //rounds the corner of the square for better UI design
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.780392, green: 0.941176, blue: 0.945098, alpha: 1.0)
        //color #c7f0f1
        self.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 0)
        /* setting up the tab bar on the bottom of the screen, title as calendar and using the image calendar from Xcode, tag is like a number to determine which screen the user looks at (0 means first screen); self just means this current screen */
        loadData()
        updateHeatmap()
        //setup
        let calendarView = UICalendarView()
        //creates apple calendar
        //creates the working calendar but not actually putting it as the UI View yet
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        //do not auto position
        calendarView.calendar = Calendar(identifier: .gregorian)
        //creating a gregorian calendar system, 12 months and 28-31 days
        calendarView.locale = .current
        //use the user's timezone on their device to ensure the calendar is updated
        calendarView.fontDesign = .rounded
        let selectionDate = UICalendarSelectionSingleDate(delegate: self)
        //User can click onto one specific date on the Calendar
        //delegate self means send the info to THIS view controller
        calendarView.selectionBehavior = selectionDate
        
        calendar.addSubview(calendarView)
        //puts this working calendar onto the calendar UIView
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendar.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendar.bottomAnchor)
            //basically strentch the working calendar to the fit the calendar UIView
        ])
    }
    
        }

extension VisualViewController: UICalendarSelectionSingleDateDelegate {
    //respond to the user clicking a specific date in the calendar
    func dateSelection(_ selectionDate: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        //makes a constant with the selected date
        //? means optional data
        //didselectDate triggers the datecomponents, a function which breaks the date down into day, month and year, and puts it into dateComponents (kinda like a box)
        guard let selectedDate = dateComponents?.date else { return }
        //guard makes this process not crash if this doesn't work
        //grab the date from dateComponents
        let calendar = Calendar.current
        //grab the user's calendar settings
        var totalEarnings: Double = 0.0
        //starts 0.0 everytime date selection is clicked
        for entry in allEntries {
            if calendar.isDate(entry.date, inSameDayAs: selectedDate) {
                totalEarnings += entry.earnings
                //if the calendar's date from the app matches the selectedDate from the date selection, the earnings is added to the total earnings
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //date formatter turns computer time (complex numbers) into text like "9:31 PM". Medium is the format that it "translates" into, like Nov 23, 1937.
        let dateString = formatter.string(from: selectedDate)
        //gets the date string
        
        let alert = UIAlertController(
            title: "Earnings for \(dateString)",
            message: "You earned: $\(String(format: "%.2f", totalEarnings))",
            //get the total earnings
            /* formatting:
             $: money sign
             %: formatting rule
             .2: always show two numbers after decimal point
             f: decimal (floating point)
             */
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        //adding just one option to close the alert
        
        self.present(alert, animated: true)
        //presenting the alert
    }
}
