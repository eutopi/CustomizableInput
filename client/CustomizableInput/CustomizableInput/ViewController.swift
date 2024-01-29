//
//  ViewController.swift
//  CustomizableInput
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

class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    var bindedModule: UIImageView?
    var moduleType: String?
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet var trackingView: UIView!
    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var canvasTitleTextField: UITextField!
    @IBOutlet weak var canvas: UIView!
    
    @IBOutlet weak var canvasModeBtn: UIButton!
    
    @IBOutlet weak var moduleSliderBtn: UIImageView!
    @IBOutlet weak var moduleToggleBtn: UIImageView!
    @IBOutlet weak var moduleJoystickBtn: UIImageView!
    @IBOutlet weak var moduleButtonBtn: UIImageView!
    @IBOutlet weak var modulePickerBtn: UIImageView!
    @IBOutlet weak var trashIcon: UIImageView!
    
    var copiedImageView: UIImageView?
    var slider: UISlider?
    var moduleDictionary: [String: CustomModule] = [:]

    
    // previous stuff, remove later
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
        // Do any additional setup after loading the view.
        //        initializeButtons()
        //        startAccelerometerUpdates()
        initializeCanvas()
    }
    
    func initializeCanvas() {
        canvasView.layer.cornerRadius = 15;
        canvasView.layer.masksToBounds = true;
        self.canvasTitleTextField.delegate = self
        trashIcon.alpha = 0.7
        trashIcon.tag = -1
        
        canvasModeBtn.isSelected = true
        canvasModeBtn.setImage(UIImage(named: "ToggleEditBtn"), for: .selected)
        canvasModeBtn.setImage(UIImage(named: "TogglePlayBtn"), for: .normal)
        canvasModeBtn.addTarget(self, action: #selector(canvasModeBtnTapped), for: .touchUpInside)

        // Initialize slider gestures
        let panGestureSlider = CustomPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureSlider.bindedModule = moduleSliderBtn
        panGestureSlider.moduleType = "slider"
        moduleSliderBtn.addGestureRecognizer(panGestureSlider)
        
        // Initialize toggle gestures
        let panGestureToggle = CustomPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureToggle.bindedModule = moduleToggleBtn
        panGestureToggle.moduleType = "toggle"
        moduleToggleBtn.addGestureRecognizer(panGestureToggle)
        
        // Initialize joystick gestures
        let panGestureJoystick = CustomPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureJoystick.bindedModule = moduleJoystickBtn
        panGestureJoystick.moduleType = "joystick"
        moduleJoystickBtn.addGestureRecognizer(panGestureJoystick)
        
        // Initialize button gestures
        let panGestureButton = CustomPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureButton.bindedModule = moduleButtonBtn
        panGestureButton.moduleType = "button"
        moduleButtonBtn.addGestureRecognizer(panGestureButton)
        
        // Initialize picker gestures
        let panGesturePicker = CustomPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesturePicker.bindedModule = modulePickerBtn
        panGesturePicker.moduleType = "color"
        modulePickerBtn.addGestureRecognizer(panGesturePicker)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func canvasModeBtnTapped() {
        canvasModeBtn.isSelected.toggle()
        print(moduleDictionary.count)
        for module in moduleDictionary.values {
            module.isEditMode = canvasModeBtn.isSelected
            print(module.isEditMode)
            if ((module.superview) == nil) {
                moduleDictionary.removeValue(forKey: module.id)
            }
        }
        if (canvasModeBtn.isSelected) {
            trashIcon.alpha = 0.7
        }
        else {
            trashIcon.alpha = 0
        }
    }
    
    @objc func handlePan(_ gesture: CustomPanGestureRecognizer) {
        let translation = gesture.translation(in: trackingView)
        
        if let bindedModule = gesture.bindedModule {
            if let moduleType = gesture.moduleType {
                if gesture.state == .began {
                    // Create a copy of the original image view only once
                    copiedImageView = UIImageView(image: bindedModule.image)
                    copiedImageView?.frame = bindedModule.frame
                    trackingView.addSubview(copiedImageView!)
                }
                
                // Update the position of the copied image view as the user pans
                copiedImageView?.center = CGPoint(x: copiedImageView!.center.x + translation.x, y: copiedImageView!.center.y + translation.y)
                
                if gesture.state == .ended {
                    print("object dropped")
                    if let copiedImageView = copiedImageView, canvasView.frame.contains(copiedImageView.frame.origin) {
                        let convertedFrame = trackingView.convert(copiedImageView.frame, to: canvasView)
                        
                        copiedImageView.removeFromSuperview()
                        if let newModule = createModule(moduleType: moduleType) {
                            newModule.frame = CGRect(x: convertedFrame.minX, y: convertedFrame.minY, width: newModule.frame.width, height: newModule.frame.height)
                            newModule.isEditMode = canvasModeBtn.isSelected
                            canvasView.addSubview(newModule)
                            moduleDictionary[newModule.id] = newModule
                        } else {
                            print("Failed to create module for moduleType:", moduleType)
                        }
                    } else {
                        copiedImageView?.removeFromSuperview()
                    }
                }
                
                // Reset the translation to avoid accumulation
                gesture.setTranslation(.zero, in: trackingView)
            }
        }
    }
    
    func createModule(moduleType: String) -> CustomModule? {
        switch moduleType {
        case "button":
            return CustomButton()
        case "slider":
            return CustomSlider()
        case "color":
            return CustomColor()
        case "toggle":
            return CustomToggle()
        case "joystick":
            return CustomJoystick()
        default:
            // Handle unknown module types or return nil
            return nil
        }
    }
    
    func initializeGestures() {
        let panGestureRecognizerLeftBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanLeftMouse(_:)))
        panGestureRecognizerLeftBtn.delegate = self
        leftButton.addGestureRecognizer(panGestureRecognizerLeftBtn)
        let panGestureRecognizerRightBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanRightMouse(_:)))
        panGestureRecognizerRightBtn.delegate = self
        rightButton.addGestureRecognizer(panGestureRecognizerRightBtn)
        
        let panGestureRecognizerPhysicalLeftBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanPhysicalLeftMouse(_:)))
        panGestureRecognizerPhysicalLeftBtn.delegate = self
        leftButtonPhysical.addGestureRecognizer(panGestureRecognizerPhysicalLeftBtn)
        let panGestureRecognizerPhysicalRightBtn = UIPanGestureRecognizer(target: self, action: #selector(handlePanPhysicalRightMouse(_:)))
        panGestureRecognizerPhysicalRightBtn.delegate = self
        rightButtonPhysical.addGestureRecognizer(panGestureRecognizerPhysicalRightBtn)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.delegate = self
        trackingView.addGestureRecognizer(panGestureRecognizer)
        
        let panGestureRecognizerScrollbar = UIPanGestureRecognizer(target: self, action: #selector(handleScrollbarTouch(_:)))
        panGestureRecognizerScrollbar.delegate = self
        traditionalScrollbar.addGestureRecognizer(panGestureRecognizerScrollbar)
        
        panGestureRecognizer.require(toFail: panGestureRecognizerLeftBtn)
        panGestureRecognizer.require(toFail: panGestureRecognizerRightBtn)
        panGestureRecognizer.require(toFail: panGestureRecognizerPhysicalLeftBtn)
        panGestureRecognizer.require(toFail: panGestureRecognizerPhysicalRightBtn)
        panGestureRecognizer.require(toFail: panGestureRecognizerScrollbar)
    }
    
    // on screen touch events
    
    func makeTapSound() {
        // Create a feedback generator
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        
        // Trigger the feedback
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func leftMouseDown(_ sender: Any) {
        print("left click down")
        makeTapSound()
        sendMessage(message: "left down")
    }
    
    @IBAction func leftMouseUp(_ sender: Any) {
        print("left click up")
        sendMessage(message: "left up")
    }
    
    @IBAction func rightMouseDown(_ sender: Any) {
        print("right click down")
        makeTapSound()
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
    
    @IBAction func handlePanPhysicalLeftMouse(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
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
    
    @IBAction func handlePanPhysicalRightMouse(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
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
            startAccelerometerUpdates()
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
            stopAccelerometerUpdates()
        }
    }
    
    
    // physical motion events
    
    func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1  // Set your desired update interval in seconds
            motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
                guard let data = accelerometerData else { return }
                
                // Adjust the threshold value as needed
                let threshold: Double = 0.05
                
                if abs(data.acceleration.x) > threshold || abs(data.acceleration.y) > threshold {
                    print("\(data.acceleration.x), \(data.acceleration.y)")
                    self.sendMessage(message: "move: \(data.acceleration.x * 100), \(-data.acceleration.y * 100)")
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

