// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

/// A mailbox address or an RFC address group.
public indirect enum MailAddress: Sendable, Hashable, Codable, Identifiable {
    case address(EmailAddress)
    case group(label: String?, members: [MailAddress])

    /// Individual mailbox addresses contained by this value, recursively.
    public var addresses: [EmailAddress] {
        switch self {
        case .address(let address):
            [address]
        case .group(_, let members):
            members.flatMap(\.addresses)
        }
    }

    /// A concise label suitable for message-list UI.
    public var displayName: String {
        switch self {
        case .address(let address):
            address.label ?? address.value
        case .group(let label, let members):
            label ?? members.first?.displayName ?? ""
        }
    }

    public var id: String {
        switch self {
        case .address(let address):
            "address:\(address.id)"
        case .group(let label, let members):
            "group:\(label ?? ""):\(members.map(\.id).joined(separator: ","))"
        }
    }
}

/// Shared email address model suitable for IMAP, JMAP and SMTP
public struct EmailAddress: CustomStringConvertible, ExpressibleByStringLiteral, Hashable, Identifiable, Sendable, Codable {
    public let value: String
    public let label: String?

    public var host: String? {
        URL(string: "http://\(value.components(separatedBy: "@").last!)")?.host()
    }

    public var local: String? {
        value.contains("@") ? value.components(separatedBy: "@").dropLast().joined(separator: "@") : nil
    }

    public var isEmailAddress: Bool { !(host ?? "").isEmpty && !(local ?? "").isEmpty }

    public init(_ value: String, label: String? = nil) {
        let components: [String] = value.trimmed().components(separatedBy: "<")
        if components.count == 2, components[1].hasSuffix(">") {  // "Example Name <name@example.com>"
            self.value = "\(components[1].dropLast())"
            self.label = label ?? components[0].trimmed()
        } else {
            let label: String = label?.trimmed() ?? ""
            self.value = components[0].trimmed()
            self.label = !label.isEmpty ? label : nil
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { !(label ?? "").isEmpty ? "\(label!) <\(value)>" : value }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    // MARK: Identifiable
    public var id: String { value }
}
