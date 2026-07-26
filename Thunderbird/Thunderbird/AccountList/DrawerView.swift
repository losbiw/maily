//
//  Drawer.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 4/10/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import SwiftUI

struct DrawerView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @Binding var showDrawer: Bool

    // MARK: View
    var body: some View {

        ZStack {
            if showDrawer {
                Button {
                    showDrawer.toggle()
                } label: {
                    Rectangle()
                        .fill(Color.primary.opacity(0.3))
                        .ignoresSafeArea()
                }
                .accessibilityLabel("dismiss")

                HStack {
                    VStack(alignment: .leading) {
                        ScrollView {
                            DrawerContent(showDrawer: $showDrawer)
                        }.toolbar {
                            ToolbarItem(id: "settings", placement: .bottomBar) {
                                NavigationLink(destination: GeneralSettingsView()) {
                                    Text("settings_header")
                                        .foregroundStyle(.black)
                                }
                            }
                            ToolbarItem(placement: .bottomBar) {
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(.surface)
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: showDrawer)
        .toolbar(showDrawer ? .hidden : .visible, for: .navigationBar)
    }
}

#Preview("Account Drawer") {
    @Previewable @State var accounts: Accounts = Accounts()
    @Previewable @State var showDrawer: Bool = true
    DrawerView(showDrawer: $showDrawer).environment(accounts)
}

struct DrawerContent: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @Binding var showDrawer: Bool
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(accounts.allAccounts) { account in
                let mailboxes: MailboxManager = MailboxManager(account: account)
                AccountFolderDisclosureView().environment(mailboxes)
            }
        }
    }
}
