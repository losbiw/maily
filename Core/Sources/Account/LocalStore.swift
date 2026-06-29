// LocalStore.swift
// Core
//
// Created by Vlad Skorinov on 28/06/2026.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//


import Foundation
import GRDB

/// Basically just interfaces with GRDB, mostly adheres to the spec in `Database.md`
public struct LocalStore {
    private var dbQueue: DatabaseQueue
    
    public init() throws {
        var defaultDBURL = try FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("maily.sqlite")
            .path
        
        try self.init(dbPath: defaultDBURL)
    }
    
    public init(dbPath: String) throws {
        var migrator = LocalStoreMigrator()
        
        dbQueue = try DatabaseQueue(path: dbPath)
        
        try migrator.applyMigrations(db: dbQueue)
    }
    
    public func loadSession() throws -> SessionState? {
        let session = try dbQueue.read { db in
            try SessionState.find(db, id: "1")
        }
        
        return session
    }
    
    public func saveSession(_ session: SessionState) throws {
        try dbQueue.write { db in
            try session.save(db)
        }
    }
    
    // public func loadMailbox(_ mailbox: String) -> Mailbox {}
}

// MARK: Account DB methods
extension LocalStore {
    public func loadAccounts() throws -> [Account] {
        let accounts = try dbQueue.read { db in
            try Account.fetchAll(db)
        }
        
        return accounts
    }
    
    public func deleteAccount(_ id: UUID) throws {
        let _ = try dbQueue.write { db in
            try Account.deleteOne(db, id: id)
        }
    }
    
    public func deleteAllAccounts() throws {
        let _ = try dbQueue.write { db in
            try Account.deleteAll(db)
        }
    }
    
    public func saveAccounts(_ accounts: [Account]) throws {
        try dbQueue.write { db in
            try accounts.forEach { try $0.save(db) }
        }
    }
}

// MARK: Mailbox DB methods
extension LocalStore {
    
}

private struct LocalStoreMigrator {
    private var migrator = DatabaseMigrator()
    
    public init() {
        migrator.registerMigration("Initialize Maily DB", migrate: { db in
            try db.create(table: "session") { t in
                t.autoIncrementedPrimaryKey("id")
            }
        })
    }
    
    public func applyMigrations(db: DatabaseQueue) throws {
        try migrator.migrate(db)
    }
}
