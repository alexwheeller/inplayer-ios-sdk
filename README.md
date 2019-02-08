<h1 align="center">
  <a target="_blank" href="https://inplayer-org.github.io/inplayer-ios-sdk/">
    <img src="https://assets.inplayer.com/images/inplayer-256.png" alt="inplayer-ios-sdk" title="InPlayer iOS SDK" width="300">
    <br />
    <span style="font-size: 1.5rem; color: blue">InPlayer's iOS SDK</span>
  </a>
</h1>
<p align="center" style="font-size: 1.2rem;">InPlayer's iOS API Client Wrapper</p>

## Requirements

 * iOS 10.0+
 * Xcode 10.1+
 * Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

    $ gem install cocoapods

To integrate InPlayerSDK into your Xcode project using CocoaPods, specify it in your `Podfile`

    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '10.0'

    target '<Your Target name>' do
        use_frameworks!
        pod 'InPlayerSDK'
    end

Then, run the following command:

    $ pod install

**Note**: InPlayerSDK is build with submodules. So if you like you can call it like this in your Podfile:

    pod 'InPlayerSDK/Core' (all features, default)
    pod 'InPlayerSDK/Payment' (includes Core and Payment modules)
    pod 'InPlayerSDK/Notification' (includes Core and Notification modules)

### Dependencies

This SDK has dependencies that it relies on. The list consists of:

     pod 'Alamofire', '5.0.0.beta.1'
     pod 'AWSIoT', '2.8.4' (only Notifications module)

## Usage

 Import `InPlayerSDK` to your file.

### Configuration

To intialize SDK and start using it, you must first do the following steps:

Create configuration object:

     let configuration = InPlayer.Configuration(clientId: "<YOUR CLIENT ID HERE>", referrer: "<REFERRER URL GOES HERE>" environment: <ENVIORMENT TYPE>)

Initialize InPlayer:

    InPlayer.initialize(configuration: configuration)

### Services

InPlayerSDK consists out of four services:
`Account`, `Asset`, `Payment` and `Notification`.

##### Account
Account related methods.

###### Example
Authenticate method:

    InPlayer.Account.authenticate(username: "<YOUR USERNAME>", password: "<YOUR PASSWORD>", success: { (authorization) in
        // Successfully logged in.
    }, failure: { (error) in
        // Some error occured.
    })

##### Asset
Asset related methods:

###### Example
Get asset details:

    InPlayer.Asset.getAsset(id: <ITEM_ ID>, success: { (item) in
       // Successfully obtained item details.
    }, failure: { error in
       // Some error occured.
    }

##### Notification

Notification service has two methods:

   public static func subscribe(onStatusChanged: @escaping ( _status: InPlayerNotificationStatus) -> Void,          onMessageReceived: @escaping (_ notification: InPlayerNotification) -> Void, onError: @escaping (_ error: InPlayerError) -> Void)

   and

   public static func unsubscribe()

   public static func isSubscribed() -> Bool

###### Example:
Subscribe method:

    InPlayer.Notification.subscribe(onStatusChanged: { (status) in
        // Notification status changed
    }, onMessageReceived: { (message) in
        // Because message has type which is enum containing associated value, this is one of the ways to use it.
        if case let NotificationType.accessGranted(resource) = message.type {
            // Access was granted, you can use resource
        }
    }, failure: { (error) in
        // InPlayerError containing info about what happened
    })


## Contributing

We are thankful for any contributions made by the community. By contributing you agree to abide by
the Code of Conduct in the [Contributing Guidelines](https://github.com/inplayer-org/inplayer-ui/blob/master/.github/CONTRIBUTING.md).

## License

Licensed under the MIT License, Copyright © 2018-present InPlayer.

See [LICENSE](https://github.com/inplayer-org/inplayer-ios-sdk/blob/master/LICENSE) for more information.