//
//  EmailListView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 10/20/25.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI
import Account

struct EmailListView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    // TODO: replace with actual emails
    let tempEmails = TempEmail.sampleData
    // TODO: why is this even here?
    @State var editMode: EditMode = .inactive
    @State private var selections = Set<UUID>()
    @State private var showDrawer = false
    @State private var path = NavigationPath()

    //Hardcoded for testing
    let attributedString = try? NSMutableAttributedString(
        data: Data(
            """
            <html>
            <body>
            <h2>This is a test email with a bit of text</h2>
            <p>Its doing its best to model how an email might look</p>
            </body>
            </html>
            """.utf8),
        options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil
    )

    func sortEmails() {
        //Not yet implemented
        AlertManager.shared.showAlert = true
        AlertManager.shared.alertTitle = "Sort Emails"
    }

    func selectAll() {
        for tempEmail in tempEmails {
            selections.insert(tempEmail.uuid)
        }
    }

    //TODO: replace with backend unread state call
    func markAllRead() {
        for tempEmail in tempEmails {
            tempEmail.unread = false
            tempEmail.newEmail = false
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                if tempEmails.isEmpty {
                    VStack {
                        Text("empty_inbox")
                            .padding(.bottom, 5)
                        Text("new_messages_will_appear")
                            .padding(.bottom, 10)
                        Button {
                            //Do Nothing
                        } label: {
                            Text("add_another_account")
                        }.buttonBorderShape(.capsule)
                            .buttonStyle(.bordered)
                            .foregroundStyle(.black)
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        List(tempEmails, id: \.uuid, selection: $selections) { email in
                            NavigationLink {
                                ReadEmailView(email)
                            } label: {
                                EmailCellView(email: email)
                            }
                            .contentShape(Rectangle())
                            .simultaneousGesture(
                                LongPressGesture().onEnded { _ in
                                    withAnimation {
                                        editMode = .active
                                    }
                                }
                            )
                            .listRowSeparator(.hidden)
                            .navigationLinkIndicatorVisibility(.hidden)
                        }
                    }.environment(\.editMode, $editMode)
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                }
                Button {
                    path.append("compose")
                } label: {
                    Image("compose")
                        .font(.title.weight(.regular))
                        .padding(.all, 12)
                        .padding(.leading, 5)
                        .background(Color(white: 0.9))
                        .foregroundColor(.muted)
                        .clipShape(Circle())
                }
                .background(.clear)
                .padding()
                .navigationDestination(for: String.self) { destination in
                    if destination == "compose" {
                        ComposeView()
                    }
                }
                DrawerView(showDrawer: $showDrawer)
            }
            .navigationTitle("inbox_header")

            .navigationBarBackButtonHidden(editMode.isEditing)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showDrawer = true
                    } label: {
                        Label("Account", systemImage: "line.3.horizontal").labelStyle(.iconOnly)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    if editMode.isEditing == true {
                        Button(
                            "close_button", systemImage: "xmark",
                            action: {
                                withAnimation {
                                    editMode = .inactive
                                }
                            })
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(
                            "date_sort_button",
                            action: {
                                sortEmails()
                            })
                        Button(
                            "read_status_sort_button",
                            action: {
                                sortEmails()
                            })
                        Button(
                            "has_attachments_sort_button",
                            action: {
                                sortEmails()
                            })
                    } label: {
                        Label("sort_button", systemImage: "line.3.horizontal.decrease", )
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(
                            editMode.isEditing ? "done_button" : "select_all_button",
                            action: {
                                withAnimation {
                                    editMode = editMode.isEditing ? .inactive : .active
                                }
                                selectAll()
                            })
                        Button(
                            "mark_all_read_button",
                            action: {
                                markAllRead()
                            })
                        Button(
                            "account_sign_out_button",
                            action: {
                                accounts.deleteAccounts()
                            })
                    } label: {
                        Label("options_button", systemImage: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview("Email List") {
    @Previewable @State var flags: FeatureFlags = FeatureFlags(distribution: .current)
    @Previewable @State var accounts: Accounts = Accounts()
    EmailListView()
        .environment(flags)
        .environment(accounts)
}
