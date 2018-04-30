.data 

original_list: .space 100 
sorted_list: .space 100

space: .asciiz " "
nextLine: .asciiz "\n"

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of original list: "
str3: .asciiz "Enter a key to search for: "
str4: .asciiz "Content of sorted list: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"

nozero: .asciiz "\nThe list size should be greater than 0! \n"
nonegative: .asciiz "\nThe list size should not be negative! \n"
error_msg: .asciiz "\nThe list size cannot be greater than 25! \n "

.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	#overwrites $ra
	addi $sp, $sp -8
	sw $ra, 0($sp)
	
	#prints first prompt
	li $v0, 4 
	la $a0, str0 
	syscall 
	
	#read size of list from user
	li $v0, 5
	syscall
	
	move $s0, $v0
	move $t0, $0
	move $t9, $0
	la $s1, original_list
	addi $t9,$zero,25
	
#MESSAGES TO LET USER KNOW THAT VALUES ENTERED ARE INVALID#

	beqz $s0, NoZero
	bltz $s0, negative
  	bgtu $s0, $t9, invalid_size
	
loop_in:
	#prints second prompt
	li $v0, 4 
	la $a0, str1 
	syscall 
	
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	
	#read elements from user
	li $v0, 5
	syscall
	
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	#moves arguments from memory to argument registers
	move $a0, $s1
	move $a1, $s0
	
	#Call inSort to perform insertion sort in original list
	jal inSort
	
	sw $v0, 4($sp)
	
	#prints third prompt
	li $v0, 4 
	la $a0, str2 
	syscall 
	
	la $a0, original_list
	move $a1, $s0
	
	#Print original list
	jal printList
	
	#prints fifth prompt
	li $v0, 4 
	la $a0, str4 
	syscall 
	
	lw $a0, 4($sp)
	
	#Print sorted list
	jal printList
	
	#prints fourth prompt
	li $v0, 4 
	la $a0, str3 
	syscall 
	
	#read search key from user
	li $v0, 5
	syscall
	
	move $a3, $v0
	lw $a0, 4($sp)
	
	#call bSearch to perform binary search
	jal bSearch
	
	beq $v0, $0, notFound
	
	#prints found if key is found
	li $v0, 4 
	la $a0, strYes 
	syscall 
	
	j end
	
notFound:
	#prints not found if key is not found
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	#restores $ra
	lw $ra, 0($sp)
	addi $sp, $sp 8
	
	#ends program
	li $v0, 10 
	syscall

Exit:   
   # Exit program if anything wrong happens
   li $v0, 10
   syscall
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	#Your implementation of printList here	

	#overwrites $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#load arguements to temp registers
	move $t0, $a0
	move $t1, $a1
	
whilePrintList:
	#loads element from list arguement and prints it out
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	#loads space and prints it out
	li $v0, 4
	la $a0, space
	syscall
	
	#iterates pointers and iterator
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	
	#checks to see if size iterator is equal to 0
	#else, jump to top of loop
	beq $t1, $zero, exitPrintList
	
	j whilePrintList
	
exitPrintList:
	#loads a new line and prints it out
	li $v0, 4
	la $a0, nextLine
	syscall
	
	#restores $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	#Your implementation of inSort here
	
	#overwrites $ra
	addi $sp, $sp, -32
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	
	#move arguments into respective temp registers
	move $s0, $a0
	move $s1, $a1
	
	#sets i = 1
	addi $s2, $zero, 1
	
arraycp:
	#load original list
	la $t0, original_list
	#loads empty sorted list
	la $t1, sorted_list
	#iterator
	addi $t6, $t6, 0
	#s1 is size
	
arraycploop:
	#iterator is done when one less than size
	beq $s1, $t6, arraycpend
	
	#grabs element from original list
	lw $t2, ($t0)
	#stores element into sorted list
	sw $t2, ($t1)
		
	#iterates pointers and iterator
	addi $t0, $t0, 4 
	addi $t1, $t1, 4
	addi $t6, $t6, 1
	
	j arraycploop

arraycpend:
	#now using sorted list to perform insertion sort
	#loading sorted list into $t1
	la $t1, sorted_list
	#sorted list is stored inside $s0
	move $s0, $t1

iloop:
	#if i = arraySize then end
	beq $s2, $s1, iend
	
	#$t2 = offset(muliplies i by 4)
	sll $t2, $s2, 2
	#t3 = address of array + offset
	add $t3, $s0, $t2
	#s3 = array[i]
	lw $s3, ($t3)
	#j = i - 1
	addi $s4, $s2, -1
	
jloop:
	# break if j < 0
	bltz $s4, jend
	
	# a0 = s3 = key = array[i]
	move $a0, $s3
	
	la $t0, ($s0) 
	sll $t2, $s4, 2
	# t3 = array[j]
	add $t3, $t0, $t2
	# value of array[j] as argument 
	lw $a1, ($t3)

	jal stringlt 
		
	move $t0, $v0
	#if true, end
	beq $t0, $zero, jend
		
		
#NESTED LOOP BEGINS HERE#
	
	la $t0, ($s0)
	sll $t2, $s4, 2 
	add $t3, $t0, $t2
	# t4 = array[j]
	lw $t4, 0($t3)

	# t2 = j + 1
	addi $t2, $s4, 1 
	sll $t3, $t2, 2
	# address of array[j+1]
	add $t1, $t3, $s0 
	# array[j+1] = array[j]
	sw $t4, 0($t1) 
	#j--
	addi $s4, $s4, -1 
		
	j jloop
		
jend:	
	#array[j+1] = key
	move $t0, $s4
	addi $t0, $t0, 1
	sll $t2, $t0, 2
	add $t1, $s0, $t2
		
	sw $s3, ($t1)
	
	#i++
	addi $s2, $s2, 1
	j iloop

iend:
	#restores a1
	move $a1, $s1
	
	#restores $ra
	lw $ra, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	addi $sp, $sp, 32
	
	#returns the address of the sorted array
	la $v0, sorted_list
	
	jr $ra
	
#string less than function: returns true if less than, false if greater than
stringlt: 

	# t0 = a0 = s3 = key = array[i]
	move $t0, $a0 
	# array [j]
	move $t1, $a1 


	sltloop:
	# jumps to less than if t0 < t1
	blt $t0, $t1, iflt 
	# jumps to greater than if t0 > t1
	bge $t0, $t1, ifgt 
	
	j sltloop
	
	stringend:
	# checks if x = 0
	beq $t2, $zero, iflt
	# returns false
	j ifgt
	
	 # returns true
	iflt:
	li $v0, 1
	j sltend	
	
	# returns false
	ifgt:
	li $v0, 0
	j sltend

	sltend:
	jr $ra
	
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	#Your implementation of bSearch here
	
	# address sorted list
	move $s0, $a0 
	# size/right
	move $s1, $a1 
	# search key
	move $s2, $a3 
	# left
	move $s3, $a2 
	# mid
	li $s5, 0 
	
	#keeping size in line
	addi $s1, $s1, -1 # size/right
	
	#checks if left is greater than right
	bgt $s3, $s1, rightcheck
	
nopegoback:

	#checks if right is less than left
	blt $s1, $s3, bfalse 
	
	# mid = l + (r - l)/2
	sub $t0, $s1, $s3
	div $t0, $t0, 2
	add $s5, $s3, $t0
	
	# t1 = array[mid]
	sll $t1, $s5, 2
	add $t2, $s0, $t1
	lw $t1, ($t2)
	
	#checks if array[mid] == search key
	beq $t1, $s2, btrue
	
	#if l == 0 and r == 0 then return false
	li $t4, 0
	li $t5, 0
	
	slti $t4, $a3, 1
	slti $t5, $a1, 1
	
	add $t4, $t4, $t5
	li $t5, 2
	beq $t4, $t5, bfalse
	
	# jumps to greater than if t0 > t1
	bgt $t1, $s2, bsgt
	# jumps to less than if t0 < t1
	blt $t1, $s2, bslt 
	
bsgt:
	sub $a1, $s5, $s3
	j bSearch
	
bslt:
	addi $a2, $s5, 1
	j bSearch
	
btrue:
	li $v0, 1
	jr $ra
bfalse:
	li $v0, 0
	jr $ra

rightcheck:
	sll $t6, $s1, 2
	add $t6, $s0, $t6
	lw $t7, ($t6)
	beq $s2, $t7, btrue
		
	j nopegoback

#MESSAGE FUNCTIONS HERE#

NoZero:
	la $a0, nozero
  	li $v0, 4
  	syscall
	j Exit
negative:
	la $a0, nonegative
  	li $v0, 4
  	syscall
	j Exit
invalid_size:
  	la $a0, error_msg
  	li $v0, 4
  	syscall
	j Exit
