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
    @Environment(SessionManager.self) private var session: SessionManager
    
    @State private var selections = Set<String>()
    @State private var path = NavigationPath()
    @State private var emails: [Email] = []
    
    // MARK: UI State
    @State private var showDrawer = false
    @State var editMode: EditMode = .inactive
    @State var error: Error?
        
    func sortEmails(by strategy: SortStrategy) {
        //Not yet implemented
        AlertManager.shared.showAlert = true
        AlertManager.shared.alertTitle = "Sort Emails"
    }

    func selectAll() {
        for email in emails {
            selections.insert(email.id)
        }
    }

    //TODO: replace with backend unread state call
    func markAllRead() {
        for email in emails {
            email.unread = false
            email.newEmail = false
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                if emails.isEmpty {
                    VStack {
                        Text("empty_inbox")
                            .padding(.bottom, 5)
                        Text("new_messages_will_appear")
                            .padding(.bottom, 10)
                        Button {
                            // TODO: trigger login flow
                        } label: {
                            Text("add_another_account")
                        }.buttonBorderShape(.capsule)
                            .buttonStyle(.bordered)
                            .foregroundStyle(.black)
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        List(emails, id: \.id, selection: $selections) { email in
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
                        
                        ProgressView()
                            .progressViewStyle(.circular)
                            .onAppear {
                                do {
                                    let oldestEmail = emails.first!
                                    let additionalEmails = try session.loadEmails(cursor: oldestEmail.uid)
                                    
                                    emails.append(contentsOf: additionalEmails)
                                } catch {
                                    self.error = error
                                }
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
                    .environment(session)
            }
            .navigationTitle("inbox_header")
            
            .navigationBarBackButtonHidden(editMode.isEditing)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            showDrawer = true
                        }
                    } label: {
                        Label("account", systemImage: "line.3.horizontal")
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
                                sortEmails(by: .date)
                            })
                        Button(
                            "read_status_sort_button",
                            action: {
                                sortEmails(by: .status)
                            })
                        Button(
                            "has_attachments_sort_button",
                            action: {
                                sortEmails(by: .hasAttachments)
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
                                do {
                                    try session.deleteCurrentAccount()
                                } catch {
                                    self.error = error
                                }
                            })
                    } label: {
                        Label("options_button", systemImage: "ellipsis")
                    }
                }
            }
        }
        .onChange(of: session.selectedMailbox, initial: true) {
            do {
                emails = try session.loadEmails()
            } catch {
                self.error = EmailError.failedToLoad(error)
            }
        }
    }
}

public enum EmailError: Error {
    case failedToLoad(Error)
}

public enum SortStrategy {
    case date
    case status
    case hasAttachments
}

#Preview("Email List") {
    @Previewable @State var flags: FeatureFlags = FeatureFlags(distribution: .current)
    @Previewable @State var store = LocalStore()
    @Previewable @State var accountManager = AccountManager(store: store)
    
    EmailListView()
        .environment(flags)
        .environment(accountManager)
}
