/*
 
 ViewControllerThree.swift
 
 This file will contain the code for the third viewcontroller.
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

class ViewControllerThree: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEntries.count
        //use the count of entries for the amount of rows of the table
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //index path means row number
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //dequeueReusableCell reuses the cell when scrolling down, but putting new data into it
        //lets say theres 5000 entries of task, but the phone can only allow 10 in the view, so once the user scrolls down, the "empty" cell will be reused but new data will be put there so the user can see
        //cell is the identifier of the prototype cell in the table view
        let entry = allEntries[indexPath.row]
        // use current row to grab the value from all entries (e.g. its on the third row then its the third value in the array)
        
        // Main Task Title
        cell.textLabel?.text = entry.taskName
        //main title of the cell is taskName
        
        // Format the date for the subtitle
        let dateString = entry.date.formatted(date: .abbreviated, time: .omitted)
        //formatting the date string: translate it into a form like "Oct 24 2025", omit time to make it clean
        cell.detailTextLabel?.text = "$\(entry.earnings) | \(entry.timeSpent) | \(dateString)"
        //subtitle of the cell is earnings, time spent, data string
        return cell
        //return the whole cell
    }
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var historyTable: UITableView!
    
    
    // MARK: - Variables and Constants
    var allEntries: [task] = []
    //array is in terms of the struct so has four key elements
    
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "goforward"), tag: 0)
        /* setting up the tab bar on the bottom of the screen, title as history and using the image goforward from Xcode, tag is like a number to determine which screen the user looks at (0 means first screen); self just means this current screen */
        historyTable.dataSource = self
        historyTable.delegate = self
        //history table getting its datasource and delegate (how it behaves) from this view controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistory()
        //everytime this view gets in focus, it updates the history table
    }
    
    func loadHistory() {
        let defaults = UserDefaults.standard
        // UserDefaults is a built in database
        // Declaring defaults as the database
        if let data = defaults.data(forKey: "SavedTasks"){
            // if let prevents crashes for the app to skip this step if it doesn't work
            //finds the "folder" SavedTasks in the UserDefaults database
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([task].self, from: data){
                //try is does similar thing as if let
                //from data is the constant just declared, basically getting this piece of data and putting it into JSONDecoder
                //putting those decoded JSON format of data back to the task array
                self.allEntries = decoded.sorted(by:{ $0.date > $1.date })
                //organize the data before putting it into the historyTable
                //compare in terms of date, which is bigger goes first
                //$0 and $1 is just task one and task 2 and comparing their dates so the greater one is in front
                self.historyTable.reloadData()
                //reload data calls the previous tableView data again to update the data
            }
        }
    }
    
    
    @IBAction func clearAllData(_ sender: Any) {
        let alert = UIAlertController(title: "Clear History?", message: "This will permanently delete all recorded tasks. Are you sure?", preferredStyle: .actionSheet)
        //prepare alert to clear data
        let clearAction = UIAlertAction(title: "Clear All", style: .destructive) { (_) in
            //destructive means the option is red
            UserDefaults.standard.removeObject(forKey: "SavedTasks")
            //remove everything in the SavedTasksFolder
            self.allEntries.removeAll()
            //remove everything in the array
            self.historyTable.reloadData()
            //reload historyTable
        }
        
        // The "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        //do nothing
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        //add these two options to the alert
        self.present(alert, animated: true)
        //present the alert
    }
    
}
