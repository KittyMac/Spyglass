import XCTest
import Spyglass
import Hitch

private func testdata(path: String) -> String {
    return URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(path).path
}

final class SpyglassTests: XCTestCase {
    let tessdataPath = testdata(path: "Data/tessdata")
    
    func testImage0() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image0.jpg"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "1234567890\n")
    }
    
    func testImage1() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image1.jpg"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "2F.SM.LC.SCA.12FT\n")
    }
    
    func testImage2() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image2.png"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "Lenore\nLenore, Lenore, mon amour\nEvery day | love you more\nWithout you, my heart grows sore\nJe te aime encore trés beaucoup, Lenore\nLenore, Lenore, don’t think me a bore\nBut | can go on and on about your charms\nforever and ever more\nOn a scale of one to three, | love you four\nMon amour, je te aime encore tres beaucoup,\nLenore\n")
    }
    
    func testImage3() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image3.png"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "Multiple Interword Spaces\n")
    }
    
    func testImage4() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image4.png"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "P<GRCELLINAS<<GEORGIOS<<K<LKLLLLLLLLLLLLLLLKLLKLKL\nAEOO0000057GRC6504049M1208283<<<<<<<<<K<K<K<<00\n")
    }
    
    func testImage5() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image5.jpg"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "KENTIV KUNV/DATE OF EXPIRY\n21.02.2012\n")
    }
    
    func testImage6() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image6.png"))!
        guard let spyglass = try? Spyglass(languages: "eng.best",
                                           tessdataPath: tessdataPath) else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        XCTAssertEqual(result, "Gradient Glitter Phone C... $2.97\niPhone 14 Pro / black x1\nWW\ni Vertical dingcheng\n")
    }
}
