// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI
import Account

struct ContentView: View {
    @State private var isSetupShown: Bool = false
    @State private var hasAuthorization: Bool = false
    
    @Environment(SessionManager.self) private var session: SessionManager
    @Environment(AccountManager.self) private var accountManager: AccountManager

    // MARK: View
    var body: some View {
        VStack {
            if hasAuthorization {
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
        .onChange(of: session.selectedAccount, initial: true) {
            let acc = session.selectedAccount
            
            guard acc != nil else {
                hasAuthorization = false
                return
            }
            
            hasAuthorization =
                acc?.incomingServer?.authorization != nil
                && acc?.outgoingServer?.authorization != nil
            
            isSetupShown = false
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
