global polynomial_degree
extern malloc
extern calloc
extern free
extern printf

polynomial_degree:
        push    rsi                                     ; save value of `n`
; legend to variables:
; - RDI - `int const *y`           - 1st arg
; - RSI - `size_t n`               - 2nd arg
; - DL  - `bool all_zeros = true`  - flag to check whether all numbers in an array are 0
; - ECX - `int result = -1`        - result of the function
; - R8  - `size_t i = 0`           - loop index
; - R9  - `int** diffs`            - array of subtractions of neighboring elements
; - R10 - `size_t bignum_len = roundUp_32(n+32)/sizeof(int)` (explained 11 lines below)
; allocate dynamic array `diffs` with malloc:
        push    rdi                                     ; save value of `y`
        mov     rdi, rsi
        shl     rdi, 0x3                                ; RDI := `n * sizeof(int*)`
        call    malloc wrt ..plt                        ; call malloc with prepared size
        test    rax, rax                                ; check malloc's result
        pop     rdi                                     ; regain value of `y`
        jz      exit_fail
        mov     r9, rax                                 ; assign malloc's result to `diffs`
        pop     rdi                                     ; regain value of `y`
; `bignum_len` is `n+32` rounded up to nearest multiple of 32 and then divided by `32`
        mov     r10, rsi
        add     r10, 0x1000
        add     r10, 0x011111
        and     r10, 0xFFFF1000
        shl     r10, 0x3

        xor      r8, r8                                 ; `i = 0`
        mov      dl, 0x1                                ; `all_zeros = true`

; convert values of `y` into bignums of `diffs`, check if they're all zeros
.loop_alloc_bignums:    ;TODO: czy tu dobrze adresuję?
  ; allocate space for `i`-th bignum
    ; save values of modifiable registers
        push    rdi
        push    rsi
        push    dl
        push    r8
        push    r9
        push    r10
        mov     rdi, r10                                ; RDI := `bignum_len`
        mov     rsi, 0x100                              ; RSI := `sizeof(int)`
        call    calloc wrt ..plt                        ; call calloc with prepared size
        pop     r10
        pop     r9
        pop     r8
        pop     dl
        pop     rsi
        pop     rdi
        test    rax, rax                                ; check calloc's result
        jz      exit_fail
        mov     [r10+r8*8], rax                         ; assign calloc's result to `diffs[i]`
  ; initialize bignum with its first 4 bytes
        mov     [r11], [rdi+r8*4]                       ; `diffs[i][0] = y[i];`
  ; check if `y[i] == 0`
        test    [rdi+r8*4], [rdi+r8*4]                  ; (y[i] != 0)?
        setz    r11b
        and     dl, r11b                                ; `all_zeros &= `diffs[i] != 0`
; check loop condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_alloc_bignums                     ; loop again if yes
; end of .loop_alloc_bignums

        mov     ecx, 0xFFFFFFFF                         ; `result = -1`
; calculate neighboring subtractions, incrementing result along the way
.loop_incr_res:
        inc     ecx                                     ; `result++`
        dec     rsi                                     ; `n--`
        mov     dl, 0x1                                 ; `all_zeros = true`
        xor     r8, r8                                  ; `i = 0`
  ; inner loop of loop_incr_res - performs `n` subtractions
.loop_sub_all:
        push    r8
    ; inner loop of loop_sub_all - performs one subtraction
.loop_sub:
        ...
    ; check loop_sub condition
       inc     r8                                      ; `i++`
       cmp     r8, r10                                 ; `(i < bignum_len)?`
       jb      .loop_alloc_bignums                     ; loop again if yes
    ; end of loop_sub
  ; check loop_sub_all condition
        pop     r8
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_alloc_bignums                     ; loop again if yes
    ; end of loop_sub_all
; check loop_incr_res condition
       push     r12b
       push     r13b
       test     dl, dl
       setz     r12b                                    ; R12B := `!all_zeros`
       test     rsi, rsi
       setnz    r13b                                    ; R13B := `n > 0`
       and      r13b, r12b
       test     r13b
       pop      r13b
       pop      r12b
       jnz      .loop_incr_res                          ; loop again if `!all_zeros && n > 0`
; end of loop_incr_res

.return:
        mov     rdi, r10
        push    ecx
        call    free wrt ..plt                          ; `free(diffs)`
        pop     ecx                                     ; save value of `result`
        mov     eax, ecx                                ; EAX := `result`
        pop     rsi                                     ; regain original value of `n`
        ret                                             ; return with EAX
.exit_fail:
        pop     rsi
        mov     rax, 1                                  ; set exit code to 1
        syscall                                         ; exit
