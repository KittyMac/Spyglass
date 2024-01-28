import Foundation
import Hitch
import Chronometer
import CTess
import Gzip

/// [tessdata](https://github.com/tesseract-ocr/tessdata),
/// [tessdata_best](https://github.com/tesseract-ocr/tessdata_best),
/// or [tessdata_fast](https://github.com/tesseract-ocr/tessdata_fast) respositories

struct CTessError: LocalizedError {
    let error: String
}

let tessdata = (try? SpyglassPamphlet.EngFastTraineddataGzip().gunzipped()) ?? Data()

public enum Spyglass {
    
    public static func destroy() {
        ctess_destroy()
    }
    
    public static func parse(image: Data,
                             binarized: Int = 0,
                             cropTop: Int = 0,
                             cropLeft: Int = 0,
                             cropBottom: Int = 0,
                             cropRight: Int = 0) -> String? {
        
        return tessdata.withUnsafeBytes { unsafeRawBufferPointer in
            let unsafeDataBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
            
            let stringPtr = image.withUnsafeBytes { unsafeRawBufferPointer in
                let unsafeImageBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
                
                return ctess_parse("eng",
                                   unsafeDataBufferPointer.baseAddress,
                                   tessdata.count,
                                   unsafeImageBufferPointer.baseAddress,
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
}
