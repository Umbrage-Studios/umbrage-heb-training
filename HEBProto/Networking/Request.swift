//
//  Request.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/2/22.
//

import Foundation

enum APIService {
    case krogerSignIn

    var baseURL: String {
        switch self {
        case .krogerSignIn: return "https://api.kroger.com"
        }
    }

    var version: String? {
        switch self {
        case .krogerSignIn: return "v1"
        }
    }

    var secret: String {
        var key: Secret.Key
        switch self {
        case .krogerSignIn:
            key = .krogerClientIDKey
        default:
            fatalError("Secret requested for service that does not have a secret")
        }

        return Secret.value(key)
    }
}

enum Request {
    case krogerAuth

    var service: APIService {
        switch self {
        case .krogerAuth:
            return .krogerSignIn
        }
    }

    private var method: URLRequest.HTTPMethod {
        switch self {
        case .krogerAuth:
            return .post
        }
    }

    private var path: String {
        var path: String
        switch self {
        case .krogerAuth:
            path = "connect/oauth2/token"
        }

        guard !params.isEmpty else { return path }

        let parameters = params.map { "\($0)=\($1)" }.joined(separator: "&")
        return [path, parameters].joined(separator: "?")
    }

    private var urlString: String {
        var urlString: String
        urlString = [service.baseURL, service.version, path].compactMap { $0 }.joined(separator: "/")

        return urlString
    }

    var urlRequest: URLRequest {
        let urlString = urlString
        guard let url = URL(string: urlString) else {
            fatalError("Unable to create url from \(urlString)")
        }

        var request = URLRequest(url: url)
        request.method = method
        request.httpBody = httpBody

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private var params: [String: String] {
        let params = [String: String]()

        switch self {
        default:
            break
        }

        return params
    }

    private var headers: [String: String] {
        var headers = ["Content-Type" : "application/json"]

        switch service {
        case .krogerSignIn:
            guard let encodedID = service.secret.data(using: .utf8)?.base64EncodedString() else {
                fatalError("COULD NOT ENCODE YAHOO AUTH CLIENT ID")
            }

            headers["Authorization"] = "Basic \(encodedID)"
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }

        return headers
    }

    private var httpBody: Data? {
        var dictionary = [String : Any]()
        switch self {
        case .krogerAuth:
            dictionary["grant_type"] = "client_credentials"
            dictionary["scope"] = "product.compact"

            // The Kroger API is really picky and so we need to format it slightly differently from the other HTTP bodies
            return dictionary.map { "\($0.0)=\($0.1)" }.joined(separator: "&").data(using: .utf8)
        }
    }

    /// Calls that have a refreshable token associated with them return `true`
    var isRefreshable: Bool {
        switch service {
        default:
            return false
        }
    }
}

extension Request: Equatable {
    var id: String {
        switch self {
        case .krogerAuth: return "krogerAuth"
        }
    }

    static func ==(lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id
    }
}

extension URLRequest {
    enum HTTPMethod: String, CaseIterable {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }

    var method: HTTPMethod? {
        get {
            guard let httpMethod = httpMethod else { return nil }
            return HTTPMethod(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}

struct Secret {
    enum Key: String {
        case krogerClientIDKey = "KROGER_CLIENT_ID_KEY"
    }
    
    static func value(_ key: Key) -> String {
        guard let secret = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("Requested key does not exist")
        }
        
        return secret
    }
}

