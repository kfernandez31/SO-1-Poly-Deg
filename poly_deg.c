#include "poly_deg.h"
#include <stdbool.h>
#include <stdlib.h>

#define MOD1 (1000000000+7)
#define MOD2 (1000000000+9)
#define MOD3 (1000000000+21)

static long hash(long x) {
    return (((x % MOD1) % MOD2) % MOD3);
}

int polynomial_degree(int const *y, size_t n) {
    int result = -1;

    if (n == 0 || y == NULL) {
        return result;
    }

    bool all_zeros = true;
    long* diffs = malloc(n * sizeof(long));
    size_t i;

    for (i = 0; i < n; i++) {
        diffs[i] = y[i];
        all_zeros &= !diffs[i];
    }

    while (n > 0 && !all_zeros) {
        result++;
        n--;
        all_zeros = true;
        for (i = 0; i < n; i++) {
            diffs[i] = hash(diffs[i] - diffs[i + 1]);
            all_zeros &= !diffs[i];
        }
    }
    free(diffs);
    return result;
}
