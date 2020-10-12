//
//  SpeechSynthesizer.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import AVFoundation

enum SpeechSynthesizerError: Error {
    case unknownLanguage
    
    var localizedDescription: String {
        switch self {
        case .unknownLanguage:
            return "Unknown Language!".localize
        }
    }
}

protocol SpeakableProtocol: class {
    var didStartHandler: (() -> Void)? { get set }
    var didFinishHandler: (() -> Void)? { get set }
    func speak(string: String) throws
}

final class SpeechSynthesizer: NSObject, SpeakableProtocol {
    
    // MARK: - Public properties
    
    var didStartHandler: (() -> Void)?
    var didFinishHandler: (() -> Void)?
    
    // MARK: - Private properties
    
    private let synthesizer: AVSpeechSynthesizer
    
    // MARK: - Init
    
    override init() {
        self.synthesizer = AVSpeechSynthesizer()
        
        super.init()
        
        self.synthesizer.delegate = self
    }
    
    // MARK: - Public methpods
    
    func speak(string: String) throws {
        let language = try dominantLanguage(for: string)
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        
        synthesizer.speak(utterance)
    }
    
    // MARK: - Private methpods
    
    private func dominantLanguage(for text: String) throws -> String {
        if let language = NSLinguisticTagger.dominantLanguage(for: text) {
            return language
        } else {
            throw SpeechSynthesizerError.unknownLanguage
        }
    }
    
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        didStartHandler?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishHandler?()
    }
    
}
