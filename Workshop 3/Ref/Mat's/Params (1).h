// TODO: 0. Modify these constants to match the filter you have designed

// length of filter
#define M 48

// buffer size
#define N 512

// input data processing block size
#define L (N-M+1)

#define BUFFER_SIZE     (M-1)
#define REM(INDEX)      ((INDEX) + BUFFER_SIZE) % BUFFER_SIZE
