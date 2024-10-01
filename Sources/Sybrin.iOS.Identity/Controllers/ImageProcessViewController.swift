//
//  ImageCropViewController.swift
//  Sybrin.iOS.DocumentScanner
//
//  
//
import UIKit
import AVFoundation

/// The `EditScanViewController` offers an interface for the user to edit the detected rectangle.
final class ImageProcessViewController: UIViewController, UIAdaptivePresentationControllerDelegate, ScanPlanDelegate {
    
    public final var ImageProccessSuccessCallback: imageProcessCompletion?
    public final var ImageProcessErrorCallback: imageProcessError?
    
    public typealias imageProcessCompletion = (UIImage, UIImage) -> ()
    public typealias imageProcessError = (String) -> ()
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = origialImage
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var rectView: RectangleView = {
        let rectView = RectangleView()
        rectView.editable = true
        rectView.translatesAutoresizingMaskIntoConstraints = false
        return rectView
    }()
    
    lazy private var nextButton: UIBarButtonItem = {
        let title = NSLocalizedString("mbdoccapture.next_button", tableName: nil, bundle: bundle(), value: "Next", comment: "")
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(pushReviewController))
        button.tintColor = .white
        return button
    }()
    
    lazy private var cancelButton: UIBarButtonItem = {
        let title = NSLocalizedString("mbdoccapture.cancel_button", tableName: nil, bundle: bundle(), value: "Cancel", comment: "")
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(dismissEditScanViewControllerController))
        if #available(iOS 13.0, *) {
            button.tintColor = .systemBlue
        } else {
            // Fallback on earlier versions
            button.tintColor = .systemBlue
        }

        return button
    }()
    
    /// The image the rectangle was detected on.
    private let origialImage: UIImage
    
    /// The detected rectangle that can be edited by the user. Uses the image's coordinates.
    private var rect: Rectangle
    
    private var zoomGestureController: ZoomGestureController!
    
    private var rectViewWidthConstraint = NSLayoutConstraint()
    private var rectViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(image: UIImage, rect: Rectangle?, rotateImage: Bool = true, completion: imageProcessCompletion? = nil, error: imageProcessError? = nil) {
        self.ImageProccessSuccessCallback = completion
        self.ImageProcessErrorCallback = error
        
        self.origialImage = rotateImage ? image.applyingPortraitOrientation() : image
        self.rect = rect ?? EditScanViewController.defaultRectangle(forImage: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildDoneButton() -> UIButton{
        let doneButton = UIButton()
        doneButton.backgroundColor = UIColor.systemBlue
        doneButton.setTitle("Done", for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.addTarget(self, action: #selector(self.pushReviewController), for: .touchUpInside)
        
        doneButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.75).isActive = true
        doneButton.layer.cornerRadius = 10
        doneButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return doneButton
    }
    
    func buildResetButton() -> UIButton{
        let doneButton = UIButton()
        doneButton.backgroundColor = UIColor.white
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.setTitle("Reset", for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.addTarget(self, action: #selector(self.resetImage), for: .touchUpInside)
        
        doneButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.25).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.07).isActive = true
        
        return doneButton
    }
    
    func buildBlackAndWhiteButton() -> UIButton{
        let doneButton = UIButton(type: .custom)
        doneButton.backgroundColor = UIColor.white
        let icon = UIImage(named: "circle.righthalf.filled",in: Bundle(identifier: "com.sybrin.Sybrin-iOS-DocumentScanner"), compatibleWith: nil)
        doneButton.tintColor = .black

        doneButton.setImage(icon, for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.addTarget(self, action: #selector(self.applyGrayScaleFilter), for: .touchUpInside)
        
         let buttonSize = view.frame.width * 0.1
        
        doneButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        return doneButton
    }
    
    func buildRotateButton() -> UIButton{
        let doneButton = UIButton(type: .custom)
        doneButton.backgroundColor = UIColor.white
        let icon = UIImage(named: "rotate.right",in: Bundle(identifier: "com.sybrin.Sybrin-iOS-DocumentScanner"), compatibleWith: nil)
        doneButton.tintColor = .black

        doneButton.setImage(icon, for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.addTarget(self, action: #selector(self.rotateImage), for: .touchUpInside)
        
         let buttonSize = view.frame.width * 0.1
        
        doneButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        return doneButton
    }
    
    var rotationAmount = 0.0
    
    @objc private func rotateImage(){
        let rotationIncrement = 90.0
        
        self.rotationAmount += rotationIncrement
        
        self.imageView.rotate(angle: rotationIncrement)
        self.rectView.rotate(angle: rotationIncrement)
    }
    
    @objc private func resetImage(){
        self.imageView.image = self.origialImage
        self.imageView.rotate(angle: -rotationAmount)
        self.rectView.rotate(angle: -rotationAmount)
        self.rotationAmount = 0
    }
    
    @objc private func applyGrayScaleFilter(){
        self.imageView.image = self.imageView.image?.convertToGrayScale() ?? UIImage()
    }
    
    private func buildButtonBar() -> UIStackView{
        let horizontalButtonStackView   = UIStackView()
              horizontalButtonStackView.axis  = NSLayoutConstraint.Axis.horizontal
              horizontalButtonStackView.distribution  = UIStackView.Distribution.fill
              horizontalButtonStackView.alignment = UIStackView.Alignment.center
        horizontalButtonStackView.spacing = 20
        
        horizontalButtonStackView.addArrangedSubview(buildBlackAndWhiteButton())
        horizontalButtonStackView.addArrangedSubview(buildResetButton())
        horizontalButtonStackView.addArrangedSubview(buildRotateButton())
        
        return horizontalButtonStackView
    }

    
    func assembleViewAndButtonStack(){
        let buttonMarginSpacing : CGFloat = 15.0
        let viewStackHorizontalPadding : CGFloat = 20.0
        
        //Stack View
        let verticleStackView   = UIStackView()
        verticleStackView.axis  = NSLayoutConstraint.Axis.vertical
        verticleStackView.distribution  = UIStackView.Distribution.fill
        verticleStackView.alignment = UIStackView.Alignment.center
        verticleStackView.layoutMargins = UIEdgeInsets(top: 0, left: viewStackHorizontalPadding, bottom: buttonMarginSpacing, right: viewStackHorizontalPadding)
        verticleStackView.isLayoutMarginsRelativeArrangement = true
        verticleStackView.spacing = buttonMarginSpacing
        
        verticleStackView.addArrangedSubview(buildButtonBar())

        verticleStackView.addArrangedSubview(imageView)
        verticleStackView.addSubview(rectView)
//
//        let horizontalButtonStackView   = UIStackView()
//        horizontalButtonStackView.axis  = NSLayoutConstraint.Axis.horizontal
//        horizontalButtonStackView.distribution  = UIStackView.Distribution.fill
//        horizontalButtonStackView.alignment = UIStackView.Alignment.center
//
        let button: UIButton = buildDoneButton()
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        verticleStackView.addArrangedSubview(button)
        
//        verticleStackView.addArrangedSubview(horizontalButtonStackView)

        verticleStackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(verticleStackView)

        //Constraints
        verticleStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        verticleStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Edit Document"
        self.view.backgroundColor = .white
//        setupViews()
        assembleViewAndButtonStack()
        setupConstraints()
        
//        self.navigationController?.navigationBar.topItem?.title = "Title"
//        self.navigationController?.navigationBar.backgroundColor = .white
//
//        let navItem = UINavigationItem(title: "SomeTitle")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action:nil)
//        navItem.leftBarButtonItem = doneItem
//
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        
        
//        self.title = NSLocalizedString("mbdoccapture.scan_edit_title", tableName: nil, bundle: bundle(), value: "Trimming", comment: "")
//        self.navigationItem.rightBarButtonItem = nextButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
//
//        if #available(iOS 13.0, *) {
//            isModalInPresentation = false
//            navigationController?.presentationController?.delegate = self
//        }
        
        zoomGestureController = ZoomGestureController(image: self.origialImage, rectView: rectView)
        
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        rectView.addGestureRecognizer(touchDown)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustRectViewConstraints()
        displayRect()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
//        navigationController?.navigationBar.tintAdjustmentMode = .normal
//        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(rectView)
    }
    
    private func setupConstraints() {
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (self.navigationController?.navigationBar.frame.height) ?? 25 + UIApplication.shared.statusBarFrame.height),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 120),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
//        rectViewWidthConstraint = rectView.widthAnchor.constraint(equalToConstant: 0.0)
//
//        let rectViewConstraints = [
//            rectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height),
//            rectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            view.bottomAnchor.constraint(equalTo: rectView.bottomAnchor, constant: 70),
//            view.leadingAnchor.constraint(equalTo: rectView.leadingAnchor),
//            rectView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
//        ]
        
        rectViewWidthConstraint = rectView.widthAnchor.constraint(equalToConstant: 0.0)
        rectViewHeightConstraint = rectView.heightAnchor.constraint(equalToConstant: 0.0)

        let rectViewConstraints = [
            rectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (self.navigationController?.navigationBar.frame.height) ?? 25 + UIApplication.shared.statusBarFrame.height),
            rectViewWidthConstraint,
            rectViewHeightConstraint
        ]
        
        
        NSLayoutConstraint.activate(rectViewConstraints + imageViewConstraints)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    // MARK: - Actions
    
    @objc func dismissEditScanViewControllerController() {
        
        if Constants.isfromGallery == true {
            dismiss(animated: true)
        } else {
            Constants.isfromGallery = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func pushReviewController() {
        guard let customOriginalImage = self.imageView.image else {
            return
        }
        
        guard let rect = rectView.rect,
              let ciImage = CIImage(image: customOriginalImage) else {
                  if let imageScannerController = navigationController as? ImageScannerController {
                      let error = ImageScannerControllerError.ciImageCreation
                      imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
                  }
                  return
              }
        
        let scaledRect = rect.scale(rectView.bounds.size, origialImage.size)
        self.rect = scaledRect
        
        var cartesianScaledRect = scaledRect.toCartesian(withHeight: origialImage.size.height)
        cartesianScaledRect.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledRect.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledRect.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledRect.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledRect.topRight)
        ])
        
//        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
        
        var uiImage: UIImage!
        
        // Let's try to generate the CGImage from the CIImage before creating a UIImage.
        if let cgImage = CIContext(options: nil).createCGImage(filteredImage, from: filteredImage.extent) {
            uiImage = UIImage(cgImage: cgImage)
        } else {
            uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        }
        
        let croppedAndDeskewedImage = uiImage.withFixedOrientation()
        
        let imageRotationRadians = self.rotationAmount * .pi / 180
        
        guard let rotatedCroppedAndDeskewedImage = croppedAndDeskewedImage.rotate(radians: Float(imageRotationRadians)) else {return}
        
        guard let successCallbakc = self.ImageProccessSuccessCallback else {
            return
        }
        
        successCallbakc(self.origialImage, rotatedCroppedAndDeskewedImage)
        self.dismiss(animated: true, completion: nil)
        
//        let results = ImageScannerResults(originalImage: image, scannedImage: finalImage, enhancedImage: enhancedImage, doesUserPreferEnhancedImage: false, detectedRectangle: scaledRect)
//
//
//        NetworkCallHandler.sybrinAddressExtraction(image: finalImage) { [weak self] (result) in
//            guard let self = self else { return }
//
//            switch result {
//                case .success(let model):
//
//                    DispatchQueue.main.async {
//                        let navigationController = UINavigationController()
//
//                        let confirmationViewController = ImageConfirmationViewContrller(image: finalImage)
//
//                        confirmationViewController.modalPresentationStyle = .fullScreen
//                        navigationController.pushViewController(confirmationViewController, animated: true)
//                    }
//
//
////                    guard let callback = self.ImageProccessSuccessCallback else {return}
////
////                    callback(finalImage)
//
//                case .failure(let error):
//                    "Failure sybrin address extraction response".log(.ProtectedError)
//                    "Error: \(error.message)".log(.Verbose)
////                    completion(.failure(.LivenessFailed))
//            }
//        }
//
//
//        let reviewViewController = ReviewViewController(results: results)
        
        
//        self.present(reviewViewController, animated: true, completion: nil)
    }
    
    private func displayRect() {
        let imageSize = origialImage.size
        let imageFrame = CGRect(origin: rectView.frame.origin, size: CGSize(width: rectViewWidthConstraint.constant, height: rectViewHeightConstraint.constant))
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedRect = rect.applyTransforms(transforms)
        
        rectView.drawRectangle(rect: transformedRect, animated: false)
    }
    
    /// The rectView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints to make sure that the rectView is on top of the displayed image.
    private func adjustRectViewConstraints() {
        let frame = AVMakeRect(aspectRatio: origialImage.size, insideRect: imageView.bounds)
        rectViewWidthConstraint.constant = frame.size.width
        rectViewHeightConstraint.constant = frame.size.height
    }
    
    /// Generates a `Rectangle` object that's centered and one third of the size of the passed in image.
    private static func defaultRectangle(forImage image: UIImage) -> Rectangle {
        let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
        let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
        let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        
        let rect = Rectangle(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return rect
    }
}

extension ImageProcessViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

