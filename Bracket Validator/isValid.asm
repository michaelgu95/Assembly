.data	0x0
openers: .byte '(','{','['
closers: .byte ')','}',']'
newline: .asciiz "\n"
buffer: .space 100
stack: .space 100


.text
main:	
	li 	$v0, 8		#read input string
    	la 	$a0, buffer
	li 	$a1, 100	
   	move 	$t0, $a0	#address of string read in $t0
   	syscall
	li	$t5, 0		#stacksize = 0
	li	$t4, 0		#i=0 (for counting byte address after buffer)
	jal 	isValid
	end:
	move	$a0, $v1	#print isValid
	li 	$v0, 1
	syscall 
	ori     $v0, $0, 10     # System call code 10 for exit
	syscall
	
isValid:
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la	$t1, openers	
	la	$t2, closers
	add	$s1, $t4, $t0	#address of buffer+i
	lb 	$a0, 0($s1)	#character at buffer+i
	jal 	checkOpeners
	jal	checkClosers
	
	addi	$t4, $t4, 1	#i++
	add	$s1, $t4, $t0	#address of buffer+i
	lb 	$s0, 0($s1)	#character at buffer+i
	lb	$t6, newline	#check if buffer+i is newline
	
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 4
	bne	$t6, $s0, isValid
	
	bne 	$t5, $0, false	#if(stackSize != 0)
	li 	$v1, 1
	jr 	$ra
	
checkOpeners:
	lb	$s2, 0($t1)	# load opening brackets
	lb	$s3, 1($t1)
	lb	$s4, 2($t1)
	
	la	$t6, stack
	add	$t6, $t6, $t5
	addi 	$t6, $t6, 1	# *(stack+stackSize+1)
	 
	bne	$a0, $s2, skipOpen1	#if(text[i] != '(' 
	sb	$a0, 0($t6)
	addi	$t5, $t5, 1
	skipOpen1:
	bne	$a0, $s3, skipOpen2		#text[i] != '{' 
	sb	$a0, 0($t6)
	addi	$t5, $t5, 1
	skipOpen2:
	bne	$a0, $s4, skipOpen3		#text[i] != '['
	sb	$a0, 0($t6)
	addi	$t5, $t5, 1
	skipOpen3:
	jr 	$ra
	
checkClosers:
	lb	$s5, 0($t2)	# load closing brackets
	lb	$s6, 1($t2)
	lb	$s7, 2($t2)
	
	la	$t6, stack
	add	$t6, $t6, $t5
	lb 	$t6, 0($t6)	# *(stack+stackSize)
	
	bne	$a0, $s5, skipClose1	#if(text[i] != ')' 
	beq	$t5, $0, false 	# if(!(stackSize > 0)
	bne	$t6, $s2, false	# if *(stack+stackSize) != '('
	addi	$t5, $t5, -1
	skipClose1:
	bne	$a0, $s6, skipClose2		#text[i] != '}' 
	beq	$t5, $0, false 	# if(!(stackSize > 0)
	bne	$t6, $s3, false # if *(stack+stackSize) != '{'
	addi	$t5, $t5, -1
	skipClose2:
	bne	$a0, $s7, skipClose3		#text[i] != ']'
	beq	$t5, $0, false 	# if(!(stackSize > 0)
	bne	$t6, $s4, false # if *(stack+stackSize) != '['
	addi	$t5, $t5, -1
	skipClose3:
	jr 	$ra
	
false:
	li 	$v1, 0
	j	end
	
