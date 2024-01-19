//
//  ModuleMenu.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 1/17/24.
//

import UIKit

class MenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var titleText: String = "None"
    var options: [String] = []
    var selectedOption: String?
    
    var newFunctionName: UITextField = UITextField()
    var newFunctionCurrentlyRecording: Bool = false
    var newFunctionButton: UIButton = UIButton()
    var removeFunctionButton: UIButton = UIButton()
    var recordStartButton: UIButton = UIButton()
    var recordStopButton: UIButton = UIButton()
    var recordSaveButton: UIButton = UIButton()
    
    var pickerView: UIPickerView = UIPickerView()
    var blackRectangle: UIView = UIView()
    var testModule: UIView = UIView()

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleText = title
        self.options = ModuleConstants.options[title]!
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of the menu view controller
        view.backgroundColor = UIColor(hex: "2E2D2D", alpha: 1)
        preferredContentSize = CGSize(width: 400, height: 200)

        // Add title label
        let titleLabel = UILabel()
        let attributedText = NSMutableAttributedString(string: "Edit / " + (titleText.uppercased()))
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)]
        attributedText.addAttributes(boldFontAttribute, range: NSRange(location: 0, length: 5)) // Assuming "Edit" is 5 characters
        titleLabel.attributedText = attributedText
        titleLabel.textColor = UIColor(hex: "C0C0C0", alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Add UIPickerView for selectable options
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tintColor = UIColor.white
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)

        // Create UIButton for new function
        newFunctionButton = createImageButton(imageColor: UIColor(hex: "C0C0C0", alpha: 1), textColor: UIColor(hex: "C0C0C0", alpha: 1), image: UIImage(systemName: "plus.circle.fill")!, fontSize: 16, buttonText: " New Function ")
        newFunctionButton.addTarget(self, action: #selector(newFunctionTapped), for: .touchUpInside)
        view.addSubview(newFunctionButton)
        
        // Create UIButton for remove function
        removeFunctionButton = createImageButton(imageColor: UIColor(hex: "C0C0C0", alpha: 1), textColor: UIColor(hex: "C0C0C0", alpha: 1), image: UIImage(systemName: "minus.circle.fill")!, fontSize: 16, buttonText: "")
        removeFunctionButton.addTarget(self, action: #selector(removeFunctionTapped), for: .touchUpInside)
        view.addSubview(removeFunctionButton)
        removeFunctionButton.isHidden = true
        newFunctionName.borderStyle = .line
        newFunctionName.layer.borderWidth = 1
        newFunctionName.layer.borderColor = UIColor(hex: "C0C0C0", alpha: 1).cgColor
        newFunctionName.attributedPlaceholder = NSAttributedString(
            string: "Enter new function name here...",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(hex: "C0C0C0", alpha: 0.8),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]
        )
        newFunctionName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newFunctionName)
        newFunctionName.textColor = UIColor(hex: "C0C0C0", alpha: 0.8)
        newFunctionName.text = "Unnamed"
        newFunctionName.isHidden = true
        newFunctionName.delegate = self
        
        recordStartButton = createImageButton(imageColor: .red, textColor: UIColor(hex: "C0C0C0", alpha: 1), image: UIImage(systemName: "record.circle")!, fontSize: 16, buttonText: " Record action ")
        recordStartButton.addTarget(self, action: #selector(recordStartButtonTapped), for: .touchUpInside)
        view.addSubview(recordStartButton)
        recordStartButton.isHidden = true
        
        recordStopButton = createImageButton(imageColor: .red, textColor: UIColor(hex: "C0C0C0", alpha: 1), image: UIImage(systemName: "stop.circle.fill")!, fontSize: 16, buttonText: " Stop recording ")
        recordStopButton.addTarget(self, action: #selector(recordStopButtonTapped), for: .touchUpInside)
        view.addSubview(recordStopButton)
        recordStopButton.isHidden = true
        
        recordSaveButton = createImageButton(imageColor: UIColor(hex: "C0C0C0", alpha: 1), textColor: UIColor(hex: "C0C0C0", alpha: 1), image: UIImage(systemName: "square.and.arrow.up.fill")!, fontSize: 16, buttonText: "")
        recordSaveButton.addTarget(self, action: #selector(recordSaveButtonTapped), for: .touchUpInside)
        view.addSubview(recordSaveButton)
        recordSaveButton.isHidden = true
        recordSaveButton.isEnabled = false
        
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
        blackRectangle = UIView()
        blackRectangle.backgroundColor = UIColor(hex: "181717", alpha: 1)
        blackRectangle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackRectangle)

        testModule = ModuleConstants.module[titleText]!
        view.addSubview(testModule)

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            newFunctionButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            newFunctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            newFunctionButton.trailingAnchor.constraint(equalTo: blackRectangle.leadingAnchor, constant: -20),  // Align with the left edge of the black rectangle
            
            removeFunctionButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            removeFunctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),

            newFunctionName.topAnchor.constraint(equalTo: removeFunctionButton.topAnchor),
            newFunctionName.leadingAnchor.constraint(equalTo: removeFunctionButton.trailingAnchor, constant: 0),
            newFunctionName.trailingAnchor.constraint(equalTo: blackRectangle.leadingAnchor, constant: -20),
            
            recordStartButton.topAnchor.constraint(equalTo: removeFunctionButton.bottomAnchor, constant: 5),
            recordStartButton.leadingAnchor.constraint(equalTo: newFunctionName.leadingAnchor),
            
            recordStopButton.topAnchor.constraint(equalTo: removeFunctionButton.bottomAnchor, constant: 5),
            recordStopButton.leadingAnchor.constraint(equalTo: newFunctionName.leadingAnchor),

            recordSaveButton.topAnchor.constraint(equalTo: removeFunctionButton.bottomAnchor, constant: 5),
            recordSaveButton.leadingAnchor.constraint(equalTo: newFunctionName.trailingAnchor, constant: -30),

            selectButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            selectButton.trailingAnchor.constraint(equalTo: blackRectangle.leadingAnchor, constant: -20),  // Align with the left edge of the black rectangle

            blackRectangle.topAnchor.constraint(equalTo: view.topAnchor),
            blackRectangle.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 20),  // Align with the right edge of the pickerView
            blackRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackRectangle.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testModule.center = blackRectangle.center
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()

        label.text = options[row]
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)  // Set the font size to 16

        return label
    }
    
    @objc func newFunctionTapped() {
        newFunctionButton.isHidden = true
        removeFunctionButton.isHidden = false
        newFunctionName.isHidden = false
        recordStartButton.isHidden = false
        recordStopButton.isHidden = true
        recordSaveButton.isHidden = false
        recordSaveButton.isEnabled = false
        recordSaveButton.alpha = 0.2
    }
    
    @objc func removeFunctionTapped() {
        newFunctionButton.isHidden = false
        removeFunctionButton.isHidden = true
        newFunctionName.isHidden = true
        recordStartButton.isHidden = true
        recordStopButton.isHidden = true
        recordSaveButton.isHidden = true
    }
    
    @objc func recordStartButtonTapped() {
        recordStartButton.isHidden = true
        recordStopButton.isHidden = false
        recordSaveButton.isEnabled = false
        recordSaveButton.alpha = 0.2
    }
    
    @objc func recordStopButtonTapped() {
        recordStartButton.isHidden = false
        recordStopButton.isHidden = true
        recordSaveButton.isEnabled = true
        recordSaveButton.alpha = 1
    }
    
    @objc func recordSaveButtonTapped() {
        options.append(newFunctionName.text!)
        pickerView.reloadAllComponents()
        removeFunctionTapped()
    }

    @objc func handleSelection() {
        if let selectedOption = selectedOption {
            print("Selected Option: \(selectedOption)")
            dismiss(animated: true, completion: nil)
        } else {
            print("No option selected")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
