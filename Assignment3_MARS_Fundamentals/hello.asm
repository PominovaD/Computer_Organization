.data
message:.asciiz "Hello, World!"

.text
main:
li $v0,4   #print str
la $a0,message  #send str to a0
syscall
