import Birecursive_Macro_Core
import Cofree_Macro_Core
import Free_Macro_Core
import Futumorphism_Macro_Core
import Histomorphism_Macro_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        var declarations = Birecursive_Macro_Core.Derivation.expansion(of: declaration)
        declarations += Cofree_Macro_Core.Derivation.carrier(of: declaration)
        declarations += Free_Macro_Core.Derivation.carrier(of: declaration)
        declarations += Histomorphism_Macro_Core.Derivation.operation(of: declaration)
        declarations += Futumorphism_Macro_Core.Derivation.operation(of: declaration)
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
