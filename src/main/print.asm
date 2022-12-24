print16:
    pusha

print16_loop:
    mov al, [bx]
    cmp al, 0
    je print16_done

    mov ah, 0x0e
    int 0x10

    add bx, 1
    jmp print16_loop

print16_done:
    call print16_nl
    popa
    ret

print16_nl:
    pusha

    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10

    popa
    ret

failed:
    mov bx, BOOT_FAIL
    call print16
    jmp $

; Messages
MSG_BOOTING: db "ProtocOs booting...", 0
MSG_16BIT_MODE: db "Starting: 16-bit Mode...", 0
MSG_32BIT_MODE: db "Starting: 32-bit Mode...", 0
MSG_LOAD_KERNEL: db "Loading kernel...", 0
MSG_BOOT_SUCCESS: db 0x0a, 0x0d, "ProtocOs boot success.", 0x0a, 0x0d,  0
BOOT_FAIL: db 0x0a, 0x0d, "ProtocOs boot failed.", 0x0a, 0x0d,  0