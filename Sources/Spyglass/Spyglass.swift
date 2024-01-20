import Foundation
import Hitch
import Chronometer
import CTess

/// [tessdata](https://github.com/tesseract-ocr/tessdata),
/// [tessdata_best](https://github.com/tesseract-ocr/tessdata_best),
/// or [tessdata_fast](https://github.com/tesseract-ocr/tessdata_fast) respositories

struct CTessError: LocalizedError {
    let error: String
}

public class Spyglass {
    let ctess: UnsafeMutablePointer<CTess>?
    
    public init(languages: String,
                tessdataPath: String) throws {
        ctess = ctess_init(languages, tessdataPath)
        if ctess == nil {
            throw CTessError(error: "failed to initialize tesseract")
        }
    }
    
    deinit {
        ctess_destroy(ctess)
    }
    
    public func parse(image: Data) -> String? {
        let stringPtr = image.withUnsafeBytes { bytePointer in
            return ctess_parse(ctess, bytePointer, image.count)
        }
        
        guard let stringPtr = stringPtr else { return nil}
        
        let string = String(utf8String: stringPtr)
        
        free(UnsafeMutableRawPointer(mutating: stringPtr))
        
        return string
    }
}
