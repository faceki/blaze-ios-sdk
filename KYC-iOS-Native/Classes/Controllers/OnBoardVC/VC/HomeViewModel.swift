//
//  ViewModel.swift
//  ScanDocument
//
//

import Foundation
class HomeViewModel {
    func workflowRulesApiCall() async throws -> WorkflowRule {
        return try await Request.shared.requestApi(WorkflowRule.self, baseUrl: "https://sdk.faceki.com/api/v3/workflows/rulesbylink?link=\(Faceki_verificationLink)", method: .get, url: "", isSnakeCase: false)
    }
}
