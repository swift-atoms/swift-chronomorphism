import Cofree_Macro
import Corecursive_Macro
import Free_Macro
import Functor_Base_Macro
import Futumorphism_Macro
import Histomorphism_Macro
import Recursive_Macro
import Chronomorphism_Macro
import Testing

@Cofree
@Corecursive
@Free
@FunctorBase
@Futumorphism
@Histomorphism
@Recursive
@Chronomorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

private func fibonacci(of seed: Int) -> Int {
    Count.chronomorphism(
        seed,
        coalgebra: { seed -> Count.Base<Count.Free<Int>> in
            seed == 0 ? .zero : .successor(.pure(seed - 1))
        },
        algebra: { (layer: Count.Base<Count.Cofree<Int>>) -> Int in
            switch layer {
            case .zero: 0
            case .successor(.cofree(_, .zero)): 1
            case let .successor(.cofree(previous, .successor(.cofree(beforePrevious, _)))): previous + beforePrevious
            }
        }
    )
}

@Suite
struct `Chronomorphism boundaries` {
    @Test
    func `a seed that stops at once folds the base case`() {
        #expect(fibonacci(of: 0) == 0)
        #expect(fibonacci(of: 1) == 1)
    }

    @Test
    func `the fold sees two layers of the unfolded history`() {
        #expect(fibonacci(of: 10) == 55)
    }
}
