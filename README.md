<p align="center">
    <img src="/image/seeso_logo.png">
</p>
<div align="center">
    <h1>SeeSo Demo SwiftUI </h1>
    <a href="https://github.com/visualcamp/seeso-sample-ios/releases" alt="release">
        <img src="https://img.shields.io/badge/version-2.4.3-blue" />
    </a>
</div>

## SeeSo
SeeSo is an AI based eye tracking SDK which uses image from RGB camera to track where the user is looking.
Extra hardware is not required and you can start your development for free.
In 2021, SeeSo was recognized for its innovative technology and won GLOMO Award for Best Mobile Innovation for Connected Living!
1. Supports multi-platform (iOS/Android/Unity/Windows/Web-JS)
2. Has simple and quick calibration (1-5 points)
3. Has high accuracy and robustness compared to its competitors.

## Documentation
* Overview: https://docs.seeso.io/docs/seeso-sdk-overview/
* Quick Start: https://docs.seeso.io/docs/ios-quick-start/
* API(Swift): https://docs.seeso.io/docs/ios-api-docs/
* API(Objective-C): https://docs.seeso.io/docs/objc-api-docs/

## Requirements
* SeeSo.framework : 2.5.0
* Swift: 5.5
* It must be run on a **real iOS device. (iOS 11.0 +, iPhone 6s +)**
* It must be an **internet environment.**
* [SeeSo iOS SDK](https://console.seeso.io/)
* Must be issued a license key in [SeeSo Console](https://console.seeso.io/)

## Setting License Key
* Get a license key from https://console.seeso.io and copy your key to [`SeeSoManager`](SeeSo-demo-swiftui/SeeSoManager.swift#L15)
   ```
   private let licenseKey : String = "Input your key." // Please enter the key value for development issued by the SeeSo.io
   ```

## How to run
1. Clone or download this project.
2. Add SeeSo.framework to the project as shown below. (At this time, "copy items if needed" should be checked.)

    ![images/_2020-06-11__3.32.25.png](image/ios/1.png)

    2-1 

    ![images/_2020-06-11__3.32.39.png](image/ios/2.png)

    2-2

    ![images/_2020-06-11__3.33.44.png](image/ios/3.png)

    2-3

3. Now change the SeeSo.framework to sign & embed as shown below.

    ![images/_2020-06-11__3.33.21.png](image/ios/4.png)

    3-1

4. Sign in with your developer ID in the Signing & Capabilities tab.

      
## Contact Us
If you have any problems, feel free to [contact us](https://seeso.io/Contact-Us) 
