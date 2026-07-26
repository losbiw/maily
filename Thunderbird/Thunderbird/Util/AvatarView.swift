// AvatarView.swift
// Thunderbird
//
// Created by Ashley Soucar on 6/30/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

import SwiftUI
import EmailAddress

struct AvatarView: View {
    private var avatarText: String = ""
    private var bubbleColor: Color = .clear

    init(displayName: String, bubbleColor: Color) {
        if (!displayName.isEmpty && !displayName.isEmailAddress) {
            avatarText = createAvatarText(displayName: displayName)
        } else if (displayName.isEmailAddress) {
            avatarText = String(displayName.first!).capitalized
        }
        self.bubbleColor = bubbleColor
    }

    var body: some View {
        Text(avatarText)
            .font(.body)
            .overlay {
                Circle()
                    .stroke(
                        bubbleColor,
                        style: StrokeStyle(
                            lineWidth: 1
                        )
                    )
                    .fill(bubbleColor.opacity(0.15))
                    .padding(3)
                    .frame(width: 40, height: 40)

            }
    }
}

#Preview {
    AvatarView(
        displayName: "blakls ddfas",
        bubbleColor: Color(randomizeAvatarColor())
    )
}
