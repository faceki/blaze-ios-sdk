//
//  DocumentCopyRulesModel.swift
//  ScanDocument
//
//

import Foundation

struct WorkflowRule: Codable {
  let status: Bool
  let code: Int
  let message: String
  let appVersion: String
  let result: ResultModel?
}

struct ResultModel: Codable {
  let _id: String
  let branchId: String
  let workflowId: String
  let companyId: String
  let documents: [String]
//  let nationality: [Any]
//  let countries: [Any]
  let liveness_type: String
//  let custom_internal_engine: Any?
  let ocr_only: Bool
  let user_verify_once: Bool
  let document_optional: Bool
  let store_data: Bool
  let recaptured_allow: Bool
  let geolocation_enforce: Bool
  let auto_capture: Bool
  let sms_verification: Bool
  let email_verification: Bool
//  let store_data_expiry: Any?
  let face_match_score: Int
  let minAge: Int
  let maxAge: Int
  let theme: Theme
  let amlType: String
  let callbackURL: URL
  let region: String
  let __v: Int
}

struct Theme: Codable {
  let backgroundColor: String
  let cardBackgroundColor: String
  let iconColorDesktop: String
  let buttonColor: String
  let headingColor: String
  let textColor: String
  let iconColor: String
  let selfieImage: String
  let logoImage: String
  let skipEmailScreen: Bool
  let skipResult: Bool
  let successText: String
  let declineText: String
  let imageUrls: [String]
  let language: String
}
