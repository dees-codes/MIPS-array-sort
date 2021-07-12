	# Deepson Shrestha
	# Project 1 - CS 330

	# MIPS implementation of array sort program

	# Data segment contents
	.data
prompt1:	.asciiz "Enter number of elements in array: "
prompt2:	.asciiz "Enter array elements, one per line: \n"
newline:	.asciiz "\n"

	# Make sure the rest of the word size variables start on a byte
	# address that is a multiple of 4
	.align 2
list:	.space 400 # int list[100]

	# Our code
	.text

	# n is associated with $s2
	# address of list will be in $s7
	# i is associated with $s0
	# j is associated with $s1
	# min_pos is associated with $s3
	# temp is associated with $s4

main:	# Load array address into $s7
	la $s7, list

	# Prompt for number of elements
	#
	# address of prompt 1 in $a0
	la $a0, prompt1
	# print_string syscall number in $v0
	li $v0, 4
	# make the syscall
	syscall

	#Read number of elements from console, store in $s2
	li $v0, 5
	syscall
	move $s2, $v0

	# Prompt for the elements
	la $a0, prompt2
	li $v0, 4
	syscall

	# Loop n times, reading one int on each iteration,
	# and storing it in list[i]

	# i = 0
	li $s0, 0

for1:	# "i < n': branch on i >= n
	bge $s0, $s2, for1_exit

	# scanf ("%d", &list[i])
	#
	# calculate &list[i]
	sll $t0, $s0, 2		# $t0 = 4 * i
	addu $t0, $t0, $s7	# $t0 = &list[i]
	#
	# read_int
	li $v0, 5		# $v0 = read_int
	syscall			# int is in $v0
	#
	# list[i] = $v0
	sw $v0, 0($t0)

	# i++
	addi $s0, $s0, 1
	# end of for1 loop body
	j for1

for1_exit:
	# Find correct element for each position except last

	# i = 0
	li $s0, 0
	# saving n-1 into a register
	addi $s5, $s2, -1 

for2:	# "i < n-1" : branch on i >= n-1
	bge $s0, $s5, for2_exit
	# Initializing minimum position
	move $s3, $s0
	# Initializing j as i+1
	addi $s1, $s0, 1

for3:	# "j < n" : branch on j >= n
	bge $s1, $s2, for3_exit

	# Calculate &list[j]
	sll $t0, $s1, 2 	# $t0 = 4*j
	addu $t0, $t0, $s7      # $t0 = &list[j]
	# Assign value in list[j] to $t0
	lw $t0, 0($t0)		# $t0 = list[j]

	# Calculate &list[min_pos]
	sll $t1, $s3, 2 	# $t1 = 4*min_pos
	addu $t1, $t1, $s7	# $t1 = &list[min_pos]
	#Assign value in list[min_pos] to $t1
	lw $t1, 0($t1)		# $t1 = list[min_pos]

	#if list[j] >= list[min_pos], jump to increment
	bge $t0, $t1, increment
	# if list[j] < list[min_pos]
	# min_pos = j
	move $s3, $s1		
	# end of for3, jump to increment
	j increment
	
increment:
	# adds one to loop counter j
	addi $s1, $s1, 1	#j++
	j for3			#repeat loop

for3_exit:
	# Since min_pos changed when body of 'if' was last executed
	# content of $t0 should be updated
	sll $t1, $s3, 2		 # $t1 = 4*min_pos	
	addu $t1, $t1, $s7	 # $t1 = &list[min_pos]
	lw $t1, 0($t1)		 # $t1 = list[min_pos]

	# Calculate &list[i]
	sll $t2, $s0, 2 	# $t2 = 4*i
	addu $t2, $t2, $s7      # $t2 = &list[i]
	# Assign value in list[i] to $t2
	lw $t2, 0($t2)		# $t2 = list[i]

	move $s4, $t2		# list[i] = temp

	# Calculating list[i] and assigning list[min_pos] to list[i]
	move $t2, $t1		# $t2 = list[min_pos}
	sll $t5, $s0, 2		# $t5 = 4 * i
	add $t5, $t5, $s7	# $t5 = &list[i]
	sw $t2, 0($t5)		# list[i] = list[min_pos]

	# Calculating list[min_pos] and assigning temp to it
	move $t1, $s4		# $t1 = temp
	sll $t5, $s3, 2		# $t5 = 4 * min_pos
	add $t5, $t5, $s7	# $t5 = list[min_pos]
	sw $t1, 0($t5)		# list[min_pos] = temp

	# Repeat loop for2
	addi $s0, $s0, 1	# i++
	j for2			# jump to the loop for2
	

for2_exit:
	# print "\n"
	la $a0, newline
	li $v0, 4
	syscall

	# i = 0
	li $s0, 0

for4:	#" i<n ": branch on i >= n
	bge $s0, $s2, for4_exit

	# printf ("%d\n", list[i])

	# Calculate &list[i]
	sll $t3, $s0, 2 	# $t3 = 4*i
	addu $t3, $t3, $s7 	# $t3 = &list[i]

	# print list[i]
	lw $a0, 0($t3) 		# $a0 = list[i]
	li $v0, 1		# $v0 = print_int
	syscall

	# print "\n"
	la $a0, newline
	li $v0, 4
	syscall

	# i++
	addi $s0, $s0, 1

	# done with loop body
	j for4

for4_exit:	 j $ra

