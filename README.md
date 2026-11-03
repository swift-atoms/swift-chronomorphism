# swift-chronomorphism

Use this package to unfold a seed and fold the result in one pass, when one step of the unfold may produce several layers at once and one step of the fold needs the results of earlier layers, not just the one directly below it. Attach `@Chronomorphism` to a recursive enum that also carries `@FunctorBase`, `@Free` and `@Cofree`; the enum then gets a static `chronomorphism` that takes a seed, a coalgebra and an algebra. If the fold needs only the layer directly below, use the sibling package swift-hylomorphism. If you only unfold, use `@Futumorphism` from swift-futumorphism; if you only fold, use `@Histomorphism` from swift-histomorphism.

## Laws

- No value of the enum itself is built. The unfold and the fold are fused: each layer the coalgebra produces is folded as soon as its children are done.
- The coalgebra runs once for every `pure` seed in the `Free` it returns. A `suspend` layer it returns is folded as it is, without calling the coalgebra again.
- The algebra receives each child as a `Cofree` node: the child's own result (`extract`) together with that child's layer, which holds its children's results in turn, all the way down. A fold can therefore read results from two or more layers below, as Fibonacci does in the tests.
- The result is the algebra's value at the top layer. A seed whose first layer has no children (the base case) runs the algebra exactly once.
- The generated `chronomorphism` is `public` only when the enum is declared `public`; for any other access level it is internal.
- `@Chronomorphism` on anything other than an enum is a compile-time error.
