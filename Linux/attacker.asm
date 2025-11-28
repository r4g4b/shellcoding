bits 64
global _start
section .text
_start:
    ; socket()
    ; mac: 97	 int sys_socket(int domain, int type, int protocol); 
    ; linux: 29


    mov rdi, 0x2
    mov rsi, 1
    mov rdx, 0
    mov rax, 0x29
    syscall

    mov r12, rax  ; socket_fd

    ; connect

    mov rdi, r12

    ; pushing arguments on stack (map struct on stack)
        ; mov rcx, 0x02 00 11 5c 0100007f
    ; mov rcx, 0x020011d77f000001
    ; 0x7f000001 -> 01 00 00 7f
    ; 11 d7
    ; 00 02 -> 02 00 
    ; 02 00 11 d7 7f 00 00 01
    xor rdx, rdx
    push rdx  ; sin zero (8 bytes)
    mov rcx, 0x0100007fd7110002
    push rcx ; address(127.0.0.1) and port(4444 -> 11d7 in big endian) and family (0x02)

   
    mov rsi, rsp
    mov rdx, 16  ; size of struct address
    mov rax, 0x2A
    syscall
    cmp rax, 0
    je read_command
    jmp _exit1


read_command:
    mov rdi, 0              ; stdin
    sub rsp, 256            ; allocate buffer on stack
    mov rsi, rsp            ; buffer pointer
    mov rdx, 254            ; read max 254 bytes (leave room for \n\0)
    xor rax, rax            ; sys_read
    syscall
    ; rax = bytes read
    ; add newline and null terminator
    mov byte [rsp + rax], 0x0a      ; add '\n' at end
    inc rax
    mov byte [rsp + rax], 0x00      ; add '\0' 
    ; don't inc rax - we don't send the \0
    
    ; send command to socket (including \n but not \0)
    mov rdi, r12            ; socket_fd
    mov rsi, rsp            ; buffer
    mov rdx, rax            ; length (includes \n)
    mov rax, 1              ; sys_write
    syscall
    
    ; receive response
    mov rdi, r12            ; socket_fd
    mov rsi, rsp            ; reuse buffer
    mov rdx, 256            ; max bytes
    xor rax, rax            ; sys_read
    syscall
    
    ; write response to stdout
    mov rdx, rax            ; bytes received
    mov rdi, 1              ; stdout
    mov rsi, rsp            ; buffer
    mov rax, 1              ; sys_write
    syscall    
    add rsp, 256            ; cleanup buffer
    jmp read_command
_exit:
    mov rax, 0x3c
    mov rdi, 0
    syscall
_exit1:
    mov rax, 0x3c
    mov rdi, 1
    syscall