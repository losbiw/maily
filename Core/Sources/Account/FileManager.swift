// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

// Read and write accounts to JSON file on disk; stopgap for account persistence
extension FileManager {
    func fileExists(at url: URL) throws -> Bool {
        guard url.isFileURL else {
            throw URLError(.unsupportedURL)
        }
        return fileExists(atPath: url.path())
    }
}

extension JSONEncoder {
    convenience init(_ outputFormatting: OutputFormatting) {
        self.init()
        self.outputFormatting = outputFormatting
    }
}

extension URL {
    static var accounts: Self { documents("Accounts.json") }

    static func documents(_ path: String = "") -> Self {
        (isTestEnvironment ? Self.temporaryDirectory : .documentsDirectory).appending(path: path)
    }
}

extension ProcessInfo {
    var isTestEnvironment: Bool { environment["XCTestSessionIdentifier"] != nil }
}

var isTestEnvironment: Bool { ProcessInfo.processInfo.isTestEnvironment }
private let lock: NSLock = NSLock()
