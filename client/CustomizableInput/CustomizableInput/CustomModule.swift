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

class CustomToggle: UIView {

    private var thumbView: UIView!
    private var isOn = false
    private var touchPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        setupToggle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupToggle()
    }

    private func setupToggle() {
        // Customize the appearance of the toggle
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(hex: "FFFFFF", alpha: 0.4).cgColor
        backgroundColor = UIColor(hex: "181717", alpha: 1)

        // Create thumb view
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        thumbView.backgroundColor = UIColor(hex: "0DCBCC", alpha: 0.5)
        thumbView.layer.cornerRadius = frame.height / 2
        thumbView.layer.borderWidth = 1.0
        thumbView.layer.borderColor = UIColor(hex: "0DCBCC", alpha: 1).cgColor
        addSubview(thumbView)

        // Add a tap gesture recognizer to handle toggling
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)

        // Add a pan gesture recognizer to handle dragging
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        toggle()
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

    private func toggle() {
        isOn.toggle()
        UIView.animate(withDuration: 0.2) {
            self.thumbView.center.x = self.isOn ? self.bounds.width - self.thumbView.bounds.width / 2 : self.thumbView.bounds.width / 2
            self.backgroundColor = self.isOn ?  UIColor.white : UIColor(hex: "181717", alpha: 1)
        }
    }
}

class CustomColor: UIColorWell {

    private var touchPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
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

class CustomJoystick: UIView {

    private var thumbView: UIView!
    private var touchPoint: CGPoint?
    private var touchPointThumb: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupJoystick()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupJoystick()
    }

    private func setupJoystick() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(hex: "FF9809", alpha: 1).cgColor
        backgroundColor = UIColor(hex: "FF9809", alpha: 0.5)

        // Create thumb view
        thumbView = UIView(frame: CGRect(x: frame.width / 2, y: frame.height / 2, width: frame.width / 3, height: frame.height / 3))
        thumbView.backgroundColor = UIColor(hex: "FF9809", alpha: 1)
        thumbView.layer.cornerRadius = frame.width / 6
        thumbView.layer.borderWidth = 1.0
        thumbView.layer.borderColor = UIColor.white.cgColor
        addSubview(thumbView)
        
        createArrowView(at: CGPoint(x: frame.width / 1.5, y: frame.height / 4.5), rotation: 0) // Up arrow
        createArrowView(at: CGPoint(x: frame.width / 1.5, y: frame.height + frame.height / 9), rotation: .pi) // Down arrow
        createArrowView(at: CGPoint(x: frame.width / 4.5, y: frame.height / 1.5), rotation: -.pi / 2) // Left arrow
        createArrowView(at: CGPoint(x: frame.width + frame.width / 9, y: frame.height / 1.5), rotation: .pi / 2) // Right arrow
        

        // Add a pan gesture recognizer to handle dragging
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
        
        let panGestureRecognizerThumb = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureThumb(_:)))
            thumbView.addGestureRecognizer(panGestureRecognizerThumb)
    }
    
    private func createArrowView(at center: CGPoint, rotation: CGFloat) {
        let arrowView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height / 3))
        arrowView.backgroundColor = UIColor.clear
        arrowView.center = center

        let trianglePath = UIBezierPath()
        let sideLength = frame.width / 6 // Adjust the side length as needed

        // Move to the top vertex of the equilateral triangle
        trianglePath.move(to: CGPoint(x: 0, y: -sideLength / (2 * sqrt(3))))

        // Add lines to the bottom-left and bottom-right vertices
        trianglePath.addLine(to: CGPoint(x: -sideLength / 2, y: sideLength / (2 * sqrt(3))))
        trianglePath.addLine(to: CGPoint(x: sideLength / 2, y: sideLength / (2 * sqrt(3))))

        // Close the path to form a triangle
        trianglePath.close()

        // Create a CAShapeLayer for the triangle
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = trianglePath.cgPath
        shapeLayer.fillColor = UIColor(hex: "FF9809", alpha: 1).cgColor

        // Apply rotation
        shapeLayer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)

        arrowView.layer.addSublayer(shapeLayer)
        addSubview(arrowView)
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
    
    @objc private func handlePanGestureThumb(_ sender: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        if sender.state == .began {
            // Save the initial touch point
            touchPointThumb = sender.location(in: self)
        } else if sender.state == .changed {
            // Calculate the translation from the initial touch point
            let translation = sender.translation(in: self)

            // Calculate the new position of thumbView
            let newThumbCenter = CGPoint(x: thumbView.center.x + translation.x, y: thumbView.center.y + translation.y)

            // Ensure thumbView stays within the bounds of self
            let thumbFrame = thumbView.frame
            let minX = thumbFrame.width / 2
            let maxX = self.bounds.width - thumbFrame.width / 2
            let minY = thumbFrame.height / 2
            let maxY = self.bounds.height - thumbFrame.height / 2

            let clampedX = min(max(minX, newThumbCenter.x), maxX)
            let clampedY = min(max(minY, newThumbCenter.y), maxY)

            thumbView.center = CGPoint(x: clampedX, y: clampedY)

            // Reset the translation to avoid cumulative changes
            sender.setTranslation(CGPoint.zero, in: self)
        } else if sender.state == .ended || sender.state == .cancelled {
            // Clear the touch point when dragging ends
            touchPointThumb = nil
        }
    }
}
