#include "stdio.h"
#include "stdlib.h"
#include "ctess.h"
#include <tesseract/environ.h>
#include <tesseract/capi.h>
#include <tesseract/pix.h>
#include <string.h>

extern PIX * pixReadMem(const l_uint8 *data, size_t size );

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

void ctess_destroy(CTess * ctess) {
    if (ctess != NULL) {
        TessBaseAPIEnd(ctess->tesseract);
        TessBaseAPIDelete(ctess->tesseract);
        free(ctess);
    }
}

const char * ctess_parse(CTess * ctess,
                         const void * imageData,
                         size_t imageDataSize) {
    PIX * pix = pixReadMem(imageData, imageDataSize);
    if (pix == NULL) { return NULL; }
    
    TessBaseAPISetImage2(ctess->tesseract, pix);
    
    if (TessBaseAPIGetSourceYResolution(ctess->tesseract) < 70) {
        TessBaseAPISetSourceResolution(ctess->tesseract, 300);
    }
    
    const char * string = TessBaseAPIGetUTF8Text(ctess->tesseract);
    const char * string2 = strdup(string);
    
    TessDeleteText(string);
    
    return string2;
}

