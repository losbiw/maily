// UtilFunctions.swift
// Thunderbird
//
// Created by Ashley Soucar on 7/6/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

import Foundation
import SwiftUI

func createAvatarText(displayName: String) -> String {
    let splitName = displayName.split(separator: " ")
    if splitName.count >= 2 {
        let letter = "\(splitName[0].capitalized.first!)\(splitName[1].capitalized.first!)"
        return letter
    } else if (!splitName.isEmpty) {
        return String(splitName[0].capitalized.first!)
    } else {
        return ""
    }
}

func randomizeAvatarColor() -> String {
    let userColors: [String] = [
        "user-red", "user-orange", "user-yellow", "user-green", "user-blue", "user-pink",
        "user-purple"
    ]
    return userColors.randomElement()!
}
