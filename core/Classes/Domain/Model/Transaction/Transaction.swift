//
//  Transaction.swift
//  falcon
//
//  Created by Manu Herrera on 24/08/2018.
//  Copyright © 2018 muun. All rights reserved.
//

public struct Transaction {
    public var hash: String?
    public var confirmations: Int
}

struct NextTransactionSize: Codable {
    let sizeProgression: [SizeForAmount]
    let validAtOperationHid: Double?
}

public struct SizeForAmount: Codable {
    let amountInSatoshis: Satoshis
    // The sizeInBytes actually returns the size in WeightUnit, we need to divide that number by 4 to have vBytes
    let sizeInBytes: Int64
}

struct RawTransaction {
    let hex: String
}

struct RawTransactionResponse {
    let hex: String
    let nextTransactionSize: NextTransactionSize
}
