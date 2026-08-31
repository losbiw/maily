// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import MIME
import Testing

struct CharacterTests {
    @Test func entityInit() {
        #expect(Character(entity: "&quot") == "\"")  // Entities are valid without closing semicolon
        #expect(Character(entity: "&nbsp;") == "\u{00a0}")
        #expect(Character(entity: "&cent;") == "¢")
        #expect(Character(entity: "&times;") == "×")
        #expect(Character(entity: "&larr") == "←")
        #expect(Character(entity: "&alpha;") == "α")
        #expect(Character(entity: "&copy") == "©")
        #expect(Character(entity: "&shy;") == nil)  // Real entity with no character value
        #expect(Character(entity: "&foo;") == nil)  // Fake entity
    }
}
