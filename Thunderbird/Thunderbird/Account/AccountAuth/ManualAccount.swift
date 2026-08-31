// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import SwiftUI

struct ManualAccount: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var loginDetails: LoginDetails = LoginDetails()
    @State private var path: NavigationPath = NavigationPath()

    // MARK: View
    var body: some View {
        NavigationStack(path: $path) {
            AccountInformation($path)
                .environment(loginDetails)
                .environment(accountManager)
                .toolbarRole(.editor)
                .toolbar {
                    ToolbarItem(id: "navBar", placement: .cancellationAction) {
                        Button(
                            "close_button", systemImage: "xmark",
                            action: {
                                dismiss()
                            })
                    }
                }
                .onChange(of: accountManager.allAccounts.count) {
                    dismiss()
                }
                .navigationBarBackButtonHidden()
                .navigationDestination(for: String.self) { destination in
                    if destination == "EmailAccountTypeSelection" {
                        EmailAccountTypeSelection($path).toolbarRole(.editor).environment(loginDetails)
                    }
                    if destination == "ManualAccountSetup" {
                        if loginDetails.inProgressAccount == nil {
                            ManualServerSetup(loginDetails)
                                .toolbarRole(.editor)
                                .environment(accountManager)
                                .environment(loginDetails)
                        } else {
                            ManualServerSetup(loginDetails)
                                .toolbarRole(.editor)
                                .environment(accountManager)
                                .environment(loginDetails)
                        }
                    }
                }
        }.accentColor(.gray)
    }
}

#Preview("Manual Account Setup") {
    @Previewable @State var getStarted: Bool = false
    @Previewable @State var store = LocalStore()
    @Previewable @State var accountManager = AccountManager(store: store)

    ManualAccount()
        .environment(accountManager)
        .sheet(isPresented: $getStarted) {
            EmptyView()
                .presentationDragIndicator(.visible)
        }
}

private struct Background: View {

    // MARK: View
    var body: some View {
        GeometryReader { proxy in
            Image.background
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .opacity(proxy.size.width > 444.0 ? 0.0 : 1.0)
        }
        .ignoresSafeArea()
    }
}

private extension Image {
    static var background: Self { Self("Welcome/Background") }
    static var logo: Self { Self("Welcome/Logo") }
}

@Observable
class LoginDetails {
    var inProgressAccount: Account?
    var enteredEmail: String
    var serverProtocol: ServerProtocol?

    init(inProgressAccount: Account? = nil, enteredEmail: String = "", serverProtocol: ServerProtocol? = nil) {
        self.inProgressAccount = inProgressAccount
        self.enteredEmail = enteredEmail
        self.serverProtocol = serverProtocol
    }
}
