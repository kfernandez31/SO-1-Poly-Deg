; todo: hide what shouldn't be global
extern printf

global mod
global hash
global polynomial_degree
extern malloc
extern free

mod:                                                    ; calculates x % y
        push    rbp
        mov     rbp, rsp                                ; create stack frame
        sub     rsp, 0x18                               ; get stack space for 2 longs (16 bytes) + 8 bytes offset

        mov     QWORD [rbp-0x8], rdi                    ; (1st arg) RDI := `x`
        mov     QWORD [rbp-0x10], rsi                   ; (2nd arg) RSI := `y`
        mov     rax, QWORD [rbp-0x8]                    ; RAX := `x`
        cqo                                             ; fill RDX with the sign of `x` that is in RAX
        idiv    rsi                                     ; divide RDX:RAX by RSI, RDX shall hold remainder
        mov     rax, rdx                                ; move return value (remainder) to RAX

        add     rsp, 0x18                               ; clear stack
        pop     rbp                                     ; destroy stack frame
        ret                                             ; return with RAX

hash:                                                   ; calculates ((x % 0x3B9ACA07) % 0x3B9ACA09) % 0x3B9ACA15
        push    rbp
        mov     rbp, rsp                                ; create stack frame
        sub     rsp, 0x10                               ; get stack space for 1 long (8 bytes) + 8 bytes offset
        ; first modulo:
        mov     rsi, 0x3B9ACA07
        call    mod
        mov     QWORD [rbp-0x8], rax                    ; copy first result into `x`
        ; second modulo:
        mov     rsi, 0x3B9ACA09
        call    mod
        mov     QWORD [rbp-0x8], rax                    ; copy second result into `x`
        ; third modulo:
        mov     rsi, 0x3B9ACA15
        call    mod
        add     rsp, 0x10                               ; clear stack
        pop     rbp                                     ; destroy stack frame
        ret                                             ; return with RAX

polynomial_degree:
        push    rbp                                     ; create stack frame
        mov     rbp, rsp
        sub     rsp, 0x30                               ; get stack space for:
        ; - arguments:
        ;     - `int const* y` (8 bytes),
        ;     - `size_t n` (8 bytes),
        ; - local variables:
        ;     - `bool all_zeros` (1 byte),
        ;     - `int result` (4 bytes),
        ;     - `long* diffs` (8 bytes),
        ;     - `size_t i` (8 bytes),
        ; - offset: 11 bytes.
        mov     QWORD [rbp-0x8], rdi                    ; (1st arg) RDI := `y`
        mov     QWORD [rbp-0x10], rsi                   ; (2nd arg) RSI := `n`
        mov     DWORD [rbp-0x14], 0xFFFFFFFF            ; `result = -1`
        ; corner-case checking:
        cmp     QWORD [rbp-0x8], 0x0                    ; check if `y == NULL`
        je      return
        cmp     QWORD [rbp-0x10], 0x0                   ; check if `n == 0`
        je      return                                  ; return -1 if either arg is 0

        mov     BYTE [rbp-0x15], 0x1                    ; `all_zeros = true`
        ; allocate dynamic array `diffs` with malloc:
        mov     rax, QWORD [rbp-0x10]                   ; RAX := `n`
        shl     rax, 0x3                                ; RAX := `n * `sizeof(long)`
        mov     rdi, rax
        call    malloc wrt ..plt                        ; call malloc with prepared size
        test    rax, rax                                ; check malloc's result
        jz      fail_exit
        mov     QWORD [rbp-0x20], rax                   ; assign malloc's result to `diffs`

        mov     QWORD [rbp-0x28], 0x0                   ; prepare loop index `i = 0`
        mov     rax, QWORD [rbp-0x8]                    ; RAX := `y`
        mov     rcx, QWORD [rbp-0x20]                   ; RCX := `diffs`
    loop_copy:                                          ; copy contents of `y` into `diffs`, check if `y` is zero-filled
        mov     rdx, QWORD [rbp-0x28]                   ; RDX := `i`
        movsx   rsi, DWORD [rax+rdx*4]                  ; RSI := `y[i]`
        mov     QWORD [rcx+rdx*8], rsi                  ; `diffs[i] = y[i]`

        mov     r8b, BYTE [rbp-0x15]                    ; R8B := `all_zeros`
        mov     r9, QWORD [rcx+rdx*8]                   ; R9 := `diffs[i]`
        test    r9, r9
        sete    r9b                                     ; R9B := `diffs[i] != 0`
        and     r8b, r9b
        mov     BYTE [rbp-0x15], r8b                    ; `all_zeros &= `diffs[i] != 0`

        inc     QWORD [rbp-0x28]                        ; `i++`
        mov     rdx, QWORD [rbp-0x28]                   ; RDX := `i`
        cmp     rdx, QWORD [rbp-0x10]                   ; compare `i` with `n`
        jb      loop_copy                               ; loop again if `i < n`
    ; end of loop_copy
    loop_incr_res:
        inc     DWORD [rbp-0x14]                        ; `result++`
        dec     QWORD [rbp-0x10]                        ; `n--`
        mov     BYTE [rbp-0x15], 0x1                    ; set `all_zeros` to true
        mov     QWORD [rbp-0x28], 0x0                   ; prepare loop index `i = 0`
        mov     rcx, QWORD [rbp-0x20]                   ; RCX := `diffs`
    loop_hash:
        mov    rdx, QWORD [rbp-0x28]                    ; RAX := `i`
        mov    rax, QWORD [rcx+rdx*8]                   ; RAX := `diffs[i]`
        mov    rdi, QWORD [rcx+rdx*8+0x1]               ; RDI := `diffs[i+1]`
        sub    rdi, rax

                ; auxiliary printing:
                ;mov rdi, fmt1
                ;mov rsi, QWORD [rbp-0x10]
                ;mov rdx, QWORD [rbp-0x14]
                ;mov al, 0
                ;call printf

        ;call   hash
        ;mov    QWORD [rcx+rdx*8], rax                   ; `diffs[i] = hash(diffs[i]-diffs[i+1])` TODO: wywala się

        mov rax, rdi
        mov     r8b, BYTE [rbp-0x15]                     ; R8B := `all_zeros`
        mov     r9, QWORD [rcx+rdx*8]                    ; R9 := `diffs[i]`
        test    r9, r9
        setnz   r10b                                     ; R10B := `diffs[i] != 0`
        and     r8b, r10b
        mov     BYTE [rbp-0x15], r8b                     ; `all_zeros &= `diffs[i] != 0`

        inc    QWORD [rbp-0x30]                         ; `i++`
        mov    rdx, QWORD [rbp-0x30]                    ; RAX := `i`
        cmp    rdx, QWORD [rbp-0x10]                    ; compare `i` with `n`
        jb      loop_hash                                ; loop again if `i < n`
    ; end of loop_hash
        mov     r8b, BYTE [rbp-0x15]                    ; R8B := `all_zeros`
        test    r8b, r8b
        setnz   r11b                                    ; R11B := `!all_zeros`
        mov     r9, QWORD [rbp-0x10]                    ; R9 := `n`
        test    r9, r9
        setne   r10b                                    ; R10B := `n > 0`
        and     r10b, r11b                              ; R10B := `!all_zeros && n > 0`
        cmp     r10b, 0x1
        je     loop_incr_res                            ; loop again if `!all_zeros && n > 0`
    ;end of loop_incr_res
    return:
        mov     rdi, QWORD [rbp-0x20]
        call    free wrt ..plt                          ; `free(diffs)` ;TODO: wywala się
        mov     eax, DWORD [rbp-0x14]                   ; EAX := `result`
        add     rsp, 0x30                               ; clear stack
        pop     rbp                                     ; destroy stack frame
        ret                                             ; return with EAX
    fail_exit:
        add     rsp, 0x30                               ; clear stack
        pop     rbp                                     ; destroy stack frame
        mov     eax, 1                                  ; set exit code to 1
        int     0x80                                    ; exit

section .data
    fmt1:    db "n = %ld, result = %d", 10, 0
    fmt2:    db "n = %ld", 10, 0