// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

public typealias Accounts = AccountManager

/// Globally manage shared, persistent accounts from the SwiftUI environment.
@Observable
public final class AccountManager {
    public private(set) var allAccounts: [Account] = []
    public var error: AccountError?
    private var store: LocalStore

    /// Feature flag enables autoconfiguring new accounts using [JMAP](https://jmap.io), when supported by email provider.
    public var isJMAPAvailable: Bool = false

    public func account(for id: UUID) -> Account? {
        allAccounts.first(where: { $0.id == id })
    }

    public func set(_ account: Account, at index: Int? = nil) {
        error = nil
        let backupAccounts = allAccounts
        
        do {
            var accounts: [Account] = allAccounts
            let currentIndex: Int? = accounts.firstIndex { account.id == $0.id }
            if let currentIndex {
                accounts.remove(at: currentIndex)
            }
            let index: Int? = index ?? currentIndex  // New index OR current index OR nil (append to end)
            if let index, index < accounts.count {
                accounts.insert(account, at: index)  // Insert at new or current target index
            } else {
                accounts.append(account)  // Append to end of array
            }
            
            try store.saveAccounts(accounts)
            allAccounts = try store.loadAccounts()
        } catch {
            // revert previous mutations
            allAccounts = backupAccounts
            self.error = .GRDB(error)
        }
    }

    public func delete(_ account: Account) {
        error = nil
        do {
            try store.deleteAccount(account.id)
            allAccounts = try store.loadAccounts()
        } catch {
            self.error = .GRDB(error)
        }
    }

    public func deleteAccounts() {
        error = nil
        do {
            try store.deleteAllAccounts()
            allAccounts = []
        } catch {
            self.error = .GRDB(error)
        }
    }

    public init(store: LocalStore) {
        self.store = store
        
        do {
            allAccounts = try store.loadAccounts()
        } catch {
            self.error = .GRDB(error)
        }
    }
}
