//
//  RequestManager.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import Foundation
import Network

// MARK: - Network Protocol

protocol Network {
    func send<T: Decodable>(_ request: Request) async throws -> T
}

// MARK: - Errors

enum HEBNetworkError: Error {
    case invalidResponse(Data)
    case networkUnavailable
    case invalidRequest
}

// MARK: - RequestManager

final class RequestManager: Network {
    static let shared = RequestManager()
    private init() {}

    // MARK: - Network Request Methods
    func send<T: Decodable>(_ request: Request) async throws -> T {
        // Get the URL for the request
        var urlRequest = request.urlRequest

        // Check if the token is still valid or get a new one, if it needs it
        if request.isRefreshable {
            let validToken = try await AuthManager.validToken()
            urlRequest.setValue("Basic \(validToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)


        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard (200..<300).contains(statusCode) else {
            throw HEBNetworkError.invalidRequest
        }

        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw HEBNetworkError.invalidResponse(data)
        }

        return result
    }
}


// MARK: - Mock Network Object

// Used for dependency injection in view previews
struct MockNetwork: Network {
    func send<T: Decodable>(_ request: Request) async throws -> T {
        throw HEBNetworkError.invalidRequest
    }
}

// Inspired by https://www.donnywals.com/building-a-token-refresh-flow-with-async-await-and-swift-concurrency/
private actor AuthManager {
    enum AuthError: Error {
        case missingToken
    }

    private init() {}

    static var refreshTask: Task<String, Error>?

    static func validToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        guard let token = TokenManager.shared.token else {
            throw AuthError.missingToken
        }

        if token.isValid {
            return token.accessToken
        }

        return try await refreshToken()
    }

    static func refreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () -> String in
            defer { refreshTask = nil }

            let refreshedToken: AuthToken = try await RequestManager.shared.send(.krogerAuth)

            TokenManager.shared.token = refreshedToken

            guard let updatedExpriration = Calendar.current.date(byAdding: .second, value: refreshedToken.expiresIn, to: Date())?.timeIntervalSince1970 else { return refreshedToken.accessToken }

            TokenManager.shared.tokenExpiration = updatedExpriration
            return refreshedToken.accessToken
        }

        self.refreshTask = task

        return try await task.value
    }
}
