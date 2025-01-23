//
//  CustomMergePolicy.swift
//  MyMovieApp
//
//  Created by ali cihan on 23.01.2025.
//

import Foundation
import CoreData

class CustomMergePolicy: NSMergePolicy {
    init() {
        super.init(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    override func resolve(constraintConflicts list: [NSConstraintConflict]) throws {
        for conflict in list {
            if let object = conflict.conflictingObjects.first as? CDMovie,
               let snapshot = conflict.databaseSnapshot {
                if let isPopular = snapshot["isPopular"] as? Bool, isPopular {
                    object.isPopular = true
                    object.popularDate = snapshot["popularDate"] as? Date
                }
                if let isUpcoming = snapshot["isUpcoming"] as? Bool, isUpcoming {
                    object.isUpcoming = true
                    object.upcomingDate = snapshot["upcomingDate"] as? Date
                }
                if let isNowPlaying = snapshot["isNowPlaying"] as? Bool, isNowPlaying {
                    object.isNowPlaying = true
                    object.nowPlayingDate = snapshot["nowPlayingDate"] as? Date
                }
                if let savedDate = snapshot["savedDate"] as? Date {
                    object.savedDate = savedDate
                }
            }
        }
        try super.resolve(constraintConflicts: list)
    }
}
