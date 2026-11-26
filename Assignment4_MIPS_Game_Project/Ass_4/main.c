#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int board[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
// Print the board
void printBoard() {
for (int i = 0; i < 9; i++) {
if (board[i] == 0) printf("%d", i + 1);
else if (board[i] == 1) printf("X");
else printf("O");

if (i % 3 == 2) printf("\n");
else printf(" | ");
}
}
// Check winner
int checkWinner() {
int winPatterns[8][3] = {
{0, 1, 2},
{3, 4, 5},
{6, 7, 8},
{0, 3, 6},
{1, 4, 7},
{2, 5, 8},
{0, 4, 8},
{2, 4, 6}
};

for (int i = 0; i < 8; i++) {
    int a = winPatterns[i][0];
    int b = winPatterns[i][1];
    int c = winPatterns[i][2];
    if (board[a]!=0 && board[a]==board[b] && board[b]==board[c]){
        return board[a];
    }
}
return 0;
}
// Check if board is full
int isBoardFull() {
for (int i = 0; i < 9; i++) {
if (board[i] == 0)return 0;
}
return 1;
}
// Computer move
void computerMove() {
int position;
do {position=rand()%9;
} while (board[position]!=0);

board[position] = 2;
printf("Computer chose area for O: %d\n", position + 1);
}

int main() {
int position;
srand(time(NULL));
while(1){printBoard();
    // Player move
    printf("Choose the area for your X from 1 to 9: ");
    scanf("%d", &position);

    if (position < 1 || position > 9 ||
        board[position - 1] != 0) {
        printf("Invalid position! Try again.\n");
        continue;
    }
    board[position - 1] = 1;
    if (checkWinner() == 1) {
        printBoard();
        printf("You won! =D\n");
        break;
    }
    if (isBoardFull()) {
        printBoard();
        printf("It's a draw!\n");
        break;
    }
    // Computer move
    computerMove();
    if (checkWinner() == 2) {
        printBoard();
        printf("Computer won! =(\n");
        break;
    }
    if (isBoardFull()) {
        printBoard();
        printf("It's a draw!\n");
        break;
    }
}
return 0;
}

