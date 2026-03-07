/*
 
 ViewControllerTwo.swift
 
 This file will contain the code for the second viewcontroller.
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

class ViewControllerTwo: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mTaskNameTextField: UITextField!
    @IBOutlet weak var mEarningsTextField: UITextField!
    
    
    // MARK: - Variables and Constants
    
    
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*touches began means the user touches the screen, the (_ touches...) thing after that is required to put in in Xcode */
        self.view.endEditing(true)
        /* self means the main keyboard, end editing true forces the keyboard to close, so everytime the user clicks other place except the keyboard, the keyboard collapses*/
        
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
        //same thing as Timer View Controller
    }
    
    func finalSave() {
            let name = mTaskNameTextField.text ?? "Unnamed Task"
            let earnings = Double(mEarningsTextField.text ?? "0") ?? 0.0
            let totalSeconds = Int(timePicker.countDownDuration)
        //same thing as Timer View Controller, but getting the seconds from the timerpicker duration
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            
            let duration = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
            
            let newEntry = task(taskName: name, earnings: earnings, timeSpent: duration, date: Date())
            saveToDatabase(newEntry: newEntry)
            
            let successAlert = UIAlertController(title: "Saved!", message: "Manual task recorded.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
    
            mEarningsTextField.text = ""
            mTaskNameTextField.text = ""
            timePicker.countDownDuration = 0
        
    }
    
    func saveToDatabase(newEntry: task) {
        let defaults = UserDefaults.standard
        var savedEntries = [task]()
        if let data = defaults.data(forKey: "SavedTasks") {
            if let decoded = try? JSONDecoder().decode([task].self, from: data) {
                savedEntries = decoded
            }
        }
        savedEntries.append(newEntry)
        if let encoded = try? JSONEncoder().encode(savedEntries) {
            defaults.set(encoded, forKey: "SavedTasks")
        }
    }
    
    //same thing as Timer View Controller
    
   
}
