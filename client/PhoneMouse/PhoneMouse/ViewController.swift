//
//  ViewController.swift
//  PhoneMouse
//
//  Created by Tongyu Zhou on 10/9/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var trackingView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    let motionManager = CMMotionManager()
    let panMode = "touch"

    override func viewDidLoad() {
        super.viewDidLoad()
//        startAccelerometerUpdates()
        // Do any additional setup after loading the view.
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

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
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

