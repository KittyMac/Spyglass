#ifndef ctess_h
#define ctess_h

typedef struct CTess {
    void * tesseract;
} CTess;

CTess * ctess_init(const char * language,
                   const char * tessdataPath);
void ctess_destroy(CTess * ctess);

#endif
