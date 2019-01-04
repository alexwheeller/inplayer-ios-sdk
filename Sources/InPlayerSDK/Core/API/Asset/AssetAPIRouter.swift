import Alamofire

/// Enum of available asset api routes
enum AssetAPIRouter: INPAPIConfiguration {

    case getItem(id: Int, merchantUUID: String)
    case getItemAccessFees(id: Int)
    case getItemAccess(id: Int)

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getItem(let id, let merchantUUID):
            return String(format: NetworkConstants.Endpoints.Asset.itemDetails, merchantUUID, "\(id)")
        case .getItemAccessFees(let id):
            return String(format: NetworkConstants.Endpoints.Asset.itemAccessFees, "\(id)")
        default:
            return ""
        }
    }

    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }

    var urlEncoding: Bool {
        switch self {
        default:
            return true
        }
    }
}

public class INPAssetService {

    @discardableResult
    public static func getItem(id: Int, merchantUUID: String, completion: @escaping (Result<INPItemModel>) -> Void) -> Request {
        return NetworkDataSource.performRequest(route: AssetAPIRouter.getItem(id: id,
                                                                              merchantUUID: merchantUUID),
                                                completion: completion)
    }

    @discardableResult
    public static func getItemAccessFees(id: Int, completion: @escaping (Result<[INPAccessFeeModel]>) -> Void) -> Request {
        return NetworkDataSource.performRequest(route: AssetAPIRouter.getItemAccessFees(id: id),
                                                completion: completion)
    }
}
