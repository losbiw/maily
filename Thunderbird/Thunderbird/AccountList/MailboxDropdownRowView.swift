//
//  MailboxDropdownRowView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 5/7/26.
//

import Account
import SwiftUI

let iconShapes = FolderIconShapes()
struct MailboxDropdownRowView: View {
    @State var isExpanded: Bool = false
    var mailbox: Mailbox

    //TODO: Subfolders and 'new' are not fully implemented
    var tempHasSubfolders: Bool = false
    var tempHasNew: Bool = false

    var body: some View {
        if tempHasSubfolders {
            DisclosureGroup(isExpanded: $isExpanded) {
                //TODO: Eventual subfolder
            } label: {
                HStack {
                    (iconSwitcher(folderName: mailbox.name, tinted: tempHasNew)).frame(width: 24, height: 24)
                    Text(mailbox.name)
                        .foregroundStyle(.black)
                    Spacer()
                    if (!isExpanded && mailbox.unreadEmails! > 0) {
                        UnreadCounter(unreadCount: mailbox.unreadEmails ?? 0, hasNew: false)
                    }
                }
            }.padding(.horizontal)
                .font(.subheadline)
        } else {
            HStack {
                (iconSwitcher(folderName: mailbox.name, tinted: tempHasNew)).frame(width: 24, height: 24)
                Text(mailbox.name)
                    .foregroundStyle(.black)
                Spacer()
                if mailbox.unreadEmails! > 0 {
                    UnreadCounter(unreadCount: mailbox.unreadEmails ?? 0, hasNew: !tempHasNew)
                }
            }
            .onTapGesture {
                //TODO: Load relevant email list
            }
            .padding(.horizontal)
            .font(.subheadline)
        }

    }
}

#Preview {
    @Previewable @State var accounts: Accounts = Accounts()
    @Previewable @State var mailbox: Mailbox = Mailbox("Inbox", unreadEmails: 2)
    MailboxDropdownRowView(mailbox: mailbox).environment(accounts)
}

@ViewBuilder func iconSwitcher(folderName: String, tinted: Bool) -> some View {

    switch iconName(folderName: folderName) {
    case "inbox":
        tinted ? iconShapes.inboxPathTinted : iconShapes.inboxPath
    case "archive":
        tinted ? iconShapes.archivePathTinted : iconShapes.archivePath
    case "draft":
        tinted ? iconShapes.draftPathTinted : iconShapes.draftPath
    case "sent":
        tinted ? iconShapes.sentPathTinted : iconShapes.sentPath
    case "spam":
        tinted ? iconShapes.spamPathTinted : iconShapes.spamPath
    case "trash":
        tinted ? iconShapes.trashPathTinted : iconShapes.trashPath
    default:
        tinted ? iconShapes.folderPathTinted : iconShapes.folderPath
    }
}

func iconName(folderName: String) -> String {
    let localizedFolderIconNames: [String: String] = [
        "inbox": "inbox_localized",
        "archive": "archive_localized",
        "draft": "draft_localized",
        "sent": "sent_localized",
        "spam": "spam_localized",
        "trash": "trash_localized"
    ]
    for (icon, localizedName) in localizedFolderIconNames {
        if (folderName
            .localizedCaseInsensitiveContains(icon)
            || folderName
                .localizedCaseInsensitiveContains(localizedName))
        {
            return icon
        }
    }
    return "folder"
}
