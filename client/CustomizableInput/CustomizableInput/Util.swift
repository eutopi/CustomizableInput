//
//  Util.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 12/7/23.
//

import UIKit

public func findImageView(at point: CGPoint, superview: UIView) -> UIImageView? {
        for subview in superview.subviews {
            if let imageView = subview as? UIImageView, imageView.frame.contains(point) {
                return imageView
            }
        }

        return nil
}

public func createImageButton(imageColor: UIColor, textColor: UIColor, image: UIImage, fontSize: CGFloat, buttonText: String) -> UIButton {
    let imageButton = UIButton(type: .system)
    imageButton.translatesAutoresizingMaskIntoConstraints = false
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = image.withTintColor(imageColor, renderingMode: .alwaysOriginal)
    let imageString = NSAttributedString(attachment: imageAttachment)
    let text = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
    text.insert(imageString, at: 0)
    imageButton.setAttributedTitle(text, for: .normal)
    imageButton.tintColor = textColor
    imageButton.setAttributedTitle(text, for: .normal)
    
    return imageButton
}

public func sendMessage(path: String, message: String) {
    // replace the IP address below as necessary
    guard let url = URL(string: "http://192.168.86.31:5000/\(path)") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = message.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
        }
    }
    
    task.resume()
}
