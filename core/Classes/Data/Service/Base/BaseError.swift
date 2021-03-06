//
//  BaseError.swift
//  falcon
//
//  Created by Manu Herrera on 14/05/2019.
//  Copyright © 2019 muun. All rights reserved.
//

import Foundation

public struct DeveloperError: Codable, Error {
    public let developerMessage: String?
    let errorCode: Int
    public let message: String
    let requestId: Int
    let status: Int

    public func getKindOfError() -> ExactDeveloperError {
        switch errorCode {
        case 429: return .tooManyRequests
        case 2016: return .missingOrInvalidAuthToken
        case 2021: return .exchangeRateWindowTooOld
        case 2038: return .sessionExpired
        case 2045: return .invalidChallengeSignature
        case 2052: return .invalidEmail

        case 4002: return .forceUpdate

        // Swaps
        case 8100: return .invalidInvoice
        case 8101: return .invoiceExpiresTooSoon
        case 8102: return .invoiceAlreadyUsed
        case 8105: return .noPaymentRoute

        default: return .defaultError
        }
    }
}

public enum ExactDeveloperError {
    case defaultError
    case tooManyRequests

    case missingOrInvalidAuthToken
    case forceUpdate
    case sessionExpired
    case invalidEmail
    case nonUserFacing
    case invalidChallengeSignature
    case exchangeRateWindowTooOld

    //Swaps
    case invalidInvoice
    case invoiceExpiresTooSoon
    case invoiceAlreadyUsed
    case noPaymentRoute
}

public enum ServiceError: Error {
    case internetError
    case codableError
    case defaultError
    case customError(_ error: DeveloperError)
    case serviceFailure
    case timeOut
}
