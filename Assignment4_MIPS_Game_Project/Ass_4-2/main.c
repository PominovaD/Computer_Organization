#include <stdio.h>
#include <stdlib.h>

#define WIDTH 32
#define HEIGHT 16

int snakeX=10;
int snakeY=8;

int foodX=20;
int foodY=5;

int direction=0;
//0=right
//1=left
//2=up
//3=down

int main(){
    char input;
    while(1){
        printf("Enter direction (W/A/S/D): ");
        scanf(" %c", &input);
        if (input=='w') {direction = 2;}
        else if (input=='s') {direction = 3;}
        else if (input=='a') {direction = 1;}
        else if (input=='d') {direction = 0;}

        if (direction==0) {snakeX++;}
        else if (direction == 1) {snakeX--;}
        else if (direction == 2) {snakeY--;}
        else if (direction == 3) {snakeY++;}
        printf("Snake position: %d, %d\n", snakeX, snakeY);
    }

    return 0;
}
