//
//  RequestManager.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import Foundation
import Network

// MARK: - Safe

public struct Safe<T: Decodable>: Decodable {
    public let result: Result<T, Error>

    public init(from decoder: Decoder) throws {
        let catching = { try T(from: decoder) }
        result = Result(catching: catching)
    }
}

// MARK: - Network Protocol

protocol Network {
    func send<T: Decodable>(_ request: Request) async throws -> T
}

// MARK: - Errors

enum BettorVisionNetworkError: Error {
    case invalidResponse(Data)
    case networkUnavailable
    case invalidRequest
    case fieldError(FieldError)
}

struct FieldError: Decodable {
    let fieldName: String
    let message: String

    enum ResponseCodingKeys: String, CodingKey {
        case error
    }

    enum CodingKeys: String, CodingKey {
        case fieldName = "field"
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)

        fieldName = try nestedContainer.decode(String.self, forKey: .fieldName)
        message = try nestedContainer.decode(String.self, forKey: .message)
    }
}

// MARK: - RequestManager

final class RequestManager: Network {
    static let shared = RequestManager()
    private init() {}

    // MARK: - Network Request Methods
    func send<T: Decodable>(_ request: Request) async throws -> T {
//        guard Connectivity.shared.isConnected else { throw BettorVisionNetworkError.networkUnavailable }

        var urlRequest = request.urlRequest
        if request.isRefreshable {
            let validToken = try await AuthManager.validToken()
            urlRequest.setValue("Basic \(validToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        guard (200..<300).contains(statusCode) else {
//            let decoder = JSONDecoder()
//
//            if let fieldError = try? decoder.decode(FieldError.self, from: data) {
//                throw BettorVisionNetworkError.fieldError(fieldError)
//            }

            throw BettorVisionNetworkError.invalidRequest
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw BettorVisionNetworkError.invalidResponse(data)
        }

        return result
    }
}


// MARK: - Mock Network Object

// Used for dependency injection in view previews
struct MockNetwork: Network {
    func send<T: Decodable>(_ request: Request) async throws -> T {
        throw BettorVisionNetworkError.invalidRequest
    }
}

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
            
            guard let token = TokenManager.shared.token else {
                throw AuthError.missingToken
            }

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

