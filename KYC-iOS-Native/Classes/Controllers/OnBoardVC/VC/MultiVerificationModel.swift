//
//  MultiVerificationModel.swift
//  ScanDocument
//
//

import Foundation


struct KYCVerification: Codable {
  let status: Bool
  let code: Int
  let message: String
  let appVersion: String
  let result: KYCVerificationModel?
}

struct KYCVerificationModel: Codable {
  let requestId: String
  let decision: String
  let companyId: String
  let workflowId: String
  let branchId: String
}
