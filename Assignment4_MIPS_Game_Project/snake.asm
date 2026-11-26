# 8x8 256x128 32x16  0x10040000
# $t0,$t1 head  $t5,$t6 old head  $t2,$t3 food $t4 points $s5 length $s0,$s1 body
.data
choose:.asciiz "Enter direction(w/a/s/d): "
pos:.asciiz "Snake position: "
wrong:.asciiz "Wrong character, try again"
newLine:.asciiz "\n"
win:.asciiz "You win!"
lose:.asciiz "You lose"
yourPoints:.asciiz "Your points: "

bodyX:.word 9,8,7,0,0,0,0,0,0,0,0,0,0,0
bodyY:.word 8,8,8,0,0,0,0,0,0,0,0,0,0,0
.text

#snake
li $t0,10   #x=10
li $t1,8    #y=8
li $s5,3   #snake length
#food
li $t2,20   #x=20
li $t3,5    #y=5

li $t4,0    #points

j clearScreen
direct:
li $v0,4
la $a0,choose   #print choice
syscall
li $v0,12       #scan char
syscall
move $s1,$v0    #direction to $s1
li $v0,4
la $a0,newLine  #print newLine
syscall

beq $s1,'w',subY
beq $s1,'s',addY
beq $s1,'a',subX
beq $s1,'d',addX

wrongChar:
li $v0,4
la $a0,wrong   #print choice
syscall
li $v0,4
la $a0,newLine  #print newLine
syscall
j direct

#moveHead
subY:
move $t5,$t0     #x -> t5
move $t6,$t1     #y -> t6
subi $t1,$t1,1   #y--
j moveBody

addY:
move $t5,$t0     #x -> t5
move $t6,$t1     #y -> t6
addi $t1,$t1,1   #y++
j moveBody

subX:
move $t5,$t0     #x -> t5
move $t6,$t1     #y -> t6
subi $t0,$t0,1   #x--
j moveBody

addX:
move $t5,$t0     #x -> t5
move $t6,$t1     #y -> t6
addi $t0,$t0,1   #x++

moveBody:
#save old tail
subi $t7,$s5,1
sll $t7,$t7,2
la $s0,bodyX
add $t7,$t7,$s0 #address of index
lw $s6,0($t7)   #load tailX to s6

subi $t7,$s5,1
sll $t7,$t7,2
la $s1,bodyY
add $t7,$t7,$s1 #address of index
lw $s7,0($t7)   #load tailY to s7

la $s0,bodyX
move $s2,$s5       #length of body ->s2
subi $s2,$s2,1     #last index of body
moveBodyX:
blt $s2,1,finishX
sll $t7,$s2,2   #index*4 byte
add $t7,$t7,$s0 #address of index
lw $s3,-4($t7)   #load body[i-1] to s3
sw $s3,0($t7)   #body[i] = body[i-1]
subi $s2,$s2,1
j moveBodyX
finishX:
sw $t5,0($s0)   #body1 = headX

la $s1,bodyY
move $s2,$s5       #length of body ->s2
subi $s2,$s2,1     #last index of body
moveBodyY:
blt $s2,1,finishY
sll $t7,$s2,2   #index*4 byte
add $t7,$t7,$s1 #address of index
lw $s3,-4($t7)   #load body[i-1] to s3
sw $s3,0($t7)   #body[i] = body[i-1]
subi $s2,$s2,1
j moveBodyY
finishY:
sw $t6,0($s1)   #body1 = headY

checkPos:
#boards
bgt $t0,31,youLose
bgt $t1,15,youLose
blt $t0,0,youLose
blt $t1,0,youLose
#snakeBody
la $s0,bodyX
la $s1,bodyY
li $s2,0      #index
checkBody:
bge $s2,$s5,endCheckBody
sll $t7,$s2,2   #X index*4 byte
add $t7,$t7,$s0 #address of index X
lw $s3,0($t7)   #load X[0] to s3

sll $t7,$s2,2   #Y index*4 byte
add $t7,$t7,$s1 #address of index Y
lw $s4,0($t7)   #load Y[0] to s4

bne $t0,$s3,nextSeg  #headX != bodyX
beq $t1,$s4,youLose    #headY != bodyY
nextSeg:
addi $s2,$s2,1     #next index
j checkBody
endCheckBody:
j findFood

printPos:
li $v0,4
la $a0,pos   #print position
syscall
li $v0,1
move $a0,$t0   #print x
syscall
li $v0,11
li $a0,' '   #print space
syscall
li $v0,1
move $a0,$t1   #print y
syscall
li $v0,4
la $a0,newLine  #print newLine
syscall

findFood:
bne $t0,$t2,notEaten
bne $t1,$t3,notEaten
j eatFood

notEaten:
j clearScreen

eatFood:
addi $t4,$t4,1

li $a0,14
bge $s5,$a0,maxLength
addi $s5,$s5,1

#old into new array pos
subi $t7,$s5,1
sll $t7,$t7,2
la $s0,bodyX
add $t7,$t7,$s0 #address of index
sw $s6,0($t7)   #load tailX to s6

subi $t7,$s5,1
sll $t7,$t7,2
la $s0,bodyY
add $t7,$t7,$s0 #address of index
sw $s7,0($t7)   #load tailY to s7

maxLength:
li $v0,4
la $a0,yourPoints   #print points
syscall
li $v0,1
move $a0,$t4  
syscall
li $v0,4
la $a0,newLine  #print newLine
syscall
li $a0,14
bge $t4,$a0,youWin

randomFood:
li $a0,0
li $a1,32    #max X
li $v0,42
syscall
move $t2,$a0  #x=

li $a0,0
li $a1,16   #max Y
li $v0,42
syscall
move $t3,$a0  #y=

bne $t0,$t2,checkFoodBody
beq $t1,$t3,randomFood

checkFoodBody:
la $s0,bodyX
la $s1,bodyY
li $s2,0

foodBodyLoop:
bge $s2,$s5,clearScreen
sll $t7,$s2,2
add $t7,$t7,$s0
lw $s3,0($t7)  #bodyX to s3
sll $t7,$s2,2
add $t7,$t7,$s1
lw $s4,0($t7)  #bodyX to s4

bne $t2,$s3,nextFoodSeg
beq $t3,$s4,randomFood

nextFoodSeg:
addi $s2,$s2,1
j foodBodyLoop

youWin:
li $v0,4
la $a0,win   
syscall
j end

youLose:
li $v0,4
la $a0,lose   
syscall
j end

end:
li $v0,10
syscall



#draw snake
clearScreen:
li $a3,0x10040000
li $v1,512   #number of cells
li $a2,0    #black color
clearLoop:
sw $a2,0($a3)   #current cell black
addi $a3,$a3,4  #next cell
subi $v1,$v1,1  #counter of cells
bgtz $v1,clearLoop

drawBody:
la $s0,bodyX
la $s1,bodyY
li $s2,0      #first index
drawBodyLoop:
bge $s2,$s5,drawHead
sll $t7,$s2,2      #index we need
add $t7,$t7,$s0    #address
lw $s3,0($t7)      #s3=segX
sll $t7,$s2,2      #index we need
add $t7,$t7,$s1    #address
lw $s4,0($t7)      #s3=segY

li $a0,32       #offset
mul $a1,$s4,$a0  #y*32
add $a1,$a1,$s3  #y*32+x
sll $a1,$a1,2    #*4 bytes
li $v0,0x10040000   #base address
add $v0,$v0,$a1    #base address+offset
li $a2,0x0000FF00 #color
sw $a2,0($v0)   #draw pixel
addi $s2,$s2,1  #next index
j drawBodyLoop
drawHead:
li $a0,32       #offset
mul $a1,$t1,$a0  #y*32
add $a1,$a1,$t0  #y*32+x
sll $a1,$a1,2    #*4 bytes
li $v0,0x10040000   #base address
add $v0,$v0,$a1    #base address+offset
li $a2,0x0000FF00 #color
sw $a2,0($v0)   #draw pixel

drawFood:
li $a0,32       #offset
mul $a1,$t3,$a0  #y*32
add $a1,$a1,$t2  #y*32+x
sll $a1,$a1,2    #*4 bytes
li $v0,0x10040000   #base address
add $v0,$v0,$a1    #base address+offset
li $a2,0x00FF0000 #color
sw $a2,0($v0)   #draw pixel
j direct