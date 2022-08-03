//
//  TokenManager.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/3/22.
//

import Foundation
import Combine

final class TokenManager {
    private enum StorageKeys {
        static let authTokenKey = "HEBAuthToken"
        static let authTokenExiprationDate = "HEBAuthTokenExpirationDate"
    }
    
    static let shared = TokenManager()
    private init() {}
    
    var tokenExpiration: TimeInterval? {
        get {
            // Retrive the expiration time from UserDefaults
            guard let data = UserDefaults.standard.data(forKey: StorageKeys.authTokenExiprationDate) else { return nil }
            
            return try? JSONDecoder().decode(TimeInterval.self, from: data)
        }
        set {
            //
            guard let updatedTokenExpirationData = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(updatedTokenExpirationData, forKey: StorageKeys.authTokenExiprationDate)
        }
    }
    
    // This is bad practice, we really should be storing tokens in Keychain or somewhere else
    var token: AuthToken? {
        get {
            // Retrieve the token from UserDefaults
            guard let tokenData = UserDefaults.standard.data(forKey: StorageKeys.authTokenKey) else { return nil }
            return try? JSONDecoder().decode(AuthToken.self, from: tokenData)
        }
        set {
            // Save the token data in UserDefaults
            guard let tokenData = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(tokenData, forKey: StorageKeys.authTokenKey)
        }
    }
}

struct AuthToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        
        // Now that we have the properties set, we can set the expiration date based on the `expiresIn`
        setExpirationDate()
    }
    
    var isValid: Bool {
        Date().timeIntervalSince1970 < expirationDateSecondsSince1970
    }
    
    private var expirationDateSecondsSince1970: TimeInterval {
        // Refresh the token if we are within 5 seconds of expiration
        guard let expirationSecondsSince1970 = TokenManager.shared.tokenExpiration else { return Date().timeIntervalSince1970 - 5 }
            return expirationSecondsSince1970
    }
    
    private func setExpirationDate() {
        // Only set the expiration the first time (if there is no saved token)
        // On refresh the expiration will be updated, but we don't need to update whenever we decode a token
        guard
            TokenManager.shared.tokenExpiration == nil,
            let expirationDate = Calendar.current.date(byAdding: .second, value: expiresIn, to: Date())
            else { return }

        // Set the token expiration time
        TokenManager.shared.tokenExpiration = expirationDate.timeIntervalSince1970
    }
}
