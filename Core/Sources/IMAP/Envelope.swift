// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import EmailAddress
import Foundation
import MIME
import NIOIMAPCore

public struct Envelope: Sendable {
    public let subject: String?
    public let date: InternetMessageDate?
    public let from: [MailAddress]
    public let sender: [MailAddress]
    public let reply: [MailAddress]
    public let to: [MailAddress]
    public let cc: [MailAddress]
    public let bcc: [MailAddress]
    public let inReplyTo: String?
    public let messageID: String?

    public init(
        subject: String? = nil,
        date: InternetMessageDate? = nil,
        from: [MailAddress] = [],
        sender: [MailAddress] = [],
        reply: [MailAddress] = [],
        to: [MailAddress] = [],
        cc: [MailAddress] = [],
        bcc: [MailAddress] = [],
        inReplyTo: String? = nil,
        messageID: String? = nil,
    ) {
        self.subject = subject
        self.date = date
        self.from = from
        self.sender = sender
        self.reply = reply
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.inReplyTo = inReplyTo
        self.messageID = messageID
    }

    init(_ envelope: NIOIMAPCore.Envelope) {
        subject = try? envelope.subject?.readableBytesView.description.headerDecoded()
        from = envelope.from.addresses
        sender = envelope.sender.addresses
        reply = envelope.reply.addresses
        to = envelope.to.addresses
        cc = envelope.cc.addresses
        bcc = envelope.bcc.addresses
        inReplyTo = String(envelope.inReplyTo)
        messageID = String(envelope.messageID)
        date = try? InternetMessageDate(internetMessageDate: envelope.date)
    }
}

extension String {
    init?(_ messageID: NIOIMAPCore.MessageID?) {
        guard let messageID else {
            return nil
        }
        self.init(messageID)
    }
}
