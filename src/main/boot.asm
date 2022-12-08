[bits 16]
[org 0x7c00]
[org 0x7c00]

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; Test for if its running
mov ah, 0x0e
mov al, 'a'
int 0x10
mov al, 0x00
mov ah, 0x00

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

; setup stack
mov bp, 0x9000
mov sp, bp

call load_kernel
call switch_to_32bit

jmp $

%include "src\main\disk.asm"
%include "src\main\gdt.asm"
%include "src\main\switch-to-32bit.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 4             ; dh -> num sectors
    mov dl, [BOOT_DRIVE]  ; dl -> disk
    call disk_load
    ret

[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET ; give control to the kernel
    jmp $ ; loop in case kernel returns

; boot drive variable
BOOT_DRIVE db 0

; padding
times 510 - ($-$$) db 0

; magic number
dw 0xaa55