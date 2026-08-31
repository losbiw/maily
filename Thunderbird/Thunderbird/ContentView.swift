// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import SwiftUI

struct ContentView: View {
    @Environment(SessionManager.self) private var session: SessionManager
    @Environment(AccountManager.self) private var accountManager: AccountManager

    @State private var isSetupShown: Bool = false

    // MARK: View
    var body: some View {
        VStack {
            if accountManager.allAccounts.count > 0 {
                EmailListView()
                    .environment(session)
            } else {
                NavigationStack {
                    WelcomeScreen($isSetupShown)
                }
                .sheet(isPresented: $isSetupShown) {
                    ManualAccount()
                        .environment(accountManager)
                }
                .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: accountManager.allAccounts, initial: true) {
            if (isSetupShown) {
                isSetupShown = false
            }
        }.task {
            do {
                try await accountManager.checkAndRenewExpirations()
            } catch {
                print("OAuth Expiration refresh error: \(error)")
            }
        }
    }
}

#Preview("Content View") {
    @Previewable @State var store = LocalStore()
    @Previewable @State var accountManager = AccountManager(store: store)
    @Previewable @State var session = SessionManager(store: store, accountManager: accountManager)

    ContentView()
        .environment(session)
        .environment(accountManager)
}
