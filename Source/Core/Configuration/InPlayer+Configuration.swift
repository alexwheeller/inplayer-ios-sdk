import Foundation

extension InPlayer {
    /**
     Bool property to check if configuration was set.
     
     Used to prevent calling
     ````
     func initialize(config: Configuration) {
     ````
     multiple times.
     */
    static var isConfigured: Bool = false
    
    /**
     ClientId from the configuration. Defaults to empty string.
     */
    static var clientId: String = ""
    
    /**
     Referrer
     */
    static var referrer: String?
    
    /**
     Environment from the configuration. Defaults to production.
     */
    static var environment: InPlayerEnvironmentType = .production
    
    /**
     Redirect URI used for social integration
     */
    static var redirectURI: String = ""
    
    /**
 */
    static func getBaseUrlString() -> String {
        switch environment {
        case .debug:
            return NetworkConstants.BaseUrls.debug
        case .staging:
            return NetworkConstants.BaseUrls.staging
        case .production:
            return NetworkConstants.BaseUrls.production
        }
    }
}
