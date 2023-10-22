//
//  UIView+Extension.swift
//  PokedexUIKit
//
//  Created by Maciej on 09/10/2023.
//

import UIKit

extension UIView {
    func applyRoundedCorners(_ value: CGFloat = 10) {
        layer.cornerRadius = value
    }
}
