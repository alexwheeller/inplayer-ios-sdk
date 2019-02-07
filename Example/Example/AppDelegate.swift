import UIKit
import InPlayerSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // On first start of the app call this:
        let configuration = InPlayer.Configuration(clientId: "xxx")
        InPlayer.initialize(configuration: configuration)

        InPlayer.Account.getAccount()
        return true
    }
}
