li $t1,1  #t1=1
li $t2,'\n'
loop:
bgt $t1,100,end

move $a0,$t1  #move i to a0
li $v0,1      #int
syscall       #print

li $v0,11   #print char
move $a0,$t2   #new line
syscall

add $t1,$t1,1
j loop
end:
