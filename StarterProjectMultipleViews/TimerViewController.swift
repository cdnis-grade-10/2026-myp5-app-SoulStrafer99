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
   
    var count:Int = 0
    
    var timerCounting:Bool = false
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        self.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "stopwatch"), tag: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This tells the view to stop editing, which hides the keyboard
        self.view.endEditing(true)
    }

    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer", message: "Are you sure you want to reset the timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: {(_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {(_) in
            self.count = 0
            self.timer.invalidate()
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
            self.currentTimeLabel.text = "Current Timer: N/A"
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func startStopTapped(_ sender: Any) {
        if(timerCounting) {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.green, for: .normal)
        }
        else {
            timerCounting = true
                startStopButton.setTitle("STOP", for: .normal)
                startStopButton.setTitleColor(UIColor.red, for: .normal)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
        currentTimeLabel.text =  "Current Time: \(getCurrentTime())"
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
        
    }
    @IBAction func saveButton(_ sender: Any) {
            let confirmAlert = UIAlertController(
                title: "Confirm Details",
                message: "Is the task name, earnings, and time spent all correct?",
                preferredStyle: .alert
            )
            
            let yesAction = UIAlertAction(title: "Yes, Save it", style: .default) { (_) in
                self.finalSave()
            }
            
            let noAction = UIAlertAction(title: "No, Go back", style: .cancel, handler: nil)
            
            confirmAlert.addAction(yesAction)
            confirmAlert.addAction(noAction)
            
            self.present(confirmAlert, animated: true, completion: nil)
    }
    
    func finalSave() {
        let name = tTaskNameTextField.text ?? "Unnamed Task"
        let earnings = Double(tEarningsTextField.text ?? "0") ?? 0.0
        let duration = timerLabel.text ?? "00 : 00 : 00"
        
        let newEntry = task(taskName: name, earnings: earnings, timeSpent: duration, date: Date())
        
        saveToPersistence(newEntry: newEntry)
        let successAlert = UIAlertController(title: "Saved!", message: "Task recorded.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        tEarningsTextField.text = ""
        tTaskNameTextField.text = ""
        count = 0
        timer.invalidate()
        timerCounting = false
        timerLabel.text = "00 : 00 : 00"
        currentTimeLabel.text = "Current Timer: N/A"
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        
    }
    
    func saveToPersistence(newEntry: task) {
        let defaults = UserDefaults.standard
        var savedEntries = [task]()
        if let data = defaults.data(forKey: "SavedHistory") {
            if let decoded = try? JSONDecoder().decode([task].self, from: data) {
                savedEntries = decoded
            }
        }
        savedEntries.append(newEntry)
        if let encoded = try? JSONEncoder().encode(savedEntries) {
            defaults.set(encoded, forKey: "SavedHistory")
        }
    }
}

