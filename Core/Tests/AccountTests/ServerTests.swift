// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import Account
import Testing
import Foundation

struct ServerProtocolTests {
    @Test func defaultPort() {
        #expect(ServerProtocol.jmap.defaultPort == 443)
        #expect(ServerProtocol.imap.defaultPort == 993)
        #expect(ServerProtocol.smtp.defaultPort == 587)
    }
}
