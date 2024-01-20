#ifndef ctess_h
#define ctess_h

#import <stdlib.h>

typedef struct CTess {
    void * tesseract;
} CTess;

CTess * ctess_init(const char * language,
                   const char * tessdataPath);
void ctess_destroy(CTess * ctess);
const char * ctess_parse(CTess * ctess,
                         const void * imageData,
                         size_t imageDataSize);

#endif
