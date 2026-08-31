// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct NumEntryWrapper: View {

    /// - Parameters:
    ///  - header: The name attached to the entry box
    ///  - suggestionText: The placeholder value for the entry box to give context to the entry field
    ///  - entryText: Binding Int to pass data outside wrapper
    init(
        _ header: LocalizedStringResource,
        _ suggestion: String,
        _ entryText: Binding<Int?>,
    ) {
        headerText = header
        suggestionText = suggestion
        _entryText = entryText
    }

    private var headerText: LocalizedStringResource
    private var suggestionText: String
    @Binding private var entryText: Int?

    // MARK: View
    var body: some View {
        Text(headerText)
            .listRowSeparator(.visible, edges: .bottom)
        TextField(suggestionText, value: $entryText, formatter: NumberFormatter())
            #if os(iOS)
        .keyboardType(.numberPad)
        .listRowSeparator(.hidden)
        .textFieldStyle(.plain)
        .autocapitalization(.none)
            #endif
            .autocorrectionDisabled()
            .focusable()
    }
}
