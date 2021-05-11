// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "jamiejenkinscom",
    products: [
        .executable(name: "jamiejenkinscom", targets: ["jamiejenkinscom"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "jamiejenkinscom",
            dependencies: ["Publish"]
        )
    ]
)
