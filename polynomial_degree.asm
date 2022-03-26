extern printf
section .bss
        m   equ 0xFFFFFFFF
        
        exp equ 0
        n   equ 981   
section .data
        y   dd -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
        fmt db "Got %d, expected %d", 10, 0
        elm db "%d ", 0
        endl db "", 10, 0
section .text
global main
main:
        mov rbp, rsp; for correct debugging
        sub     rsp, 0x8
        mov     rdi, y
        mov     rsi, n
        call    polynomial_degree
        mov     rdi, fmt
        mov     rsi, rax
        mov     rdx, exp
        call    printf
        ret

; further in this file, "bignum" will refer to the representation of an integer as an (int32_t) array
global polynomial_degree
extern malloc
extern calloc
extern free

SYS_EXIT        equ 0x1
EXIT_FAIL       equ 0x1

polynomial_degree:
        sub     rsp, 0x8                                ; stack offset to 16 bytes
; legend to variables:
; - RDI - `int const *y`    - 1st arg
; - RSI - `size_t n`        - 2nd arg
; - EDX - `int arr_alt = 0` - bit-alternative of every element in an array - used to check whether all numbers in an array are 0
; - RCX - `int result = -1` - result of the function
; - R9  - `int_32t *bnums`  - dynamically allocated array ([n][bnum_len]) of bigints (actually one contiguous block)
; - R10 - `size_t bnum_len` - bigint length - k/sizeof(int) such that $min_{k\inN}: k*32 >= n+32$ ;TODO: dobrze?
        mov     r10, rsi
        add     r10, 0x3F                 ; +32+31
        and     r10, 0xFFFFFFFFFFFFFFE0   ; &(-31)
        shr     r10, 0x5                  ; /32
; allocate dynamic array `bnums` with malloc:
        push    rdi                                     ; save value of both input args
        push    rsi

        push    rdi
        push    rsi
        push    rdx
        push    rcx
        push    r8
        push    r9
        push    r10
        
        mov     rax, rsi
        mul     r10
        shl     rax, 0x2                                ; RAX := `n * bnum_len * sizeof(int)`
        mov     rdi, rax
        call    calloc wrt ..plt                        ; call calloc with prepared size
        pop     r10
        pop     r9
        pop     r8
        pop     rcx
        pop     rdx
        pop     rsi
        pop     rdi
        test    rax, rax                                ; check calloc's result
        jz      .exit_fail
        mov     r9, rax                                 ; assign calloc's result to `bnums`
; `bnum_len` is `n+32` rounded up to nearest multiple of 32 and then divided by 4 bytes (for each int_32 cell)

        xor     r8, r8                                 ; `i = 0`
        xor     edx, edx                               ; `array_alt = 0`
.loop_init_bignums: ;`for(i=0..n-1){...}` - preprocess each `y[i]` into a bignum `bnums[i]`, check if `y[i] == 0`
  ; initialize bignum with its first 4 bytes and check value and sign of `y[i]`
        mov     rax, r8
        push    rdx                                     ; 1-arg mul modifies rdx, have to save it
        mul     r10                                     ; RAX := `i * bnum_len`
        pop     rdx
        shl     rax, 0x2                                ; RAX *= `sizeof(int)`
        mov     r11d, DWORD[rdi+r8*4]                   ; R11D :=`y[i]`
        mov     [r9+rax], r11d                          ; `bnums[i][0] = y[i]`
        or      edx, r11d
        jns     .after_ext                              ; non-negative bignums are already sgn-exted due to calloc

        push    r8
        mov     r8, 0x1                                 ; `size_t j = 1`
.loop_sign_ext: ; `for(j=1..bignum_len-1){...}` - "sign-extends" a bignum with 1s; TODO: we popraw jak niżej
        lea     r11, [r9+rax]
        mov     rax, r8                                    
        shl     rax, 0x2  
        push    rdx                                     ; 1-arg mul modifies rdx, have to save it
        mul     r8                                      ; RAX := `j * sizeof(int)`
        pop     rdx
        add     r11, rax                                ; R11 := `bnums[i] + j*sizeof(int) == bnums[i][j]`     
        mov     DWORD[r11], 0xFFFFFFFF                  ; `bnums[i][j] = -1`
        inc     r8
        cmp     r8, r10                                 ; `(j < bnum_len)?`
        jb      .loop_sign_ext                          ; loop again if yes
        pop     r8                                      ; R8 = `i`
    ; end of loop_sign_ext
.after_ext:
; check loop_init_bignums condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_init_bignums                      ; loop again if yes
; end of loop_init_bignums

        mov     rcx, 0xFFFFFFFF                         ; `result = -1`
        push    r12                                     ; non-scratch register R12 has to be restored later
        test    rdx, rdx
        jz     .return                                  ; nothing left to compute, early return (case when y == [0...0])
.loop_main: ; `while(n > 0 && array_alt){...}` - main loop of the algorithm
        inc     ecx                                     ; `result++`
        xor     rdx, rdx                                ; `array_alt = false`
        dec     rsi                                     ; `n--`
        xor     r8, r8                                  ; `i = 0`
        test    rsi, rsi
        jz     .return                                  ; nothing left to compute, early return (case when n reaches 0)
.loop_all_sub: ; `for(i=0..n-1){...}` - inner loop of loop_main - performs all `n` subtractions
        mov     rax, r10                                    
        shl     rax, 0x2                                ; RAX := `bnum_len * sizeof(int)`
        mov     rdi, rax                                ; RDI won't used anymore, can use it as a scratch reg
        push    rdx                                     ; 1-arg mul modifies rdx, have to save it
        mul     r8                                      ; RAX := `i * bnum_len * sizeof(int)`
        pop     rdx
        add     rdi, rax                                ; RDI := `(i+1) * bnum_len * sizeof(int)`
        lea     r11, [r9+rax]                           ; R11 := `bnums[i]`
        lea     r12, [r9+rdi]                           ; R12 := `bnums[i+1]`
        push    r8                                      ; make use of R8 for another loop index - `j`
        xor     r8, r8                                  ; `size_t j = 0`
        pushf                                           ; required for the first iteration
.loop_one_sub: ; `for(j=0..bnum_len-1){...}` - inner loop of loop_all_sub - subtracts one bignum from another, saves the state of FC for when its needed
        popf                                            ; regain last carry
        mov     eax, [r12+r8*4]                         ; EDI := `bnums[i+1][j]`
        sbb     eax, [r11+r8*4]                         ; EAX := `bnums[i+1][j]-bnums[i][j]`
        mov     [r11+r8*4], eax                         ; `bnums[i][j] = bnums[i+1][j]-bnums[i][j]`
        pushf                                           ; push current carry
        or      edx, [r11+r8*4]                         ; `array_alt |= bnums[i][j]`
    ; check loop_one_sub condition
        inc     r8                                      ; `j++`
        cmp     r8, r10                                 ; `(j < bnum_len)?`
        jb      .loop_one_sub                           ; loop again if yes
        popf                                            ; flags don't need to be on the stack anymore
    ; end of loop_one_sub
        pop     r8                                      ; R8 = `i`
  ; check loop_all_sub condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_all_sub                           ; loop again if yes
  ; end of loop_all_sub
; check loop_main condition
        xor     r11, r11
        test    rsi, rsi
        setnz   r11b
        xor     rax, rax
        test    rdx, rdx
        setnz   al
        and     r11b, al                                ; `(array_alt != 0 && n > 0)?`
        jnz     .loop_main                              ; loop again if yes
; end of loop_main

.return:
        pop     r12

        push    rdi
        push    rsi
        push    rdx
        push    rcx
        push    r8
        push    r9
        push    r10
        mov     rdi, r9
        call    free wrt ..plt                          ; `free(bnums)`
        pop     r10
        pop     r9
        pop     r8
        pop     rcx
        pop     rdx
        pop     rsi
        pop     rdi
; actual return
        mov     eax, ecx                                ; EAX := `result`
        pop     rsi
        pop     rdi                                     ; regain original value of both input args
        add     rsp, 0x8
        ret                                             ; return with EAX
.exit_fail: ; label to jump to if ENOMEM occurs
        pop     rsi
        pop     rdi                                     ; regain original value of both input args
        mov     rax, SYS_EXIT
        mov     edi, EXIT_FAIL
        syscall                                         ; `exit(1)`

