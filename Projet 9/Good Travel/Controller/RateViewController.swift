//
//  ViewController.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 08/12/2020.
//

import UIKit

class RateViewController: UIViewController,
                          AlertPresentable,
                          UIPickerViewDelegate,
                          UIPickerViewDataSource,
                          UITextFieldDelegate {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  var rateConverter = RateConverter()

  @IBOutlet weak var euroTextField: UITextField!
  @IBOutlet weak var sumTextField: UITextField!
  @IBOutlet weak var resultSumTextField: UITextField!
  @IBOutlet weak var deviseSelectedTextField: UITextField!
  let cuerrencyPickerView = UIPickerView()

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  /// Setup of the viewDidLoad
  func setup () {
    cuerrencyPickerView.delegate = self
    cuerrencyPickerView.dataSource = self
    deviseSelectedTextField.inputView = cuerrencyPickerView
    cuerrencyPickerView.backgroundColor = .gray
    deviseSelectedTextField.delegate = self
  }
  override func viewDidLoad() {
    super.viewDidLoad()
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
    return cuerrencyList.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return cuerrencyList[row].name
  }

  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int,
                   inComponent component: Int) {
    deviseSelectedTextField.text = cuerrencyList[row].name
  }

  /// Collect the value of the dictionary for the the API call
  /// - Parameter picker: choice the picker view
  /// - Returns: return value of the language
  func choiceOfPickerView(picker: UIPickerView) -> String?{
    let indexPicker = picker.selectedRow(inComponent: 0)
    return cuerrencyList[indexPicker].value
  }

  //----------------------------------------------------------------------------
  // MARK: - Convert Action
  //----------------------------------------------------------------------------

  /// Manage error, check condition and use handleRateConversion function
  @IBAction func convertAmount(_ sender: Any) {
    guard let value = sumTextField.text, !value.isEmpty else {
      showError(message: "Inserez une valeur")
      return
    }
    guard let resultCuerrency =
            choiceOfPickerView(picker: cuerrencyPickerView) else {
      showError(message: "Selectionne une devise de sortie")
      return
    }
    guard deviseSelectedTextField.text != "Choisis une monnaie" else {
      showError(message: "Choisis une monnaie")
      return
    }
    rateConverter.convert(euro: value, resultCuerrency: resultCuerrency) {
      [weak self] (result, error) in
      DispatchQueue.main.async {
        self?.handleRateConversion(result: result, error: error)
      }
    }
    view.endEditing(true)  }

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  /// Manage error message and post the result of the rate on UI
  /// - Parameters:
  ///   - result: parameters of the closure convert
  ///   - error: parameters of the closure convert
  private func handleRateConversion(result: String?, error: Error?) {
    if let error = error as? RateConverter.RateConterError {
      switch error {
      case .invalidEuro :
        showError(message: "Expression non valide")
      case .negativeExpression:
        showError(message: "Inserez une valeur positive")
      case .invalidRate:
        showError(message: "Erreur à la récupération des données")
      case.longExpression:
        showError(message: "Expression trop longue")
      case.invalidCuerrency:
        showError(message: "Erreur selection devise")
      }
      return
    }
    guard let result = result else {
      showError(message : "Resultat introuvable")
      return
    }
    resultSumTextField.text = result
  }
}

