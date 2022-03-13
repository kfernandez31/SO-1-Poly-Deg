#include "poly_deg.h"
#include <stdbool.h>

#define MOD1 (1000000000+7)
#define MOD2 (1000000000+9)
#define MOD3 (1000000000+21)

static long hash(long x) {
    return (((x % MOD1) % MOD2) % MOD3);
}

int polynomial_degree(int const *y, size_t n) {
    if (n == 0 || y == NULL) {
        return -1;
    }

    bool all_zeros = true;
    int result = -1;
    size_t size = n;
    long diffs[size];

    for (size_t i = 0; i < n; i++) {
        diffs[i] = y[i];
        all_zeros &= (diffs[i] == 0);
    }

    while (size > 0 && !all_zeros) {
        result++;
        size--;
        all_zeros = true;
        for (size_t i = 0; i < size; i++) {
            diffs[i] = hash(diffs[i] - diffs[i + 1]);
            all_zeros &= (diffs[i] == 0);
        }
    }
    return result;
}
