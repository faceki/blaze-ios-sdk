//
//  ViewModel.swift
//  ScanDocument
//
//

import Foundation
class HomeViewModel {
    func workflowRulesApiCall() async throws -> WorkflowRule {
        return try await Request.shared.requestApi(WorkflowRule.self, baseUrl: "https://sdk.faceki.com/api/v3/workflows/rules?workflowId=\(Faceki_workflowId)", method: .get, url: "", isSnakeCase: false)
    }
}
