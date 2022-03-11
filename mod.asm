global mod
global hash
global mod_with_overhead

mod:    ; calculates x % y
        push    rbp
        mov     rbp, rsp                ; create stack frame
        sub     rsp, 0x18               ; get stack space for 2 longs (16 bytes) + 8 bytes offset

        mov     QWORD [rbp - 0x8], rdi  ; copy RDI into x
        mov     QWORD [rbp - 0x10], rsi ; copy RSI into y
        mov     rax, QWORD [rbp - 0x8]  ; copy x into RAX
        cqo                             ; fill RDX with RAX's sign
        idiv    rsi                     ; divide RDX:RAX by RSI, RDX shall hold remainder
        mov     rax, rdx                ; move return value (remainder) to RAX

        add     rsp, 0x18               ; clear stack
        pop     rbp                     ; destroy stack frame
        ret                             ; return with RAX

hash:   ; calculates ((x % 0x3B9ACA07) % 0x3B9ACA09) % 0x3B9ACA15
        push    rbp
        mov     rbp, rsp                ; create stack frame
        sub     rsp, 0x10               ; get stack space for 1 long (8 bytes) + 8 bytes offset
        ; first modulo:
        mov     rsi, 0x3B9ACA07
        call    mod
        mov     QWORD [rbp - 0x8], rax  ; copy first result into x
        ; second modulo:
        mov     rsi, 0x3B9ACA09
        call    mod
        mov     QWORD [rbp - 0x8], rax  ; copy second result into x
        ; third modulo:
        mov     rsi, 0x3B9ACA15
        call    mod
        ; third result is already held in RAX
        add     rsp, 0x10               ; clear stack
        pop     rbp                     ; destroy stack frame
        ret                             ; return with RAX
