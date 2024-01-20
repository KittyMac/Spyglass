import Foundation
import Hitch
import Chronometer
import CTess

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
}
