.data 
	x: .float 1.0, 0.2, 0.5, 0.31, 1e10, 10, 20, -2, -10
	.align 2
	one: .asciiz "\nThe original values are:\n"
	.align 2
	two: .asciiz "\nThe sorted values are:\n"
	.align 2
	space: .asciiz "  "
	
.text 
main:
	la $a0, one
	li $v0 4
	syscall 
	li $a1, 0
	jal print_float_array
	
	la $a0, two	#bubble sort using greater than
	li $v0 4
	syscall 
	jal do_loop_greater
	li $a1, 0
	jal print_float_array
	
	la $a0, two	#bubble sort using less than
	li $v0 4
	syscall 
	jal do_loop_less
	li $a1, 0
	jal print_float_array
	
	ori     $v0, $0, 10     # System call code 10 for exit
	syscall                 # Exit the program

do_loop_greater:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, compare_floats_greater_than
	li $a1, 1	#i=1
	li $t4, 1	#sorted = 1
	jal bubblesort_float_generic
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	beq $t4, $0, do_loop_greater	#while(!sorted)
	
	jr $ra
	
do_loop_less:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, compare_floats_less_than
	li $a1, 1	#i=1
	li $t4, 1	#sorted = 1
	jal bubblesort_float_generic
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	beq $t4, $0, do_loop_less	#while(!sorted)
	
	jr $ra

bubblesort_float_generic:
	addi $sp, $sp, -8
	sw $a1, 4($sp)		#store i in stack
	sw $ra, 0($sp)
	
	li $t1, 4
	mult $t1, $a1
	mflo $t2
	
	la $t3, x
	add $t2, $t3, $t2	#&x[i] in $t2
	
	addi $s1, $a1, -1
	mult $s1, $t1
	mflo $s1
	
	add $s3, $t3, $s1	#&x[i-1] in $s3
	
	move $a1, $s3	#put x[i] and x[i-1] into arguments for function call
	move $a2, $t2
	jalr $a0
	lw $ra, 0($sp)
	
	beq $v0, $0, skipSwap	#if comparator returns 0, don't swap
	li $t4, 0	#sorted = 0
	l.s $f5, 0($t2)	#swapping
	l.s $f6, 0($s3)
	s.s $f5, 0($s3)
	s.s $f6, 0($t2)
skipSwap:
	lw $a1, 4($sp)
	addi $a1, $a1, 1
	addi $sp, $sp, 8
	blt $a1, 9, bubblesort_float_generic  #i < N
	jr $ra
	

print_float_array:
	li $t1, 4
	mult $t1, $a1
	mflo $t2
	
	la $a0, x
	add $t2, $a0, $t2
	
	l.s $f12, 0($t2)
	li $v0, 2
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $a1, $a1, 1
	li $t3, 9
	bne $a1, $t3, print_float_array
	
	jr $ra
	
	
#greater than comparator
compare_floats_greater_than:
	l.s $f2, 0($a1)
	l.s $f4, 0($a2)
	c.lt.s $f4, $f2
	
	bc1t greater
	li $v0, 0	#if false
	j afterGreater
greater:		#else if true
	li $v0, 1
afterGreater:
	jr $ra
	
	
#less than comparator	
compare_floats_less_than:
	l.s $f2, 0($a1)
	l.s $f4, 0($a2)
	c.lt.s $f2, $f4
	
	bc1t less
	li $v0, 0	#if false
	j afterLess
less:			#else if true
	li $v0, 1
afterLess:
	jr $ra
