//
//  SearchHistory.swift
//  Smashtag
//
//  Created by developer on 05/12/16.
//  Copyright (c) 2016 Wesley Egbertsen. All rights reserved.
//

import Foundation

class SearchHistory {
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct UserDefaultHistory {
        static let Key = "SearchHistory.History"
        static let Amount = 100
    }
    
    // Calculated variable so that the history is only gettable and only edditable by using the public add api function
    var history: [String] {
        return defaults.objectForKey(UserDefaultHistory.Key) as? [String] ?? [String]()
    }
    
    func add(searchText: String) {
        var tempHistory = history
        if let historyItemIndex = find(tempHistory, searchText) {
            tempHistory.removeAtIndex(historyItemIndex)
        }
        
        tempHistory.insert(searchText, atIndex: 0)
        
        while tempHistory.count > UserDefaultHistory.Amount {
            tempHistory.removeLast()
        }
        
        setHistory(tempHistory)
    }
    
    private func setHistory(history: [String]) {
        defaults.setObject(history, forKey: UserDefaultHistory.Key)
    }
    
}