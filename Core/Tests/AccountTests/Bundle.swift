// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension Bundle {
    func data(forResource name: String?, withExtension ext: String? = nil) throws -> Data {
        guard let url: URL = url(forResource: name, withExtension: ext) else {
            throw URLError(.fileDoesNotExist)
        }
        return try Data(contentsOf: url)
    }
}
