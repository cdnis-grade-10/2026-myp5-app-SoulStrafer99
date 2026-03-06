//
//  data.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import Foundation

struct task: Codable {
    let taskName: String
    let earnings: Double
    let timeSpent: String
    let date: Date
}
//four key elements for arrays and other parts of the app control
//codable allows to switch data models' format to other formats like JSON
