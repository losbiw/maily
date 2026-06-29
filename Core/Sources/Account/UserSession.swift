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
public final class UserSession {
    private var store: LocalStore
    private var session: SessionState
    public private(set) var error: SessionError?
    
    public init(store: LocalStore, accounts: Accounts) {
        error = nil
        
        let firstAccount = accounts.allAccounts.first!
        
        self.store = store
        let defaultSession = SessionState(selectedAccountId: firstAccount.id, selectedMailboxByAccount: [:])
        
        do {
            session = try store.loadSession() ?? defaultSession
        } catch {
            self.error = .store(error)
            session = defaultSession
        }
    }
    
    public var selectedAccountId: UUID { session.selectedAccountId }
    
    public var selectedMailboxName: String? {
        session.selectedMailboxByAccount[selectedAccountId] ?? "INBOX"
    }
        
    public func selectAccount(_ id: UUID) {
        error = nil
        let fallbackId = session.selectedAccountId
        
        do {
            session.selectedAccountId = id
            try store.saveSession(session)
        } catch {
            self.session.selectedAccountId = fallbackId
            self.error = .store(error)
        }
    }
    
    public func selectMailbox(_ mailbox: String, for accountId: UUID) {
        error = nil
        let fallbackMap = session.selectedMailboxByAccount
        
        do {
            session.selectedMailboxByAccount[accountId] = mailbox
            try store.saveSession(session)
        } catch {
            self.session.selectedMailboxByAccount = fallbackMap
            self.error = .store(error)
        }
    }
    
    /// Assumes mailbox is being selected for current `SessionStorage.selectedAccountId`
    public func selectMailbox(_ mailbox: String) {
        selectMailbox(mailbox, for: session.selectedAccountId)
    }
}


public struct SessionState: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var selectedAccountId: UUID
    var selectedMailboxByAccount: [UUID: String]
    
    // Single-row database to store state, so should be fine?
    public var id: String
    
    public init(selectedAccountId: UUID, selectedMailboxByAccount: [UUID: String]) {
        self.selectedAccountId = selectedAccountId
        self.selectedMailboxByAccount = selectedMailboxByAccount
        self.id = "1"
    }
}


public enum SessionError: Error {
    case store(Error)
    case account(String)
}

