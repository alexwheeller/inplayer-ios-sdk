import Foundation

public class InPlayer {
    private init () {}

    /**
     Initialize SDK with clientID and enviorment.
     - Parameters:
         - clientId: Also called merchantId, to identify client using the SDK.
         - referrer: The request’s source URL
         - environment: Sets SDK environment.
     */
    public static func initialize(withClienId clientId: String,
                                  referrer: String? = nil,
                                  environment: EnvironmentType = .production) {
        InPlayer.Configuration.configure(withClientId: clientId, referrer: referrer, environment: environment)
    }
}
