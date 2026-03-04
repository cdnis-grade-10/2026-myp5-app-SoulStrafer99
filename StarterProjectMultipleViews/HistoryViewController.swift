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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let entry = allEntries[indexPath.row]
        
        // Main Task Title
        cell.textLabel?.text = entry.taskName
        
        // Format the date for the subtitle
        let dateString = entry.date.formatted(date: .abbreviated, time: .omitted)
        
        // Display Earnings and Time
        cell.detailTextLabel?.text = "$\(entry.earnings) | \(entry.timeSpent) | \(dateString)"
        
        return cell
    }
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var historyTable: UITableView!
    
    
    // MARK: - Variables and Constants
    var allEntries: [task] = []
    
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "goforward"), tag: 0)
        historyTable.dataSource = self
        historyTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistory()
    }
    
    func loadHistory() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: "SavedHistory"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([task].self, from: data){
                self.allEntries = decoded.sorted(by:{ $0.date > $1.date })
                self.historyTable.reloadData()
            }
        }
    }
}
