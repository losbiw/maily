// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

/// Manage each ``MailboxManager`` for every ``Account``.
@Observable
public final class UnifiedMailboxManager {
    public var mailboxManagers: [MailboxManager] = []

    public init() {}
}
