//
//  ViewController.swift
//  String2SpeechExtension
//
//  Created by Ricardo Venieris on 13/05/20.
//  Copyright © 2020 Ricardo Venieris. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

	@IBOutlet weak var textToSpeech: UITextView!
	
	@IBOutlet weak var pitchLabel: UILabel!
	@IBOutlet weak var pitchSlider: UISlider!
	
	@IBOutlet weak var rateLabel: UILabel!
	@IBOutlet weak var rateSlider: UISlider!
	
	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		pitchLabel.text = String(format: "Pitch: %.2f", pitchSlider.value)
		rateLabel.text = String(format: "Rate: %.2f", rateSlider.value)

		hideKeyboardWhenTappedAround()

	}
	@IBAction func stopSpeech(_ sender: Any) {
		"".stopSpeaking()
	}
	
	@IBAction func pitchChanged(_ sender: UISlider) {
		pitchLabel.text = String(format: "Pitch: %.2f", pitchSlider.value)
	}
	
	@IBAction func rateChanged(_ sender: UISlider) {
		rateLabel.text = String(format: "Rate: %.2f", rateSlider.value)
	}
	


}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return AVSpeechSynthesisVoice.speechVoices().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
		let voice = AVSpeechSynthesisVoice.speechVoices()[indexPath.row]
		
		cell.name.text = voice.name
		cell.language.text = voice.language

		return cell
	}
	
	func setBackgroundColorForSelectedCell(to color:UIColor) {
		guard let indexPath = tableView.indexPathForSelectedRow else {return}
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.backgroundColor = color
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let voice = AVSpeechSynthesisVoice.speechVoices()[indexPath.row].language
		"".stopSpeaking()
		String(textToSpeech.text).speak(voice: voice, pitch: pitchSlider.value, rate: rateSlider.value, delegate: self)
	}
}

extension ViewController: AVSpeechSynthesizerDelegate {
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		setBackgroundColorForSelectedCell(to: .systemPink)
		textToSpeech.backgroundColor = .systemPink
	}
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		setBackgroundColorForSelectedCell(to: .clear)
		textToSpeech.backgroundColor = .systemBackground
	}
}

extension ViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
