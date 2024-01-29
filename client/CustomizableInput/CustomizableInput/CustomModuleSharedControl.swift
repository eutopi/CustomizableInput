//
//  CustomModuleSharedControl.swift
//  CustomizableInput
//
//  Created by Tongyu Zhou on 1/17/24.
//

import UIKit

protocol MenuPresentable {
    func showMenu(from viewController: UIViewController, at touchPoint: CGPoint)
}

class BaseControl: UIControl, MenuPresentable {

    private var touchPoint: CGPoint?
    private var moduleTitle = "Undefined Module"
    private var moduleID = ""

    init(frame: CGRect, title: String, id: String) {
        super.init(frame: frame)
        self.moduleTitle = title
        self.moduleID = id
        setupControl()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }

    func setupControl() {
        self.isUserInteractionEnabled = true

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)

        self.addInteraction(UIContextMenuInteraction(delegate: self))
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self)

        if let viewController = findViewController() {
            showMenu(from: viewController, at: touchPoint)
        }
    }

    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func showMenu(from viewController: UIViewController, at touchPoint: CGPoint) {
        // Create a custom view controller for the menu
        let menuViewController = MenuViewController(title: moduleTitle, id: moduleID)

        // Set the presentation style to popover
        menuViewController.modalPresentationStyle = .popover

        // Get the popover presentation controller
        if let popoverPresentationController = menuViewController.popoverPresentationController {
            // Set the source view and source rect
            popoverPresentationController.sourceView = viewController.view
            popoverPresentationController.sourceRect = CGRect(origin: touchPoint, size: .zero)

            // Present the menu
            viewController.present(menuViewController, animated: true, completion: nil)
        }
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        // Pan gesture handling code goes here

        guard let superview = self.superview?.superview else { return }
    
        guard let view = self.superview
            else { return }
        
        if sender.state == .began {
            touchPoint = sender.location(in: superview)
            self.center = view.center
        } else if sender.state == .changed {
            let translation = sender.translation(in: superview)
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            view.center = self.center
            sender.setTranslation(CGPoint.zero, in: superview)
        } else if sender.state == .ended || sender.state == .cancelled {
            let touchPointEnd = sender.location(in: superview)
            if let imageView = findImageView(at: touchPointEnd, superview: superview) {
                if imageView.tag == -1 {
                    self.superview!.removeFromSuperview()
                }
            }
            
            touchPoint = nil
        }
    }
}
