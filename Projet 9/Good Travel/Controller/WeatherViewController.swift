//
//  WeatherViewController.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 19/01/2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,
                             AlertPresentable,
                             CLLocationManagerDelegate {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  var weatherConverter = WeatherConverter()

  @IBOutlet weak var temperatureLilleLabel: UILabel!
  @IBOutlet weak var descriptionLilleLabel: UILabel!
  @IBOutlet weak var temperatureNYLabel: UILabel!
  @IBOutlet weak var descriptionNYLabel: UILabel!
  @IBOutlet weak var geolocalisedLabel: UILabel!

  private(set) var locationManager: CLLocationManager?

  private(set) var latitudeSourceLocalisation: Double = 0
  private(set) var longitudeSourceLocalisation: Double  = 0

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    locationManager?.requestLocation()
  }

  private func setup() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    locationManager?.requestWhenInUseAuthorization()
  
  }

  //----------------------------------------------------------------------------
  // MARK: - API Action
  //----------------------------------------------------------------------------

  private func recuperateWeathers() {
    weatherConverter.getWeathers(sourceLocalisation: .init(
                                  longitude: longitudeSourceLocalisation,
                                  latitude: latitudeSourceLocalisation)) {
      [weak self] (result, error) in
      DispatchQueue.main.async {
        self?.handleInformationWeather(result: result, error: error)
      }
    }
  }

  //----------------------------------------------------------------------------
  // MARK: - Setup geolocation
  //----------------------------------------------------------------------------

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let isAbleToLocate = manager.authorizationStatus == .authorizedAlways
    || manager.authorizationStatus == .authorizedWhenInUse
    guard isAbleToLocate else {
      showError(message : "Données de geolocalistation introuvable.")
      return
    }
  }

  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    guard let geoLatitudeSourceLocalisation =
            locations.first?.coordinate.latitude else {
      return
    }
    guard let geoLongitudeSourceLocalisation =
            locations.first?.coordinate.longitude else {
      return
    }
    longitudeSourceLocalisation  = geoLongitudeSourceLocalisation
    latitudeSourceLocalisation = geoLatitudeSourceLocalisation
    recuperateWeathers()
  }

  func locationManager(_ manager: CLLocationManager,
                       didFailWithError error: Error) {
    print("Error location")
  }

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  /// Manage error message and post the result of the weather request on UI
  /// - Parameters:
  ///   - result: parameters of the closure convert
  ///   - error: specifie the error
  private func handleInformationWeather(
    result: WeatherConverter.WeatherConverterResult?, error: Error?) {
    if let error = error as? TranslateConverter.TranslateConverterError {
      switch error {
      case .dataError:
        showError(message: "Erreur réseau")
      }
      return
    }
    guard let descripitonOfDestination = result?.destination.description else {
      showError(message : "Resultat introuvable")
      return
    }
    guard let temperatureOfDestination = result?.destination.temperature else {
      showError(message : "Resultat introuvable")
      return
    }
    guard let descripitonOfSource = result?.source.description else {
      showError(message : "Resultat introuvable")
      return
    }
    guard let temperatureOfSource = result?.source.temperature else {
      showError(message : "Resultat introuvable")
      return
    }
    guard let name = result?.source.name else {
      showError(message : "Resultat introuvable")
      return
    }
    geolocalisedLabel.text = name
    temperatureLilleLabel.text = temperatureOfSource
    descriptionLilleLabel.text = descripitonOfSource
    temperatureNYLabel.text = temperatureOfDestination
    descriptionNYLabel.text = descripitonOfDestination
  }
}
