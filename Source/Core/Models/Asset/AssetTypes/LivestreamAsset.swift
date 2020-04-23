import Foundation

/// Livestream asset model
public struct LivestreamAsset: Codable, AssetJSONDecoder {
    
    public let accountId: String
    public let eventId: Int
    public let videoId: Int?
    
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case eventId = "event_id"
        case videoId = "video_id"
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try values.decode(String.self, forKey: .accountId)
        if let eventStr = try? values.decode(String.self, forKey: .eventId), let eventIdInt = Int(eventStr) {
            eventId = eventIdInt
        } else {
            eventId = try values.decode(Int.self, forKey: .eventId)
        }
        videoId = try? values.decode(Int.self, forKey: .videoId)
    }
}
