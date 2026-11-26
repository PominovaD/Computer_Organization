#setup
li $t0,5
li $t1,6
li $t3,268500992   #memory address for 1st number
li $t4,268501024   #memory address for 2nd number
sw $t0,0($t3)      #store number1 in memory
sw $t1,0($t4)      #store number2 in memory
#clear
li $t0,0
li $t1,0
li $t3,0
li $t4,0

#[Start program]
#load two addresses into reg
li $t3,268500992
li $t4,268501024
li $t5,268501056   #define address for our sum

#Load two summands from memory and place them into registers
lw $t0,0($t3)
lw $t1,0($t4)
# Sum the registers and place sum in another register
add $t2,$t0,$t1

#Place sum into memory
sw $t2,0($t5)
