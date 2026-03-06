/*
 
 ViewControllerOne.swift
 
 This file will contain the code for the first viewcontroller.
 Please ensure that your code is organised and is easy to read.
 This means that you will need to both structure your code correctly,
 in addition to using the correct syntax for Swift.
 
 Unless you are told otherwise, ensure that you are using the
 camelCase syntax. For example, outputLabel and firstName are good
 examples of using the camelCase syntax.
 
 Within each class, you can see clearly identified sections denoted by
 MARK statements. These MARK statements allow you to structure and organise
 your code.
 
 - @IBOutlets should be listed under the MARK section on IBOutlets
 - Variables and constants listed under the MARK section Variables and Constants
 - Functions (including @IBActions) listed under the section on IBActions and Functions.
 
 As you develop each view controller class with Swift code, please include
 detailed comments to both demonstrate understanding, and which serve you as
 a reminder as to what your code actually does.
 
 */

import UIKit

class ViewControllerOne: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var tTaskNameTextField: UITextField!
    @IBOutlet weak var tEarningsTextField: UITextField!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    
    // MARK: - Variables and Constants
    var timer:Timer = Timer()
   // creates the timer that actually counts
    
    var count:Int = 0
    // keep track of how many secons has passed
    
    var timerCounting:Bool = false
    // simple on/off switch to know if the timer is counting
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        // initial setup
        super.viewDidLoad()
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        //initilizing the startStopButton title color
        self.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "stopwatch"), tag: 0)
        /* setting up the tab bar on the bottom of the screen, title as timer and using the image stopwatch from Xcode, tag is like a number to determine which screen the user looks at (0 means first screen); self just means this current screen */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*touches began means the user touches the screen, the (_ touches...) thing after that is required to put in in Xcode */
        self.view.endEditing(true)
        /* self means the main keyboard, end editing true forces the keyboard to close, so everytime the user clicks other place except the keyboard, the keyboard collapses*/
        
    }

    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer", message: "Are you sure you want to reset the timer?", preferredStyle: .alert)
        // preparing the alert with title
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: {(_) in
            // cancel condition: do nothing as theres nothing after "handler: {(_) in
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {(_) in
            self.count = 0
            self.timer.invalidate()
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
            self.currentTimeLabel.text = "Current Timer: N/A"
        }))
        // yes condition, reset everything (using self to let it access this view controller's variables which are out of scope for the this part of the function)
        self.present(alert, animated: true, completion: nil)
        //acutally popping the alert to the screen
        // completion nil is not to do anything after completing the alert
    }
    @IBAction func startStopTapped(_ sender: Any) {
        if timerCounting == true {
            timerCounting = false
            timer.invalidate()
            //stop timer
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.green, for: .normal)
            //changes button to start
        }
        else {
            timerCounting = true
                startStopButton.setTitle("STOP", for: .normal)
                startStopButton.setTitleColor(UIColor.red, for: .normal)
            //changes button to stop
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            //count per 1 second, looking in this view controller, every 1 second continue, trigger the time counter function, keep repeating until stopped
            
        }
    }
    
    @objc func timerCounter() -> Void {
        //object C function required by XCode
        count = count + 1
        //adding a second
        let time = secondsToHoursMinutesSeconds(seconds: count)
        //turn seconds into the hours minutes seconds format for other purposes in the app
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        // making a tuple (lightweight version of a struct) in three items: hours, minutes and seconds; calls the function to process and return those values
        timerLabel.text = timeString
        currentTimeLabel.text =  "Current Time: \(getCurrentTime())"
        //get current time after timer starts counting/ resumes counting
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        //date formatter turns computer time (complex numbers) into text like "9:31 PM". Short is the format that it "translates" into, like 9:31 PM. Long is another way to "translate", an example being "9:31:24 PM PST", but this app doesn't require it in detail.
        return formatter.string(from: Date())
        //from Date just gets the timestamp now and goes through the date formatter and returns it as a string
    }
    
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        //seconds / 3600 is hours, (seconds % 3600) / 60 is minutes, and (seconds % 3600) % 60 is seconds; % means only getting the remainder
        //example being 3665 seconds, 3665/3600 = 1 hour, 3665/3600 remainder = 65 divded by 60 = 1 minute, then the remainder of that is 5 seconds, so it will return a tuple (1, 1, 5)
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        //setup
        timeString += String(format: "%02d", hours)
        //adds hours to the time string from the tuple number
        /* formatting:
         %: formatting rule
         0: use zeros if number is too short (e.g. 1 turns to 01)
         2: final number is two characters long
         d: whole number return (d for digit)
         */
        timeString += " : "
        //seperator for time
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
        // repeats the cycle to have a hh:mm:ss timeString returned
    }
    @IBAction func saveButton(_ sender: Any) {
            let confirmAlert = UIAlertController(
                title: "Confirm Details",
                message: "Is the task name, earnings, and time spent all correct?",
                preferredStyle: .alert
            )
        //creates alert when saving
            
            let yesAction = UIAlertAction(title: "Save", style: .default) { (_) in
                //if clicked Save then perform final save
                self.finalSave()
            }
            
            let noAction = UIAlertAction(title: "Go back", style: .cancel, handler: nil)
        // if clicked go back then go back and do nothing, cancel alert
            
            confirmAlert.addAction(yesAction)
            confirmAlert.addAction(noAction)
        // adding those two actions to the alert (two options)
            
            self.present(confirmAlert, animated: true, completion: nil)
        // presenting the alert, completion nil is for not doing anything after presenting the alert
    }
    
    func finalSave() {
        let name = tTaskNameTextField.text ?? "Unnamed Task"
        //?? is to make a default value if the user doesn't input anything, so in this case, if the user input is blank, it becomes unnamed task
        let earnings = Double(tEarningsTextField.text ?? "0") ?? 0.0
        //again, if the tEarnings Text Field doesn't have anything, it turns to 0. Then it turns tEarningsTextField text (or 0) into a double, then in case the user typed something that cannot be converted like "im trolling", it becomes 0.0
        let duration = timerLabel.text ?? "00 : 00 : 00"
        // if timer.Label.text is empty, takes 00:00:00
        
        let newEntry = task(taskName: name, earnings: earnings, timeSpent: duration, date: Date())
        //new task created as a new data point, being "packaged" by task name, earnings, time spent and date
        
        saveToPersistence(newEntry: newEntry)
        // saves it to the database with the new task (didn't use new task as name to prevent confusion)
        let successAlert = UIAlertController(title: "Saved!", message: "Task recorded.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        // sucess alert if sucessfully added
        tEarningsTextField.text = ""
        tTaskNameTextField.text = ""
        count = 0
        timer.invalidate()
        timerCounting = false
        timerLabel.text = "00 : 00 : 00"
        currentTimeLabel.text = "Current Timer: N/A"
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        // reset everything for next task input
        
    }
    
    func saveToPersistence(newEntry: task) {
        let defaults = UserDefaults.standard
        // UserDefaults is a built in database
        // Declaring defaults as the database
        var savedEntries = [task]()
        //array is in terms of the struct so has four key elements
        //create a list to organize the tasks
        if let data = defaults.data(forKey: "SavedTasks") {
            // if let prevents crashes for the app to skip this step if it doesn't work
            //finds the "folder" SavedTasks in the UserDefaults database
            //either creates new folder called SavedTasks or goes to the existing SavedTasks folder
            if let decodedTasks = try? JSONDecoder().decode([task].self, from: data) {
                //try is does similar thing as if let
                //from data is the constant just declared, basically getting this piece of data and putting it into JSONDecoder
                //JSON is a type of data to save in UserDefaults, decoder just turns it back to readable array of "task"
                savedEntries = decodedTasks
                //fills the savedEntries array with old tasks called up in the UserDefaults SavedTasksFolder
            }
        }
        savedEntries.append(newEntry)
        //takes the new entry and puts it to the last of the array
        if let encoded = try? JSONEncoder().encode(savedEntries) {
            //putting the whole savedEntry array back into JSON format of data
            //encoded is the name of the JSON format data
            defaults.set(encoded, forKey: "SavedTasks")
            //updating the SavedTasks folder in UserDefaults
        }
    }
}
// using let for basically almost everything as I don't have to change it constantly
