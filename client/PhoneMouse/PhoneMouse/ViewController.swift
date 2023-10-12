//
//  ViewController.swift
//  PhoneMouse
//
//  Created by Tongyu Zhou on 10/9/23.
//

import UIKit
import CoreMotion

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var trackingView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet var mouseModeToggleLabel: UILabel!
    
    @IBOutlet var leftButtonPhysical: UIButton!
    @IBOutlet var rightButtonPhysical: UIButton!
    @IBOutlet var traditionalScrollbar: UIImageView!
    @IBOutlet var traditionalBG1: UIImageView!
    @IBOutlet var traditionalBG2: UIImageView!
    
    let motionManager = CMMotionManager()
    var mouseMode = "traditional"

    override func viewDidLoad() {
        super.viewDidLoad()
//        startAccelerometerUpdates()
        // Do any additional setup after loading the view.
        initializeGestures()
        initializeButtons()
    }
    
    func initializeGestures() {
        let panGestureRecognizerLeftBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanLeftMouse(_:)))
        panGestureRecognizerLeftBtn.delegate = self
        leftButton.addGestureRecognizer(panGestureRecognizerLeftBtn)
        
        let panGestureRecognizerRightBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanRightMouse(_:)))
        panGestureRecognizerRightBtn.delegate = self
        rightButton.addGestureRecognizer(panGestureRecognizerRightBtn)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.delegate = self
        trackingView.addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.require(toFail: panGestureRecognizerLeftBtn)
        panGestureRecognizer.require(toFail: panGestureRecognizerRightBtn)
        
        let panGestureRecognizerScrollbar = UIPanGestureRecognizer(target: self, action: #selector(handleScrollbarTouch(_:)))
        panGestureRecognizerScrollbar.delegate = self
        traditionalScrollbar.addGestureRecognizer(panGestureRecognizerScrollbar)
    }
    
    func initializeButtons() {
        leftButton.backgroundColor = UIColor(hex: "#2047C4")
        rightButton.backgroundColor = UIColor(hex: "#2047C4")
        leftButton.layer.cornerRadius = 5
        rightButton.layer.cornerRadius = 5
        leftButton.isHidden = true
        rightButton.isHidden = true
        
        let maskLayerLeft = CAShapeLayer()
        maskLayerLeft.path = UIBezierPath(
            roundedRect: leftButtonPhysical.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
        
        let maskLayerRight = CAShapeLayer()
        maskLayerRight.path = UIBezierPath(
            roundedRect: rightButtonPhysical.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
        
        
        leftButtonPhysical.backgroundColor = .white
        leftButtonPhysical.layer.cornerRadius = 35
        leftButtonPhysical.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        leftButtonPhysical.layer.mask = maskLayerLeft
        
        rightButtonPhysical.backgroundColor = .white
        rightButtonPhysical.layer.cornerRadius = 35
        rightButtonPhysical.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        rightButtonPhysical.layer.mask = maskLayerRight
    }
    
    // on screen touch events
    
    @IBAction func leftMouseDown(_ sender: Any) {
        print("left click down")
        sendMessage(message: "left down")
    }
    
    @IBAction func leftMouseUp(_ sender: Any) {
        print("left click up")
        sendMessage(message: "left up")
    }
    
    @IBAction func rightMouseDown(_ sender: Any) {
        print("right click down")
        sendMessage(message: "right down")
    }
    
    @IBAction func rightMouseUp(_ sender: Any) {
        print("right click up")
        sendMessage(message: "right up")
    }

    @IBAction func handleScrollbarTouch(_ recognizer: UIPanGestureRecognizer) {
        if mouseMode != "traditional" { return }
        switch recognizer.state {
            case .changed:
                let translation = recognizer.translation(in: trackingView)
                print("Finger moved by (\(translation.x), \(translation.y))")
                sendMessage(message: "scroll: \(translation.y)")
                recognizer.setTranslation(.zero, in: trackingView)
            default:
                break
        }
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if mouseMode != "trackpad" { return }
        let numberOfTouches = recognizer.numberOfTouches
        switch recognizer.state {
            case .changed:
                let translation = recognizer.translation(in: trackingView)
                print("Finger moved by (\(translation.x), \(translation.y))")
                if (numberOfTouches == 1) {
                    sendMessage(message: "move: \(translation.x), \(translation.y)")
                }
                else if (numberOfTouches == 2) {
                    sendMessage(message: "scroll: \(translation.y)")
                }
                recognizer.setTranslation(.zero, in: trackingView)
            default:
                break
        }
    }
    
    @IBAction func handlePanLeftMouse(_ recognizer: UIPanGestureRecognizer) {
        if mouseMode != "trackpad" { return }
        switch recognizer.state {
            case .changed:
                let translation = recognizer.translation(in: trackingView)
                print("Finger moved by (\(translation.x), \(translation.y))")
                sendMessage(message: "move: \(translation.x), \(translation.y)")
                recognizer.setTranslation(.zero, in: trackingView)
            case .ended, .cancelled, .failed:
                print("left click up")
                sendMessage(message: "left up")
            default:
                break
        }
    }
    
    @IBAction func handlePanRightMouse(_ recognizer: UIPanGestureRecognizer) {
        if mouseMode != "trackpad" { return }
        switch recognizer.state {
            case .changed:
                let translation = recognizer.translation(in: trackingView)
                print("Finger moved by (\(translation.x), \(translation.y))")
                sendMessage(message: "move: \(translation.x), \(translation.y)")
                recognizer.setTranslation(.zero, in: trackingView)
            case .ended, .cancelled, .failed:
                print("right click up")
                sendMessage(message: "right up")
            default:
                break
        }
    }
    
    
    @IBAction func handleSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            
            leftButton.isHidden = true
            rightButton.isHidden = true
            leftButtonPhysical.isHidden = false
            rightButtonPhysical.isHidden = false
            traditionalScrollbar.isHidden = false
            traditionalBG1.isHidden = false
            traditionalBG2.isHidden = false
            mouseMode = "traditional"
            mouseModeToggleLabel.text = "Traditional"
            mouseModeToggleLabel.textColor = .white
        }
        else {
            leftButton.isHidden = false
            rightButton.isHidden = false
            leftButtonPhysical.isHidden = true
            rightButtonPhysical.isHidden = true
            traditionalScrollbar.isHidden = true
            traditionalBG1.isHidden = true
            traditionalBG2.isHidden = true
            trackingView.backgroundColor = .white
            mouseMode = "trackpad"
            mouseModeToggleLabel.text = "Trackpad"
            mouseModeToggleLabel.textColor = .black
        }
    }
    
    
    // physical motion events
    
    func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1  // Set your desired update interval in seconds
            motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
                guard let data = accelerometerData else { return }
                
                // Adjust the threshold value as needed
                let threshold: Double = 0.2
                
                if abs(data.acceleration.x) > threshold || abs(data.acceleration.y) > threshold || abs(data.acceleration.z) > threshold {
                    self.sendMessage(message: "phone moved")
                }
            }
        }
    }

    func stopAccelerometerUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func sendMessage(message: String) {
        // mac at brown
//        guard let url = URL(string: "http://10.39.14.93:5000/touch") else { return }
//        // mac
        guard let url = URL(string: "http://192.168.86.106:5000/touch") else { return }
        // windows
//        guard let url = URL(string: "http://192.168.86.111:5000/touch") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = message.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
//            else if let data = data {
//                print("Response: \(String(data: data, encoding: .utf8) ?? "")")
//            }
        }

        task.resume()
    }
}

