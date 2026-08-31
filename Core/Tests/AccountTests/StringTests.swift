// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
@testable import Account
import Testing

struct StringTests {
    @Test func htmlAttributes() {
        let attributes: [String.HTMLAttribute] = _htmlAttributes.htmlAttributes()
        #expect(attributes.count == 19)
        #expect(attributes.filter({ $0.name == "href" }).count == 3)
        #expect(attributes.filter({ $0.name == "href" }).first?.value == "test.html")
        #expect(attributes.filter({ $0.name == "href" }).last?.value == "test.html")
        #expect(attributes.filter({ $0.name == "src" }).count == 8)
        #expect(attributes.filter({ $0.name == "src" }).first?.value == "test.png")
        #expect(attributes.filter({ $0.name == "src" }).last?.value == "a test.png")
    }

    @Test func htmlTagsStripped() {
        #expect(_htmlTagsStripped.htmlTagsStripped() == "Desktop Help\nFind the help you need configuring and using Thunderbird Desktop.")
    }
}

// swift-format-ignore
private let _htmlAttributes: String = """
<!-- Source - https://stackoverflow.com/a/317081
     Posted by VonC, modified by community
     Retrieved 2026-08-14, License - CC BY-SA 4.0 -->
<a href=test.html class=xyz>
<a href="test.html" class="xyz">
<a href='test.html' class="xyz">
<script type="text/javascript" defer async id="something" onload="alert('hello');"></script>
<img src="test.png">
<img src="a test.png">
<img src=test.png />
<img src=a test.png />
<img src=test.png >
<img src=a test.png >
<img src=test.png alt=crap >
<img src=a test.png alt=crap >
"""

// swift-format-ignore
private let _htmlTagsStripped: String = """
<div class="entry-text">
    <h2 aria-label="Desktop Help.">Desktop Help</h2>
    <h6>Find the help you need configuring and using Thunderbird Desktop.</h6>
</div>
"""
