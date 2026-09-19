public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)static func chronomorphism<Seed, Result>(
                _ seed: Seed,
                coalgebra: (Seed) -> Base<Free<Seed>>,
                algebra: (Base<Cofree<Result>>) -> Result
            ) -> Result {
                func history(_ future: Free<Seed>) -> Cofree<Result> {
                    future.fold(
                        pure: { history(.suspend(coalgebra($0))) },
                        suspend: { layer in .cofree(algebra(layer), layer) }
                    )
                }
                return history(.pure(seed)).extract
            }
            """]
    }
}
