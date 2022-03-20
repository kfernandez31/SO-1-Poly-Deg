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


void sub(int *a, const int *b, size_t ncells, bool *all_zeros) {
    flag FC = 0;
    bool carry = false;
    for (size_t i = 0; i < ncells; i++) {
        size_t idx = ncells - i;
        a[idx] -= (FC == 1);
        carry = (FC == 1);
        a[idx] - b[idx];
        if (FC == 1) {
            carry = true;
        }

        if (carry) {
            a[idx] -= 1;
        }
        *all_zeros &= (a[idx] == 0);
    }
}

//todo: masking with pow64

int polynomial_degree_v2(int const *y, size_t n) {
    bool all_zeros = true;
    int result = -1;
    int **diffs = malloc(n * sizeof(int*));
    size_t bignum_bits = roundTo64((n+32)/sizeof(int));

    for (size_t i = 0; i < n; i++) {
        diffs[i] = calloc(bignum_bits, sizeof(int));
        diffs[i][0] = y[i];
        all_zeros &= !diffs[i][0];
    }

    while (n > 0 && !all_zeros) {
        result++;
        n--;
        all_zeros = true;
        for (size_t i = 0; i < n; i++) {
            sub(diffs[i], diffs[i + 1], bignum_bits, &all_zeros);
        }
    }

    for (size_t i = 0; i < n; i++) {
        free(diffs[i]);
    }
    free(diffs);
    return result;
}