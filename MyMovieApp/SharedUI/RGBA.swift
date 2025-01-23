//
//  RGBA.swift
//  MyMovieApp
//
//  Created by ali cihan on 20.01.2025.
//

import Foundation
import SwiftUI

struct RGBA {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var a: CGFloat
        
    static var clear = RGBA(r: 0, g: 0, b: 0, a: 0)
    
    var color: UIColor {
        UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
