//
//  ModuleMenu.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 1/17/24.
//

import UIKit

class MenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var titleText: String?
    var options: [String] = ["Option 1", "Option 2", "Option 3"] // Add your options here
    var selectedOption: String?

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleText = title
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of the menu view controller
        view.backgroundColor = UIColor(hex: "2E2D2D", alpha: 1)
        preferredContentSize = CGSize(width: 400, height: 200)  // Increase the width for the black rectangle

        // Add title label
        let titleLabel = UILabel()
        let attributedText = NSMutableAttributedString(string: "Edit / " + (titleText?.uppercased() ?? ""))
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)]
        attributedText.addAttributes(boldFontAttribute, range: NSRange(location: 0, length: 5)) // Assuming "Edit" is 5 characters
        titleLabel.attributedText = attributedText
        titleLabel.textColor = UIColor(hex: "C0C0C0", alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Add UIPickerView for selectable options
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tintColor = UIColor.white
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)

        // Create UIButton
        let newFunctionButton = UIButton(type: .system)
        newFunctionButton.translatesAutoresizingMaskIntoConstraints = false
        newFunctionButton.addTarget(self, action: #selector(newFunctionTapped), for: .touchUpInside)

        // Create attributed text with white-colored image
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor(hex: "C0C0C0", alpha: 1), renderingMode: .alwaysOriginal)
        let imageString = NSAttributedString(attachment: imageAttachment)
        let text = NSMutableAttributedString(string: " New Function", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        text.insert(imageString, at: 0)
        newFunctionButton.setAttributedTitle(text, for: .normal)
        newFunctionButton.tintColor = UIColor(hex: "C0C0C0", alpha: 1)
        newFunctionButton.setAttributedTitle(text, for: .normal)
        view.addSubview(newFunctionButton)

        // Add a button to handle selection
        let selectButton = UIButton(type: .system)
        selectButton.setTitle(" Confirm ", for: .normal)
        selectButton.setTitleColor(UIColor(hex: "C0C0C0", alpha: 1), for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        selectButton.layer.borderWidth = 1.0
        selectButton.layer.borderColor = UIColor(hex: "C0C0C0", alpha: 1).cgColor
        selectButton.layer.cornerRadius = 5.0
        selectButton.addTarget(self, action: #selector(handleSelection), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectButton)

        // Black rectangle view
        let blackRectangle = UIView()
        blackRectangle.backgroundColor = UIColor(hex: "181717", alpha: 1)
        blackRectangle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackRectangle)

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            newFunctionButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            newFunctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            newFunctionButton.trailingAnchor.constraint(equalTo: blackRectangle.leadingAnchor, constant: -20),  // Align with the left edge of the black rectangle

            selectButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            selectButton.trailingAnchor.constraint(equalTo: blackRectangle.leadingAnchor, constant: -20),  // Align with the left edge of the black rectangle

            blackRectangle.topAnchor.constraint(equalTo: view.topAnchor),
            blackRectangle.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 20),  // Align with the right edge of the pickerView
            blackRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackRectangle.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = options[row]
    }
    
    @objc func newFunctionTapped() {
        print("new function")
    }

    @objc func handleSelection() {
        if let selectedOption = selectedOption {
            print("Selected Option: \(selectedOption)")
            dismiss(animated: true, completion: nil)
        } else {
            print("No option selected")
        }
    }
}
