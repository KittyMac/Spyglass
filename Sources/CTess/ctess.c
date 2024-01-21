#include "stdio.h"
#include "stdlib.h"
#include "ctess.h"
#include <tesseract/environ.h>
#include <tesseract/capi.h>
#include <tesseract/pix.h>
#include <string.h>

extern PIX * pixReadMem(const l_uint8 *data, size_t size );
extern PIX * pixConvertTo8 ( PIX *pixs, l_int32 cmapflag );
extern PIX * pixThresholdToBinary ( PIX *pixs, l_int32 thresh );
extern PIX * pixRemoveBorderGeneral ( PIX *pixs, l_int32 left, l_int32 right, l_int32 top, l_int32 bot );
extern void pixDestroy ( PIX **ppix );

CTess * ctess_init(const char * language,
                   const char * tessdataPath) {
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
    
    if (binaryThreshold > 0) {
        PIX *pixB = pixConvertTo8(pix, 0);
        pixDestroy(&pix);
        pix = pixThresholdToBinary(pixB, binaryThreshold);
        pixDestroy(&pixB);
    }
    
    if (cropTop > 0 || cropLeft > 0 || cropBottom > 0 || cropRight > 0) {
        PIX *pixB = pixRemoveBorderGeneral(pix, cropLeft, cropRight, cropTop, cropBottom);
        pixDestroy(&pix);
        pix = pixB;
    }
    
    TessBaseAPISetImage2(ctess->tesseract, pix);
    
    if (TessBaseAPIGetSourceYResolution(ctess->tesseract) < 70) {
        TessBaseAPISetSourceResolution(ctess->tesseract, 300);
    }
    
    const char * string = TessBaseAPIGetUTF8Text(ctess->tesseract);
    const char * string2 = strdup(string);
    
    TessDeleteText(string);
    
    return string2;
}

