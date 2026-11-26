#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int cards[52]={2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13,14,14,14,14
};
int board[8]={0};
int yourCards=0;
int compCards=0;
int yourPoints=0;
int compPoints=0;

// Get card points
int getPoints(int card) {
    if (card<=10)return card;
    if (card>=11 && card<=13)return 10;
    return 11;
}
// Draw a random card without replacement
int drawCard() {
    int index;
    do {index=rand()%52;
    } while (cards[index]==0);

    int card = cards[index];
    cards[index] = 0;
    return card;
}
// Add card to player's or computer's board
void updateBoard(int card, int player) {
    if(player == 1){
        board[yourCards] = card;
        yourCards++;
        yourPoints += getPoints(card);
    }
    else{
        board[4 + compCards] = card;
        compCards++;
        compPoints += getPoints(card);
    }
}
// Adjust Ace from 11 to 1 if necessary
void adjustPoints(int *points, int *board, int count) {
    while(*points>21) {
        int aceFound = 0;
        for (int i = 0; i<count; i++) {
            if (board[i]==14){
                *points -= 10;
                board[i] = -14;
                aceFound = 1;
                break;
            }
        }
        if (!aceFound)
            break;
    }
}
// Display cards
void printBoard() {
    printf("\nYour cards: ");
    for (int i = 0; i < yourCards; i++)
        printf("%d ", board[i]);
    printf("\nYour points: %d\n", yourPoints);
    printf("\nComputer cards: ");
    for (int i = 0; i < compCards; i++)
        printf("%d ", board[4 + i]);
    printf("\nComputer points: %d\n", compPoints);
}
int main() {
    srand(time(NULL));
    printf("The deal begins!\n");
    // Initial cards
    updateBoard(drawCard(), 1);
    updateBoard(drawCard(), 2);
    updateBoard(drawCard(), 1);
    updateBoard(drawCard(), 2);
    adjustPoints(&yourPoints, board, yourCards);
    int computerBoard[4];
    for (int i = 0; i < compCards; i++)
        computerBoard[i] = board[4 + i];
    adjustPoints(&compPoints, computerBoard, compCards);
    char choice;
    // Player turn
    while (yourPoints < 21) {
        printBoard();
        printf("\nHit or stand? (h/s): ");
        scanf(" %c", &choice);
        if (choice=='s')break;
        if (choice=='h') {
            int card = drawCard();
            printf("You drew: %d\n", card);
            updateBoard(card, 1);
            adjustPoints(&yourPoints, board, yourCards);
        }
        else {
            printf("Invalid choice!\n");
        }
    }
    // Computer turn
    while (compPoints<17 && compCards<4) {
        int card = drawCard();
        printf("Computer drew: %d\n", card);
        updateBoard(card, 2);

        for (int i=0; i<compCards; i++)
            computerBoard[i] = board[4+i];

        adjustPoints(&compPoints, computerBoard, compCards);
    }
    printBoard();
    // Determine winner
    if (yourPoints>21) {
        printf("\nYou lose!\n");
    }
    else if (compPoints>21) {
        printf("\nYou win!\n");
    }
    else if (yourPoints<compPoints){
        printf("\nYou lose!\n");
    }
    else{
        printf("\nYou win!\n");
    }
    return 0;
}


