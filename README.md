# Mars

Mars is a thin framework that provides a set of extensions to `SequenceType`. There are no requirements outside of the Swift standard library and each function is thoroughly documented (and Quick Help compliant). An explaination of each function can be found below.

## all

`public func all(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool`

Determines whether all elements of the structure satisfy the predicate.

```
[2, 4, 6, 8, 10].all(isEven)

true
```

## any

`public func any(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool`

Determines whether any element of the structure satisfies the predicate.

```
[1, 2, 3, 4, 5].all(isEven)

true
```

## cycle

`public func cycle() -> CycleSequence<Self.Generator.Element>`

Returns a sequence that repeats this sequence indefinitely.

```
[1, 2, 3].cycle().prefix(5)

[1, 2, 3, 1, 2]
```

## drop

`public func drop(count: Int) -> [Self.Generator.Element]`

Returns a sequence containing all but the first `n` elements.

```
[1, 2, 3, 4, 5].drop(3)

[4, 5]
```

## dropWhile

`public func dropWhile(@noescape predicate: (Self.Generator.Element) -> Bool) -> [Self.Generator.Element]`

Returns a sequence containing all but the initial elements that pass the predicate.

```
[2, 4, 6, 7, 8].dropWhile(isEven)

[7, 8]
```

## first

`public func first(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element?`

Finds the first element in the sequence that passes the predciate.

```
[1, 2, 3, 4, 5].first({$0 > 3})

Optional.Some(3)
```

## group

`public func group() -> [[Self.Generator.Element]]`

A convenience method that calls groupBy(==) for sequences where the elements are `Equatable`

```
[1, 1, 2, 2, 3, 1].group()

[[1, 1], [2, 2], [3], [1]]
```

## groupBy

`public func groupBy(@noescape predicate: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [[Self.Generator.Element]]`

Partitions the sequence into an array of arrays where each array contains equal neighboring elements from the intial sequence. Flattening the returned array would be equal to the intial sequence.

```
[1, 1, 2, 2, 3, 1].groupBy(==)

[[1, 1], [2, 2], [3], [1]]
```

## iterate

`public func iterate<T>(initial: T, _ transform: (T) -> T) -> IterateSequence<T>`

Returns a sequence that repeatedly applies `transform` to generate each successive value, indefinitely.

```
iterate(2, {$0 * 2}).prefix(5)

[2, 4, 8, 16, 32]
```

## last

`public func last(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element?`

Finds the last element in the sequence that passes the predciate.

```
[1, 2, 3, 4, 5].last({$0 > 3})

Optional.Some(5)
```

## reduce

`public func reduce(@noescape combine: (Self.Generator.Element, Self.Generator.Element) -> Self.Generator.Element) -> Self.Generator.Element?`

Returns the result of repeatedly calling `combine` with an accumulated value initialized to the first element in the sequence and each element of `self`, in turn.

```
[1, 2, 3, 4, 5].reduce(+)

15
```

## scan

`public func scan<T>(initial: T, @noescape combine: (T, Self.Generator.Element) -> T) -> [T]`

Returns an array of the intermediate results of calling `combine` on successive elements of self and an accumulated value.

```
[1, 2, 3, 4, 5].scan(0, +)

[0, 1, 3, 6, 10, 15]
```

There is also a variant of scan that uses the first element of the sequence as the initial accumulator.

```
[1, 2, 3, 4, 5].scan(+)

[1, 3, 6, 10, 15]
```

## take

`public func take(count: Int) -> [Self.Generator.Element]`

Returns a sequence containing the first `n` elements.
    
```
[1, 2, 3, 4, 5].take(3)

[1, 2, 3]
```

## takeWhile

`public func takeWhile(@noescape predicate: (Self.Generator.Element) -> Bool) -> [Self.Generator.Element]`

Returns a sequence containing the initial elements that pass the predicate.
    
```
[2, 4, 6, 7, 8].takeWhile(isEven)

[2, 4, 6]
```

## unzip

`public func unzip<T, U, Sequence: SequenceType where Sequence.Generator.Element == (T, U)>(sequence: Sequence) -> ([T], [U])`

Breaks a sequence of pairs out into two individual sequences, where the elements of the `i`th sequence are the `i`th elements of each pair.

```
unzip([(1, 2), (3, 4), (5, 6)])

([1, 3, 5], [2, 4, 6])
```

There is also a variant of unzip that works with tuples of length three.

```
unzip([(1, 2, 3), (4, 5, 6), (7, 8, 9)])

([1, 4, 7], [2, 5, 8], [3, 6, 9])
```

## zip

`public func zip<Sequence: SequenceType>(sequence: Sequence) -> GeneratorSequence<Zip2Generator<Self.Generator, Sequence.Generator>>`

Creates a sequence of pairs built out of two underlying sequences, where the elements of the `i`th pair are the `i`th elements of each underlying sequence.

```
[1, 3, 5].zip([2, 4, 6])

[(1, 2), (3, 4), (5, 6)]
```

There is also a variant of zip that works with three sequences.

```
[1, 4, 7].zip([2, 5, 8], [3, 6, 9])

[(1, 2, 3), (4, 5, 6), (7, 8, 9)]
```
