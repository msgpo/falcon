//
//  DataDependencyContainer.swift
//  core
//
//  Created by Juan Pablo Civile on 31/05/2019.
//

import Foundation
import Dip

public extension DependencyContainer {

    enum DataTags: String, DependencyTagConvertible {
        case databaseUrl
        case secureStoragePrefix
        case secureStorageGroup
    }

    static func dataContainer() -> DependencyContainer {
        return DependencyContainer { container in
            container.register(.singleton) {
                try DatabaseCoordinator(
                    url: try container.resolve(tag: DataTags.databaseUrl),
                    preferences: try container.resolve(),
                    secureStorage: try container.resolve()
                )
            }

            container.register {
                SecureStorage(keyPrefix: try container.resolve(tag: DataTags.secureStoragePrefix),
                              group: try container.resolve(tag: DataTags.secureStorageGroup))
            }
            container.register(.singleton, factory: Preferences.init)

            container.register(factory: FeeWindowRepository.init)
            container.register(factory: UserRepository.init)
            container.register(factory: ExchangeRateWindowRepository.init)
            container.register(factory: KeysRepository.init)
            container.register(factory: NextTransactionSizeRepository.init)
            container.register(factory: SessionRepository.init)
            container.register(factory: OperationRepository.init)
            container.register(factory: PublicProfileRepository.init)
            container.register(factory: TaskRunner.init)
            container.register(factory: SubmarineSwapRepository.init)
            container.register(factory: BlockchainHeightRepository.init)

            container.register(factory: HoustonService.init)
            container.register(factory: MuunWebService.init)
        }
    }
}
