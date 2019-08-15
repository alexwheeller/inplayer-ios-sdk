import Foundation

/// Item model
public struct InPlayerItem : Codable {

    /// Access control type object
    public let accessControlType : InPlayerAccessControlType?

    /// The date the asset was created on, measured in seconds since 1 January 1970 (UTC)
    public let createdAt : Double?

    /// Item's ID
    public let id : Int?

    /// Shows whether the asset is active and can be monetized
    public let isActive : Bool?

    /// Item type object
    public let itemType : InPlayerItemType?

    /// Merchant's ID
    public let merchantId : Int?

    /// Merchant's UUID
    public let merchantUuid : String?

    /// Object containing additional information about the item
    public let metadata : [InPlayerItemMetadata]?

    public let metahash : [String: String]?

    /// The asset’s title
    public let title : String?

    /// The date when the asset was last updated, measured in seconds since 1 January 1970 (UTC)
    public let updatedAt : Double?

    /// The asset’s content which can be a json object, a string, an html or an xml document
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case accessControlType = "access_control_type"
        case createdAt = "created_at"
        case id = "id"
        case isActive = "is_active"
        case itemType = "item_type"
        case merchantId = "merchant_id"
        case merchantUuid = "merchant_uuid"
        case metadata = "metadata"
        case metahash = "metahash"
        case title = "title"
        case updatedAt = "updated_at"
        case content = "content"
    }

    /// Decoder method
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessControlType = try values.decodeIfPresent(InPlayerAccessControlType.self, forKey: .accessControlType)
        createdAt = try values.decodeIfPresent(Double.self, forKey: .createdAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        itemType = try values.decodeIfPresent(InPlayerItemType.self, forKey: .itemType)
        merchantId = try values.decodeIfPresent(Int.self, forKey: .merchantId)
        merchantUuid = try values.decodeIfPresent(String.self, forKey: .merchantUuid)
        metadata = try values.decodeIfPresent([InPlayerItemMetadata].self, forKey: .metadata)
        metahash = try values.decodeIfPresent([String: String].self, forKey: .metahash)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        updatedAt = try values.decodeIfPresent(Double.self, forKey: .updatedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}
