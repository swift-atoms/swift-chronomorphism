import Chronomorphism_Macro_Core
import SwiftParser
import SwiftSyntax
import Testing

private func member(of source: String) throws -> String {
    let file = Parser.parse(source: source)
    let declaration = try #require(
        file.statements.compactMap { $0.item.as(EnumDeclSyntax.self) }.first
    )
    return Derivation.expansion(of: declaration).map(\.description).joined()
}

enum `Access Tests` {}

extension `Access Tests` {
    @Suite
    struct `Chronomorphism access` {
        @Test
        func `a public enum gets a public member`() throws {
            let source = "public indirect enum Count { case zero }"
            #expect(try member(of: source).hasPrefix("public static func"))
        }

        @Test
        func `a package enum gets a package member`() throws {
            let source = "package indirect enum Count { case zero }"
            #expect(try member(of: source).hasPrefix("package static func"))
        }

        @Test
        func `an internal enum gets an internal member`() throws {
            let source = "indirect enum Count { case zero }"
            #expect(try member(of: source).hasPrefix("static func"))
        }
    }
}
