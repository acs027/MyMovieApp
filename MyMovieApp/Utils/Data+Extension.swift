//
//  UIImage+Extension.swift
//  MyMovieApp
//
//  Created by ali cihan on 1.01.2025.
//

import Foundation
import SwiftUI

extension Data {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(data: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 350)
    }
    
    var averageColorRGBA: RGBA {
        let clear = RGBA.clear
        guard let inputImage = CIImage(data: self) else { return clear }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return clear }
        guard let outputImage = filter.outputImage else { return clear }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return RGBA(r:CGFloat(bitmap[0]) / 255,g:CGFloat(bitmap[1]) / 255,b:CGFloat(bitmap[2]) / 255, a:CGFloat(bitmap[3]) / 350)
    }
}

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
