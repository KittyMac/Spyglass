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
                                    binarized: -1,
                                    cropLeft: 150)
        XCTAssertEqual(result, "Gradient Glitter Phone C... $2.97\niPhone 14 Pro / black x1\nVertical dingcheng\n")
    }
    
    func testImage7() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image7.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: -1)
        XCTAssertEqual(result, "Item(s) total: $42.64\nItem(s) discount: -$30.67\n\n$11.97\nSubtotal: $11.97\nShipping: FREE\nSales tax: $0.72\nOrder total: $12.69\nYou saved: -$30.67\n")
    }
    
    func testImage8() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image8.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: -1,
                                    cropLeft: 150)
        XCTAssertEqual(result, "10pcs Dupes Luxury We... $3.67\nSE3252 x1\nNooxian\n")
    }
    
    func testImage9() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image9.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: -1,
                                    cropLeft: 150)
        XCTAssertEqual(result, "Men\'s \'PARIS\' Letter Prin... $10.47\nKhaki / M(38) xl\nURONLY\n\nMen\'s Rabbit Graffiti Pri... $12.87\nGrey / M(38) x1\nSeek Sun Vigor\n")
    }
}
