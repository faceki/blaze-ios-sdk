import Foundation

struct WorkflowRule: Codable {
    let status: Bool
    let code: Int
    let message: String
    let appVersion: String
    let result: ResultModel?
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
    let additional_document_rules: [String]? // or a specific type
    let additional_document_required: Bool?
}

struct Theme: Codable {
    let backgroundColor: String
    let cardBackgroundColor: String
    let iconColorDesktop: String
    let iconColor: String
    let headingColor: String
    let textColor: String
    let buttonColor: String
    let selfieImage: String
    let successText: String?
    let declineText: String?
    let skipResult: Bool
    let skipEmailScreen: Bool
    let language: String
    let logoImage: String
}
