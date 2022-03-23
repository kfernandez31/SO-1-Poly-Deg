; further in this file, "bignum" will refer to the representation of an integer as an (int32_t) array
global polynomial_degree
extern malloc
extern calloc
extern free
extern printf

section .bss
        m   equ 0xFFFFFFFF
        
        ;exp equ 1
        ;n   equ 5
        ;exp equ 2
        ;n   equ 9
        exp equ 0
        n   equ 1
        ;exp equ 0
        ;n   equ 2
        ;exp equ 0xFFFFFFFF
        ;n   equ 1
        ;exp equ 0xFFFFFFFF
        ;n   equ 4
        ;exp equ 5
        ;n   equ 6
        ;exp equ 65
        ;n   equ 66
        ;exp equ 67
        ;n   equ 68
section .data
        ;y   dd -9, 0, 9, 18, 27
        ;y   dd 1, 4, 9, 16, 25, 36, 49, 64, 81
        y   dd 777;TODO: crash?
        ;y   dd 5, 5
        ;y   dd 0 ;TODO: crash?
        ;y   dd 0,0,0,0 ;TODO: zły wynik (0 zamiast -1)?
        ;y   dd 1,m,1,m,1,m ;TODO: zły wynik (0 zamiast 5)?  v_(6 zamiast 65), vv_(2 zamiast 67)
        ;y   dd 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m
        y;   dd 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m, 1, m
        
        fmt db "Got %d, expected %d", 10, 0
        elm db "%d ", 0
        endl db "", 10, 0

section .text
print_array: ;(arr, n)
        xor r8, r8
.loop:
        mov r9, [rdi+r8*4]
                push rdi
                push rsi
                push r8
        mov     rdi, elm
        mov     rsi, r9
        mov     al, 0
        call    printf
                pop r8
                pop rsi
                pop rdi
        inc r8
        cmp r8, rsi
        jb  .loop
        
        mov     rdi, endl
        mov     al, 0
        call    printf
        
        ret

; TODO: tu chyba jeszcze powinienem wyrównać RSP do 16tki
global main
main:
    mov rbp, rsp; for correct debugging
        sub     rsp, 0x8
    
        ;;;DEBUG;;;
        mov     rdi, y
        mov     rsi, n
        ;;;DEBUG;;;
        
; legend to variables:
; - RDI - `int const *y`           - 1st arg
; - RSI - `size_t n`               - 2nd arg
; - EDX  - `int non_zero = false`  - flag to check whether all numbers in an array are 0
; - RCX - `int result = -1`        - result of the function
; - R8  - `size_t i=0, j=0`        - loop indexes
; - R9  - `int_32t** bnums`        - array of subtractions of neighboring elements
; - R10 - `size_t bignum_len = roundUp_32(n+32)/sizeof(int)` (explained a couple of lines below)
; - AL - `bool carry`              - local flag used during the bigint subtraction algorithm
; - R11, RCX                       - general purpose placeholder
; allocate dynamic array `bnums` with malloc:

        push    rdi                                     ; save value of both input args
        push    rsi
        
        push    rdi
        push    rsi
        mov     rdi, rsi
        shl     rdi, 0x3                                ; RDI := `n * sizeof(int*)`
        call    malloc wrt ..plt                        ; call malloc with prepared size
        test    rax, rax                                ; check malloc's result
        pop     rsi
        pop     rdi
        jz      .exit_fail
        mov     r9, rax                                 ; assign malloc's result to `bnums`
; `bignum_len` is `n+32` rounded up to nearest multiple of 32 and then divided by 4 bytes
        mov     r10, rsi
        add     r10, 0x3F                 ; +32+31
        and     r10, 0xFFFFFFFFFFFFFFE0   ; &(-31)
        shr     r10, 0x5                  ; /32


        xor     r8, r8                                 ; `i = 0`
        xor     edx, edx                               ; `non_zero = false`
.loop_alloc_bignums: ;`for(i=0..n-1){...}` - preprocess each `y[i]` into a bignum `bnums[i]`, check if `y[i] == 0`
  ; save values of scratch registers
        push    rdi
        push    rsi
        push    rdx
        push    r8
        push    r9
        push    r10
        mov     rdi, r10                                ; RDI := `bignum_len`
        mov     rsi, 0x100                              ; RSI := `sizeof(int)`
        call    calloc wrt ..plt                        ; call calloc with the size of a bignum
        pop     r10
        pop     r9
        pop     r8
        pop     rdx
        pop     rsi
        pop     rdi
        test    rax, rax                                ; check calloc's result
        jz      .exit_fail
        mov     [r9+r8*8], rax                          ; assign allocated memory to `bnums[i]`
  ; check value and sign of `y[i]`
        mov     r11d, [rdi+r8*4]
        or      edx, r11d                               ; `non_zero |= `bnums[i]`
        test    r11d, r11d
        jns     .after_ext                              ; non-negative bignums are already sgn-exted due to calloc
       
        xor     r11, r11                                ; `size_t j = 0`
.loop_sign_ext: ; `for(j=0..n-1){...}` - "sign-extends" a bignum with 1s
        mov     DWORD[rax+r11*4], 0xFFFFFFFF            ; `bnums[i][j] = -1`
        inc     r11
        cmp     r11, rsi                                ; `(j < bignum_len)?`
        jb      .loop_sign_ext                          ; loop again if yes
    ; end of loop_sign_ext
.after_ext:
  ; initialize bignum with its first 4 bytes
        mov     r11d, [rdi+r8*4]   
        mov     [rax], r11d                             ; `bnums[i][0] = y[i]` 
; check loop_alloc_bignums condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_alloc_bignums                     ; loop again if yes
; end of .loop_alloc_bignums


        mov     rcx, 0xFFFFFFFF                         ; `result = -1`
        push    r12                                     ; non-scratch register R12 has to be restored later
.loop_main: ; `while(n > 0 && non_zero){...}` - main loop of the algorithm
        inc     ecx                                     ; `result++`
        dec     rsi                                     ; `n--`
        xor     r8, r8                                  ; `i = 0`
.loop_all_sub: ; `for(i=0..n-1){...}` - inner loop of loop_main - performs all `n` subtractions
        xor     rdx, rdx                                ; `non_zero = false`
        xor     al, al                                  ; `bool carry = false`
        mov     r11, [r9+r8*8]                          ; R11 := `bnums[i]`
        mov     r12, [r9+r8*8+8]                        ; R12 := `bnums[i+1]`
        push    r8                                      ; push R8 in order to use it for another index - `j`
        xor     r8, r8                                  ; `size_t j = 0`
.loop_one_sub: ; `for(j=0..bignum_len-1){...}` - inner loop of loop_all_sub - subtracts one bignum from another
        test    al, al
        jz      .actual_sub                             ; no carry from previous iteration, proceed to the actual subtraction
        dec     DWORD[r11+r8*4]                         ; `if(carry) bnums[i][j]--`
        setc    al
        test    al, al
        jz      .actual_sub                             ; no carry from decrementing, proceed to the actual subtraction
        mov     al, 0x1                                 ; `if(FC) carry = true`
        push    rdi
.actual_sub:
        mov     edi, DWORD[r12+r8*4]                    ; EDI := `bnums[i+1][j]`
        sub     DWORD[r11+r8*4], edi                    ; `bnums[i][j] -= bnums[i+1][j]`
        setc    al                                      ; `carry = FC`
        or      edx, DWORD[r11+r8*4]                    ; `non_zero |= bnums[i][j]`
    ; check loop_one_sub condition
        inc     r8                                      ; `j++`
        cmp     r8, r10                                 ; `(j < bignum_len)?`
        jb      .loop_one_sub                           ; loop again if yes
    ; end of loop_one_sub
        pop     r8                                      ; regain `i` in R8
  ; check loop_all_sub condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_all_sub                           ; loop again if yes
  ; end of loop_all_sub
; check loop_main condition
        and     rdx, rsi                                ; `(non_zero && n > 0)?`
        jnz     .loop_main                              ; loop again if yes
; end of loop_main


        pop     r12
.return:
        mov     rdi, r9
        push    rcx
        call    free wrt ..plt                          ; `free(bnums)`
        pop     rcx                                     ; save value of `result`
        mov     eax, ecx                                ; EAX := `result`
        pop     rsi
        pop     rdi                                     ; regain original value of both input args
        add     rsp, 0x8
        
        ;;;DEBUG;;;
        push    rax
        mov     rdi, fmt
        mov     rsi, rax
        mov     rdx, exp
        mov     al, 0
        call    printf
        xor     rax, rax
        pop     rax
        ;;;DEBUG;;;
        ret                                             ; return with EAX
.exit_fail:
        pop     rsi
        mov     rax, 1                                  ; set exit code to 1
        syscall                                         ; exit

