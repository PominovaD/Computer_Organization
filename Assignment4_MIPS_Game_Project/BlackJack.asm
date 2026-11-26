# 8x8 512x256 0x10040000
#2-10,11-v,12-d,13-k,14-t = 48
.data
start:.asciiz "The deal begins"
HitStand:.asciiz "Hit or stand? Print 'h' for Hit or 's' for stand: "
newLine:.asciiz "\n"
win:.asciiz "You win"
lose:.asciiz "You lose"
yourPoints:.asciiz "Your points: "
compPoints:.asciiz "Computer points: "

cards:.word 2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13,14,14,14,14
board:.word 0,0,0,0,0,0,0,0
.text

main:
#horiz lines
li $a0,0          #x=0
li $a1,15          #y=15
li $a2,0x00FFFFFF  #color white

jal drawPixel
loop1:
bge $a0,63,vert  #if x>63
addi $a0,$a0,1    #x+1
jal drawPixel
j loop1

#vert lines
vert:
li $a0,15          #x=15
li $a1,0           #y=0
jal drawPixel
j loop2

loop2:
bgt $a1,31,endLoop2  #if y>31
addi $a1,$a1,1       #y+1
jal drawPixel
j loop2
endLoop2:
li $a1,0           #y=0
addi $a0,$a0,16    #x+16
jal drawPixel

loop3:
bgt $a1,31,endLoop3   #if y>31
addi $a1,$a1,1       #y+1
jal drawPixel
j loop3
endLoop3:
li $a1,0           #y=0
addi $a0,$a0,16    #x+16
jal drawPixel

loop4:
bgt $a1,31,endLoop4   #if y>31
addi $a1,$a1,1       #y+1
jal drawPixel
j loop4
endLoop4:

game:
move $s4,$zero   #count your fields
move $s5,$zero   #count comp fields
move $s6,$zero   #count your points
move $s7,$zero   #count comp points
li $v0,4
la $a0, start   #print start
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall

randomForYou:
li $a0,0
li $a1,47
li $v0,42
syscall
#randomAddress
la $t2,cards      #address
move $t1,$a0      #index t1
sll $t1,$t1,2     #index*4 bytes
add $t2,$t2,$t1   #address of index
lw $t3,0($t2)     #load element to t3
beq $t3,$zero,randomForYou
li $a3,1          #1 for you
jal updateArrayCards

#area
li $a0,4          #start index=4
move $a2,$s4
jal updateArrayBoard
li $a0,4
add $a0,$a0,$s4   #current field index
li $a2,15         #size of 1 field
mul $t0,$s4,$a2   #field x=15*index x=0...15*3
add $t0,$t0,$s4
move $a3,$t3
#count field and points
add $s4,$s4,1     #count++
move $t5,$t3
li $t4,10
ble $t3,$t4,countPointsY  #if card<=10
li $t4,12
bgt $t3,$t4,pointsTY      #if card >12
pointsVQKY:
li $t5,10
j countPointsY
pointsTY:
li $t5,11
li $s0,21
add $s6,$s6,$t5
bgt $s6,$s0,otherNumberY
countPointsY:
add $s6,$s6,$t5
j printYouPoints

otherNumberY:
li $s0,10
sub $s6,$s6,$s0   #points -10

printYouPoints:
li $v0,4
la $a0,yourPoints   #print your points
syscall
li $v0,1
move $a0,$s6    #print number
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall
li $v0,1
move $a0,$s4    #print number
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall

youDraw:
move $a0,$t0  #x=
li $a1,15     #y=15
j choseNumberToDraw

randomForComp:
li $s1,21
bgt $s6,$s1,compWin
li $a0,0
li $a1,47
li $v0,42
syscall
#randomAddress
la $t2,cards      #address
move $t1,$a0      #index t1
sll $t1,$t1,2     #index*4 bytes
add $t2,$t2,$t1   #address of index
lw $t3,0($t2)     #load element to t3
beq $t3,$zero,randomForComp
li $a3,2          #2 for comp
jal updateArrayCards

#area
li $a0,0          #start index=0
move $a2,$s5
jal updateArrayBoard
li $a0,0
add $a0,$a0,$s5   #current field index
li $a2,15     #size of 1 field
mul $t0,$s5,$a2   #field x=15*index x=0...15*3
add $t0,$t0,$s5
move $a0,$t0  #x=
li $a1,0     #y=0

#count fields and points
add $s5,$s5,1     #count++
move $t5,$t3
li $t4,10
ble $t3,$t4,countPointsC  #if card<=10
li $t4,12
bgt $t3,$t4,pointsTC      #if card >12
pointsVQKC:
li $t5,10
j countPointsC
pointsTC:
li $t5,11
li $s0,21
add $s7,$s7,$t5
bgt $s7,$s0,otherNumberC
j printCompPoints
countPointsC:
add $s7,$s7,$t5
j printCompPoints

otherNumberC:
li $s0,10
sub $s7,$s7,$s0   #points -10

printCompPoints:
li $v0,4
la $a0,compPoints   #print comp points
syscall
li $v0,1
move $a0,$s7    #print number
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall
li $v0,1
move $a0,$s5    #print number
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall

copmDraw:
move $a0,$t0  #x=
li $a1,0     #y=0
j choseNumberToDraw

choseNumberToDraw:
li $t1,2              #elem
beq $t3,$t1,drawCard2
li $t1,3
beq $t3,$t1,drawCard3
li $t1,4
beq $t3,$t1,drawCard4
li $t1,5
beq $t3,$t1,drawCard5
li $t1,6
beq $t3,$t1,drawCard6
li $t1,7
beq $t3,$t1,drawCard7
li $t1,8
beq $t3,$t1,drawCard8
li $t1,9
beq $t3,$t1,drawCard9
li $t1,10
beq $t3,$t1,drawCard10
li $t1,11
beq $t3,$t1,drawCardV
li $t1,12
beq $t3,$t1,drawCardQ
li $t1,13
beq $t3,$t1,drawCardK
li $t1,14
beq $t3,$t1,drawCardT


updateArrayCards:
la $s0,cards      #address
move $s1,$a0      #index to s1
sll $s1,$s1,2     #index*4 bytes
add $s0,$s0,$s1   #address of index
move $s2,$a3      #s2=0 or 1 
sw $s2,0($s0)     #s2 ->s0
#print cards
la $t0,cards      #address
li $t1,0          #index 0
printCardsLoop:
bgt $t1,47,endUpdateCards #if index >47
lw $a0,0($t0)      #load element
li $v0,1
syscall

li $a0,' '         #space
li $v0,11
syscall
addi $t0,$t0,4       #next element
addi $t1,$t1,1       #next index
j printCardsLoop
endUpdateCards:
li $v0,4
la $a0,newLine   #print newLine
syscall
jr $ra

updateArrayBoard:
la $s0,board      #address
add $a0,$a0,$a2   #start index + count
move $s1,$a0      #index
sll $s1,$s1,2     #index*4 bytes
add $s0,$s0,$s1   #address of index
move $s2,$t3      #s2=t3 card
sw $s2,0($s0)
#print board
la $t0,board      #address
li $t1,0          #index 0
printBoardLoop:
bgt $t1,7,endUpdateBoard #if index >7
lw $a0,0($t0)      #load element
li $v0,1
syscall

li $a0,' '         #space
li $v0,11
syscall
addi $t0,$t0,4       #next element
addi $t1,$t1,1       #next index
j printBoardLoop
endUpdateBoard:
li $v0,4
la $a0,newLine   #print newLine
syscall
jr $ra

countArea:
li $s1,21
bgt $s6,$s1,compWin
bgt $s7,$s1,youWin
bgt $s4,$s5,randomForComp   #you count > comp count
bgt $s5,$s4,randomForYou  #comp count > you count
li $s1,2
bge $s5,$s1,hitStand
j randomForYou

hitStand:
li $s1,21
beq $s7,$s1,compWin
li $v0,4
la $a0,HitStand   #print start
syscall
li $v0,12        #scan char
syscall
move $s1,$v0
li $v0,4
la $a0,newLine   #print newLine
syscall

li $s2,'s'
beq $s1,$s2,countPointsAfter
j randomForYou
 
countPointsAfter:
li $s1,21
bgt $s6,$s7,countMaxYou   #you points > comp points
bgt $s7,$s6,countMaxComp  #comp points > you points
countMaxYou:
bgt $s6,21,compWin
j youWin
countMaxComp:
bgt $s7,21,youWin

compWin:
li $v0,4
la $a0,lose   #print lose
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall
j end
youWin:
li $v0,4
la $a0,win   #print win
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall
j end

drawCard2:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,5
addi $a1,$a1,5
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
j countArea

drawCard3:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,5
addi $a1,$a1,5
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
addi $a0,$a0,3
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
j countArea

drawCard4:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,9
addi $a1,$a1,9
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
j countArea

drawCard5:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,9
addi $a1,$a1,4
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
j countArea

drawCard6:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,8
addi $a1,$a1,5
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
j countArea

drawCard7:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,5
addi $a1,$a1,5
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
j countArea

drawCard8:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,5
addi $a1,$a1,6
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
j countArea

drawCard9:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,8
addi $a1,$a1,7
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
j countArea

drawCard10:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,3
addi $a1,$a1,6
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel

addi $a0,$a0,3
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a1,$a1,2
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
j countArea

drawCardV:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,7
addi $a1,$a1,5
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
j countArea

drawCardQ:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,7
addi $a1,$a1,10
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,2
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
j countArea

drawCardK:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,5
addi $a1,$a1,5
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,3
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a1,$a1,6
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
j countArea

drawCardT:
#x=a0 y=a1
li $a2,0x00FFFFFF  #color white
addi $a0,$a0,6
addi $a1,$a1,11
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
subi $a1,$a1,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
jal drawPixel
addi $a0,$a0,1
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
addi $a1,$a1,1
jal drawPixel
subi $a0,$a0,1
subi $a1,$a1,3
jal drawPixel
subi $a0,$a0,1
jal drawPixel
subi $a0,$a0,1
jal drawPixel
j countArea

drawPixel:
li $t0,64        #offset
mul $t0,$t0,$a1  #y*32
add $t0,$t0,$a0  #y*32+x
sll $t0,$t0,2    #*4 bytes
li $t1,0x10040000   #base address
addu $t1,$t1,$t0    #base address+offset
sw $a2,0($t1)   #draw pixel
jr $ra

end:
