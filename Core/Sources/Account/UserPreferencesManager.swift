// UserSession.swift
// Core
//
// Created by Vlad Skorinov on 27/06/2026.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

import Foundation
import GRDB

@Observable
public final class UserPreferencesManager {
    private var store: LocalStore
    private var preferences: UserPreferences
    
    public init(store: LocalStore, accounts: [Account]) {
        let firstAccount = accounts.first
        
        self.store = store
        let defaultPreferences = UserPreferences(selectedAccountId: firstAccount?.id, selectedMailboxByAccount: [:])
        
        do {
            preferences = try store.loadPreferences() ?? defaultPreferences
        } catch {
            preferences = defaultPreferences
        }
    }
    
    public var selectedAccountId: UUID? { preferences.selectedAccountId }
    
    public var selectedMailboxName: String? {
        // even if selectedAccountId doesn't exist the property will default to INBOX
        preferences.selectedMailboxByAccount[selectedAccountId!] ?? "INBOX"
    }
        
    public func selectAccount(_ id: UUID) throws {
        let fallbackId = preferences.selectedAccountId
        
        do {
            preferences.selectedAccountId = id
            try store.savePreferences(preferences)
        } catch {
            self.preferences.selectedAccountId = fallbackId
            // TODO: report a non-critical "failed to select account" error here
            throw error
        }
    }
    
    public func selectMailbox(_ mailbox: String, for accountId: UUID) throws {
        let fallbackMap = preferences.selectedMailboxByAccount
        
        do {
            preferences.selectedMailboxByAccount[accountId] = mailbox
            try store.savePreferences(preferences)
        } catch {
            self.preferences.selectedMailboxByAccount = fallbackMap
            throw error
        }
    }
    
    /// Assumes mailbox is being selected for current `SessionStorage.selectedAccountId`
    public func selectMailbox(_ mailbox: String) throws {
        guard let currentAccountId = preferences.selectedAccountId else {
            throw PreferencesError.account("No accounted selected")
        }
        
        try selectMailbox(mailbox, for: preferences.selectedAccountId!)
    }
}


public struct UserPreferences: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var selectedAccountId: UUID?
    var selectedMailboxByAccount: [UUID: String]
    
    // Single-row database to store state, so should be fine?
    public var id: String
    
    public init(selectedAccountId: UUID?, selectedMailboxByAccount: [UUID: String]) {
        self.selectedAccountId = selectedAccountId
        self.selectedMailboxByAccount = selectedMailboxByAccount
        self.id = "1"
    }
}


public enum PreferencesError: Error {
    case store(Error)
    case account(String)
}

