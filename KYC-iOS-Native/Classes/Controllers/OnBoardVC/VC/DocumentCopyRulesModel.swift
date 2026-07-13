import Foundation

struct WorkflowRule: Codable {
    let status: Bool
    let code: Int
    let message: String
    let appVersion: String
    let result: ResultModel?
    let additionalFields: [String: JSONValue]

    private enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
        case appVersion
        case result
    }

    init(status: Bool, code: Int, message: String, appVersion: String, result: ResultModel?, additionalFields: [String: JSONValue] = [:]) {
        self.status = status
        self.code = code
        self.message = message
        self.appVersion = appVersion
        self.result = result
        self.additionalFields = additionalFields
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? container.decode(Bool.self, forKey: .status)) ?? false
        code = (try? container.decode(Int.self, forKey: .code)) ?? 0
        message = (try? container.decode(String.self, forKey: .message)) ?? ""
        appVersion = (try? container.decode(String.self, forKey: .appVersion)) ?? ""
        result = try? container.decodeIfPresent(ResultModel.self, forKey: .result)
        additionalFields = decoder.flexibleAdditionalFields(excluding: [
            "status",
            "code",
            "message",
            "appVersion",
            "result"
        ])
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
        try container.encode(appVersion, forKey: .appVersion)
        try container.encodeIfPresent(result, forKey: .result)
    }
}

struct ResultModel: Codable {
    let workflowId: String
    let companyId: String
    let documents: [String]

    let ocr_only: Bool?
    let user_verify_once: Bool?
    let document_optional: Bool
    let store_data: Bool?
    let recaptured_allow: Bool?
    let geolocation_enforce: Bool
    let auto_capture: Bool
    let sms_verification: Bool?
    let email_verification: Bool?
    let face_match_score: Int?
    let minAge: Int?
    let maxAge: Int?
    let theme: Theme?
    let amlType: String?

    let region: String?
    let __v: Int?

    let require_contact_details: Bool?
    let additional_document_rules: [String]?
    let additional_document_required: Bool?
    let additionalFields: [String: JSONValue]

    private enum CodingKeys: String, CodingKey, CaseIterable {
        case workflowId
        case companyId
        case documents
        case ocr_only
        case user_verify_once
        case document_optional
        case store_data
        case recaptured_allow
        case geolocation_enforce
        case auto_capture
        case sms_verification
        case email_verification
        case face_match_score
        case minAge
        case maxAge
        case theme
        case amlType
        case region
        case __v
        case require_contact_details
        case additional_document_rules
        case additional_document_required
    }

    init(
        workflowId: String = "",
        companyId: String = "",
        documents: [String] = [],
        ocr_only: Bool? = nil,
        user_verify_once: Bool? = nil,
        document_optional: Bool = false,
        store_data: Bool? = nil,
        recaptured_allow: Bool? = nil,
        geolocation_enforce: Bool = false,
        auto_capture: Bool = false,
        sms_verification: Bool? = nil,
        email_verification: Bool? = nil,
        face_match_score: Int? = nil,
        minAge: Int? = nil,
        maxAge: Int? = nil,
        theme: Theme? = nil,
        amlType: String? = nil,
        region: String? = nil,
        __v: Int? = nil,
        require_contact_details: Bool? = nil,
        additional_document_rules: [String]? = nil,
        additional_document_required: Bool? = nil,
        additionalFields: [String: JSONValue] = [:]
    ) {
        self.workflowId = workflowId
        self.companyId = companyId
        self.documents = documents
        self.ocr_only = ocr_only
        self.user_verify_once = user_verify_once
        self.document_optional = document_optional
        self.store_data = store_data
        self.recaptured_allow = recaptured_allow
        self.geolocation_enforce = geolocation_enforce
        self.auto_capture = auto_capture
        self.sms_verification = sms_verification
        self.email_verification = email_verification
        self.face_match_score = face_match_score
        self.minAge = minAge
        self.maxAge = maxAge
        self.theme = theme
        self.amlType = amlType
        self.region = region
        self.__v = __v
        self.require_contact_details = require_contact_details
        self.additional_document_rules = additional_document_rules
        self.additional_document_required = additional_document_required
        self.additionalFields = additionalFields
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        workflowId = (try? container.decodeFlexibleString(forKey: .workflowId)) ?? ""
        companyId = (try? container.decodeFlexibleString(forKey: .companyId)) ?? ""
        documents = (try? container.decodeFlexibleStringArray(forKey: .documents)) ?? []
        ocr_only = try? container.decodeFlexibleBool(forKey: .ocr_only)
        user_verify_once = try? container.decodeFlexibleBool(forKey: .user_verify_once)
        document_optional = (try? container.decodeFlexibleBool(forKey: .document_optional)) ?? false
        store_data = try? container.decodeFlexibleBool(forKey: .store_data)
        recaptured_allow = try? container.decodeFlexibleBool(forKey: .recaptured_allow)
        geolocation_enforce = (try? container.decodeFlexibleBool(forKey: .geolocation_enforce)) ?? false
        auto_capture = (try? container.decodeFlexibleBool(forKey: .auto_capture)) ?? false
        sms_verification = try? container.decodeFlexibleBool(forKey: .sms_verification)
        email_verification = try? container.decodeFlexibleBool(forKey: .email_verification)
        face_match_score = try? container.decodeFlexibleInt(forKey: .face_match_score)
        minAge = try? container.decodeFlexibleInt(forKey: .minAge)
        maxAge = try? container.decodeFlexibleInt(forKey: .maxAge)
        theme = try? container.decodeIfPresent(Theme.self, forKey: .theme)
        amlType = try? container.decodeFlexibleString(forKey: .amlType)
        region = try? container.decodeFlexibleString(forKey: .region)
        __v = try? container.decodeFlexibleInt(forKey: .__v)
        require_contact_details = try? container.decodeFlexibleBool(forKey: .require_contact_details)
        additional_document_rules = (try? container.decodeFlexibleStringArray(forKey: .additional_document_rules))
        additional_document_required = try? container.decodeFlexibleBool(forKey: .additional_document_required)
        additionalFields = decoder.flexibleAdditionalFields(excluding: [
            "workflowId",
            "companyId",
            "documents",
            "ocr_only",
            "user_verify_once",
            "document_optional",
            "store_data",
            "recaptured_allow",
            "geolocation_enforce",
            "auto_capture",
            "sms_verification",
            "email_verification",
            "face_match_score",
            "minAge",
            "maxAge",
            "theme",
            "amlType",
            "region",
            "__v",
            "require_contact_details",
            "additional_document_rules",
            "additional_document_required"
        ])
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workflowId, forKey: .workflowId)
        try container.encode(companyId, forKey: .companyId)
        try container.encode(documents, forKey: .documents)
        try container.encodeIfPresent(ocr_only, forKey: .ocr_only)
        try container.encodeIfPresent(user_verify_once, forKey: .user_verify_once)
        try container.encode(document_optional, forKey: .document_optional)
        try container.encodeIfPresent(store_data, forKey: .store_data)
        try container.encodeIfPresent(recaptured_allow, forKey: .recaptured_allow)
        try container.encode(geolocation_enforce, forKey: .geolocation_enforce)
        try container.encode(auto_capture, forKey: .auto_capture)
        try container.encodeIfPresent(sms_verification, forKey: .sms_verification)
        try container.encodeIfPresent(email_verification, forKey: .email_verification)
        try container.encodeIfPresent(face_match_score, forKey: .face_match_score)
        try container.encodeIfPresent(minAge, forKey: .minAge)
        try container.encodeIfPresent(maxAge, forKey: .maxAge)
        try container.encodeIfPresent(theme, forKey: .theme)
        try container.encodeIfPresent(amlType, forKey: .amlType)
        try container.encodeIfPresent(region, forKey: .region)
        try container.encodeIfPresent(__v, forKey: .__v)
        try container.encodeIfPresent(require_contact_details, forKey: .require_contact_details)
        try container.encodeIfPresent(additional_document_rules, forKey: .additional_document_rules)
        try container.encodeIfPresent(additional_document_required, forKey: .additional_document_required)
    }
}

struct Theme: Codable {
    let backgroundColor: String?
    let cardBackgroundColor: String?
    let iconColorDesktop: String?
    let iconColor: String?
    let headingColor: String?
    let textColor: String?
    let buttonColor: String?
    let selfieImage: String?
    let successText: String?
    let declineText: String?
    let skipResult: Bool?
    let skipEmailScreen: Bool?
    let language: String?
    let logoImage: String?
    let additionalFields: [String: JSONValue]

    private enum CodingKeys: String, CodingKey, CaseIterable {
        case backgroundColor
        case cardBackgroundColor
        case iconColorDesktop
        case iconColor
        case headingColor
        case textColor
        case buttonColor
        case selfieImage
        case successText
        case declineText
        case skipResult
        case skipEmailScreen
        case language
        case logoImage
    }

    init(
        backgroundColor: String? = nil,
        cardBackgroundColor: String? = nil,
        iconColorDesktop: String? = nil,
        iconColor: String? = nil,
        headingColor: String? = nil,
        textColor: String? = nil,
        buttonColor: String? = nil,
        selfieImage: String? = nil,
        successText: String? = nil,
        declineText: String? = nil,
        skipResult: Bool? = nil,
        skipEmailScreen: Bool? = nil,
        language: String? = nil,
        logoImage: String? = nil,
        additionalFields: [String: JSONValue] = [:]
    ) {
        self.backgroundColor = backgroundColor
        self.cardBackgroundColor = cardBackgroundColor
        self.iconColorDesktop = iconColorDesktop
        self.iconColor = iconColor
        self.headingColor = headingColor
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.selfieImage = selfieImage
        self.successText = successText
        self.declineText = declineText
        self.skipResult = skipResult
        self.skipEmailScreen = skipEmailScreen
        self.language = language
        self.logoImage = logoImage
        self.additionalFields = additionalFields
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backgroundColor = try? container.decodeFlexibleString(forKey: .backgroundColor)
        cardBackgroundColor = try? container.decodeFlexibleString(forKey: .cardBackgroundColor)
        iconColorDesktop = try? container.decodeFlexibleString(forKey: .iconColorDesktop)
        iconColor = try? container.decodeFlexibleString(forKey: .iconColor)
        headingColor = try? container.decodeFlexibleString(forKey: .headingColor)
        textColor = try? container.decodeFlexibleString(forKey: .textColor)
        buttonColor = try? container.decodeFlexibleString(forKey: .buttonColor)
        selfieImage = try? container.decodeFlexibleString(forKey: .selfieImage)
        successText = try? container.decodeFlexibleString(forKey: .successText)
        declineText = try? container.decodeFlexibleString(forKey: .declineText)
        skipResult = try? container.decodeFlexibleBool(forKey: .skipResult)
        skipEmailScreen = try? container.decodeFlexibleBool(forKey: .skipEmailScreen)
        language = try? container.decodeFlexibleString(forKey: .language)
        logoImage = try? container.decodeFlexibleString(forKey: .logoImage)
        additionalFields = decoder.flexibleAdditionalFields(excluding: [
            "backgroundColor",
            "cardBackgroundColor",
            "iconColorDesktop",
            "iconColor",
            "headingColor",
            "textColor",
            "buttonColor",
            "selfieImage",
            "successText",
            "declineText",
            "skipResult",
            "skipEmailScreen",
            "language",
            "logoImage"
        ])
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(cardBackgroundColor, forKey: .cardBackgroundColor)
        try container.encodeIfPresent(iconColorDesktop, forKey: .iconColorDesktop)
        try container.encodeIfPresent(iconColor, forKey: .iconColor)
        try container.encodeIfPresent(headingColor, forKey: .headingColor)
        try container.encodeIfPresent(textColor, forKey: .textColor)
        try container.encodeIfPresent(buttonColor, forKey: .buttonColor)
        try container.encodeIfPresent(selfieImage, forKey: .selfieImage)
        try container.encodeIfPresent(successText, forKey: .successText)
        try container.encodeIfPresent(declineText, forKey: .declineText)
        try container.encodeIfPresent(skipResult, forKey: .skipResult)
        try container.encodeIfPresent(skipEmailScreen, forKey: .skipEmailScreen)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(logoImage, forKey: .logoImage)
    }
}

enum JSONValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case array([JSONValue])
    case object([String: JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
            return
        }
        if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
            return
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }
}

private extension KeyedDecodingContainer {
    func decodeFlexibleString(forKey key: Key) throws -> String {
        if let string = try? decode(String.self, forKey: key) { return string }
        if let int = try? decode(Int.self, forKey: key) { return String(int) }
        if let bool = try? decode(Bool.self, forKey: key) { return String(bool) }
        if let double = try? decode(Double.self, forKey: key) { return String(double) }
        return ""
    }

    func decodeFlexibleBool(forKey key: Key) throws -> Bool {
        if let bool = try? decode(Bool.self, forKey: key) { return bool }
        if let int = try? decode(Int.self, forKey: key) { return int != 0 }
        if let string = try? decode(String.self, forKey: key) {
            let lowercased = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return ["true", "1", "yes", "y"].contains(lowercased)
        }
        return false
    }

    func decodeFlexibleInt(forKey key: Key) throws -> Int {
        if let int = try? decode(Int.self, forKey: key) { return int }
        if let double = try? decode(Double.self, forKey: key) { return Int(double) }
        if let string = try? decode(String.self, forKey: key), let int = Int(string) { return int }
        return 0
    }

    func decodeFlexibleStringArray(forKey key: Key) throws -> [String] {
        if let array = try? decode([String].self, forKey: key) { return array }
        if let string = try? decode(String.self, forKey: key) {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("[") {
                if let data = trimmed.data(using: .utf8),
                   let array = try? JSONDecoder().decode([String].self, from: data) {
                    return array
                }
            }
            return trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        }
        if let single = try? decode(String.self, forKey: key), !single.isEmpty {
            return [single]
        }
        return []
    }
}

private extension Decoder {
    func flexibleAdditionalFields(excluding keys: [String]) -> [String: JSONValue] {
        guard let container = try? self.container(keyedBy: AnyCodingKey.self) else { return [:] }
        let excluded = Set(keys)
        var fields: [String: JSONValue] = [:]

        for key in container.allKeys where !excluded.contains(key.stringValue) {
            if let value = try? container.decode(JSONValue.self, forKey: key) {
                fields[key.stringValue] = value
            }
        }

        return fields
    }
}

private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
