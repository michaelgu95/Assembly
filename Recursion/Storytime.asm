.data    
space: .asciiz "  "  	#space as separator
.align 2
newline: .asciiz "\n"
.align 2
end: .asciiz "END\n"  	#terminating character
.align 2
one: .asciiz "A "
.align 2
two: .asciiz " couldn't sleep, so her mother told a story about a little "
.align 2
three: .asciiz ",\n"
.align 2
four: .asciiz "... and then the "
.align 2
five: .asciiz " fell asleep;\n"
.align 2
six: .asciiz "who couldn't sleep, so the "
.align 2
seven: .asciiz "'s mother told a story about a little "
.align 2
eight: .asciiz "... and then the little "
.align 2
nine: .asciiz "... who fell asleep.\n"
.align 2
ten: .asciiz " fell asleep.\n"
.align 2
buffer: .space 16	  #Allocate buffer for each name, 15 characters long

.text
main:
   	 li  $s0, 0      #Load immediate value 0 into i
  	 lw $t4,end        #Load string "END\n"
   	 j getNames
    #Begin for loop:
getNames:    
    	li $v0, 8
    	la $a0, buffer
    	li $s3, 8
    	mult $s3, $s0
    	mflo $s3
    	add $a0, $a0, $s3	#4*i + address of names array 
    	li $a1, 15	
   	move $t0, $a0	#address of string read in $t0
   	syscall 
   	
   	lw $t0, 0($t0) #get string read at stored address
    	beq $t0, $t4, endLoop #if $t0 equals "END\n"
   	
   	li $s1,0               # Set index to 0
	jal remove	#remove \n from input
   	
    	addi $s0, $s0, 1	#i++
    	beq $s0, 21, endLoop	#if i=21
    	j getNames

remove:
	la $t1, 0($a0)
	li $t2, 10
	add $s2, $t1, $s1
    	lb $a3,0($s2)      # Load character at index
    	addi $s1,$s1,1      # Increment index
    	bne $a3, $t2, remove
    	sb $0, 0($s2)        # Add the terminating character in its place
	jr $ra
	
endLoop:
	li $a0, 0  #current argument 
	addi $a1, $s0, 0 #num argument
	jal bedTimeStory
	ori     $v0, $0, 10     # System call code 10 for exit
	syscall                 # Exit the program

bedTimeStory:
	li $s0, 0  #i=0
	
	addi $sp, $sp, -8 
	sw $a0, 0($sp)	#store value of current in stack
	sw $ra, 4($sp)	#store value of ra in stack 
	
	bne $a0, 0, afterOuter #if(current!=0)
	jal caseOuter
	j afterInner
afterOuter:
	lw $a0, 0($sp)
	addi $t3, $a0, 1
	bge $t3, $a1, afterMiddle #else if(current +2 >= number), number stored in $s0
	jal caseMiddle
	j afterInner
afterMiddle:
	bne $t3, $a1 afterInner #else if(current +2 == number)
	jal caseInner
afterInner:
	lw $ra, 4($sp)	
	addi $sp, $sp, 8
	jr $ra	#return to caller
	
	
caseInner:
	lw $a0, 0($sp)	#retreive correct value of current into $a0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0	#i=0
	jal spaceLoop	
	
	la $a0, nine
	li $v0, 4
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

spaceLoop:
	addi $sp, $sp, -4
	sw $a0, 0($sp)	#store current in stack
	
	la $a0, space
	li $v0, 4
	syscall	#print space
	
	lw $a0, 0($sp)	#get value of current back from stack
	addi $sp, $sp, 4
	
	addi $t1, $t1, 1	#i++
	blt $t1, $a0, spaceLoop	#i<current
	
	jr $ra	#else, finish printing spaces
	
caseMiddle: #need to store $a0, $ra, $t1, $t0 on the stack
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	add $t0, $a0, 1 #current+1 in $t0
	la $t1, buffer	#load address of names[0] into $t1
	
	li $t2, 8  #store 4 in $t2
	
	mult $t0, $t2	
	mflo $t0	#4*(current+1)
	add $t0, $t1, $t0 #t0 now contains address at current +1 + buffer
	sw $t0, 12($sp)	#store words[current+1] in stack
	
	mult $a0, $t2	
	mflo $t0	#4*(current)
	add $t1, $t1, $t0 #t1 now contains address at current + buffer
	sw $t1, 8($sp)	#store words[current+1] in stack

	
	li $t1, 0	#i=0
	jal spaceLoop
	
	la $a0, six
	li $v0, 4
	syscall	#print 'who couldn't sleep, so the "
	
	lw $t1, 8($sp)
	la $a0, 0($t1)
	li $v0, 4
	syscall	#print "words[current]"
	
	la $a0, seven
	li $v0, 4
	syscall	#print "'s mother told a story about a little "
	
	lw $t0, 12($sp)
	la $a0, 0($t0)
	li $v0, 4
	syscall	#print "words[current+1]"
	
	la $a0, three
	li $v0, 4
	syscall
	
	lw $a0, 0($sp)	#get original value of current back from stack
	addi $a0, $a0,1
	jal bedTimeStory
	
	lw $a0, 0($sp)	#get original value of current back from stack
	li $t1, 0
	jal spaceLoop
	
	la $a0, eight
	li $v0, 4
	syscall	#print "... and then the little "
	
	lw $t1, 8($sp)
	la $a0, 0($t1)
	li $v0, 4
	syscall	#print "words[current]"
	
	la $a0, five
	li $v0, 4
	syscall	#print " fell asleep;\n"
	
	lw $ra, 4($sp)
	addi $sp, $sp, 16
	jr $ra

caseOuter: #need to store $a0, $ra, $t1 on the stack
	addi $sp, $sp, -12
	sw $a0, 0($sp)	#store value of current in stack
	sw $ra, 4($sp)	#store $ra in stack
	
	add $t0, $a0, 1 #current+1 in $t0
	
	la $t1, buffer	#load address of names[0] into $t1
	sw $t1, 8($sp)
	
	li $t2, 8 #store 4 in $t2
	mult $t0, $t2	
	mflo $t0	#4*(current+1)
	add $t0, $t1, $t0 #t0 now contains address 1 word past names\
	
	la $a0, one             #print "A "
    	li $v0, 4                      
    	syscall
    	
    	la $a0, buffer
    	la $a0, 0($t1)             #print "words[current]"
    	li $v0, 4                    
    	syscall
    	
    	la $a0, two
    	li $v0, 4
    	syscall
    	
    	la $a0, buffer
    	la $a0, 0($t0)           #print "words[current+1]"
    	li $v0, 4                      
    	syscall
    	
    	la $a0, three
    	li $v0, 4
    	syscall
    	
    	lw $a0, 0($sp)	#get current back from stack]
	addi $a0, $a0, 1	#bedtimestory(words, current+1, number);
	jal bedTimeStory
	
	la $a0, four             #print "... and then the "
    	li $v0, 4                       
    	syscall
    	
    	lw $t1, 8($sp)	#get words[current] back from stack
    	la $a0, 0($t1)            
    	li $v0, 4                        
    	syscall
    	
    	la $a0, ten # " fell asleep.\n"
    	li $v0, 4
    	syscall
	
	lw $ra, 4($sp)	
	addi $sp, $sp, 12
	jr $ra

