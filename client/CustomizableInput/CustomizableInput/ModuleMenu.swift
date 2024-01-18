//
//  ModuleMenu.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 1/17/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of the menu view controller
        view.backgroundColor = UIColor.white
        preferredContentSize = CGSize(width: 150, height: 100)

        // Add buttons or other UI elements to the menu
        let option1Button = UIButton(type: .system)
        option1Button.setTitle("Option 1", for: .normal)
        option1Button.addTarget(self, action: #selector(handleOption1), for: .touchUpInside)
        option1Button.frame = CGRect(x: 20, y: 20, width: 110, height: 30)
        view.addSubview(option1Button)

        let option2Button = UIButton(type: .system)
        option2Button.setTitle("Option 2", for: .normal)
        option2Button.addTarget(self, action: #selector(handleOption2), for: .touchUpInside)
        option2Button.frame = CGRect(x: 20, y: 60, width: 110, height: 30)
        view.addSubview(option2Button)
    }

    @objc func handleOption1() {
        print("Option 1 selected")
        dismiss(animated: true, completion: nil)
    }

    @objc func handleOption2() {
        print("Option 2 selected")
        dismiss(animated: true, completion: nil)
    }
}
