import XCTest

import Mars

class MarsTests: XCTestCase {
    
    // MARK: Optional
    
    func testFlatMap2() -> () {
        let add = {(a: Int, b: Int) in
            return a + b
        }
        
        let opt: Int? = 1
        let sum = (opt, opt) >>- add
        XCTAssertEqual(sum, 2)
        
        let none = (opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap3() -> () {
        let add = {(a: Int, b: Int, c: Int) in
            return a + b + c
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt) >>- add
        XCTAssertEqual(sum, 3)
        
        let none = (opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap4() -> () {
        let add = {(a: Int, b: Int, c: Int, d: Int) in
            return a + b + c + d
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt, opt) >>- add
        XCTAssertEqual(sum, 4)
        
        let none = (opt, opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap5() -> () {
        let add = {(a: Int, b: Int, c: Int, d: Int, e: Int) in
            return a + b + c + d + e
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt, opt, opt) >>- add
        XCTAssertEqual(sum, 5)
        
        let none = (opt, opt, opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap6() -> () {
        let add = {(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int) in
            return a + b + c + d + e + f
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt, opt, opt, opt) >>- add
        XCTAssertEqual(sum, 6)
        
        let none = (opt, opt, opt, opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap7() -> () {
        let add = {(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int, g: Int) in
            return a + b + c + d + e + f + g
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt, opt, opt, opt, opt) >>- add
        XCTAssertEqual(sum, 7)
        
        let none = (opt, opt, opt, opt, opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    func testFlatMap8() -> () {
        let add = {(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int, g: Int, h: Int) in
            return a + b + c + d + e + f + g + h
        }
        
        let opt: Int? = 1
        let sum = (opt, opt, opt, opt, opt, opt, opt, opt) >>- add
        XCTAssertEqual(sum, 8)
        
        let none = (opt, opt, opt, opt, opt, opt, opt, nil) >>- add
        XCTAssertNil(none)
    }
    
    // MARK: SequenceType
    
    func testAll() -> () {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8 , 9, 10]
        let isEven = {$0 % 2 == 0}
        
        XCTAssertTrue([].all(isEven))
        
        XCTAssertTrue(numbers.filter(isEven).all(isEven))
        XCTAssertFalse(numbers.all(isEven))
    }
    
    func testAny() -> () {
        let numbers = 1 ... 10
        let isEven = {$0 % 2 == 0}
        let isGreaterThan10 = {$0 > 10}
        
        XCTAssertFalse([].any(isEven))
        
        XCTAssertTrue(numbers.any(isEven))
        XCTAssertFalse(numbers.any(isGreaterThan10))
    }
    
    func testCycle() -> () {
        let numbers = [1, 2, 3].cycle()
        
        var elements: [Int] = []
        var generator = numbers.generate()
        for _ in 0 ..< 7 {
            elements.append(generator.next()!)
        }
        
        XCTAssertEqual(elements, [1, 2, 3, 1, 2, 3, 1])
        
        var emptyGenerator = [].cycle().generate()
        XCTAssertNil(emptyGenerator.next())
    }
    
    func testDrop() -> () {
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(numbers.drop(0), numbers)
        XCTAssertEqual(numbers.drop(3), [4, 5])
        XCTAssertEqual(numbers.drop(5), [])
        XCTAssertEqual(numbers.drop(6), [])
    }
    
    func testDropWhile() -> () {
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(numbers.dropWhile({$0 <= 0}), numbers)
        XCTAssertEqual(numbers.dropWhile({$0 <= 3}), [4, 5])
        XCTAssertEqual(numbers.dropWhile({$0 <= 6}), [])
    }
    
    func testFirst() -> () {
        let numbers = [1, 2, 3, 4, 5]
        let isEven = {$0 % 2 == 0}
        let isGreaterThan5 = {$0 > 5}
        
        XCTAssertEqual(numbers.first(isEven)!, 2)
        XCTAssertNil(numbers.first(isGreaterThan5))
    }
    
    func testGroup() -> () {
        let numbers = [1, 1, 2, 2, 3, 3, 1, 2, 3]
        
        XCTAssertEqual(numbers.group(), [[1, 1], [2, 2], [3, 3], [1], [2], [3]])
    }
    
    func testGroupBy() -> () {
        let numbers = [2, 4, 1, 3, 6, 8, 1, 2, 3]
        let result = numbers.groupBy({(this, that) in
            return this % 2 == that % 2
        })
        
        XCTAssertEqual(result, [[2, 4], [1, 3], [6, 8], [1], [2], [3]])
    }
    
    func testIterate() -> () {
        let sequence = iterate(2, {$0 * 2})
        
        var elements: [Int] = []
        var generator = sequence.generate()
        for _ in 0 ..< 5 {
            elements.append(generator.next()!)
        }
        
        XCTAssertEqual(elements, [2, 4, 8, 16, 32])
    }
    
    func testLast() -> () {
        let numbers = [1, 2, 3, 4, 5]
        let isEven = {$0 % 2 == 0}
        let isGreaterThan5 = {$0 > 5}
        
        XCTAssertEqual(numbers.last(isEven)!, 4)
        XCTAssertNil(numbers.last(isGreaterThan5))
    }
    
    func testReduce() -> () {
        let empty: [Int] = []
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertNil(empty.reduce(+))
        XCTAssertEqual(numbers.reduce(+)!, 15)
    }
    
    func testScan() -> () {
        let empty: [Int] = []
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(empty.scan(+), [])
        XCTAssertEqual(numbers.scan(+), [1, 3, 6, 10, 15])
    }
    
    func testScanWith() -> () {
        let empty: [Int] = []
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(empty.scan(0, combine: +), [0])
        XCTAssertEqual(numbers.scan(0, combine: +), [0, 1, 3, 6, 10, 15])
    }
    
    func testTake() -> () {
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(numbers.take(0), [])
        XCTAssertEqual(numbers.take(3), [1, 2, 3])
        XCTAssertEqual(numbers.take(5), numbers)
        XCTAssertEqual(numbers.take(6), numbers)
    }
    
    func testTakeWhile() -> () {
        let numbers = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(numbers.takeWhile({$0 <= 0}), [])
        XCTAssertEqual(numbers.takeWhile({$0 <= 3}), [1, 2, 3])
        XCTAssertEqual(numbers.takeWhile({$0 <= 6}), numbers)
    }
    
    func testUnzip2() -> () {
        let unzipped = unzip([(1, 2), (3, 4), (5, 6)])
        
        XCTAssertEqual(unzipped.0, [1, 3, 5])
        XCTAssertEqual(unzipped.1, [2, 4, 6])
    }
    
    func testUnzip3() -> () {
        let unzipped = unzip([(1, 2, 3), (4, 5, 6), (7, 8, 9)])
        
        XCTAssertEqual(unzipped.0, [1, 4, 7])
        XCTAssertEqual(unzipped.1, [2, 5, 8])
        XCTAssertEqual(unzipped.2, [3, 6, 9])
    }
    
    func testZip2() -> () {
        let first  = [1, 3, 5, 7, 9]
        let second = [2, 4, 6, 8]
        let result = Array(first.zip(second))
        
        XCTAssertEqual(result.count, 4)
        
        for (index, pair) in result.enumerate() {
            XCTAssertEqual(pair.0, first[index])
            XCTAssertEqual(pair.1, second[index])
        }
    }
    
    func testZip3() -> () {
        let first  = [1, 4, 7, 10, 12]
        let second = [2, 5, 8, 11]
        let third  = [3, 6, 9]
        let result = Array(first.zip(second, third))
        
        XCTAssertEqual(result.count, 3)
        
        for (index, triplet) in result.enumerate() {
            XCTAssertEqual(triplet.0, first[index])
            XCTAssertEqual(triplet.1, second[index])
            XCTAssertEqual(triplet.2, third[index])
        }
    }
}
