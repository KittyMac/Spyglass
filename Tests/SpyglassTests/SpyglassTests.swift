import XCTest
import Spyglass
import Hitch

final class SpyglassTests: XCTestCase {
    private func testdata(_ testFile: String = #file,
                          path: String) -> String {
        let path = URL(fileURLWithPath: testFile).deletingLastPathComponent().appendingPathComponent(path).path
        print(path)
        return path
    }
    
    func testSimple0() {
        guard let spyglass = try? Spyglass(languages: "eng",
                                           tessdataPath: testdata(path: "Data/tessdata")) else { XCTFail(); return }
        
    }
}
