//
//  UIColor+Extension.swift
//  PokedexUIKit
//
//  Created by Maciej on 07/10/2023.
//

import UIKit

typealias Kirari = UIColor.Kirari

extension UIColor {
    enum Kirari {
        static let blue = UIColor(named: "KirariSkyblue")
        static let blonde = UIColor(named: "KirariBlonde")
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func mainPink() -> UIColor {
        return rgb(red: 221, green: 94, blue: 86)
    }
}
