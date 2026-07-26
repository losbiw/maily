// UnreadCounter.swift
// Thunderbird
//
// Created by Ashley Soucar on 7/14/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

import SwiftUI

struct UnreadCounter: View {
    @State var unreadCount: Int = 0
    @State var hasNew: Bool = false
    var body: some View {
        Text("\(unreadCount)")
            .font(.caption2)
            .padding(.horizontal, 6)
            .foregroundColor(hasNew ? .accent : .white)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        (hasNew ? .accent : .white),
                        style: StrokeStyle(
                            lineWidth: 1
                        )
                    )
                    .fill(hasNew ? .white : .accent)
                    .frame(width: 20, height: 17)
            }
    }
}

#Preview {
    UnreadCounter(unreadCount: 8, hasNew: false)
}
