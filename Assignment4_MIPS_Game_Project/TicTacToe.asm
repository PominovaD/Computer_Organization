# 8x8 256x256 0x10040000
.data
enterX:.asciiz "Choose the area for your X from 1 to 9: "
enter0:.asciiz "Computer chose area for 0: "
invalid:.asciiz "Invalid position! Try again."
newLine:.asciiz "\n"
winX:.asciiz "You winned! =D"
win0:.asciiz "Computer winned =("
draw:.asciiz "It's a draw"

board:.word 0,0,0,0,0,0,0,0,0
.text

main:
#horiz lines
li $a0,0          #x=0
li $a1,10          #y=10
li $a2,0x00FFFFFF  #color white

jal drawPixel
j loop1

loop1:
bge $a0,31,loop2  #if x>=31
addi $a0,$a0,1    #x+1
jal drawPixel
j loop1

loop2:
bge $a1,21,vert #if y>=21
addi $a1,$a1,11    #y+11
li $a0,0
jal drawPixel
j loop1
#vert lines
vert:
li $a0,10          #x=10
li $a1,0           #y=0

jal drawPixel
j loop3

loop3:
bge $a1,31,loop4  #if y>=31
addi $a1,$a1,1    #y+1
jal drawPixel
j loop3

loop4:
bge $a0,21,game #if x>=21
addi $a0,$a0,11    #x+11
li $a1,0           #y=0
jal drawPixel
j loop3

game:
li $v0,4
la $a0, enterX   #print welcome
syscall

li $v0,5    #read input
syscall
move $t0,$v0 #your input to t0

li $t1,1
blt $t0,$t1,invalidPos
li $t1,9
bgt $t0,$t1,invalidPos
j chooseArea

invalidPos:
li $v0,4
la $a0, invalid   #print
syscall
li $v0,4
la $a0,newLine   #print newLine
syscall
j game

chooseArea:
li $a2,0x00FFFFFF  #color white
#choose X
li $t1,1
beq $t0,$t1,area1
li $t1,2
beq $t0,$t1,area2
li $t1,3
beq $t0,$t1,area3
li $t1,4
beq $t0,$t1,area4
li $t1,5
beq $t0,$t1,area5
li $t1,6
beq $t0,$t1,area6
li $t1,7
beq $t0,$t1,area7
li $t1,8
beq $t0,$t1,area8
li $t1,9
beq $t0,$t1,area9

area1:
li $a0,0          #index=0
li $a1,1          #1 for X
jal updateArray
li $a0,0          #x=0
li $a1,0          #y=0
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area2:
li $a0,1          #index=1
li $a1,1          #1 for X
jal updateArray
li $a0,11         #x=11
li $a1,0          #y=0
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area3:
li $a0,2          #index=2
li $a1,1          #1 for X
jal updateArray
li $a0,22         #x=22
li $a1,0          #y=0
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area4:
li $a0,3          #index=3
li $a1,1          #1 for X
jal updateArray
li $a0,0          #x=0
li $a1,11          #y=11
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area5:
li $a0,4          #index=4
li $a1,1          #1 for X
jal updateArray
li $a0,11         #x=11
li $a1,11          #y=11
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area6:
li $a0,5          #index=5
li $a1,1          #1 for X
jal updateArray
li $a0,22         #x=22
li $a1,11          #y=11
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area7:
li $a0,6          #index=6
li $a1,1          #1 for X
jal updateArray
li $a0,0          #x=0
li $a1,22          #y=22
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area8:
li $a0,7          #index=7
li $a1,1          #1 for X
jal updateArray
li $a0,11         #x=11
li $a1,22          #y=22
li $t2,0          #t2=0
jal drawX
jal checkWinner
j checkArray
area9:
li $a0,8          #index=8
li $a1,1          #1 for X
jal updateArray
li $a0,22         #x=22
li $a1,22         #y=22
li $t2,0          #t2=0
jal drawX
jal checkWinner

#choose 0
checkArray:
li $t0,0
li $t1,8
la $t2,board #address
CheckArrayLoop:
bgt $t0,$t1,endCheckArray
move $t3,$t0   #index to t3   
sll $t3,$t3,2     #index*4 bytes
add $t3,$t3,$t2   #address of index
lw $t4,0($t3)     #load element to t4
addi $t0,$t0,1
bne $t4,$zero,CheckArrayLoop
j random
endCheckArray:
j drawGame

random:
li $a0,0
li $a1,9
li $v0,42
syscall
addi $t0,$a0,1
la $t2,board      #address
move $t1,$t0      #element t1
subi $t1,$t1,1    #index t1
sll $t1,$t1,2     #index*4 bytes
add $t2,$t2,$t1   #address of index
lw $t3,0($t2)     #load element to t3
bne $t3,$zero,random

li $v0,4
la $a0,enter0   #print computer choise
syscall

li $v0,1
move $a0,$t0     #print number
syscall

li $v0,4
la $a0,newLine   #print newLine
syscall

li $t1,1
beq $t0,$t1,area10
li $t1,2
beq $t0,$t1,area20
li $t1,3
beq $t0,$t1,area30
li $t1,4
beq $t0,$t1,area40
li $t1,5
beq $t0,$t1,area50
li $t1,6
beq $t0,$t1,area60
li $t1,7
beq $t0,$t1,area70
li $t1,8
beq $t0,$t1,area80
li $t1,9
beq $t0,$t1,area90

area10:
li $a0,0          #index=0
li $a1,2          #2 for 0
jal updateArray
li $a0,0          #x=0
li $a1,0          #y=0
li $t2,0          #t2=0
j draw0

area20:
li $a0,1          #index=1
li $a1,2          #2 for 0
jal updateArray
li $a0,11         #x=11
li $a1,0          #y=0
li $t2,0          #t2=0
j draw0

area30:
li $a0,2          #index=2
li $a1,2          #2 for 0
jal updateArray
li $a0,22         #x=22
li $a1,0          #y=0
li $t2,0          #t2=0
j draw0

area40:
li $a0,3          #index=3
li $a1,2          #2 for 0
jal updateArray
li $a0,0          #x=0
li $a1,11          #y=11
li $t2,0          #t2=0
j draw0

area50:
li $a0,4          #index=4
li $a1,2          #2 for 0
jal updateArray
li $a0,11         #x=11
li $a1,11          #y=11
li $t2,0          #t2=0
j draw0

area60:
li $a0,5          #index=5
li $a1,2          #2 for 0
jal updateArray
li $a0,22         #x=22
li $a1,11          #y=11
li $t2,0          #t2=0
j draw0

area70:
li $a0,6          #index=6
li $a1,2          #2 for 0
jal updateArray
li $a0,0          #x=0
li $a1,22          #y=22
li $t2,0          #t2=0
j draw0

area80:
li $a0,7          #index=7
li $a1,2          #2 for 0
jal updateArray
li $a0,11         #x=11
li $a1,22          #y=22
li $t2,0          #t2=0
j draw0

area90:
li $a0,8          #index=8
li $a1,2          #2 for 0
jal updateArray
li $a0,22         #x=22
li $a1,22          #y=22
li $t2,0          #t2=0
j draw0

drawX:
loopX1:
jal drawPixel
bge $t2,9,endLoopX1  #if t2>=9
addi $a0,$a0,1   #x+1
addi $a1,$a1,1   #y+1
addi $t2,$t2,1   #t2+1
j loopX1
endLoopX1:
li   $t2,0        #t2=0
subi $a0,$a0,9    #x-9
loopX2:
jal drawPixel
bge $t2,9,endLoopX2  #if t2>=9
addi $a0,$a0,1     #x+1
subi $a1,$a1,1     #y-1
addi $t2,$t2,1   #t2+1
j loopX2
jr $ra
endLoopX2:
endDrawX:
jal checkWinner
j checkArray

draw0:
addi $a0,$a0,2   #x+2
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a0,$a0,1   #x+1
jal drawPixel
addi $a0,$a0,1   #x+1
subi $a1,$a1,1   #y-1
jal drawPixel
addi $a0,$a0,1   #x+1
jal drawPixel
addi $a0,$a0,1   #x+1
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a0,$a0,1   #x+1
jal drawPixel
addi $a0,$a0,1   #x+1
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a0,$a0,1   #x+1
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a1,$a1,1   #y+1
jal drawPixel
subi $a0,$a0,1   #x-1
addi $a1,$a1,1   #y+1
jal drawPixel
addi $a1,$a1,1   #y+1
jal drawPixel
subi $a0,$a0,1   #x-1
addi $a1,$a1,1   #y+1
jal drawPixel
subi $a0,$a0,1   #x-1
jal drawPixel
subi $a0,$a0,1   #x-1
addi $a1,$a1,1   #y+1
jal drawPixel
subi $a0,$a0,1   #x-1
jal drawPixel
subi $a0,$a0,1   #x-1
subi $a1,$a1,1   #y-1
jal drawPixel
subi $a0,$a0,1   #x-1
jal drawPixel
subi $a0,$a0,1   #x-1
subi $a1,$a1,1   #y-1
jal drawPixel
subi $a1,$a1,1   #y-1
jal drawPixel
subi $a0,$a0,1   #x-1
subi $a1,$a1,1   #y-1
jal drawPixel
subi $a1,$a1,1   #y-1
jal drawPixel
addi $a0,$a0,1   #x+1
subi $a1,$a1,1   #y-1
jal drawPixel
subi $a1,$a1,1   #y-1
jal drawPixel
endDraw0:
jal checkWinner
j game
#li $v0,10     #paint
#syscall
#j end

drawPixel:
li $t0,32        #offset
mul $t0,$t0,$a1  #y*32
add $t0,$t0,$a0  #y*32+x
sll $t0,$t0,2    #*4 bytes

li $t1,0x10040000   #base address
addu $t1,$t1,$t0    #base address+offset

sw $a2,0($t1)   #draw pixel
jr $ra

updateArray:
la $s0,board      #address
move $s1,$a0          #index
sll $s1,$s1,2     #index*4 bytes
add $s0,$s0,$s1   #address of index
move $s2,$a1          #1 for X, 2 for 0
sw $s2,0($s0)
#print board
la $t0,board      #address
li $t1,0          #index 0
printLoop:
bge $t1,9,endUpdate #if index >=9
lw $a0,0($t0)      #load element
li $v0,1
syscall

li $a0,' '         #space
li $v0,11
syscall
addi $t0,$t0,4       #next element
addi $t1,$t1,1       #next index
j printLoop
endUpdate:
li $v0,4
la $a0,newLine   #print newLine
syscall
jr $ra

checkWinner:
la $s0,board   #address of array
li $s2,0       #count iter    
li $s1,0      #index
li $t6,3      #max count
li $s7,1      #you or comp
horizLoop:
addi $s2,$s2,1     #add 1 to count
bgt $s2,$t6,endHorizLoop  #count 3 iter

move $s3,$s1      #index 1 to s3
sll $s3,$s3,2     #index1*4 bytes
add $s3,$s3,$s0   #address of index1
lw $s4,0($s3)     #load element 1 to s4

addi $s1,$s1,1   #increase index
move $s3,$s1      #index 2 to s3
sll $s3,$s3,2     #index2*4 bytes
add $s3,$s3,$s0   #address of index2
lw $s5,0($s3)     #load element 2 to s5

addi $s1,$s1,1   #increase index
move $s3,$s1      #index 3 to s3
sll $s3,$s3,2     #index3*4 bytes
add $s3,$s3,$s0   #address of index3
lw $s6,0($s3)     #load element 3 to s6

addi $s1,$s1,1     #index of next line
beq $s4,$zero,horizLoop
bne $s4,$s5,horizLoop
bne $s5,$s6,horizLoop

bne $s4,$s7,compWinner
j youWinner
endHorizLoop:

li $s2,0       #count iter
li $s1,0      #index
vertLoop:
addi $s2,$s2,1     #add 1 to count
bge $s2,$t6,endVertLoop  #count 3 iter

move $s3,$s1      #index of 1 to s3
sll $s3,$s3,2     #index1*4 bytes
add $s3,$s3,$s0   #address of index of 1
lw $s4,0($s3)     #load element 1 to s4

addi $s1,$s1,3   #increase index
move $s3,$s1      #index 4 to s3
sll $s3,$s3,2     #index4*4 bytes
add $s3,$s3,$s0   #address of index4
lw $s5,0($s3)     #load element 4 to s5

addi $s1,$s1,3   #increase index
move $s3,$s1      #index 7 to s3
sll $s3,$s3,2     #index7*4 bytes
add $s3,$s3,$s0   #address of index7
lw $s6,0($s3)     #load element 7 to s6

subi $s1,$s1,5     #index of next col to index 2
beq $s4,$zero,vertLoop
bne $s4,$s5,vertLoop
bne $s5,$s6,vertLoop

bne $s4,$s7,compWinner
j youWinner
endVertLoop:

#diag1
li $s1,0      #index
move $s3,$s1      #index of 1 to s3
sll $s3,$s3,2     #index1*4 bytes
add $s3,$s3,$s0   #address of index of 1
lw $s4,0($s3)     #load element 1 to s4

addi $s1,$s1,4   #increase index
move $s3,$s1      #index 5 to s3
sll $s3,$s3,2     #index5*4 bytes
add $s3,$s3,$s0   #address of index5
lw $s5,0($s3)     #load element 5 to s5

addi $s1,$s1,4   #increase index
move $s3,$s1      #index 9 to s3
sll $s3,$s3,2     #index9*4 bytes
add $s3,$s3,$s0   #address of index9
lw $s6,0($s3)     #load element 9 to s6

beq $s4,$zero,endDiag1
bne $s4,$s5,endDiag1
bne $s5,$s6,endDiag1

bne $s4,$s7,compWinner
j youWinner
endDiag1:

#diag2
li $s1,2      #index
move $s3,$s1      #index of 3 to s3
sll $s3,$s3,2     #index3*4 bytes
add $s3,$s3,$s0   #address of index of 3
lw $s4,0($s3)     #load element 3 to s4

addi $s1,$s1,2   #increase index
move $s3,$s1      #index 5 to s3
sll $s3,$s3,2     #index5*4 bytes
add $s3,$s3,$s0   #address of index5
lw $s5,0($s3)     #load element 5 to s5

addi $s1,$s1,2   #increase index
move $s3,$s1      #index 7 to s3
sll $s3,$s3,2     #index7*4 bytes
add $s3,$s3,$s0   #address of index9
lw $s6,0($s3)     #load element 7 to s6

beq $s4,$zero,endDiag2
bne $s4,$s5,endDiag2
bne $s5,$s6,endDiag2

bne $s4,$s7,compWinner
j youWinner
endDiag2:
jr $ra

#print results
youWinner:
li $v0,4
la $a0,winX  
syscall
j end
compWinner:
li $v0,4
la $a0,win0
syscall
j end
drawGame:
li $v0,4
la $a0,draw
syscall
endCheckWinner:
end:
