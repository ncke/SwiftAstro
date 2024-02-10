import Foundation

// MARK: - String Comprehension

extension String {

    /// Returns true if the string contains the given character, false otherwise.
    func containsCharacter(_ character: Character) -> Bool {
        self.first { c in c == character } != nil
    }

    /// Returns an extracted string beginning at the `n`-th character if it has non-whitespace
    /// content, nil otherwise.
    /// - Note: `n` is 1-based.
    func cols(_ n: Int) -> String? {
        guard n > 0, let substr = excerpt(n-1) else { return nil }
        let str = substr.trimmingCharacters(in: .whitespaces)
        guard !str.isEmpty else { return nil }

        return str
    }

    /// Returns an extracted string beginning at the `n`-th character and extending for `len`
    /// characters if it has non-whitespace content, nil otherwise.
    /// - Note: `n` is 1-based.
    func cols(_ n: Int, _ len: Int) -> String? {
        guard n > 0, let substr = excerpt(n-1, len) else { return nil }
        let str = substr.trimmingCharacters(in: .whitespaces)
        guard !str.isEmpty else { return nil }

        return str
    }

    /// Returns the integer contained in the substring beginning at the `n`-th character and
    /// extending for `len`characters, or nil if not an integer.
    /// - Note: `n` is 1-based.
    func cols(_ n: Int, _ len: Int) -> Int? {
        guard n > 0, let substr = excerpt(n-1, len) else { return nil }
        let str = substr.trimmingCharacters(in: .whitespaces)
        guard !str.isEmpty else { return nil }

        return Int(str)
    }

    /// Returns the double contained in the substring beginning at the `n`-th character and
    /// extending for `len` characters, or nil if not a double.
    /// - Note: `n` is 1-based.
    func cols(_ n: Int, _ len: Int) -> Double? {
        guard n > 0, let substr = excerpt(n-1, len) else { return nil }
        let str = substr.trimmingCharacters(in: .whitespaces)
        guard !str.isEmpty else { return nil }

        return Double(str)
    }

}

// MARK: - Excerpting

fileprivate extension String {

    /// Returns the `Substring` beginning at the `n`-th character and continuing
    /// for a length of `len` characters, or nil if not in bounds.
    func excerpt(_ n: Int, _ len: Int) -> Substring? {
        guard
            let start = self.index(
                self.startIndex,
                offsetBy: n,
                limitedBy: self.endIndex),
            let finish = self.index(
                self.startIndex,
                offsetBy: n + len,
                limitedBy: self.endIndex)
        else {
            return nil
        }

        let excerpt = self[start..<finish]
        return excerpt
    }

    /// Returns the `Substring` beginning at the `n`-th character and continuing
    /// for a length of `len` characters, or nil if not in bounds.
    func excerpt(_ n: Int) -> Substring? {
        guard let start = self.index(
            self.startIndex,
            offsetBy: n,
            limitedBy: self.endIndex)
        else {
            return nil
        }

        let finish = self.endIndex
        let excerpt = self[start..<finish]
        return excerpt
    }

}
