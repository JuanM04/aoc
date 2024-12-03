; -----------------------------------------------------------------------------
; This is a Win64 console program.
; It uses puts from the C library.
; 
; To assemble and run:
;     nasm -fwin64 part_1.asm && gcc part_1.obj && a
;
; NASM tutorial:
;     https://cs.lmu.edu/~ray/notes/nasmtutorial/
; -----------------------------------------------------------------------------

        bits 64
        default rel

        global  main
        extern  printf  ; int printf ( const char * format, ... );
        extern  fopen   ; FILE * fopen ( const char * filename, const char * mode );
        extern  fgetc   ; int fgetc ( FILE * stream );
        extern  fclose  ; int fclose ( FILE * stream );

        section .data
fname:  db      './input.txt', 0
fmode:  db      'r', 0
fmt:    db      'safe = %d', 0Ah, 0
txts:   db      'row %d is safe', 0Ah, 0
txtuns: db      'row %d is unsafe', 0Ah, 0
safe:   dd      0
rown:   dd      0

        section .bss
f:      resq    1
char:   resb    1
dir:    resb    1
prev:   resd    1
curr:   resd    1

        section .text
main:
        ; f = fopen(fname, fmode)
        mov     rcx, fname
        mov     rdx, fmode
        sub     rsp, 28h
        call    fopen
        add     rsp, 28h
        mov     [f], rax
processRow:
        ; Initialize varables
        mov     byte [dir], -1 ; 1 = inc / 0 = dec / -1 = undef
        mov     dword [prev], -1
        mov     dword [curr], 0
        inc     dword [rown]
        ; char = fgetc(f)
        mov     rcx, [f]
        sub     rsp, 28h
        call    fgetc
        add     rsp, 28h
        mov     [char], al
        ; is EOF? finish processing
        cmp     eax, -1
        je      exit
getDigit:
        ; add to curr : curr <- curr*10 + int(char)
        imul    ecx, dword [curr], 10
        mov     dword [curr], ecx
        and     eax, 0FFh
        sub     eax, 30h
        add     dword [curr], eax
        ; char = fgetc(f)
        mov     rcx, [f]
        sub     rsp, 28h
        call    fgetc
        add     rsp, 28h
        mov     [char], al
        ; is SPACE or LF? process safety
        cmp     eax, 0Ah
        je      checkStart
        cmp     eax, 20h
        je      checkStart
        jmp     getDigit
checkStart:
        mov     eax, dword [curr]
        ; if not prev, continue
        cmp     dword [prev], -1
        je      checkEnd
        ; ecx = prev - curr
        mov     ecx, dword [prev]
        sub     ecx, eax
        ; dl = dir
        mov     edx, ecx
        shr     edx, 31
        ; if dir not set, set it
        cmp     byte [dir], -1
        jne     checkDir
        mov     byte [dir], dl
        jmp     checkDiff
checkDir:
        cmp     byte [dir], dl
        jne     checkFail
checkDiff:
        ; check if diff is outside [-3,3] - {0}
        cmp     ecx, 0
        je      checkFail
        cmp     ecx, 3
        jg      checkFail
        cmp     ecx, -3
        jl      checkFail
        ; all checks passed, if EOL, increment safe total
        cmp     byte [char], 0Ah
        jne     checkEnd
        inc     dword [safe]
        ; print "is safe"
        mov     rcx, txts
        movsx   rdx, dword [rown]
        sub     rsp, 28h
        call    printf
        add     rsp, 28h
checkEnd:
        mov     dword [prev], eax
        mov     dword [curr], 0
        ; if EOL, process new row
        cmp     byte [char], 0Ah
        je      processRow
        ; char = fgetc(f)
        mov     rcx, [f]
        sub     rsp, 28h
        call    fgetc
        add     rsp, 28h
        mov     [char], al
        jmp     getDigit
checkFail:
        ; if check failed, consume up to to next EOL
        cmp     byte [char], 0Ah
        je      checkFailEnd
checkFailLoop:
        ; char = fgetc(f)
        mov     rcx, [f]
        sub     rsp, 28h
        call    fgetc
        add     rsp, 28h
        cmp     al, 0Ah
        jne     checkFailLoop
checkFailEnd:
        ; print "is unsafe"
        mov     rcx, txtuns
        movsx   rdx, dword [rown]
        sub     rsp, 28h
        call    printf
        add     rsp, 28h
        jmp     processRow
exit:
        ; printf("safe = %d", safe)
        mov     rcx, fmt
        movsx   rdx, dword [safe]
        sub     rsp, 28h
        call    printf
        add     rsp, 28h
        ; fclose(f)
        mov     rcx, [f]
        sub     rsp, 28h
        call    fclose
        add     rsp, 28h
        ret