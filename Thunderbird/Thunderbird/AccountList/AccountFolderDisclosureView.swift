// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import SwiftUI

struct AccountFolderDisclosureView: View {
    @Environment(MailboxManager.self) private var mailboxManager: MailboxManager
    @State private var isExpanded: Bool = false
    @State private var unreadCount: Int = 0

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(mailboxManager.mailboxes) { mailbox in
                HStack {
                    MailboxDropdownRowView(mailbox: mailbox)
                }
            }
            .padding(.vertical, 10)
        } label: {
            HStack {
                AvatarView(
                    displayName: mailboxManager.account.name,
                    bubbleColor: Color(mailboxManager.account.avatarColor)
                )
                VStack(alignment: .leading) {
                    Text(mailboxManager.account.name)
                        .font(.body)
                        .truncationMode(.middle)
                    if (!mailboxManager.account.name.isEmailAddress) {
                        Text(mailboxManager.account.identities[0].email)
                            .font(.caption2)
                            .truncationMode(.middle)
                    }
                }.padding(.horizontal)
                    .foregroundStyle(.black)
                Spacer()
                if (!isExpanded && unreadCount > 0) {
                    UnreadCounter(unreadCount: unreadCount, hasNew: false)
                }
            }.padding(.vertical, 10)
                .safeAreaPadding(.horizontal)
        }.task {
            for mailbox in mailboxManager.mailboxes {
                unreadCount += mailbox.unreadEmails!
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    @Previewable @State var mailboxes: MailboxManager = MailboxManager(account: Account("temp@email.com"))

    AccountFolderDisclosureView()
        .environment(mailboxes)
}
