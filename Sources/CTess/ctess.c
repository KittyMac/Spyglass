#include "stdio.h"
#include "stdlib.h"
#include "ctess.h"
#include <tesseract/environ.h>
#include <tesseract/capi.h>
#include <tesseract/pix.h>
#include <string.h>

extern l_int32 setMsgSeverity ( l_int32 newsev );

extern l_uint32 * pixGetData (PIX *pix);
extern l_int32 pixGetWidth (const PIX *pix);
extern l_int32 pixGetHeight (const PIX *pix);
extern l_ok pixAlphaIsOpaque (PIX *pix, l_int32 *popaque);

extern PIX * pixConvertTo32 (PIX *pixs);
extern PIX * pixConvertTo8 (PIX *pixs, l_int32 cmapflag);
extern PIX * pixConvertTo1 (PIX *pixs, l_int32 threshold);

extern PIX * pixReadMem(const l_uint8 *data, size_t size );
extern PIX * pixRemoveBorderGeneral ( PIX *pixs, l_int32 left, l_int32 right, l_int32 top, l_int32 bot );
extern void pixDestroy ( PIX **ppix );

CTess * ctess_init(const char * language,
                   const char * tessdataPath) {
    setMsgSeverity(6);
    
    CTess * ctess = malloc(sizeof(CTess));
    ctess->tesseract = TessBaseAPICreate();
    TessBaseAPIInit2(ctess->tesseract,
                     tessdataPath,
                     language,
                     OEM_LSTM_ONLY);
    return ctess;
}

CTess * ctess_init2(const char * language,
                    const char * tessdata,
                    size_t tessdatasize) {
    setMsgSeverity(6);
    
    CTess * ctess = malloc(sizeof(CTess));
    ctess->tesseract = TessBaseAPICreate();
    TessBaseAPIInit5(ctess->tesseract,
                     tessdata,
                     (int)tessdatasize,
                     language,
                     OEM_LSTM_ONLY,
                     NULL,
                     0,
                     NULL,
                     NULL,
                     0,
                     0);
    return ctess;
}

void ctess_destroy(CTess * ctess) {
    if (ctess != NULL) {
        TessBaseAPIEnd(ctess->tesseract);
        TessBaseAPIDelete(ctess->tesseract);
        free(ctess);
    }
}

const char * ctess_parse(CTess * ctess,
                         const void * imageData,
                         size_t imageDataSize,
                         int32_t binaryThreshold,
                         int32_t cropTop,
                         int32_t cropLeft,
                         int32_t cropBottom,
                         int32_t cropRight) {
    PIX * pix = pixReadMem(imageData, imageDataSize);
    if (pix == NULL) { return NULL; }
    
    if (cropTop > 0 || cropLeft > 0 || cropBottom > 0 || cropRight > 0) {
        PIX *pixB = pixRemoveBorderGeneral(pix, cropLeft, cropRight, cropTop, cropBottom);
        pixDestroy(&pix);
        pix = pixB;
    }
    
    if (binaryThreshold != 0) {
        
        if (binaryThreshold < 0) {
            // Separate everything from the "background" and the "foreground". The
            // top left pixel is choosen as the "background".
            PIX * pix32 = pixConvertTo32 (pix);
            pixDestroy(&pix);
            
            l_uint8 * startPtr = (l_uint8 *)pixGetData(pix32);
            l_int32 w = pixGetWidth(pix32);
            l_int32 h = pixGetHeight(pix32);
            l_uint8 * endPtr = startPtr + (w * h * 4);
            l_uint8 * ptr = startPtr;
            
            l_uint32 background = ((l_uint32 *)startPtr)[0];
            l_uint32 distanceR;
            l_uint32 distanceG;
            l_uint32 distanceB;
            l_uint32 distance;
            
            bool hasAlpha = false;
            while (ptr < endPtr) {
                if (ptr[0] > 0 && ptr[0] < 255) {
                    hasAlpha = true;
                    break;
                }
                ptr += 4;
            }
            ptr = startPtr;
            
            // If the alpha is all 0s or all 255
            if (hasAlpha == false) {
                while (ptr < endPtr) {
                    distanceR = startPtr[1] > ptr[1] ? (startPtr[1] - ptr[1]) : (ptr[1] - startPtr[1]);
                    distanceG = startPtr[2] > ptr[2] ? (startPtr[2] - ptr[2]) : (ptr[2] - startPtr[2]);
                    distanceB = startPtr[3] > ptr[3] ? (startPtr[3] - ptr[3]) : (ptr[3] - startPtr[3]);
                    distance = (distanceR + distanceG + distanceB) / 3;
                    
                    distance = distance * 2;
                    if (distance > 255) {
                        distance = 255;
                    }

                    if (((l_uint32 *)ptr)[0] == background) {
                        ptr[1] = 255;
                        ptr[2] = 255;
                        ptr[3] = 255;
                    } else {
                        ptr[1] = 255 - distance;
                        ptr[2] = 255 - distance;
                        ptr[3] = 255 - distance;
                    }
                    ptr[0] = 255;
                    ptr += 4;
                }
            } else {
                while (ptr < endPtr) {
                    ptr[1] = 255 - ptr[0];
                    ptr[2] = 255 - ptr[0];
                    ptr[3] = 255 - ptr[0];
                    ptr[0] = 255;
                    ptr += 4;
                }

            }
            
            // fprintf(stderr, "%d x %d\n", w, h);
            // FILE * file = fopen("/tmp/sample.raw", "wb");
            // fwrite(startPtr, endPtr - startPtr, 1, file);
            // fclose(file);
            
            pix = pix32;
        } else {
            PIX * pix1 = pixConvertTo1(pix, binaryThreshold);
            pixDestroy(&pix);
            pix = pix1;
        }
    }
    
    TessBaseAPISetImage2(ctess->tesseract, pix);
    
    if (TessBaseAPIGetSourceYResolution(ctess->tesseract) < 70) {
        TessBaseAPISetSourceResolution(ctess->tesseract, 300);
    }
    
    const char * string = TessBaseAPIGetUTF8Text(ctess->tesseract);
    pixDestroy(&pix);
    
    if (string == NULL) {
        return NULL;
    }
    
    const char * string2 = strdup(string);
    TessDeleteText(string);
    return string2;
}

