//
//  SessionActions.swift
//  falcon
//
//  Created by Juan Pablo Civile on 06/12/2018.
//  Copyright © 2018 muun. All rights reserved.
//

import Foundation
import RxSwift

public class SessionActions {

    private let sessionRepository: SessionRepository
    private let userRepository: UserRepository
    private let keysRepository: KeysRepository

    init(repository: SessionRepository, userRepository: UserRepository, keysRepository: KeysRepository) {
        self.sessionRepository = repository
        self.userRepository = userRepository
        self.keysRepository = keysRepository
    }

    public func isLoggedIn() -> Bool {
        return sessionRepository.getStatus() == SessionStatus.LOGGED_IN
    }

    public func isFirstLaunch() -> Bool {
        return sessionRepository.getStatus() == nil || userRepository.getUser() == nil
    }

    public func watchEmailAuthorization() -> Completable {
        return sessionRepository.watchStatus()
            .filter { $0 == SessionStatus.AUTHORIZED_BY_EMAIL }
            .first()
            .ignoreElements()
    }

    func emailAuthorized() -> Completable {
        return Completable.deferred({
            self.sessionRepository.setStatus(.AUTHORIZED_BY_EMAIL)

            return Completable.empty()
        })
    }

    func hasPermissionFor(status: SessionStatus) -> Bool {
        guard let currentStatus = sessionRepository.getStatus() else {
            return false
        }

        switch (status, currentStatus) {

        case (.CREATED, .CREATED),
             (.CREATED, .BLOCKED_BY_EMAIL),
             (.CREATED, .AUTHORIZED_BY_EMAIL),
             (.CREATED, .LOGGED_IN):
            return true

        case (.BLOCKED_BY_EMAIL, .BLOCKED_BY_EMAIL),
             (.BLOCKED_BY_EMAIL, .AUTHORIZED_BY_EMAIL),
             (.BLOCKED_BY_EMAIL, .LOGGED_IN):
            return true

        case (.AUTHORIZED_BY_EMAIL, .AUTHORIZED_BY_EMAIL),
             (.AUTHORIZED_BY_EMAIL, .LOGGED_IN):
            return true

        case (.LOGGED_IN, .LOGGED_IN):
            return true

        default:
            return false
        }
    }

    public func hasRecoveryCode() -> Bool {
        do {
            return try keysRepository.hasChallengeKey(type: .RECOVERY_CODE)
        } catch {
            // Default to true to avoid users double registering
            return true
        }
    }

    public func watchHasRecoveryCode() -> Observable<Bool?> {
        return sessionRepository.watchHasRecoveryCode()
    }

    public func getPrimaryCurrency() -> String {
        return userRepository.getUser()?.primaryCurrency ?? "BTC"
    }
}