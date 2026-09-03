import Chronomorphism_Derivation
import Testing

@Chronomorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `chronomorphism composes future unfold with historic fold`() {
    let count = Natural.chronomorphism(
        2,
        coalgebra: { seed -> Natural.Base<Natural.Free<Int>> in
            seed == 0 ? .zero : .successor(.pure(seed - 1))
        },
        algebra: {
            (layer: Natural.Base<Natural.Cofree<Int>>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(.cofree(child, _)): child + 1
            }
        }
    )
    #expect(count == 2)
}
