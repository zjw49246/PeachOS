ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0:step2 ;set code segment


step2:
    cli ; clear interupts
    mov ax, 0x00
    mov ds, ax ; set data segment
    mov es, ax ; set extra segment
    mov ss, ax ; set stack segment
    mov sp, 0x7c00 ; set stack pointer
    sti ; enable interupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ; jmp CODE_SEG:load32
    jmp $

; GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code:       ; CS should point to this
    dw 0xffff   ; Segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x9a     ; Access byte
    db 11001111b; High 4 bit flags and the low 4 bit flags
    db 0        ; Base 24-31 bits

; offset 0x10
gdt_data:       ; DS， SS， ES， FS， GS
    dw 0xffff   ; Segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x92     ; Access byte
    db 11001111b; High 4 bit flags and the low 4 bit flags
    db 0        ; Base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start



times 510-($ - $$) db 0
dw 0xAA55