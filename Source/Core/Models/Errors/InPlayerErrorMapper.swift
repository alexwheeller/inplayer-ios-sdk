import Foundation
import Alamofire

/**
 Interface declaring error properties
 */
public protocol InPlayerError: Error {
    /// Error code.
    var code: Int { get }

    /// Error message. (Optional)
    var message: String? { get }

    /// List of error messages. (Optional)
    var errorList: [String]? { get }

    /// The original error for further inspection.
    var originalError: Error { get }

    /// Initializer
    init(code: Int, message: String?, errorList: [String]?, error: Error)
}

final class InPlayerErrorMapper {

    /**
     Static func that checks the errors and returns generic InPlayerError containing all information.
     - Parameters:
         - originalError: The original error generated by the System or AF.
         - data: The response data containing error messages returned from server. (Optional)
     - Returns: Generic InPlayerError containing code, message, list of errors and the original error for
     further inspection.
     */
    static func mapFromError(originalError: Error, withResponseData data: Data?) -> InPlayerError {
        if let data = data {
            do {
                guard
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                else {
                    return INPInvalidJSONError(error: originalError)
                }

                var message: String?
                if let messageJson: String = json["message"] as? String {
                    message = messageJson
                }

                var errors: [String]?
                if let errorsJson = json["errors"] as? [String: String] {
                    errors = errorsJson.map{ $0.value }
                } else if let message = message {
                    errors?.append(message)
                }

                var code: Int
                if let jsonCode = json["code"] as? Int {
                    code = jsonCode
                } else if let afErrorCode = originalError.asAFError?.responseCode {
                    code = afErrorCode
                } else {
                    code = (originalError as NSError).code
                }

                return InPlayerHttpError(code: code, message: message, errorList: errors, error: originalError)
            } catch {
                return INPInvalidJSONError(error: originalError)
            }
        } else {
            guard let afError = originalError.asAFError else {
                return InPlayerHttpError(code: (originalError as NSError).code,
                                    message: originalError.localizedDescription,
                                    errorList: [originalError.localizedDescription],
                                    error: originalError)
            }
            guard
                let code = afError.responseCode,
                let message = afError.errorDescription
            else {
                return InPlayerUnknownError(error: originalError)
            }
            return InPlayerHttpError(code: code, message: message, errorList: [message], error: originalError)
        }
    }
}
