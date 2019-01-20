import Foundation

protocol UserDefaultsDataSource {
    /// Sets and retrieves clientId from UserDefaults
    static var clientId: String { set get }

    /// Sets and retrieves environment
    static var environment: EnvironmentType { set get }

    static var credentials: INPCredentials? { get set }
}

extension UserDefaults: UserDefaultsDataSource {

    static var clientId: String {
        get {
            return standard.string(forKey: InPlayerConstants.UserDefaultsKeys.clientId) ?? ""
        }
        set {
            standard.set(newValue, forKey: InPlayerConstants.UserDefaultsKeys.clientId)
        }
    }

    static var environment: EnvironmentType {
        get {
            guard
                let environmentString = standard.string(forKey: InPlayerConstants.UserDefaultsKeys.environment),
                let environment = EnvironmentType(rawValue: environmentString)
            else {
                return .production
            }
            return environment
        }
        set {
            standard.set(newValue.rawValue, forKey: InPlayerConstants.UserDefaultsKeys.environment)
            standard.synchronize()
        }
    }

    static var credentials: INPCredentials? {
        get {
            guard
                let savedCredentialData = standard.object(forKey: InPlayerConstants.UserDefaultsKeys.credentials) as? Data,
                let credentials = try? JSONDecoder().decode(INPCredentials.self, from: savedCredentialData)
            else {
                return nil
            }
            return credentials
        }
        set {
            if let newValue = newValue {
                let encoded = try? JSONEncoder().encode(newValue)
                standard.set(encoded, forKey: InPlayerConstants.UserDefaultsKeys.credentials)
            } else {
                standard.removeObject(forKey: InPlayerConstants.UserDefaultsKeys.credentials)
            }
        }
    }

    static var account: INPAccountModel? {
        get {
            guard
                let savedAccountData = standard.object(forKey: InPlayerConstants.UserDefaultsKeys.account) as? Data,
                let account = try? JSONDecoder().decode(INPAccountModel.self, from: savedAccountData)
                else {
                    return nil
            }
            return account
        } set {
            if let newValue = newValue {
                let encoded = try? JSONEncoder().encode(newValue)
                standard.set(encoded, forKey: InPlayerConstants.UserDefaultsKeys.account)
            } else {
                standard.removeObject(forKey: InPlayerConstants.UserDefaultsKeys.account)
            }
        }
    }
}
