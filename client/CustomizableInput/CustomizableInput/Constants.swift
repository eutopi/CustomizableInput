//
//  Constants.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 1/18/24.
//

import UIKit

struct ModuleConstants {
    static let options: [String: [String]] = [
        "Button": ["None", "Copy", "Paste", "Auto-indent (VSCode)"],
        "Slider": ["None", "Volume", "Page Scroll Vertical", "Page Scroll Horizontal"],
        "Color": ["None", "Page Scroll Vertical (default)", "Page Scroll Horizontal (default)"],
        "Toggle": ["None", "Page Scroll Vertical (default)", "Page Scroll Horizontal (default)"],
        "Joystick": ["None", "Page Scroll Vertical (default)", "Page Scroll Horizontal (default)"]
    ]
    
    static let module = [
        "Button": CustomButton(frame: .zero, isEditMode: false),
        "Slider": CustomSlider(frame: .zero, isEditMode: false),
        "Color": CustomColor(frame: .zero, isEditMode: false),
        "Toggle": CustomToggle(frame: .zero, isEditMode: false),
        "Joystick": CustomJoystick(frame: .zero, isEditMode: false)
    ]
}
