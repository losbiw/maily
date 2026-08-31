// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension String {
    func inlining(attachments: [EmailAttachment]) -> Self {
        var string: Self = self
        for attachment in attachments {
            string = string.inlining(attachment: attachment)
        }
        return string
    }

    func inlining(attachment: EmailAttachment) -> Self {
        var string: Self = self
        for link in attachment.links {
            string = string.replacingOccurrences(of: link, with: URL(attachment: attachment).absoluteString)
        }
        return string
    }

    typealias HTMLAttribute = (name: Self, value: Self)

    func htmlAttributes() -> [HTMLAttribute] {

        // Source - https://stackoverflow.com/a/317081
        // Posted by VonC, modified by community
        // Retrieved 2026-08-14, License - CC BY-SA 4.0
        matches(of: /([\w|data-]+)=["']?((?:.(?!["']?\s+(?:\S+)=|\s*\/?[>"']))+.)["']?/)
            .map { ("\($0.1)", "\($0.2)") }
    }

    func htmlTagsStripped() -> Self {
        replacing(/<[^>]*>/, with: "")
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }
}
