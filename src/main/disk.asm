disk_load:
    ; Test for if its running
    mov ah, 0x0e
    mov al, 'b'
    int 0x10
    mov al, 0x00
    mov ah, 0x00

    pusha
    push dx

    mov ah, 0x02 ; read mode
    mov al, dh   ; read dh number of sectors
    mov cl, 0x02 ; start from sector 2
                 ; (as sector 1 is our boot sector)
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt
    jc disk_error ; check carry bit for error

    pop dx     ; get back original number of sectors to read
    cmp al, dh ; BIOS sets 'al' to the # of sectors actually read
               ; compare it to 'dh' and error out if they are !=
    jne sectors_error
    popa
    ret

disk_error:
    ; Test for if its running
    mov ah, 0x0e
    mov al, 'O'
    int 0x10
    mov al, 0x00
    mov ah, 0x00

    jmp $

sectors_error:
    ; Test for if its running
    mov ah, 0x0e
    mov al, '%'
    int 0x10
    mov al, 0x00
    mov ah, 0x00

    jmp $