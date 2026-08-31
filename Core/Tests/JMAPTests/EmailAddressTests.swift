// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import EmailAddress
import Foundation
@testable import JMAP
import Testing

struct EmailAddressTests {

    @Test func decoderInit() throws {
        let emailAddresses = try JSONDecoder().decode([MailAddress].self, from: data)
        #expect(emailAddresses.count == 5)
        #expect(emailAddresses[0] == .group(label: "Named Group", members: [
            .address(EmailAddress("name@example.com", label: "Named Example")),
            .address(EmailAddress("noname@example.com"))
        ]))
        #expect(emailAddresses[1] == .address(EmailAddress("emptyname@example.com")))
        #expect(emailAddresses[2] == .address(EmailAddress("nullname@example.com")))
        #expect(emailAddresses[3] == .group(label: nil, members: [
            .address(EmailAddress("noname@example.com"))
        ]))
        #expect(emailAddresses[4] == .address(EmailAddress("name@example.com", label: "Named Example")))

        // Test backward compatibility with previous encoding as string
        let string: Data = "\"Named Example <name@example.com>\"".data(using: .utf8)!
        let emailAddress = try JSONDecoder().decode(MailAddress.self, from: string)
        #expect(emailAddress == .address(EmailAddress("name@example.com", label: "Named Example")))
    }
}

// swift-format-ignore
private let data: Data = """
[
    {
        "addresses": [
            {
                "email": "name@example.com",
                "name": "Named Example"
            },
            {
                "email": "noname@example.com"
            }
        ],
        "name": "Named Group"
    },
    {
        "email": "emptyname@example.com",
        "name": ""
    },
    {
        "email": "nullname@example.com",
        "name": null
    },
    {
        "addresses": [
            {
                "email": "noname@example.com"
            }
        ]
    },
    {
        "email": "name@example.com",
        "name": "Named Example"
    }
]
""".data(using: .utf8)!
