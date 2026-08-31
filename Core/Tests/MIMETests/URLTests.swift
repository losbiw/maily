// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
@testable import MIME
import Testing

struct URLTests {
    @Test func messageIDInit() throws {
        #expect(try URL(messageID: MessageID("<1762463150.A51D5B17@example.com>")).absoluteString == "mid:1762463150.A51D5B17@example.com")
        #expect(
            try URL(
                messageID: MessageID("<1762463150.A51D5B17@example.com>"),
                contentID: ContentID("part1.example.1762463150.A51D5B17")
            ).absoluteString == "mid:1762463150.A51D5B17@example.com/part1.example.1762463150.A51D5B17"
        )
        #expect(throws: MIMEError.headerValueNotASCII) {
            try URL(messageID: MessageID("not.æscii"))
        }
    }

    @Test func contentIDInit() throws {
        #expect(try URL(contentID: ContentID("<1762463150.A51D5B17@example.com>")).absoluteString == "cid:1762463150.A51D5B17@example.com")
        #expect(try URL(contentID: ContentID("part1.example.1762463150.A51D5B17")).absoluteString == "cid:part1.example.1762463150.A51D5B17")
        #expect(throws: MIMEError.headerValueNotASCII) {
            try URL(contentID: ContentID("not.æscii"))
        }
    }

    @Test func contentDispositionInit() throws {
        #expect(try URL(contentDisposition: .attachment(ContentDisposition.File(filename: "example-filename.zip"))).absoluteString == "example-filename.zip")
        #expect(try URL(contentDisposition: .inline(ContentDisposition.File(filename: "A51D5B17"))).absoluteString == "A51D5B17")
        #expect(throws: URLError.self) {
            try URL(contentDisposition: .attachment)
        }
    }
}
