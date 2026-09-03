import Birecursive_Derivation_Core
import Cofree_Derivation_Core
import Free_Derivation_Core
import Futumorphism_Derivation_Core
import Histomorphism_Derivation_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        var declarations = Birecursive_Derivation_Core.Derivation.expansion(of: declaration)
        declarations += Cofree_Derivation_Core.Derivation.carrier(of: declaration)
        declarations += Free_Derivation_Core.Derivation.carrier(of: declaration)
        declarations += Histomorphism_Derivation_Core.Derivation.operation(of: declaration)
        declarations += Futumorphism_Derivation_Core.Derivation.operation(of: declaration)
        declarations += operation(of: declaration)
        return declarations
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)static func chronomorphism<Seed, Result>(
                _ seed: Seed,
                coalgebra: (Seed) -> Base<Free<Seed>>,
                algebra: (Base<Cofree<Result>>) -> Result
            ) -> Result {
                futumorphism(seed, coalgebra).histomorphism(algebra)
            }
            """]
    }
}
