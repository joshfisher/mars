import Foundation

// MARK: - SequenceType -

extension SequenceType {
    
    /**
    Determines whether all elements of the structure satisfy the predicate.
    
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: `true` if all elements pass the predicate check, else `false`.
    
    ```
    [2, 4, 6, 8, 10].all(isEven)
    
    true
    ```
    */
    @warn_unused_result
    public func all(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        return !contains({!predicate($0)})
    }
    
    /**
    Determines whether any element of the structure satisfies the predicate.
    
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: `true` if any element passes the predicate check, else `false`.
    
    ```
    [1, 2, 3, 4, 5].all(isEven)
    
    true
    ```
    */
    @warn_unused_result
    public func any(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        return contains(predicate)
    }
    
    /**
    - returns: A sequence that repeats this sequence indefinitely.
    
    ```
    [1, 2, 3].cycle().prefix(5)
    
    [1, 2, 3, 1, 2]
    ```
    */
    @warn_unused_result
    public func cycle() -> CycleSequence<Self.Generator.Element> {
        return CycleSequence(sequence: AnySequence(self))
    }
    
    /**
    - parameter count: The number of elements to skip.
    
    - returns: A sequence containing all but the first `n` elements.
    
    ```
    [1, 2, 3, 4, 5].drop(3)
    
    [4, 5]
    ```
    */
    @warn_unused_result
    public func drop(count: Int) -> [Self.Generator.Element] {
        var i = count
        var generator = generate()
        while i-- > 0 && generator.next() != nil {}
        return Array(GeneratorSequence(generator))
    }
    
    /**
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: A sequence containing all but the initial elements that pass the predicate.
    
    ```
    [2, 4, 6, 7, 8].dropWhile(isEven)
    
    [7, 8]
    ```
    */
    @warn_unused_result
    public func dropWhile(@noescape predicate: (Self.Generator.Element) -> Bool) -> [Self.Generator.Element] {
        var generator = generate()
        while let element = generator.next() {
            if (!predicate(element)) {
                return [element] + GeneratorSequence(generator)
            }
        }
        return []
    }
    
    /**
    Finds the first element in the sequence that passes the predciate.
    
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: The element optionally.
    
    ```
    [1, 2, 3, 4, 5].first({$0 > 3})
    
    Optional.Some(4)
    ```
    */
    @warn_unused_result
    public func first(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        var result: Self.Generator.Element? = nil
        var generator = generate()
        while let element = generator.next() {
            if (predicate(element)) {
                result = element;
                break;
            }
        }
        return result
    }
    
    /**
    Partitions the sequence into an array of arrays where each array contains equal neighboring elements from the intial sequence. Flattening the returned array would be equal to the intial sequence.
    
    - parameter predicate: The equality check to perform on neighboring elements in the sequence.
    
    - returns: The partitioned sequence.
    
    ```
    [1, 1, 2, 2, 3, 1].groupBy(==)
    
    [[1, 1], [2, 2], [3], [1]]
    ```
    */
    @warn_unused_result
    public func groupBy(@noescape predicate: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [[Self.Generator.Element]] {
        var groupedItems: [[Self.Generator.Element]] = []
        var currentGroup: [Self.Generator.Element] = []
        var previousItem: Self.Generator.Element? = nil
        
        for item in self {
            if previousItem == nil || predicate(previousItem!, item) {
                currentGroup.append(item)
            }
            else {
                groupedItems.append(currentGroup)
                currentGroup = [item]
            }
            previousItem = item
        }
        
        if currentGroup.count != 0 {
            groupedItems.append(currentGroup)
        }
        
        return groupedItems
    }
    
    /**
    Finds the last element in the sequence that passes the predciate.
    
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: The element optionally.
    
    ```
    [1, 2, 3, 4, 5].last({$0 > 3})
    
    Optional.Some(5)
    ```
    */
    @warn_unused_result
    public func last(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        var result: Self.Generator.Element? = nil
        for element in reverse() {
            if (predicate(element)) {
                result = element;
                break;
            }
        }
        return result
    }
    
    /**
    - parameter combine: The reduction step to perform on each element in the sequence.
    
    - returns: The result of repeatedly calling `combine` with an accumulated value initialized to the first element in the sequence and each element of `self`, in turn.
    
    ```
    [1, 2, 3, 4, 5].reduce(+)
    
    15
    ```
    */
    @warn_unused_result
    public func reduce(@noescape combine: (Self.Generator.Element, Self.Generator.Element) -> Self.Generator.Element) -> Self.Generator.Element? {
        var generator = generate()
        let result = generator.next().map({(start) -> Generator.Element in
            var accumulator = start
            while let element = generator.next() {
                accumulator = combine(accumulator, element)
            }
            return accumulator
        })
        
        return result
    }
    
    /**
    - parameter initial: The initial value of the accumulator.
    - parameter combine: The reduction step to perform on each element in the sequence.
    
    - returns: An array of the intermediate results of calling `combine` on successive elements of self and an accumulated value.
    
    - note: The last element in the array will be the same as the result of calling `reduce`.
    
    ```
    [1, 2, 3, 4, 5].scan(0, +)
    
    [0, 1, 3, 6, 10, 15]
    ```
    */
    @warn_unused_result
    public func scan<T>(initial: T, @noescape combine: (T, Self.Generator.Element) -> T) -> [T] {
        var results = [initial]
        var generator = generate()
        while let element = generator.next() {
            results.append(combine(results.last!, element))
        }
        return results
    }
    
    /**
    - parameter combine: The reduction step to perform on each element in the sequence.
    
    - returns: An array of the intermediate results of calling `combine` on successive elements of self and an accumulated value that is implictly set to the first elemnt in the sequence.
    
    - note: The last element in the array will be the same as the result of calling `reduce`.
    
    ```
    [1, 2, 3, 4, 5].scan(+)
    
    [1, 3, 6, 10, 15]
    ```
    */
    @warn_unused_result
    public func scan(@noescape combine: (Self.Generator.Element, Self.Generator.Element) -> Self.Generator.Element) -> [Self.Generator.Element] {
        var generator = generate()
        let result = generator.next().map({(start) -> [Generator.Element] in
            var results = [start]
            while let element = generator.next() {
                results.append(combine(results.last!, element))
            }
            return results
        })
        
        return result ?? []
    }

    /**
    - parameter count: The number of elements to skip.
    
    - returns: A sequence containing the first `n` elements.
    
    ```
    [1, 2, 3, 4, 5].take(3)
    
    [1, 2, 3]
    ```
    */
    @warn_unused_result
    public func take(count: Int) -> [Self.Generator.Element] {
        var i = count
        var result: [Self.Generator.Element] = []
        var generator = generate()
        while let element = generator.next() where i-- > 0 {
            result.append(element)
        }
        return result
    }
    
    /**
    - parameter predicate: The check to perform on each element in the sequence.
    
    - returns: A sequence containing the initial elements that pass the predicate.
    
    ```
    [2, 4, 6, 7, 8].takeWhile(isEven)
    
    [2, 4, 6]
    ```
    */
    @warn_unused_result
    public func takeWhile(@noescape predicate: (Self.Generator.Element) -> Bool) -> [Self.Generator.Element] {
        var result: [Self.Generator.Element] = []
        var generator = generate()
        while let element = generator.next() where predicate(element) {
            result.append(element)
        }
        return result
    }
    
    /**
    Creates a sequence of pairs built out of two underlying sequences, where the elements of the `i`th pair are the `i`th elements of each underlying sequence.
    
    - parameter sequence: The other sequence to zip with `self`.
    
    - returns: The sequence of pairs.
    
    ```
    [1, 3, 5].zip([2, 4, 6])
    
    [(1, 2), (3, 4), (5, 6)]
    ```
    */
    @warn_unused_result
    public func zip<Sequence: SequenceType>(sequence: Sequence) -> GeneratorSequence<Zip2Generator<Self.Generator, Sequence.Generator>> {
        return GeneratorSequence(Zip2Generator(generate(), sequence.generate()))
    }
    
    /**
    Creates a sequence of tuples built out of three underlying sequences, where the elements of the `i`th tuple are the `i`th elements of each underlying sequence.
    
    - parameter sequence1: The first sequence to zip with `self`.
    - parameter sequence2: The second sequence to zip with `self`.
    
    - returns: The sequence of tuples.
    
    ```
    [1, 4, 7].zip([2, 5, 8], [3, 6, 9])
    
    [(1, 2, 3), (4, 5, 6), (7, 8, 9)]
    ```
    */
    @warn_unused_result
    public func zip<Sequence1: SequenceType, Sequence2: SequenceType>(sequence1: Sequence1, _ sequence2: Sequence2) -> GeneratorSequence<Zip3Generator<Self.Generator, Sequence1.Generator, Sequence2.Generator>> {
        return GeneratorSequence(Zip3Generator(generate(), sequence1.generate(), sequence2.generate()))
    }
}

extension SequenceType where Self.Generator.Element: Equatable {
    /**
    A convenience method that calls groupBy(==) for sequences where the elements are `Equatable`
    
    - returns: The partitioned sequence
    
    ```
    [1, 1, 2, 2, 3, 1].group()
    
    [[1, 1], [2, 2], [3], [1]]
    ```
    */
    @warn_unused_result
    public func group() -> [[Self.Generator.Element]] {
        return groupBy(==)
    }
}

// MARK: - Cycle -

public struct CycleSequence<T>: SequenceType {
    
    public let sequence: AnySequence<T>
    
    public init(sequence: AnySequence<T>) {
        self.sequence = sequence
    }
    
    public func generate() -> CycleGenerator<T> {
        return CycleGenerator(sequence: sequence)
    }
}

public struct CycleGenerator<T>: GeneratorType {
    
    private let sequence: AnySequence<T>
    private var generator: AnyGenerator<T>
    
    public init(sequence: AnySequence<T>) {
        self.sequence = sequence
        self.generator = sequence.generate()
    }
    
    public mutating func next() -> T? {
        var returnValue = generator.next()
        if returnValue == nil {
            self.generator = sequence.generate()
            returnValue = generator.next()
        }
        return returnValue
    }
}

// MARK: - Iterate -

public struct IterateSequence<T>: SequenceType {
    
    public let initial: T
    public let transform: (T) -> T
    
    public init(initial: T, transform: (T) -> T) {
        self.initial = initial
        self.transform = transform
    }
    
    public func generate() -> IterateGenerator<T> {
        return IterateGenerator(initial: initial, transform: transform)
    }
}

public struct IterateGenerator<T>: GeneratorType {
    
    private var value: T
    private let transform: (T) -> T
    
    private init(initial: T, transform: (T) -> T) {
        self.value = initial
        self.transform = transform
    }
    
    public mutating func next() -> T? {
        let returnValue = value
        value = transform(value)
        return returnValue
    }
}

/**
- parameter initial:   The initial value of the sequence.
- parameter transform: The transform to apply to generate the next value in the sequence.

- returns: A sequence that repeatedly applies `transform` to generate each successive value, indefinitely.

```
iterate(2, {$0 * 2}).prefix(5)

[2, 4, 8, 16, 32]
```
*/
@warn_unused_result
public func iterate<T>(initial: T, _ transform: (T) -> T) -> IterateSequence<T> {
    return IterateSequence(initial: initial, transform: transform)
}

// MARK: - Unzip -

public struct Unzip2Generator<T, U>: GeneratorType {
    
    private var generator: AnyGenerator<(T, U)>
    
    public init(_ generator: AnyGenerator<(T, U)>) {
        self.generator = generator
    }
    
    public mutating func next() -> (T, U)? {
        if let element = generator.next() {
            return (element.0, element.1)
        }
        return nil
    }
}

public struct Unzip3Generator<T, U, V>: GeneratorType {
    
    private var generator: AnyGenerator<(T, U, V)>
    
    public init(_ generator: AnyGenerator<(T, U, V)>) {
        self.generator = generator
    }
    
    public mutating func next() -> (T, U, V)? {
        if let element = generator.next() {
            return (element.0, element.1, element.2)
        }
        return nil
    }
}

/**
Breaks a sequence of pairs out into two individual sequences, where the elements of the `i`th sequence are the `i`th elements of each pair.

- returns: The pair of sequences.

```
unzip([(1, 2), (3, 4), (5, 6)])

([1, 3, 5], [2, 4, 6])
```
*/
@warn_unused_result
public func unzip<T, U, Sequence: SequenceType where Sequence.Generator.Element == (T, U)>(sequence: Sequence) -> ([T], [U]) {
    var first: [T] = []
    var second: [U] = []
    for (a, b) in GeneratorSequence(Unzip2Generator(AnySequence(sequence).generate())) {
        first.append(a)
        second.append(b)
    }
    return (first, second)
}

/**
Breaks a sequence of length three tuples out into three individual sequences, where the elements of the `i`th sequence are the `i`th elements of each tuple.

- returns: The tuple of sequences.

```
unzip([(1, 2, 3), (4, 5, 6), (7, 8, 9)])

([1, 4, 7], [2, 5, 8], [3, 6, 9])
```
*/
@warn_unused_result
public func unzip<T, U, V, Sequence: SequenceType where Sequence.Generator.Element == (T, U, V)>(sequence: Sequence) -> ([T], [U], [V]) {
    var first: [T] = []
    var second: [U] = []
    var third: [V] = []
    for (a, b, c) in GeneratorSequence(Unzip3Generator(AnySequence(sequence).generate())) {
        first.append(a)
        second.append(b)
        third.append(c)
    }
    return (first, second, third)
}

// MARK: - Zip -

public struct Zip3Generator<Generator1: GeneratorType, Generator2: GeneratorType, Generator3: GeneratorType>: GeneratorType {
    
    public typealias Element = (Generator1.Element, Generator2.Element, Generator3.Element)
    
    private var first: Generator1
    private var second: Generator2
    private var third: Generator3
    
    public init(_ generator1: Generator1, _ generator2: Generator2, _ generator3: Generator3) {
        self.first = generator1
        self.second = generator2
        self.third = generator3
    }

    public mutating func next() -> Element? {
        if let a = first.next(), b = second.next(), c = third.next() {
            return (a, b, c)
        }
        return nil
    }
}
