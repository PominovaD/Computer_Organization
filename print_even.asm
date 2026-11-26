li $t0,1  #t0=1
li $t1,'\n'
li $t2,2
li $t3,0
li $t4,100
li $t6,0
loop:
bgt $t0,$t4,endLoop  #i>100
rem $t5,$t0,$t2  #t5=t0%2
bne $t5,$t3,skip    #t5!=0
add $t6,$t6,$t0
skip:
addi $t0,$t0,1
j loop
endLoop:

move $a0,$t6  #move i to a0
li $v0,1      #int
syscall       #print

li $v0,11   #print char
move $a0,$t1   #new line
syscall

end:
