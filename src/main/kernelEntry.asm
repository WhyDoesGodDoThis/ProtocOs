[bits 32]
[extern main]

; Test for if its running
mov ah, 0x0e
mov al, 'e'
int 0x10
mov al, 0x00
mov ah, 0x00

call main
jmp $