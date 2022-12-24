[bits 16]
[org 0x7c00]
; Bootloader code

mov bx, MSG_BOOTING
call print16
mov bx, MSG_16BIT_MODE
call print16

; Set up the necessary data structures and registers
mov ax, 0x0000
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, 0x7C00

mov bx, MSG_LOAD_KERNEL
call print16

; Load the kernel file into memory
mov ah, 0x02        ; Function code for read sector
mov al, 0x03        ; Read 1 sector
mov ch, 0x00        ; Track 0
mov cl, 0x02        ; Sector 2
mov dh, 0x00        ; Head 0
mov dl, 0x80        ; Drive number (0x80 = first hard disk)
int 0x13            ; Call the BIOS interrupt to read the sector
jc failed           ; If theres an error jump to the load failed

mov bx, MSG_32BIT_MODE
call print16

; Set up the Global Descriptor Table (GDT)
gdt:
    dw 0x0000       ; Null descriptor
    dw 0x0000
    dd 0x00000000

; Code segment descriptor
gdt_code:
    dw 0xFFFF       ; Limit (4 GB)
    dw 0x0000       ; Base address (0)
    db 0x00         ; Access byte
    db 0x09         ; Granularity byte
    db 0x00         ; Base address (high byte)

; Data segment descriptor
gdt_data:
    dw 0xFFFF       ; Limit (4 GB)
    dw 0x0000       ; Base address (0)
    db 0x00         ; Access byte
    db 0x09         ; Granularity byte
    db 0x00         ; Base address (high byte)

; Set up the GDT pointer
gdt_ptr:
    dw 0x27         ; Limit (sizeof(gdt)-1)
    dd gdt          ; Base address of GDT

; Load the GDT
lgdt [gdt_ptr]

; Set up the code and data segment registers
mov ax, gdt_code
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esi, 0x7E00   ; Kernel entry point
mov ebx, 0x7C00   ; Kernel base address
mov ecx, 0x0001   ; Kernel size (in sectors)

; Switch to protected mode
mov eax, cr0
or eax, 1
mov cr0, eax

; Jump to the kernel entry point
jmp esi

; Printing code
%include "src\main\print.asm"

; Pad the bootloader to 510 bytes
times 510-($-$$) db 0

; Add the boot signature
dw 0xAA55