; ----------------------------------------------------------------------------------------
; This is a Win64 console program. It uses standard C libraries.
; 
; To assemble and run:
;     nasm -fwin64 part_2.asm && gcc part_2.obj && .\a.exe
;
; NASM tutorial:
;     https://cs.lmu.edu/~ray/notes/nasmtutorial/
; ----------------------------------------------------------------------------------------

        bits 64
        default rel

        global  main
        extern  printf                          ; int printf ( const char * format, ... );
        extern  fopen                           ; FILE * fopen ( const char * filename, const char * mode );
        extern  fgetc                           ; int fgetc ( FILE * stream );
        extern  fclose                          ; int fclose ( FILE * stream );

        section .data
fname:  db      './input.txt', 0                ; The input file path
fmode:  db      'r', 0                          ; Open the file in 'read' mode
txtend: db      'safe = %d', 0Ah, 0             ; Format for the last printf
txts:   db      'row %d is safe / %d', 0Ah, 0   ; Format for the printf that informs that a row is safe and the iteration
txtuns: db      'row %d is unsafe / %d', 0Ah, 0 ; Format for the printf that informs that a row is unsafe and the iteration
safe:   dd      0                               ; Total amount of safe rows
rown:   dd      0                               ; Row number - stores the current row beign processed

        section .bss
f:      resq    1                               ; Holds the file reference
arr:    resb    16                              ; An array of up to 16 uint of 8 bits, where the row numbers will be stored
arrcpy: resb    16                              ; An array of up to 16 uint of 8 bits, where the filtered array will be copied
arrlen: resb    1                               ; The length of the array above
iter:   resb    1                               ; The iteration run -- when removing elements from the array, it indicates the position 1-indexed to be removed

        section .text
main:
        mov     rcx, fname                      ; {fopen} rcx <- fname
        mov     rdx, fmode                      ; {fopen} rdx <- fmode
        sub     rsp, 28h                        ; {fopen} Reserve the shadow space
        call    fopen                           ; {fopen} rax <- fopen(rcx, rdx) = fopen(fname, fmode)
        add     rsp, 28h                        ; {fopen} Remove shadow space
        mov     [f], rax                        ; [f] <- file reference
loadRow:
        inc     dword [rown]                    ; Increment row number
        mov     byte [iter], 0                  ; Initialize iterations/tries at 0
        lea     r12, [arr]                      ; Initialize base in non-volatile register
        mov     r13, 0                          ; Initialize index in non-volatile register
        mov     byte [r12+r13], 0               ; Set first element to 0
readNumber:
        mov     rcx, [f]                        ; {fgetc} rcx <- [f]
        sub     rsp, 28h                        ; {fgetc} Reserve the shadow space
        call    fgetc                           ; {fgetc} rax <- fgetc(rcx) = fgetc(f)
        add     rsp, 28h                        ; {fgetc} Remove shadow space
        cmp     eax, -1                         ; Is the last character read EOF? If so, end the program
        je      exit                            ;
        cmp     eax, 0Ah                        ; Is the last character read LF? If so, process the read numbers so far
        je      processRow                      ;
        cmp     eax, 20h                        ; Is the last character read SPACE? If not, add the digit saved to the current number beign red
        jne     saveNumber                      ;
        inc     r13                             ; If it is space, a number ended, so increment the index
        mov     byte [r12+r13], 0               ; Initialize the next number to read as 0
        jmp     readNumber                      ; Start the process again
saveNumber:
        sub     al, 30h                         ; Convert the digit to a number (assumes it is a digit)
        movsx   cx, byte [r12+r13]              ; Get the number read so far and extend it to 16 bits
        imul    cx, cx, 10                      ; Multiply it by 10
        add     cl, al                          ; Add the digit to it, so cl <- cl*10 + al (appended digit)
        mov     byte [r12+r13], cl              ; Save the number
        jmp     readNumber                      ; Read next number
processRow:
        inc     r13                             ; Add one to the index to get the length of the array
processRowLoop:
        cmp     byte [iter], r13b               ; Does iter number exceeds the length of the array?
        jg      loadRow                         ; If so, load next row (assumes "unsafe")
        lea     rcx, [arr]                      ; {copyArray} rcx <- arr reference
        lea     rdx, [arrcpy]                   ; {copyArray} rdx <- arrcpy reference
        mov     r8, r13                         ; {copyArray} r8 <- r13 = arr length
        movzx   r9, byte [iter]                 ; {copyArray} r9 <- [iter] = item to remove + 1
        dec     r9                              ; {copyArray} r9 <- index of item to remove
        sub     rsp,  28h                       ; {copyArray} Reserve the shadow space
        call    copyArray                       ; {copyArray} rax <- copyArray(arr, arrcpy) = arrcpy length
        add     rsp,  28h                       ; {copyArray} Remove shadow space
        lea     rcx,  [arrcpy]                  ; {safetyCheck} rcx <- arrcpy reference
        mov     rdx,  rax                       ; {safetyCheck} rdx <- rax = arrcpy length
        sub     rsp,  28h                       ; {safetyCheck} Reserve the shadow space
        call    safetyCheck                     ; {safetyCheck} rax <- safetyCheck(rcd, rdx) = safetyCheck(arr, arrlen)
        add     rsp,  28h                       ; {safetyCheck} Remove shadow space
        cmp     rax,  1                         ; Is the array safe?
        je      isSafe                          ; Then jump -- otherwise, print "unsafe"
        mov     rcx, txtuns                     ; {printf} rcx <- txtuns
        movsx   rdx, dword [rown]               ; {printf} rdx <- [rown]
        movsx   r8, byte [iter]                 ; {printf} r8 <- [iter]
        sub     rsp, 28h                        ; {printf} Reserve the shadow space
        call    printf                          ; {printf} printf(rcx, rdx, r8) = printf(txtuns, rown, iter)
        add     rsp, 28h                        ; {printf} Remove shadow space
        inc     byte [iter]                     ; Increments iteration
        jmp     processRowLoop                  ; Try again
isSafe:
        mov     rcx, txts                       ; {printf} rcx <- txts
        movsx   rdx, dword [rown]               ; {printf} rdx <- [rown]
        movsx   r8, byte [iter]                 ; {printf} r8 <- [iter]
        sub     rsp, 28h                        ; {printf} Reserve the shadow space
        call    printf                          ; {printf} printf(rcx, rdx, r8) = printf(txtuns, rown, iter)
        add     rsp, 28h                        ; {printf} Remove shadow space
        inc     dword [safe]                    ; Increment safe total
        jmp     loadRow                         ; Load next row
exit:
        mov     rcx, txtend                     ; {printf} rcx <- txtend
        movsx   rdx, dword [safe]               ; {printf} rdx <- [save]
        sub     rsp, 28h                        ; {printf} Reserve the shadow space
        call    printf                          ; {printf} printf(rcx, rdx) = printf(txtend, save)
        add     rsp, 28h                        ; {printf} Remove shadow space
        mov     rcx, [f]                        ; {fclose} rcx <- [f]
        sub     rsp, 28h                        ; {fclose} Reserve the shadow space
        call    fclose                          ; {fclose} fclose(rcx) = fclose(f)
        add     rsp, 28h                        ; {fclose} Remove shadow space
        ret


; Safety check subroutine
; Computes whether an array of numbers is a safe sequence
; rcx = array pointer
; rdx = array length
; rax = 0 (unsafe) or 1 (safe)
safetyCheck:
        push    rbx                             ; Save registers
        push    rcx                             ;
        push    r8                              ;
        mov     rbx, rcx                        ; rbx <- array base pointer
        mov     r8, rdx                         ; r8 <- array length
        mov     rax, 0                          ; rax <- return value (default "unsafe")
        mov     dl, byte [rbx+0]                ; dl <- "previous element" -- initializes as the first element of the array
        mov     dh, dl                          ; dh <- whether the sequence increments or decrement
        sub     dh, byte [rbx+1]                ;       it's deduced from the first two elements (sign bit of prev - current)
        shr     dh, 7                           ;       1 = inc / 0 = dec
        mov     rcx, 1                          ; rcx <- iterator (starts at 1)
.loop:
        sub     dl, byte [rbx+rcx]              ; dl <- dl - [rbx+rcx] = prev - current
        cmp     dl, 0                           ; Check for correct magnitude (1,2,3 positive or negative)
        je      safetyCheck.fail                ;
        cmp     dl, -3                          ;
        jl      safetyCheck.fail                ;
        cmp     dl, 3                           ;
        jg      safetyCheck.fail                ;
        shr     dl, 7                           ; dl <- dl >> 7 = (prev - current) >> 7 = sign bit
        cmp     dl, dh                          ; Check for correct direction (inc/dec)
        jne     safetyCheck.fail                ;
        mov     dl, byte [rbx+rcx]              ; dl <- [rbx+rcx] = current (will be usea as "prev" in next iteration)
        inc     rcx                             ; Increment index
        cmp     rcx, r8                         ; Check if reached end
        jne     safetyCheck.loop                ;
        mov     rax, 1                          ; If this executes, it's a "safe" sequence
.fail:
        pop     r8                              ; Restore registers
        pop     rcx                             ;
        pop     rbx                             ;
        ret


; Copies array from one place to another, ignoring one value
; rcx = source array
; rdx = destiny array
; r8 = array length
; r9 = index to omit
; rax = length of the new array
copyArray:
        push    rsi                             ; Save registers
        push    rdi                             ;
        mov     rsi, 0                          ; Initialize source index
        mov     rdi, 0                          ; Initialize destiny index
.loop:
        cmp     rsi, r9                         ; Check if the index equals the item to omit
        je      copyArray.omit                  ; If so, omit
        mov     al, byte [rcx+rsi]              ; If not, copy register
        mov     byte [rdx+rdi], al              ;
        inc     rdi                             ; Increment destiny index
.omit:
        inc     rsi                             ; Increment source index
        cmp     rsi, r8                         ; Check if it reached the end of array
        jne     copyArray.loop                  ;
        mov     rax, rdi                        ; rax <- rdi = destiny array length
        pop     rdi                             ; Restore registers
        pop     rsi                             ;
        ret
