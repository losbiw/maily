// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI
import Account

struct ContentView: View {
    @State private var isPresented: Bool = false
    @State private var hasAuthorization: Bool = false
    @Environment(Accounts.self) private var accounts: Accounts

    // MARK: View
    var body: some View {
        VStack {
            if hasAuthorization {
                EmailListView()
                    .environment(accounts)
            } else {
                NavigationStack {
                    WelcomeScreen($isPresented)
                }
                .sheet(isPresented: $isPresented) {
                    ManualAccount()
                }
                .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: accounts.allAccounts, initial: true) {
            guard !accounts.allAccounts.isEmpty else {
                hasAuthorization = false
                return
            }
            hasAuthorization =
                accounts
                .allAccounts[0].incomingServer?.authorization != nil
                && accounts
                    .allAccounts[0].outgoingServer?.authorization != nil
            isPresented = false
        }
    }
}

#Preview("Content View") {
    @Previewable @State var store: LocalStore = LocalStore()
    @Previewable @State var accounts: Accounts = Accounts(store: store)

    ContentView().environment(accounts)
}
