#ifndef ctess_h
#define ctess_h

#import <stdlib.h>

void ctess_destroy();
const char * ctess_parse(const char * language,
                         const char * tessdata,
                         size_t tessdatasize,
                         const void * imageData,
                         size_t imageDataSize,
                         int32_t binaryThreshold,
                         int32_t cropTop,
                         int32_t cropLeft,
                         int32_t cropBottom,
                         int32_t cropRight);

#endif
