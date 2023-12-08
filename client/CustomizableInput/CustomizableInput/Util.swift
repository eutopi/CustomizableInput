//
//  Util.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 12/7/23.
//

import UIKit

public func findImageView(at point: CGPoint, superview: UIView) -> UIImageView? {
        for subview in superview.subviews {
            if let imageView = subview as? UIImageView, imageView.frame.contains(point) {
                return imageView
            }
        }

        return nil
}
