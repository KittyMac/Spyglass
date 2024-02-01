#ifndef ctess_h
#define ctess_h

#import <stdlib.h>

typedef struct CTess {
    void * tesseract;
} CTess;

CTess * ctess_init(const char * language,
                   const char * tessdataPath);
CTess * ctess_init2(const char * language,
                    const char * tessdata,
                    size_t tessdatasize);
void ctess_destroy(CTess * ctess);
const char * ctess_parse(CTess * ctess,
                         const void * imageData,
                         size_t imageDataSize,
                         int32_t binaryThreshold,
                         int32_t cropTop,
                         int32_t cropLeft,
                         int32_t cropBottom,
                         int32_t cropRight,
                         int32_t shrink);

#endif
