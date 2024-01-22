import XCTest
import Spyglass
import Hitch

private func testdata(path: String) -> String {
    return URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(path).path
}

final class SpyglassTests: XCTestCase {
    
    func testImage0() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image0.jpg"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "1234567890\n")
    }
    
    func testImage1() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image1.jpg"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "2F.SM.LC.SCA.12FT\n")
    }
    
    func testImage2() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image2.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "Lenore\nLenore, Lenore, mon amour\nEvery day | love you more\nWithout you, my heart grows sore\nJe te aime encore trés beaucoup, Lenore\nLenore, Lenore, don\'t think me a bore\nBut | can go on and on about your charms\nforever and ever more\nOn a scale of one to three, | love you four\nMon amour, je te aime encore tres beaucoup,\nLenore\n")
    }
    
    func testImage3() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image3.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "Multiple Interword Spaces\n")
    }
    
    func testImage4() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image4.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "P<GRCELLINAS<<GEORGIOS<<<<<<<<<<<sssssessss<\nAE00000057G6RC6504049M1208283<<<<<<<<<<<<<<00\n")
    }
    
    func testImage5() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image5.jpg"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "KEHTIV KUNI/DATE OF EXPIRY\n21.02.2012\n")
    }
    
    func testImage6() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image6.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: 0,
                                    cropLeft: 150)
        XCTAssertEqual(result, "Gradient Glitter Phone C... $2.97\niPhone 14 Pro / black x1\nVertical dingcheng\n")
    }
    
    func testImage7() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image7.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: 0)
        XCTAssertEqual(result, "Item(s) total: $42.64\nItem(s) discount: -$30.67\n\n$11.97\nSubtotal: $11.97\nShipping: FREE\nSales tax: $0.72\nOrder total: $12.69\nYou saved: -$30.67\n")
    }
}
