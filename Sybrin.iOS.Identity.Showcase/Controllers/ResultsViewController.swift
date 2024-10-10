//
//  ResultsViewController.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Identity
//import Sybrin_iOS_Identity

class ResultsViewController: UIViewController {
    private var userData: [UserData] = []

    public var documentData: DocumentModel?
    public var driversLicenseData: DriversLicenseModel?
    public var greenBookData: GreenBookModel?
    public var idCardData: IDCardModel?
    public var passportData: PassportModel?
    public var dataType: DataType = .Unspecified
    public var countryIndex: Int = -1
    public var countries = Country.allCases

    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var documentFront: UIImageView!
    @IBOutlet weak var croppedPortrait: UIImageView!
    @IBOutlet weak var dataResponseTableView: UITableView!
    @IBOutlet weak var headerCustomNavView: UIView!

    @IBAction func dismissClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerCustomNavView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerCustomNavView.addSubview(blurEffectView)
        headerCustomNavView.sendSubviewToBack(blurEffectView)

        // Updating the country flag based on selected country
        countryFlag.image = UIImage(named: countries[countryIndex].fullName.lowercased()) ?? UIImage(named: "south africa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataResponseTableView.dataSource = self
        dataResponseTableView.delegate = self

        // Moving displayed data beneath the header at the top
        dataResponseTableView.contentInset = UIEdgeInsets(top: headerCustomNavView.frame.height, left: 0, bottom: 0, right: 0)
        dataResponseTableView.rowHeight = UITableView.automaticDimension
        dataResponseTableView.estimatedRowHeight = 130

        // Adding blur effect to header
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        headerCustomNavView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        // Loading the data into the table view
        loadData()
        //loadData()
    }

    private var counter: Int = 0

    private func loadData() {
        var stringData = [String: String]()
        var imageData = [String: UIImage]()
        var data: Any!
        
        switch dataType {
            case .Document: data = self.documentData
            case .DriversLicense: data = self.driversLicenseData
            case .IDCard: data = self.idCardData
            case .GreenBook: data = self.greenBookData
            case .Passport: data = self.passportData
            case .Unspecified: data = nil
        }
        
        if let data = data {
            
            DispatchQueue.main.async {
                
                Mirror.reflectProperties(of: data, reflectSuper: true) { (label, value) in
                    addData(label, value)
                }
                
                presentData()
                
                self.dataResponseTableView.reloadData()
            }
            
        }

        // Internal function method for selecting visible data
        func selectVisisbleData(_ propertyName: String, _ info: Any) -> Bool {

            if info is Bool {
                return false
            }

            if propertyName.lowercased().contains("path")
            {
                return false
            }

            if let data = info as? String {
                if data.count <= 0 {
                    return false
                }
            }

            return true
        }
        
        func addData(_ label: String, _ value: Any) {
            
            var typeFound = false
            
            if !typeFound, let value = value as? String {
                typeFound = true
                addString(label, value)
            }
            
            if !typeFound, let value = value as? Bool {
                typeFound = true
                addBool(label, value)
            }
            
            if !typeFound, let value = value as? Int {
                typeFound = true
                addInt(label, value)
            }
            
            if !typeFound, let value = value as? Double {
                typeFound = true
                addDouble(label, value)
            }
            
            if !typeFound, let value = value as? Float {
                typeFound = true
                addFloat(label, value)
            }
            
            if !typeFound, let value = value as? Date {
                typeFound = true
                addDate(label, value)
            }
            
            if !typeFound, let value = value as? UIImage {
                typeFound = true
                addImage(label, value)
            }
            
            if !typeFound, let value = value as? Mirror {
                typeFound = true
                for (index, child) in value.children.enumerated() {
                    addData("\(label): Item \(index+1)", child)
                }
            }
            
            if !typeFound, let value = value as? Array<Any> {
                typeFound = true
                for (index, item) in value.enumerated() {
                    addData("\(label): Item \(index+1)", item)
                }
            }
            
            if !typeFound, let pair = value as? Dictionary<String, Any> {
                typeFound = true
                for (key, value) in pair {
                    addData("\(label): \(key)", value)
                }
            }
            
            if !typeFound, let value = value as? CitizenshipType {
                addCitizenshipType(label, value)
            }

            if !typeFound, let value = value as? GreenBookType {
                addGreenBookType(label, value)
            }

            if !typeFound, let value = value as? Sex {
                addSex(label, value)
            }
            
            if !typeFound {
                Mirror.reflectProperties(of: value, reflectSuper: true) { (innerLabel, innerValue) in
                    addData("\(label)\((innerLabel != "some") ? ": \(innerLabel)" : "")", innerValue)
                }
            }
            
        }
        
        func presentData() {
            for (label, value) in stringData.sorted(by: { (arg0, arg1) -> Bool in
                let (firstKey, _) = arg0
                let (secondKey, _) = arg1
                
                return (firstKey < secondKey)
            }) {
                printString(label, value)
            }
            
            for (label, value) in imageData.sorted(by: { (arg0, arg1) -> Bool in
                let (firstKey, _) = arg0
                let (secondKey, _) = arg1
                
                return (firstKey > secondKey)
            }) {
                if croppedPortrait.image == nil && label.lowercased().contains("portrait image") {
                    croppedPortrait.image = value
                }
                printImage(label, value)
            }
        }
        
        func addString(_ label: String, _ value: String) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value))"
        }
        
        func addBool(_ label: String, _ value: Bool) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value))"
        }
        
        func addInt(_ label: String, _ value: Int) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value))"
        }
        
        func addDouble(_ label: String, _ value: Double) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value))"
        }
        
        func addFloat(_ label: String, _ value: Float) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value))"
        }
        
        func addDate(_ label: String, _ value: Date) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value.dateToString(withFormat: "yyyy-MM-dd")))"
        }
        
        func addCitizenshipType(_ label: String, _ value: CitizenshipType) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value.stringValue))"
        }
        
        func addGreenBookType(_ label: String, _ value: GreenBookType) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value.stringValue))"
        }
        
        func addSex(_ label: String, _ value: Sex) {
            stringData["\(label)".camelCaseToWords()] = "\(unwrap(value.stringValue))"
        }
        
        func addImage(_ label: String, _ value: UIImage) {
            imageData["\(label)".camelCaseToWords()] = value
        }
        
        func printString(_ label: String, _ value: String) {
            guard value.count > 0 else { return }
            
            // creating user data to append
            var info: UserData = UserData()

            print("\(#function) : \(label) = \(unwrap(value))")
            
            info = UserData(
                description: "\(label)".camelCaseToWords(),
                data: "\(unwrap(value))",
                placement: .Both
            )

            self.userData.append(info)
            self.counter += 1

            // Making sure that the line placements are in the correct location
            if self.counter == 1 {
                self.userData[0].linePlacement = .BottomOnly
            }
        }
        
        func printImage(_ label: String, _ value: UIImage) {
            // creating user data to append
            var info: UserData = UserData()

            print("\(#function) : \(label) = \(value)")
            
            info = UserData(
                description: "\(label)".camelCaseToWords(),
                placement: .Both,
                image: value
            )

            self.userData.append(info)
            self.counter += 1

            // Making sure that the line placements are in the correct location
            if self.counter == 1 {
                self.userData[0].linePlacement = .BottomOnly
            }
        }
        
        func unwrap<T>(_ any: T) -> Any {
            let mirror = Mirror(reflecting: any)
            guard mirror.displayStyle == .optional, let first = mirror.children.first else { return any }
            return first.value
        }
    }

    // -------------------------
    // MARK: - Styling overrides
    // -------------------------

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userData.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataResponseCell", for: indexPath) as! DisplayDataCell

        // Adding the data to the cell
        let uD = self.userData[indexPath.row]
        cell.title?.text = uD.description.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.info?.text = uD.data.trimmingCharacters(in: .whitespacesAndNewlines)

        if let image = uD.image {
            cell.capturedImage?.contentMode = .scaleAspectFit
            cell.capturedImage?.image = image
            cell.capturedImage.layoutIfNeeded()
            cell.capturedImage.setNeedsDisplay()
            cell.setNeedsDisplay()
            cell.setNeedsLayout()

        } else {
            cell.capturedImage.image = nil
            cell.capturedImage.layoutIfNeeded()
            cell.capturedImage.setNeedsDisplay()
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
        }

        self.dataResponseTableView.setNeedsDisplay()
        self.dataResponseTableView.updateConstraints()
        self.dataResponseTableView.layoutIfNeeded()
        self.updateViewConstraints()

        if indexPath.row == 0 && indexPath.section == 0 && uD.linePlacement == .BottomOnly {
            cell.addUIEnchancements(.BottomOnly)
        } else {
            cell.addUIEnchancements(.Both)
        }

        return cell
    }

}

class DisplayDataCell: UITableViewCell {
    var cellTitle: UILabel!
    var cellDescription: UILabel!

    // Layers for UI
    private var tline = CALayer()
    private let tName = "topLine"
    private var bline = CALayer()
    private let bName = "bottomLine"
    private var dot = CALayer()

    private var dotAdded: Bool = false
    private var linesAdded: Bool = false

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var heightConstantConstraint: NSLayoutConstraint!


    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth: Double = 2

        let x: Double = Double(dot.frame.maxX / 2) + (Double(dot.frame.width) / 2) + Double(lineWidth / 2)
        let y: Double = Double(dot.frame.maxY / 2) + (Double(dot.frame.height) / 2) + Double(lineWidth / 2)

        let lineHeight = Double(contentView.bounds.height)

        // Adding line to cell
        let bottomRect = CGRect(x: x, y: y, width: lineWidth, height: lineHeight)

        if let dView = dotView,
            let subLayers = dView.layer.sublayers {
            for line in subLayers {
                if let _ = self.capturedImage {

                    if line.name == bName {
                        line.frame = bottomRect
                    }

                    // Refreshing the view
                    dotView.layoutSubviews()
                    contentView.layoutSubviews()
                }
            }
        }
    }

    //
    public func addUIEnchancements(_ linePlacement: LinePlacement) {
        // Current Frame dimensions
        let frameWidth = Double(dotView.frame.width)
        let frameHeight = Double(dotView.frame.height)

        // Adding the dot
        if !self.dotAdded {
            self.dotAdded = true

            // Adding the dot to the cell
            let dotWidth: Double = 6
            let dotHeight: Double = 6

            let dotRect = CGRect(
                x: (frameWidth / 2),
                y: (frameHeight / 2),
                width: dotWidth,
                height: dotHeight)

            let dotCornerRadius: CGFloat = dotRect.width / 2
            dot.frame = dotRect
            dot.backgroundColor = UIColor(red: 0, green: 0, blue: 0.3, alpha: 1).cgColor
            dot.cornerRadius = dotCornerRadius

            dotView.layer.addSublayer(dot)
        }

        if !self.linesAdded {
            self.linesAdded = true
            let lineWidth: Double = 2

            let x: Double = Double(dot.frame.maxX / 2) + (Double(dot.frame.width) / 2) + Double(lineWidth / 2)
            let y: Double = Double(dot.frame.maxY / 2) + (Double(dot.frame.height) / 2) + Double(lineWidth / 2)

            let lineColour = UIColor(red: 0, green: 0, blue: 0.3, alpha: 0.1).cgColor
            let lineHeight = Double(contentView.bounds.height)

            // Adding line to cell
            let topRect = CGRect(x: x, y: (y - lineHeight), width: lineWidth, height: lineHeight)
            let bottomRect = CGRect(x: x, y: y, width: lineWidth, height: lineHeight)

            bline.frame = bottomRect
            bline.name = bName
            bline.backgroundColor = lineColour

            tline.frame = topRect
            tline.name = tName
            tline.backgroundColor = lineColour

            switch linePlacement {
            case .TopOnly:
                dotView.layer.addSublayer(tline)
                dotView.layer.addSublayer(bline)
            case .Both:
                dotView.layer.addSublayer(tline)
                dotView.layer.addSublayer(bline)
            case .BottomOnly:
                dotView.layer.addSublayer(bline)
                dotView.layer.addSublayer(tline)
            }
        }
    }

}

public enum LinePlacement {
    case TopOnly
    case Both
    case BottomOnly
}

public class UserData {
    var data: String
    var description: String
    var linePlacement: LinePlacement = .Both
    var image: UIImage?

    init() {
        self.data = ""
        self.description = ""
        linePlacement = .Both
    }

    init(description: String, data: String, placement: LinePlacement) {
        self.data = data
        self.description = description
        self.linePlacement = placement
    }

    init(description: String, placement: LinePlacement, image: UIImage) {
        self.description = description
        self.image = image
        self.data = ""
    }
}

// String extension to make CamelCased words split
extension String {

    func camelCaseToWords() -> String {

        return unicodeScalars.reduce("") {

            if CharacterSet.uppercaseLetters.contains($1) {

                return ($0 + " " + String($1))
            }
            else {

                return $0 + String($1)
            }
        }
    }
}

extension Mirror {
    func reflectProperties<T>(
        matchingType type: T.Type = T.self,
        recursively: Bool = false,
        reflectSuper: Bool = false,
        using closure: (String, T) -> Void
    ) {
        
        for child in self.children {
            if let label = child.label, let value = child.value as? T {
                closure(label, value)
                
                if recursively {
                    Mirror(reflecting: child.value).reflectProperties(matchingType: type, recursively: recursively, reflectSuper: reflectSuper, using: closure)
                }
                
            }
        }
        
        if reflectSuper, let superMirror = self.superclassMirror {
            superMirror.reflectProperties(matchingType: type, recursively: recursively, reflectSuper: reflectSuper, using: closure)
        }
    }
    
    static func reflectProperties<T>(
        of target: Any,
        matchingType type: T.Type = T.self,
        recursively: Bool = false,
        reflectSuper: Bool = false,
        using closure: (String, T) -> Void
    ) {
        Mirror(reflecting: target).reflectProperties(matchingType: type, recursively: recursively, reflectSuper: reflectSuper, using: closure)
    }
    
}
