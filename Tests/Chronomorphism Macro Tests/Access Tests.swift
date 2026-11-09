import Chronomorphism_Macro_Core
import SwiftParser
import SwiftSyntax
import Testing

private func member(of source: String) -> String? {
    Parser.parse(source: source).statements
        .compactMap { $0.item.as(EnumDeclSyntax.self) }
        .first
        .map { Derivation.expansion(of: $0).map(\.description).joined() }
}

enum `Access Tests` {}

extension `Access Tests` {
    @Suite
    struct `Chronomorphism access` {
        @Test
        func `a public enum gets a public member`() {
            let source = "public indirect enum Count { case zero }"
            #expect(member(of: source)?.hasPrefix("public static func") == true)
        }

        @Test
        func `a package enum gets a package member`() {
            let source = "package indirect enum Count { case zero }"
            #expect(member(of: source)?.hasPrefix("package static func") == true)
        }

        @Test
        func `an internal enum gets an internal member`() {
            let source = "indirect enum Count { case zero }"
            #expect(member(of: source)?.hasPrefix("static func") == true)
        }
    }
}
