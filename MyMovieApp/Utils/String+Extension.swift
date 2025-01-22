//
//  String+Extension.swift
//  MyMovieApp
//
//  Created by ali cihan on 13.01.2025.
//

import Foundation


extension String {
    var dateAsYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        
        if let date = formatter.date(from: self) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
