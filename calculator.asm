section .data
    msg1 db 'Enter first number: ', 0
    msg2 db 'Enter second number: ', 0
    msg3 db 'Enter operator (+ - * /): ', 0
    resultMsg db 'Result: ', 0
    newline db 10, 0

section .bss
    num1 resb 10
    num2 resb 10
    op resb 2
    result resb 10

section .text
    global _start

_start:
    ; Prompt and read first number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 20
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10
    int 0x80

    ; Prompt and read second number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 22
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 0x80

    ; Prompt and read operator
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 27
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80

    ; Convert num1 from ASCII to integer
    mov ecx, num1
    call atoi
    mov esi, eax ; store first number in esi

    ; Convert num2 from ASCII to integer
    mov ecx, num2
    call atoi
    mov edi, eax ; store second number in edi

    ; Check operator and perform operation
    mov al, [op]
    cmp al, '+'
    je add_nums
    cmp al, '-'
    je sub_nums
    cmp al, '*'
    je mul_nums
    cmp al, '/'
    je div_nums

    jmp exit

add_nums:
    mov eax, esi
    add eax, edi
    jmp print_result

sub_nums:
    mov eax, esi
    sub eax, edi
    jmp print_result

mul_nums:
    mov eax, esi
    imul eax, edi
    jmp print_result

div_nums:
    mov eax, esi
    xor edx, edx
    idiv edi
    jmp print_result

print_result:
    mov ebx, eax ; store result in ebx
    call itoa
    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, resultMsg
    mov edx, 8
    int 0x80

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ----------------------
; Convert ASCII to int
; ----------------------
atoi:
    xor eax, eax
    xor ebx, ebx
.next_digit:
    mov bl, [ecx]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done
    cmp bl, 13
    je .done
    cmp bl, 32
    je .done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc ecx
    jmp .next_digit
.done:
    ret

; ----------------------
; Convert int to ASCII
; ----------------------
itoa:
    mov ecx, result
    add ecx, 9
    mov byte [ecx], 0
    mov eax, ebx
    cmp eax, 0
    jne .convert
    mov byte [ecx-1], '0'
    dec ecx
    jmp .done
.convert:
    xor edx, edx
.loop:
    dec ecx
    xor edx, edx
    mov ebx, 10
    div ebx
    add edx, '0'
    mov [ecx], dl
    test eax, eax
    jnz .loop
.done:
    mov eax, 4
    mov ebx, 1
    mov edx, 10
    mov esi, ecx
    ret
