import Alamofire

/**
 Authorization Handler. If some request returns 401 or 403 this handler will try to fetch new access token
 using the `refreshToken` endpoint.
 */
public final class INPAuthHandler: RequestAdapter, RequestRetrier {
    /**
     A closure to be executed once the refresh request has finished.
     - Parameters:
        - succeeded: Bool variable indicating if refresh token api call was successfull or not.
        - accessToken: The newly obtained access token.
        - refreshToken: The newly obtained refresh token.
     */
    public typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    /// Base url string, used to determine on which requests we need to add access token
    private var baseURLString: String

    /// Variable that indicates if we are already in the process of obtaining new refresh token.
    private var isRefreshing: Bool = false

    /// Lock used to block multiple accesses to refresh mechanism.
    private let lock = NSLock()

    /// Array of requests that are waiting to be retried.
    private var requestToRetry: [RequestRetryCompletion] = []

    public init(baseURLString: String) {
        self.baseURLString = baseURLString
    }

    public func adapt(_ urlRequest: URLRequest, completion: @escaping (Result<URLRequest>) -> Void) {
        let result: Result<URLRequest> = Result {
            guard
                let accessToken = InPlayer.Account.getCredentials()?.accessToken,
                let urlString = urlRequest.url?.absoluteString,
                urlString.hasPrefix(baseURLString)
            else {
                return urlRequest
            }

            var urlRequest = urlRequest
            urlRequest.setValue( NetworkConstants.HeaderParameters.bearerToken + accessToken,
                                 forHTTPHeaderField: NetworkConstants.HeaderParameters.authorization)
            return urlRequest
        }
        completion(result)
    }

    public func should(_ manager: Session, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock(); defer { lock.unlock() }
        guard request.retryCount == 0 else { return completion(false, 0.0) }
        guard let response = request.response, (response.statusCode == 401 || response.statusCode == 403)
        else {
            return completion(false, 0.0)
        }

        requestToRetry.append(completion)

        if !isRefreshing {
            refreshTokens { [weak self] (succeeded, accessToken, refreshToken) in
                guard let strongSelf = self else { return }

                strongSelf.requestToRetry.forEach { $0(succeeded, 0.25) }
                strongSelf.requestToRetry.removeAll()
            }
        }
    }

    public func refreshTokens(completion: @escaping RefreshCompletion) {
        if let refreshToken = InPlayer.Account.getCredentials()?.refreshToken {
            isRefreshing = true
            InPlayer.Account.refreshAccessToken(using: refreshToken, success: { [weak self] (authorization) in
                guard let strongSelf = self else { return }
                strongSelf.isRefreshing = false
                completion(true, authorization.accessToken, authorization.refreshToken)
                
            }) { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.isRefreshing = false
                completion(false, nil, nil)
            }
        } else {
            self.isRefreshing = false
            completion(false, nil, nil)
        }
    }
}
