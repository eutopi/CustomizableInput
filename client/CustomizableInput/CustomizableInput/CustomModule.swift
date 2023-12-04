//
//  CustomModule.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 12/4/23.
//

import UIKit

class CustomButton: UIButton {

    private var touchPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        self.backgroundColor = UIColor(hex: "B17DFF", alpha: 0.5)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitle("BUTTON", for: .normal)
        layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(hex: "B17DFF", alpha: 1).cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true

        // Enable user interaction for the button
        self.isUserInteractionEnabled = true
        // Add a pan gesture recognizer to track dragging
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        if sender.state == .began {
            // Save the initial touch point
            touchPoint = sender.location(in: superview)
        } else if sender.state == .changed {
            // Calculate the translation from the initial touch point
            let translation = sender.translation(in: superview)

            // Update the button's position
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)

            // Reset the translation to avoid cumulative changes
            sender.setTranslation(CGPoint.zero, in: superview)
        } else if sender.state == .ended || sender.state == .cancelled {
            // Clear the touch point when dragging ends
            touchPoint = nil
        }
    }
}
