//
//  CountrySelectionViewController.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class CountrySelectionController {

    private var bottomConstraint = NSLayoutConstraint()
    private var currentState: State = .closed
    private var constBotConstraint: CGFloat = 0
    public var countrySelectionTableView: UITableView!
    public var searchTextField: UITextField!

    /// MARK : - Properties
    private var popupView: UIView = UIView()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()

    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()

    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()

    private var userViewConrtoller: UIViewController!

    init(_ viewController: UIViewController) {
        self.userViewConrtoller = viewController
    }

    public func layoutPopUpSearch() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        userViewConrtoller.view.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: userViewConrtoller.view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: userViewConrtoller.view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: userViewConrtoller.view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: userViewConrtoller.view.bottomAnchor).isActive = true


        constBotConstraint = userViewConrtoller.view.frame.height
        let bConst = constBotConstraint * 0.9

        popupView.backgroundColor = .white
        popupView.translatesAutoresizingMaskIntoConstraints = false
        userViewConrtoller.view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: userViewConrtoller.view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: userViewConrtoller.view.trailingAnchor).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: userViewConrtoller.view.bottomAnchor, constant: constBotConstraint)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: bConst).isActive = true

        let margin: CGFloat = 20
        let labelRect = CGRect(x: (margin / 2), y: 10, width: (userViewConrtoller.view.frame.width - margin), height: 30)
        let textFieldRect = CGRect(x: (margin / 2), y: labelRect.height + 10, width: (userViewConrtoller.view.frame.width - margin), height: 35)
        let tableRect = CGRect(x: 0, y: (textFieldRect.height + labelRect.height) + 15, width: userViewConrtoller.view.frame.width, height: bConst - (textFieldRect.height + labelRect.height) - 10)

        // Adding Label
        let searchLabel: UILabel = UILabel(frame: labelRect)
        searchLabel.text = "Search for country"
        searchLabel.font = UIFont(name: "Roboto-black", size: 15.0)
        popupView.addSubview(searchLabel)
        popupView.bringSubviewToFront(searchLabel)

        // Adding Search Text Field
        searchTextField = UITextField(frame: textFieldRect)
        searchTextField.placeholder = "Search for country"
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = userViewConrtoller as? UITextFieldDelegate
        popupView.addSubview(searchTextField)
        popupView.bringSubviewToFront(searchTextField)

        // Adding table view to the popup view
        countrySelectionTableView = UITableView(frame: tableRect)
        countrySelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        countrySelectionTableView.dataSource = userViewConrtoller as? UITableViewDataSource
        countrySelectionTableView.delegate = userViewConrtoller as? UITableViewDelegate
        popupView.addSubview(countrySelectionTableView)
        popupView.bringSubviewToFront(countrySelectionTableView)

        //        popupView.addGestureRecognizer(panRecognizer)
        overlayView.addGestureRecognizer(tapRecognizer)
    }

    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.popupView.layer.cornerRadius = 20
                self.overlayView.alpha = 0.5
            case .closed:
                self.bottomConstraint.constant = self.constBotConstraint
                self.popupView.layer.cornerRadius = 0
                self.overlayView.alpha = 0
                self.searchTextField.resignFirstResponder()
            }

            self.userViewConrtoller.view.layoutIfNeeded()
        })

        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                ()
                break
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.constBotConstraint
            }
        }
        transitionAnimator.startAnimation()
    }

    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {

        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }

        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.popupView.layer.cornerRadius = 20
                self.overlayView.alpha = 0.5
            case .closed:
                self.bottomConstraint.constant = self.constBotConstraint
                self.popupView.layer.cornerRadius = 0
                self.overlayView.alpha = 0
            }

            self.userViewConrtoller.view.layoutIfNeeded()
        })

        // the transition completion block
        transitionAnimator.addCompletion { position in

            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                ()
            }

            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.constBotConstraint
            }

            // remove all running animators
            self.runningAnimators.removeAll()

        }

        // start all animators
        transitionAnimator.startAnimation()

        // keep track of all running animators
        runningAnimators.append(transitionAnimator)

    }

    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:

            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)

            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }

            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }

        case .changed:

            // variable setup
            let translation = recognizer.translation(in: popupView)
            var fraction = -translation.y / constBotConstraint

            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }

            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }

        case .ended:

            // variable setup
            let yVelocity = recognizer.velocity(in: popupView).y
            let shouldClose = yVelocity > 0

            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }

            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }

            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }

        default:
            ()
        }
    }


    public func viewTapped() {
        popupViewTapped(recognizer: self.tapRecognizer)
    }
}

// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }

}
