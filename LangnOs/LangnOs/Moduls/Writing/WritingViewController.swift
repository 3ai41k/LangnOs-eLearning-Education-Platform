//
//  WritingViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 18.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class WritingViewController: BindibleViewController<WritingViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var wordsCounterLabel: UILabel!
    @IBOutlet private weak var writingProgressView: WritingProgressView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var messageView: UIView! {
        didSet {
            messageView.transform = CGAffineTransform(translationX: .zero, y: Constants.messageViewYInHideState)
        }
    }
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var wordLabel: UILabel!
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet private weak var answerButton: UIButton!
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.word.assign(to: \.text, on: wordLabel),
            viewModel?.wordsCounter.assign(to: \.text, on: wordsCounterLabel),
            viewModel?.correctAnswers.assign(to: \.correctAnswers, on: writingProgressView),
            viewModel?.isAnswerHidden.assign(to: \.isHidden, on: answerButton),
            viewModel?.progress.assign(to: \.progress, on: progressView),
            viewModel?.message.compactMap({ $0 }).sink(receiveValue: { [weak self] (message, color) in
                self?.messageLabel.text = message
                self?.messageView.backgroundColor = color
                self?.showMessageView()
            }),
            viewModel?.clearInputPublisher.sink(receiveValue: { [weak self] in
                self?.textField.text = nil
            })
        ]
    }
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    // MARK: - Private methods
    
    private func showMessageView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.messageView.transform = CGAffineTransform(translationX: .zero, y: Constants.messageViewYInVisibleState)
        }) { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3) {
                    self.messageView.transform = CGAffineTransform(translationX: .zero, y: Constants.messageViewYInHideState)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didAnswerTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.answer)
    }
    
}

// MARK: - UITextFieldDelegate

extension WritingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        viewModel?.actionSubject.send(.check(text))
        return true
    }
    
}

// MARK: - Constants

extension WritingViewController {
    
    struct Constants {
        static let messageViewYInHideState: CGFloat = -44.0
        static let messageViewYInVisibleState: CGFloat = .zero
    }
    
}

