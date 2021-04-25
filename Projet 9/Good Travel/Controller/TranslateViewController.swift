//
//  TranslateViewController.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 06/01/2021.
//

import UIKit

class TranslateViewController : UIViewController,
                                AlertPresentable,
                                UIPickerViewDelegate,
                                UIPickerViewDataSource {
  
  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------
  
  var translateConverter = TranslateConverter()
  
  @IBOutlet weak var originalTextView: UITextView!
  @IBOutlet weak var translatedTextView: UITextView!
  @IBOutlet weak var origineLanguageTextField: UITextField!
  @IBOutlet weak var reachLanguageTextField: UITextField!
  let pickerLanguage = UIPickerView()
  let pickerLanguageTwo = UIPickerView()
  
  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------
  
  /// Setup of the viewDidLoad
  func setup () {
    originalTextView.isEditable = true
    translatedTextView.isEditable = false
    pickerLanguage.dataSource = self
    pickerLanguage.delegate = self
    pickerLanguageTwo.dataSource = self
    pickerLanguageTwo.delegate = self
    origineLanguageTextField.inputView = pickerLanguage
    reachLanguageTextField.inputView = pickerLanguageTwo
    pickerLanguage.backgroundColor = .gray
    pickerLanguageTwo.backgroundColor = .gray
  }
  
  override func viewDidLoad() {
    setup()
  }
  
  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  //----------------------------------------------------------------------------
  // MARK: - PickerView Setup
  //----------------------------------------------------------------------------
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return languageList.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return languageList[row].name
  }
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int,
                   inComponent component: Int) {
    if pickerView == pickerLanguage {
      origineLanguageTextField.text = languageList[row].name
    } else if pickerView == pickerLanguageTwo {
      reachLanguageTextField.text = languageList[row].name
    }
  }
  
  /// Collect the value of the dictionary for the the API call
  /// - Parameter picker: choice the picker view
  /// - Returns: return value of the language
  func choiceOfPickerView(picker: UIPickerView) -> String?{
    let indexPicker = picker.selectedRow(inComponent: 0)
    return languageList[indexPicker].value
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Convert Action
  //----------------------------------------------------------------------------
  
  /// Run API call with the order of user
  @IBAction func translateButton() {
    guard let value = originalTextView.text, !value.isEmpty else {
      showError(message: "Inserez ce que vous voulez traduire")
      return
    }
    guard let origineLanguage =
            choiceOfPickerView(picker: pickerLanguage) else {
      return
    }
    guard let reachLanguage =
            choiceOfPickerView(picker: pickerLanguageTwo) else {
      return
    }
    translateConverter.convert(source: origineLanguage,
                               target: reachLanguage,
                               originalText: value) {
      [weak self] (result, error) in
      DispatchQueue.main.async {
        self?.handleRateConversion(result: result, error: error)
      }
    }
    view.endEditing(true)
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------
  
  /// Manage error message and post the result of the translate on UI
  /// - Parameters:
  ///   - result: parameters of the closure convert
  ///   - error: specifie the error
  private func handleRateConversion(result: String?, error: Error?) {
    if let error = error as? TranslateConverter.TranslateConverterError {
      switch error {
      case .dataError:
        showError(message: "Erreur réseau")
      }
      return
    }
    guard let result = result else {
      showError(message : "Resultat introuvable")
      return
    }
    translatedTextView.text = result
  }
}


