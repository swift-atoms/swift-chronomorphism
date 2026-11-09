public import SwiftSyntax
import SwiftSyntaxBuilder
import Type_Algebra_Syntax

public enum Derivation {}

extension Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = Type.Syntax.Recursion.access(of: declaration)
        return [
            """
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
            """
        ]
    }
}
