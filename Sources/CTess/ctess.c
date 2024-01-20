#include "stdio.h"
#include "stdlib.h"
#include "ctess.h"
#include <tesseract/capi.h>


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
        TessBaseAPIDelete(ctess->tesseract);
        free(ctess);
    }
}

