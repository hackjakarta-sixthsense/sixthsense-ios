//
//  SearchSpeechModal.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import Speech

class SearchSpeechModal: ViewController {
    
    private let viewModel: SearchSpeechViewModel
    
    private let closeButton = UIButton()
    private let speechLabel = UILabel()
    private let speechFrame = UIView()
    private let speechIV = UIImageView()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id-ID"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var inputAudiostring: String?
    
    init(viewModel: SearchSpeechViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [closeButton, speechLabel, speechFrame].forEach { [weak self] view in
            self?.view.addSubview(view)
        }
        
        closeButton.icon(source: .init(systemName: "xmark"))
        closeButton.addTarget(self, action: #selector(handleClose(_:)), for: .touchUpInside)
        closeButton.constraints(
            top: view.topAnchor, leading: view.leadingAnchor, padding: .init(
                top: .apply(insets: .large), left: .apply(insets: .medium),
                bottom: 0, right: 0), width: .apply(iconSize: .large),
            height: .apply(iconSize: .large))
        
        speechLabel.text = "Speak now, i'm listening..."
        speechLabel.font = .apply(.regular, size: .title2)
        speechLabel.numberOfLines = .zero
        speechLabel.constraints(
            top: closeButton.bottomAnchor, leading: view.leadingAnchor,
            trailing: view.trailingAnchor, padding: .init(
                top: .apply(insets: .medium), left: .apply(insets: .medium),
                bottom: 0, right: .apply(insets: .medium)))
        speechLabel.textColor = .black
        
        speechFrame.layer.cornerRadius = 50
        speechFrame.backgroundColor = .lightGray
        speechFrame.isUserInteractionEnabled = true
        speechFrame.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleMic(_:))
        ))
        speechFrame.constraints(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            centerX: (view.centerXAnchor, 0), padding: .init(
                top: 0, left: 0, bottom: .apply(insets: .largest) +
                    .apply(insets: .xLarge), right: 0),
            width: 100, height: 100)
        
        speechFrame.addSubview(speechIV)
        
        speechIV.image = .init(systemName: "mic.fill")
        speechIV.contentMode = .scaleAspectFit
        speechIV.tintColor = .white
        speechIV.constraints(
            centerX: (speechFrame.centerXAnchor, 0),
            centerY: (speechFrame.centerYAnchor, 0),
            width: 50, height: 50
        )
        
        handleMic(nil)
    }
    
    @objc private func handleClose(_ sender: UIButton?) {
        dismiss(animated: true)
    }
    
    @objc private func handleMic(_ sender: UITapGestureRecognizer?) {
        if audioEngine.isRunning {
            stopRecording()
            viewModel.fetch(prompt: inputAudiostring ?? "")
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(
            with: recognitionRequest, resultHandler: { [weak self] result, error in
                guard let self = self else { return }
                var isFinal = false
                
                if let result = result {
                    self.speechLabel.text = result
                        .bestTranscription.formattedString
                    isFinal = result.isFinal
                    self.inputAudiostring = result.bestTranscription.formattedString
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.speechFrame.backgroundColor = .lightGray
                }
            }
        )
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do { try audioEngine.start() } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        speechLabel.text = "Speak now, i'm listening..."
        speechFrame.backgroundColor = .accent
    }
    
    @objc private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        speechFrame.backgroundColor = .lightGray
    }

}

extension SearchSpeechModal {
    
    func assignState(state: ApiState) {
        switch state {
        case .success: viewModel.dismissWithData()
        default: break
        }
    }
}
