ORG 0
BITS 16

jmp 0x7c0:start ;set code segment
start:
    cli ; clear interupts
    mov ax, 0x7c0
    mov ds, ax ; set data segment
    mov es, ax ; set extra segment
    mov ax, 0x00
    mov ss, ax ; set stack segment
    mov sp, 0x7c00 ; set stack pointer
    sti ; enable interupts

    mov si, message
    call print
    
    jmp $


print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0
dw 0xAA55