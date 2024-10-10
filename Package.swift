// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Sybrin_iOS_Identity", // Your package name
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14) // Make sure to include this to specify the platform (adjust the version as necessary)
    ],
    products: [
        .library(
            name: "Sybrin_iOS_Identity",
            targets: ["Sybrin_iOS_Identity"]),
    ],
    dependencies: [
        //.package(path: "/Users/rndhlovu/Documents/Projects/Sybrin.iOS.SDK.Common"),
        .package(url: "https://github.com/d-date/google-mlkit-swiftpm", from: "3.2.0"),
        .package(url: "https://github.com/SybrinDevOps/SybrinCommon", branch: "5.2.25")
    ],
    targets: [
        .target(
            name: "Sybrin_iOS_Identity",
            dependencies: [
                .product(name: "Sybrin_iOS_Common", package: "SybrinCommon"),
                // .product(name: "SybrinCommon", package: "SybrinCommon"),
                .product(name: "MLKitFaceDetection", package: "google-mlkit-swiftpm"),
                // .product(name: "MLKitVision", package: "google-mlkit-swiftpm"),
                .product(name: "MLKitBarcodeScanning", package: "google-mlkit-swiftpm")
                ],
            path: "Sources/Sybrin.iOS.Identity",  // Path to your sources
            exclude: [/*"Supporting Files/Info.plist"*/
            // "Countries/Angola",
            // "Countries/Bangladesh/*",
            // "Countries/Botswana/**",
            // "Countries/Democratic Republic of the Congo",
            // "Countries/Egypt",
            // "Countries/Ethiopia",
            // "Countries/Ghana",
            // "Countries/Kenya",
            // "Countries/Lesotho",
            // "Countries/Malawi",
            // "Countries/Mauritius",
            // "Countries/Mozambique",
            // "Countries/Namibia",
            // "Countries/Pakistan",
            // "Countries/Somalia",
            // "Countries/Tanzania",
            // "Countries/Uganda",
            // "Countries/United Kingdom",
            // "Countries/Zambia",
            // "Countries/Zimbabwe"
            ],  // Exclude any unnecessary files
            sources: [
                // "Extensions/CGRect.swift", 
                // "Extensions/Date.swift",
                // "Extensions/String.swift",
                // "Extensions/StringProtocol.swift",
                // "Extensions/UIColor.swift",
                // "Extensions/UIImage.swift",

                // "UI/IdentityUI.swift",
                // "Models/SybrinIdentityConfiguration.swift",
                // "Models/Base Models/DocumentModel.swift",
                // "Models/Base Models/DriversLicenseModel.swift",
                // "Models/Base Models/GreenBookModel.swift",
                // "Models/Base Models/IDCardModel.swift",
                // "Models/Base Models/PassportModel.swift",
                // "Handlers/SybrinIdentity.swift",
                // "Enums/Document.swift",
                // "Enums/Country.swift",
                // "Enums/CutOutType.swift"

                "Controllers",
                "Extensions",
                "Countries",
                "CropImageClasses",
                "Enums",
                "Handlers",
                "Models",
                "Parsers",
                "Protocols",
                "Scan Plan",
                "UI"
                ],
            
            resources: [
                .process("stories/Base.lproj/SybrinIdentity.storyboard"),  // Include the storyboard here
                //.process("Controllers/Base.lproj") 
                // .process("Supporting Files/Media.xcassets"),
                // .process("Supporting Files/Sybrin_iOS_Identity.h"),
                //.process("Info.plist"),
                // .process("Controllers/Base.lproj/SybrinIdentity.storyboard")
            ],  // Add resources if necessary (like assets or storyboards)
            publicHeadersPath: "Supporting Files",
            linkerSettings: []),
    ]
)
