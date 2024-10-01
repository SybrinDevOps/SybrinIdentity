//
//  LandingPageViewController.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    // MARK: Private Properties
    private var mainThemeColour: UIColor = UIColor(red: (50 / 255), green: (50 / 255), blue: (80 / 255), alpha: 1)

    private var countries = Country.allCases
    private var selectedCountryIndex: Int = Country.allCases.firstIndex(of: .SouthAfrica) ?? 0
// I don't know why, but when you uncomment the line below, the app will crash. Instead of storing the actual selected country, the line above stores the index of the selected country and can be used in the countries variable to access the selected country instead.
//    private var selectedCountry: Country? = .SouthAfrica
    private var selectedCountryFlag: UIImage = UIImage(named: "south africa")!

    // Data result variable
    private var dataType: DataType = .Unspecified
    private var documentData: DocumentModel?
    private var driversLicenseData: DriversLicenseModel?
    private var greenBookData: GreenBookModel?
    private var idCardData: IDCardModel?
    private var passportData: PassportModel?

    private var currentButtonTitle: String = ""
    private var pressedButton: SybrinButton!
    
    var selectedDocument: Document? = nil
    private var pickDocumentViewController: UIViewController!
    private var countrySelectionView: CountrySelectionController!
    
    private var availableDocuments: [Document] = Document.allCases

    // Buttons and IBOutlets on the landing screen
    @IBOutlet weak var documentButton: SybrinButton!
    @IBOutlet weak var driversLicenseButton: SybrinButton!
    @IBOutlet weak var greenBookButton: SybrinButton!
    @IBOutlet weak var smartIDButton: SybrinButton!
    @IBOutlet weak var passportButton: SybrinButton!
    @IBOutlet weak var countrySelectionButton: UIButton!
    @IBOutlet weak var pulseView: UIView!
    @IBOutlet weak var sybBackgroundImage: UIImageView!

    @IBAction func countrySelectionPressed(_ sender: UIButton) {
        // Setting the image of the last selected country
        countrySelectionView.viewTapped()
        countrySelectionButton.imageView?.image = selectedCountryFlag
        countrySelectionButton.setImage(selectedCountryFlag, for: .normal)

        // Reseting the list
        countries = Country.allCases
        countrySelectionView.countrySelectionTableView.reloadData()
        countrySelectionView.searchTextField.text = ""
    }

    @IBAction func buttonClicked(_ sender: UIButton) {

        switch sender.tag {
            case 0:
                //Document
                self.diplayLoaderOnButton(sender as! SybrinButton)
                resetPickDocumentPickerView()
                
                let editRadiusAlert = UIAlertController(title: "Choose a document", message: "", preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(pickDocumentViewController, forKey: "contentViewController")
                
                editRadiusAlert.addAction(UIAlertAction(title: "Scan", style: .default, handler: { [unowned self] action in
                    guard let document = self.selectedDocument else { return }
                    
                    DispatchQueue.main.async {
                        SybrinIdentity.shared.scanDocument(on: self, for: document, cutOutType: CutOutType.A4_LANDSCAPE, hasBackSide: HasBackSide.FALSE) { (result, message) in
                            self.reInitButton(sender as! SybrinButton)
                            if result {
                                print("Successfully launched Document Scan for \(document.name)")
                            } else {
                                guard let message = message else { return }
                                print("Failed to launch Document Scan for \(document.name): \(message)")
                            }
                        } success: { model in
                            print("Document scan success for \(document.name)")
                            self.documentData = model
                            self.dataType = .Document

                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "showResult", sender: nil)
                            }
                        } failure: { message in
                            print("Document scan failed for \(document.name): \(message)")
                        } cancel: {
                            print("Document scan canceled for \(document.name)")
                        }
                    }
                }))
                
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] action in
                    self.reInitButton(sender as! SybrinButton)
                }))
                
                self.present(editRadiusAlert, animated: true)
            case 1:
                //Drivers License
                self.diplayLoaderOnButton(sender as! SybrinButton)
                DispatchQueue.main.async {
                    SybrinIdentity.shared.scanDriversLicense(on: self, for: self.countries[self.selectedCountryIndex]) { (result, message) in
                        self.reInitButton(sender as! SybrinButton)
                        if result {
                            print("Successfully launched Drivers License Scan")
                        } else {
                            guard let message = message else { return }
                            print("Failed to launch Drivers License Scan: \(message)")
                        }
                    } success: { model in
                        print("Drivers License scan success")
                        self.driversLicenseData = model
                        self.dataType = .DriversLicense
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showResult", sender: nil)
                        }
                    } failure: { message in
                        print("Drivers License scan failed: \(message)")
                    } cancel: {
                        print("Drivers License scan canceled")
                    }
                }
            case 2:
                //Green Book
                self.diplayLoaderOnButton(sender as! SybrinButton)
                DispatchQueue.main.async {
                    SybrinIdentity.shared.scanGreenBook(on: self) { (result, message) in
                        self.reInitButton(sender as! SybrinButton)
                        if result {
                            print("Successfully launched Green Book Scan")
                        } else {
                            guard let message = message else { return }
                            print("Failed to launch Green Book Scan: \(message)")
                        }
                    } success: { model in
                        print("Green Book scan success")
                        self.greenBookData = model
                        self.dataType = .GreenBook
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showResult", sender: nil)
                        }
                    } failure: { message in
                        print("Green Book scan failed: \(message)")
                    } cancel: {
                        print("Green Book scan canceled")
                    }
                }
            case 3:
                //ID Card
                self.diplayLoaderOnButton(sender as! SybrinButton)
                DispatchQueue.main.async {
                    SybrinIdentity.shared.scanIDCard(on: self, for: self.countries[self.selectedCountryIndex]) { (result, message) in
                        self.reInitButton(sender as! SybrinButton)
                        if result {
                            print("Successfully launched ID Card Scan")
                        } else {
                            guard let message = message else { return }
                            print("Failed to launch ID Card Scan: \(message)")
                        }
                    } success: { model in
                        print("ID Card scan success")
                        self.idCardData = model
                        self.dataType = .IDCard
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showResult", sender: nil)
                        }
                    } failure: { message in
                        print("ID Card scan failed: \(message)")
                    } cancel: {
                        print("ID Card scan canceled")
                    }
                }
            case 4:
                //Passport
                self.diplayLoaderOnButton(sender as! SybrinButton)
                DispatchQueue.main.async {
                    SybrinIdentity.shared.scanPassport(on: self, for: self.countries[self.selectedCountryIndex]) { (result, message) in
                        self.reInitButton(sender as! SybrinButton)
                        if result {
                            print("Successfully launched Passport Scan")
                        } else {
                            guard let message = message else { return }
                            print("Failed to launch Passport Scan: \(message)")
                        }
                    } success: { model in
                        print("Passport scan success")
                        self.passportData = model
                        self.dataType = .Passport
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showResult", sender: nil)
                        }
                    } failure: { message in
                        print("Passport scan failed: \(message)")
                    } cancel: {
                        print("Passport scan canceled")
                    }
                }
            default:
                self.dataType = .Unspecified
                self.documentData = nil
                self.driversLicenseData = nil
                self.greenBookData = nil
                self.idCardData = nil
                self.passportData = nil
                break
        }
    }

    private func diplayLoaderOnButton(_ button: SybrinButton) {
        if let title = button.titleLabel?.text {
            currentButtonTitle = title
            pressedButton = button
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.hidesWhenStopped = false
            activityIndicator.color = .white
            activityIndicator.center = CGPoint(x: button.frame.width / 2, y: button.frame.height / 2)
            activityIndicator.startAnimating()
            activityIndicator.tag = 453

            DispatchQueue.main.async(execute: {
                button.setTitle("", for: .normal)
                button.backgroundView.addSubview(activityIndicator)
                button.bringSubviewToFront(activityIndicator)

                UIView.animate(withDuration: TimeInterval(exactly: 0.900)!,
                               delay: TimeInterval(exactly: 0)!,
                               options: [.repeat, .curveEaseInOut, .autoreverse],
                               animations: {
                                UIView.setAnimationRepeatCount(.infinity)
                                button.backgroundView.backgroundColor = .white
                                activityIndicator.color = .black
                }) { (completed) in

                }
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let btn = pressedButton {
            btn.setTitle("\(currentButtonTitle)", for: .normal)
            btn.backgroundView.viewWithTag(453)?.removeFromSuperview()
            btn.backgroundView.backgroundColor = btn.backgroundColour
        }

        countrySelectionView = CountrySelectionController(self)
        countrySelectionView.layoutPopUpSearch()

        super.viewWillAppear(animated)
    }

    private func reInitButton(_ button: SybrinButton) {
        button.setTitle("\(currentButtonTitle)", for: .normal)
        button.backgroundView.viewWithTag(453)?.removeFromSuperview()
        button.backgroundView.backgroundColor = button.backgroundColour
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        styleCountrySelectionButton()
        addPulseUnderButton()
        initializePickDocumentViewController()

        // Blending the background colour
        self.blendBackgroundImage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultsViewController
        destinationVC.dataType = self.dataType
        destinationVC.documentData = self.documentData
        destinationVC.driversLicenseData = self.driversLicenseData
        destinationVC.greenBookData = self.greenBookData
        destinationVC.idCardData = self.idCardData
        destinationVC.passportData = self.passportData
        destinationVC.countryIndex = self.selectedCountryIndex
    }

    // -------------------------
    // MARK: - Styling overrides
    // -------------------------

    // TODO: - Optimize this and move to seperate extensions framework
    private func blendBackgroundImage() {
        //        DispatchQueue.main.async{
        let currentBG = self.sybBackgroundImage.image
        let bgColour = self.mainThemeColour

        let imageWidth = currentBG?.size.width ?? 0.0
        let imageHeight = currentBG?.size.height ?? 0.0

        let bgRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)

        self.sybBackgroundImage.image = currentBG?.blendWithGradientAndRect(
            blendMode: .multiply,
            colors: [bgColour],
            locations: [1, 0],
            horizontal: true,
            alpha: 1,
            rect: bgRect)
        //        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func styleCountrySelectionButton() {
        countrySelectionButton.layer.borderColor = UIColor.white.cgColor
        countrySelectionButton.layer.borderWidth = 2
        countrySelectionButton.clipsToBounds = true
        countrySelectionButton.layer.cornerRadius = countrySelectionButton.frame.width / 2
        countrySelectionButton.isUserInteractionEnabled = true
    }

    private func addPulseUnderButton() {
        pulseView.layer.cornerRadius = pulseView.frame.width / 2
        pulseView.clipsToBounds = true
        pulseView.backgroundColor = .white

        UIView.animate(withDuration: TimeInterval(exactly: 1)!, delay: 0, options: [.repeat, .curveEaseIn, .allowUserInteraction], animations: {
            self.pulseView.alpha = 0.0
            self.pulseView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }, completion: nil)
    }
    
    private func initializePickDocumentViewController() {
        pickDocumentViewController = UIViewController()
        pickDocumentViewController.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickDocumentViewController.view.addSubview(pickerView)
    }
    
    private func resetPickDocumentPickerView() {
        if let pickview = pickDocumentViewController.view.subview(where: { view in
            return (view is UIPickerView)
        }) as? UIPickerView {
            self.selectedDocument = availableDocuments[0]
            pickview.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
}

// Table view for showing the countries on the screen
extension LandingPageViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountryIndex = indexPath.row
        
        selectedCountryFlag = UIImage(named: countries[selectedCountryIndex].fullName.lowercased()) ?? UIImage(named: "south africa")!

        countrySelectionView.searchTextField.resignFirstResponder()

        DispatchQueue.main.async {
            self.countrySelectionButton.imageView?.image = self.selectedCountryFlag
            self.countrySelectionView.viewTapped()
        }

        // Enabling and disabling buttons based on options
        self.documentButton.isEnabled = availableDocuments.count > 0
        self.driversLicenseButton.isEnabled = countries[selectedCountryIndex].supportedDocuments.contains(.DriversLicense)
        self.greenBookButton.isEnabled = countries[selectedCountryIndex] == .SouthAfrica
        self.smartIDButton.isEnabled = countries[selectedCountryIndex].supportedDocuments.contains(.IDCard)
        self.passportButton.isEnabled = countries[selectedCountryIndex].supportedDocuments.contains(.Passport)

        updateButtonStatus(self.documentButton)
        updateButtonStatus(self.driversLicenseButton)
        updateButtonStatus(self.greenBookButton)
        updateButtonStatus(self.smartIDButton)
        updateButtonStatus(self.passportButton)

        // Notifying the users that they need to contact sybrin
        if !self.smartIDButton.isEnabled  && !self.passportButton.isEnabled && !self.greenBookButton.isEnabled {
            ToastHandler.show(message: "Scanning for \(countries[selectedCountryIndex].fullName) is not supported, please contact Sybrin for more details", view: self.view)
        }

        if let pulseView = view.viewWithTag(552) {
            pulseView.removeFromSuperview()
        }
    }

    private func updateButtonStatus(_ button: SybrinButton) {
        if !button.isEnabled {
            button.updateButtonColours(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), backgroundColour: UIColor(red: 1, green: 1, blue: 1, alpha: 0.05))
        } else {

            DispatchQueue.main.async {
                button.animateTouchedBGColor() { _ in
                    button.initBGColor()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)

        cell.textLabel?.text = countries[indexPath.row].fullName

        return cell
    }

}


extension LandingPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let txtAfterUpdate = text.replacingCharacters(in: range, with: string)

        updateCountryList(txtAfterUpdate)

        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {

                if txtAfterUpdate.count > 0 {
                    updateCountryList(txtAfterUpdate)
                } else {
                    countries = Country.allCases
                }
            }
        }

        countrySelectionView.countrySelectionTableView.reloadData()

        return true
    }

    func updateCountryList(_ typedCountryName: String) {
        self.countries = countries.filter { $0.fullName.lowercased().contains(String(typedCountryName.lowercased())) }
    }
}

extension LandingPageViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableDocuments.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableDocuments[row].name
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedDocument = availableDocuments[row]
    }
}
