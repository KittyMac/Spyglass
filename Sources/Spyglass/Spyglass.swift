import Foundation
import Hitch
import Chronometer
import CTess
import SWCompression

/// [tessdata](https://github.com/tesseract-ocr/tessdata),
/// [tessdata_best](https://github.com/tesseract-ocr/tessdata_best),
/// or [tessdata_fast](https://github.com/tesseract-ocr/tessdata_fast) respositories

struct CTessError: LocalizedError {
    let error: String
}

public class Spyglass {
    let ctess: UnsafeMutablePointer<CTess>?
    let lock = NSLock()
    
    public init() throws {
        let languages = "eng"
        guard let tessdata = try? GzipArchive.unarchive(archive: SpyglassPamphlet.EngFastTraineddataGzip()) else {
            throw CTessError(error: "unable to decompress traindata")
        }
        
        ctess = tessdata.withUnsafeBytes { unsafeRawBufferPointer in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)

            return ctess_init2(languages,
                               unsafeBufferPointer.baseAddress,
                               tessdata.count)
        }

        if ctess == nil {
            throw CTessError(error: "failed to initialize tesseract")
        }
    }
    
    public init(languages: String,
                tessdataPath: String) throws {
        ctess = ctess_init(languages, tessdataPath)
        if ctess == nil {
            throw CTessError(error: "failed to initialize tesseract")
        }
    }
    
    public init(languages: String,
                tessdata: Data) throws {
        ctess = tessdata.withUnsafeBytes { unsafeRawBufferPointer in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)

            return ctess_init2(languages,
                               unsafeBufferPointer.baseAddress,
                               tessdata.count)
        }

        if ctess == nil {
            throw CTessError(error: "failed to initialize tesseract")
        }
    }
    
    deinit {
        ctess_destroy(ctess)
    }
        
    public func parse(image: Data,
                      binarized: Int = 0,
                      cropTop: Int = 0,
                      cropLeft: Int = 0,
                      cropBottom: Int = 0,
                      cropRight: Int = 0) -> String? {
        lock.lock(); defer { lock.unlock() }
        
        let stringPtr = image.withUnsafeBytes { unsafeRawBufferPointer in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)

            return ctess_parse(ctess,
                               unsafeBufferPointer.baseAddress,
                               image.count,
                               Int32(binarized),
                               Int32(cropTop),
                               Int32(cropLeft),
                               Int32(cropBottom),
                               Int32(cropRight)
            )
        }
        
        guard let stringPtr = stringPtr else { return nil}
        
        let string = String(utf8String: stringPtr)
        
        free(UnsafeMutableRawPointer(mutating: stringPtr))
        
        return string
    }
}
