.data
text1:.asciiz "Enter number: "
Fizz:.asciiz "Fizz"
Buzz:.asciiz "Buzz"
FizzBuzz:.asciiz "FizzBuzz"

.text 
li $t6,'\n'
li $t8,' '
li $t0,0
li $t7,100
loop:
bge $t0,$t7,end
#li $v0,4        #print string
#la $a0,text1    #from data
#syscall

addi $t0,$t0,1
#li $v0,5        #read int number1
#syscall
#move $t0,$v0    #t0=number1

li $t1,3        #t1=3 
li $t2,5        #t2=5 
li $t3,0        #t3=0

li $v0,1           #print int
move $a0,$t0
syscall

li $v0,11          #print char
move $a0,$t8       #space
syscall

rem $t4,$t0,$t1   #t4=t0%3
rem $t5,$t0,$t2   #t5=t0%5

bne $t4,$t3,mark1  #t4!=0
bne $t5,$t3,mark1  #t5!=0
li $v0,4           #print string
la $a0,FizzBuzz    #from data
syscall 

li $v0,11          #print char
move $a0,$t6       #new line
syscall

j loop

mark1:
bne $t4,$t3,mark2  #t4!=0

li $v0,4           #print string
la $a0,Fizz        #from data
syscall  
li $v0,11          #print char
move $a0,$t6       #new line
syscall
j loop

mark2:
bne $t5,$t3,mark3  #t5!=0
li $v0,4           #print string
la $a0,Buzz        #from data
syscall 

mark3:
li $v0,11          #print char
move $a0,$t6       #new line
syscall
j loop
end:




