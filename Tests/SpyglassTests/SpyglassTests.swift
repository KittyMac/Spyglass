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
        
        #if os(Linux)
        XCTAssertEqual(result, "P<GRCELLINAS<<GEORGIOS<<<<<<<<<<<<ssssesss<<\nAE00000057GRC6504049M1208283<<<<<<<<<<<<<<00\n")
        #else
        XCTAssertEqual(result, "P<GRCELLINAS<<GEORGIOS<<<<<<<<<<<sssssessss<\nAE00000057G6RC6504049M1208283<<<<<<<<<<<<<<00\n")
        #endif
    }
    
    func testImage5() {
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image5.jpg"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        let result = spyglass.parse(image: image.dataNoCopy())
        
        #if os(Linux)
        XCTAssertEqual(result, "KEHTIV KUNI/DATE OF EXPIRY.\n21.02.2012\n")
        #else
        XCTAssertEqual(result, "KEHTIV KUNI/DATE OF EXPIRY\n21.02.2012\n")
        #endif
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
        XCTAssertEqual(result, "Men\'s \'PARIS\' Letter Prin... $10.47\nKhaki / M(38) x1\nURONLY\n\nMen\'s Rabbit Graffiti Pri... $12.87\nGrey / M(38) x1\nSeek Sun Vigor\n")
    }
    
    func testImage10() {
        // baseline: 0.375
        // no binarization: 0.371
        // no cropping: 0.490
        // LEGACY/BEST: 0.592
        // binarization of 128: 0.246
        
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image10.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        var result: String? = nil
        measure {
            result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: -1,
                                    cropLeft: 150)
        }
        XCTAssertEqual(result, "1pc Machine Washable ... $3.98\nBlue x1\nluroca\n\nTransparent Desktop D... $5.98\n8 compartments with cover... x2\nFeng Qin\n\nOrganize Your Cables w... $5.48\nMulticolor / 20pcs x1\nKCNKON\n\nCompact Electronic Org... $2.51\nBlack x2\nSIMTOP Direct\n\n14pcs/set, Charcuterie ... $9.44\n14PCS x1\nANYIUS\n\nPremium Stainless Steel... $3.99\nNatural Color x1\nAPPUA\n\n2pcs, Silicone Spoon, Lo... $5.48\n2pcs Black x1\nshushui\n\n5pcs Mesh Zipper Pouc... $2.48\nA6 - (23*11CM) x1\nANLIN\n\n5pcs Mesh Zipper Pouc... $2.98\nA5 - (24*18CM) x1\nANLIN\n\n1pc Small Jewelry Box, ... $2.47\npink x1\nBBAOYU\n\n10PCS Travel Shoes Sto... $2.18\n5 x1\nMeimeiya care\n\n7 Pcs Travel Storage Lu... $10.08\nKhaki &quot;cationic&quot... x1\nSoak up the road\n\n7 Pcs Travel Storage Lu... $8.68\nKorean Blue [twill Oxford... x1\nSoak up the road\n")
    }
    
    func testImage11() {
        // baseline: 3.446 (-1, 150)
        // crop first: 3.426
        // binarized 128: 2.270
        // just pixConvert1(250): 3.060
        // --------
        // alpha edit in place: 3.172
        
        let image = Hitch(contentsOfFile: testdata(path: "Data/images/image11.png"))!
        guard let spyglass = try? Spyglass() else { XCTFail(); return }
        
        var result: String? = nil
        measure {
            result = spyglass.parse(image: image.dataNoCopy(),
                                    binarized: -1,
                                    cropLeft: 150)
        }
        
        /*
        XCTAssertEqual(result, "1pc Machine Washable ... $3.98\nBlue x1\nluroca\n\nTransparent Desktop D... $5.98\n8 compartments with cover... x2\nFeng Qin\n\nOrganize Your Cables w... $5.48\nMulticolor / 20pcs x1\nKCNKON\n\nCompact Electronic Org... $2.51\nBlack x2\nSIMTOP Direct\n\n14pcs/set, Charcuterie ... $9.44\n14PCS x1\nANYIUS\n\nPremium Stainless Steel... $3.99\nNatural Color x1\nAPPUA\n\n2pcs, Silicone Spoon, Lo... $5.48\n2pcs Black x1\nshushui\n\n5pcs Mesh Zipper Pouc... $2.48\nA6 - (23*11CM) x1\nANLIN\n\n5pcs Mesh Zipper Pouc... $2.98\nA5 - (24*18CM) x1\nANLIN\n\n1pc Small Jewelry Box, ... $2.47\npink x1\nBBAOYU\n\n10PCS Travel Shoes Sto... $2.18\n5 x1\nMeimeiya care\n\n7 Pcs Travel Storage Lu... $10.08\nKhaki &quot;cationic&quot... x1\nSoak up the road\n\n7 Pcs Travel Storage Lu... $8.68\nKorean Blue [twill Oxford... x1\nSoak up the road\n")
         */
    }
}
