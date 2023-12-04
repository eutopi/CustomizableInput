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

class CustomSlider: UISlider {

    private var touchPoint: CGPoint?
    private lazy var thumbView: UIView = {
            let thumb = UIView()
        thumb.backgroundColor = UIColor(hex: "436E9E", alpha: 1)//thumbTintColor
        thumb.layer.borderWidth = 1.0
            thumb.layer.borderColor = UIColor.white.cgColor
            return thumb
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
//    override func draw(_ rect: CGRect) {
//            super.draw(rect)
//
//            guard let context = UIGraphicsGetCurrentContext() else {
//                return
//            }
//
//            // Draw track border
//            let trackRect = trackRect(forBounds: bounds)
//            let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: trackRect.height / 2.0)
//        context.setFillColor(UIColor.black.cgColor)
//        context.setStrokeColor(UIColor(hex: "FFFFFF", alpha: 0.4).cgColor)
//            context.setLineWidth(1.0)
//            context.addPath(trackPath.cgPath)
//            context.drawPath(using: .fillStroke)
//        }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
            // Set proper frame
            // y: radius / 2 will correctly offset the thumb
            
            thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
            thumbView.layer.cornerRadius = radius / 2
            
            let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
            return renderer.image { rendererContext in
                thumbView.layer.render(in: rendererContext.cgContext)
            }
        }
    
    private func createTrackImage(color: UIColor, borderColor: UIColor) -> UIImage {
        let size = CGSize(width: 200, height: 5) // Adjust the size as needed
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
                    return UIImage()
                }

                // Draw rounded track background
        let trackRect = CGRect(origin: .zero, size: size)
        let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: trackRect.height / 2.0)
                context.setFillColor(color.cgColor)
                context.addPath(trackPath.cgPath)
                context.fillPath()

                // Draw rounded track border
                context.setStrokeColor(borderColor.cgColor)
                context.setLineWidth(1.0)
                context.addPath(trackPath.cgPath)
                context.drawPath(using: .stroke)

                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                return image ?? UIImage()
        }

    private func setupButton() {
        let thumb = thumbImage(radius: 20)
        setThumbImage(thumb, for: .normal)
        setMinimumTrackImage(createTrackImage(color: UIColor(hex: "59AAFF", alpha: 0.5), borderColor: UIColor(hex: "59AAFF", alpha: 1)), for: .normal)
        setMaximumTrackImage(createTrackImage(color: UIColor(hex: "181717", alpha: 1), borderColor: UIColor(hex: "FFFFFF", alpha: 0.4)), for: .normal)
        
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
