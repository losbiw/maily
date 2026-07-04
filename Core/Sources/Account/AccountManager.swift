// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

// TODO: throw custom errors with explanations
/// Globally manage shared, persistent accounts from the SwiftUI environment.
@Observable
public final class AccountManager {
    public private(set) var allAccounts: [Account] = []
    private var store: LocalStore

    /// Feature flag enables autoconfiguring new accounts using [JMAP](https://jmap.io), when supported by email provider.
    public var isJMAPAvailable: Bool = false

    public func account(for id: UUID) -> Account? {
        allAccounts.first(where: { $0.id == id })
    }

    public func set(_ account: Account, at index: Int? = nil) throws {
        let backupAccounts = allAccounts
        
        defer {
            allAccounts = backupAccounts
        }
        
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
    }

    public func delete(_ account: Account) throws {
        try store.deleteAccount(account.id)
        allAccounts = try store.loadAccounts()
    }

    public func deleteAccounts() throws {
        try store.deleteAllAccounts()
        allAccounts = []
    }

    public init(store: LocalStore) throws {
        self.store = store
        allAccounts = try store.loadAccounts()
    }
}
