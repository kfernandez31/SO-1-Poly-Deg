%include "io64.inc"
extern printf

section .bss
        n   equ 3
        exp equ 0

section .data
        y   dd 5,6,7
        fmt db "Got %d, expected %d", 10, 0
        elm db "%d ", 0
        endl db "", 10, 0
        dupa db "Dupa!", 10, 0


section .text
global CMAIN
CMAIN:
        mov rbp, rsp; for correct debugging

        mov     rdi, y
        mov     rsi, n
        call    polynomial_degree
        mov     rdi, fmt
        mov     rsi, rax
        mov     rdx, exp
        mov     al, 0
        call    printf


      ; test: printing
        ;mov rdi, y
        ;mov rsi, n
        ;call print_int_array

        xor     rax, rax
        ret

print_int_array: ;(arr, n)
        xor r8, r8
.loop:
        mov r9, [rdi+r8*4]
        push rsi
        push rdi
        push r8

        mov     rdi, elm
        mov     rsi, r9
        mov     al, 0
        call    printf

        pop r8
        pop rdi
        pop rsi
        inc r8
        cmp r8, rsi
        jb  .loop

        mov rdi, endl
        ret


print_dupa:
    push rax
    push rdi

    mov al, 0
    mov rdi, dupa
    call printf
    pop rdi
    pop rax
    ret


; further in this file, "bignum" will refer to the representation of an integer as an array
global polynomial_degree
extern malloc
extern calloc
extern free
extern printf

; performs subtraction of two bignums and stores the result in the first one
sub_bignums:
        mov     rcx, 0x1                                ; `all_zeros = true`
        xor     r8, r8                                  ; `i = 0`, this also clears CF
        xor     r9, r9                                  ; `bool carry = false`
.loop:
        test    r9, r9
        jz      .no_carry

        sub     DWORD [rdi+r8*8], 0x1                   ; `if(carry) a[i]--`
        setc    r10b
        test    r10b, r10b
        jz      .no_carry
        mov     r9, 0x1                                 ; `if(FC) carry = true`

    .no_carry:
        mov     r10d, DWORD [rsi+r8*8]
        sub     DWORD [rdi+r8*8], r10d                  ; `a[i] -= b[i]`
        setc    r9b                                     ; `carry = FC`

        mov     r10, [rdi+r8*8]
        test    r10, r10
        setz    r11b
        and     cl, r11b                                ; `all_zeros &= (a[i] == 0)`

; check outer_loop condition
        inc     r8                                      ; `i++`
        cmp     r8, rdx                                 ; `(i < bignum_len)?`
        jb      .loop                                   ; loop again if yes
        ret



; TODO: tu chyba jeszcze powinienem wyrównać RSP do 16tki
polynomial_degree:
        push    rsi                                     ; save value of `n`
; legend to variables:
; - RDI - `int const *y`           - 1st arg
; - RSI - `size_t n`               - 2nd arg
; - RDX  - `bool all_zeros = true` - flag to check whether all numbers in an array are 0
; - RCX - `int result = -1`        - result of the function
; - R8  - `size_t i = 0`           - loop index
; - R9  - TODO: wybrać rozmiar!!! `int_8t** diffs`         - array of subtractions of neighboring elements
; - R10 - `size_t bignum_len = roundUp_32(n+32)/sizeof(int)` (explained 11 lines below)
; allocate dynamic array `diffs` with malloc:
        push    rdi
        push    rsi
        mov     rdi, rsi
        shl     rdi, 0x3                                ; RDI := `n * sizeof(int*)`
        call    malloc wrt ..plt                        ; call malloc with prepared size
        test    rax, rax                                ; check malloc's result
        pop     rsi
        pop     rdi
        jz      .exit_fail
        mov     r9, rax                                 ; assign malloc's result to `diffs`
; `bignum_len` is `n+32` rounded up to nearest multiple of 8 and then divided by 1 byte
        ;mov     r10, rsi
        ;add     r10, 0x27                 ; +32+7
        ;and     r10, 0xFFFFFFFFFFFFFFF8   ; &(-8)
        ;shr     r10, 0x3                  ; /8
; `bignum_len` is `n+32` rounded up to nearest multiple of 32 and then divided by 4 bytes
        mov     r10, rsi
        add     r10, 0x3F                 ; +32+31
        and     r10, 0xFFFFFFFFFFFFFFE0   ; &(-31)
        shr     r10, 0x5                  ; /32

        xor     r8, r8                                 ; `i = 0`
        mov     rdx, 0x1                               ; `all_zeros = true`

; convert values of `y` into bignums of `diffs`, check if they're all zeros
.loop_alloc_bignums:    ;TODO: czy tu dobrze adresuję?
  ; allocate space for `i`-th bignum
    ; save values of scratch registers
        push    rdi
        push    rsi
        push    rdx
        push    r8
        push    r9
        push    r10
        mov     rdi, r10                                ; RDI := `bignum_len`
        mov     rsi, 0x100                              ; RSI := `sizeof(int)`
        call    calloc wrt ..plt                        ; call calloc with prepared size
        pop     r10
        pop     r9
        pop     r8
        pop     rdx
        pop     rsi
        pop     rdi
        test    rax, rax                                ; check calloc's result
        jz      .exit_fail
        mov     [r9+r8*8], rax                          ; assign calloc's result to `diffs[i]`
  ; initialize bignum with its first 4 bytes
        mov     r11, [rdi+r8*4]
        mov     [r9+r8*8], r11                          ; `diffs[i][0] = y[i]`
  ; check if `y[i] == 0`
        push    r10
        mov     r10, [rdi+r8*4]
        test    r10, r10                                ; (y[i] != 0)?
        pop     r10
        setz    r11b
        and     dl, r11b                                ; `all_zeros &= `diffs[i] != 0`
; check loop condition
        inc     r8                                      ; `i++`
        cmp     r8, rsi                                 ; `(i < n)?`
        jb      .loop_alloc_bignums                     ; loop again if yes
; end of .loop_alloc_bignums

        mov     rcx, 0xFFFFFFFF                         ; `result = -1`
; calculate neighboring subtractions, incrementing result along the way
.loop_incr_res:
        inc     ecx                                     ; `result++`
        dec     rsi                                     ; `n--`
        xor     r8, r8                                  ; `i = 0`
  ; inner loop of loop_incr_res - performs `n` subtractions
.loop_sub_all:
        push    rdi
        push    rsi
        push    rdx
        push    rcx
        push    r8
        push    r9
        push    r10

        lea     rdi, [r9+r8*8]                          ; RDI := `diffs[i]`
        lea     rsi, [r9+r8*8+8]                        ; RSI := `diffs[i+1]`
        mov     cl, dl                                  ; CL := `all_zeros`
        mov     rdx, r10                                ; RDX := `bignum_len`
        call    sub_bignums                             ; `sub_bignums(diffs[i], diffs[i+1], bignum_len, all_zeros)`
        mov     dl, cl                                  ; `all_zeros` may have gotten updated in sub_bignums

        pop     r10
        pop     r9
        pop     r8
        pop     rcx
        pop     rdx
        pop     rsi
        pop     rdi
  ; check loop_sub_all condition
        pop     r8
        inc     r8                                      ; `i++`
        dec     rsi
        cmp     r8, rsi                                 ; `(i < n-1)?`
        inc     rsi
        jb      .loop_sub_all                           ; loop again if yes
  ; end of loop_sub_all
; check loop_incr_res condition
       push     r12
       push     r13
       test     dl, dl
       setz     r12b                                    ; R12B := `!all_zeros`
       test     rsi, rsi
       setnz    r13b                                    ; R13B := `n > 0`
       and      r13b, r12b
       test     r13b, r13b
       pop      r13
       pop      r12
       jnz      .loop_incr_res                          ; loop again if `!all_zeros && n > 0`
; end of loop_incr_res

.return:
        mov     rdi, r9
        push    rcx
        call    free wrt ..plt                          ; `free(diffs)`
        pop     rcx                                     ; save value of `result`
        mov     eax, ecx                                ; EAX := `result`
        pop     rsi                                     ; regain original value of `n`
        ret                                             ; return with EAX
.exit_fail:
        pop     rsi
        mov     rax, 1                                  ; set exit code to 1
        syscall                                         ; exit
