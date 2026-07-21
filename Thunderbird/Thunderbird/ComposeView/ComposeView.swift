// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct ComposeView: View {
    @State private var demoHtml: String = "<h1>Hello World</h1>"
    @State private var rawText = NSAttributedString(string: "")

    var body: some View {
        EmailBodyView(editable: true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {

                    }) {
                        Image(systemName: "archivebox")
                            .foregroundStyle(.foreground)
                    }
                }
            }
    }
}
