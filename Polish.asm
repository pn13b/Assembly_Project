# Paul Nieto -- 12/04/2014
# polish.asm -- this is a program that is to calculate 
# 	"Polish" sequences. A Ploish sequence is a sequence
#	that is calculated by squaring the individual digits
#	of the number and adding them together, using that
#	number as the next value in the sequence. This process
#	repeats itself and ends up producing a sequnce that
#	that will either end in the infinite sequence 1, 1, 1,...
#	or in the sequence 20, 4, 16, 37, 58, 89, 145, 42, 20,...



# funciton terms -- written by Paul Nieto -- 12/04/14
# 	this funciton prints some preliminary text to step up
#	the output of the polish funciton. It prepairs a loop
#	to call polish 16 times to produce the polish sequence.
# Register use:
#	$sp	stack pointer
#	$ra	function return variable
#	$v0	syscall parameter
#	$a0	syscall parameter/initial argument value
#	$s0	loop variable
#	$s1	loop variable
#	$t3	temporary holding variable
#	$t4	temporary holding variable


terms:
	move $t4, $a0
	la	$a0, text	# print text
	li	$v0, 4
	syscall
	move $a0, $t4

	sw $ra, 0($sp)
	add $s0, $s0, $0
	addi $s1, $s1, 16
	addi $v0, $v0, 0
loop1:	
	li $v0, 1
	syscall

	move $t3, $a0
	
	la $a0, space
	li $v0, 4
	syscall

	move $a0, $t3

	jal polish

	addi $s0, $s0, 1
	bne $s0, $s1, loop1
	
	lw $ra, 0($sp)
	jr $ra
	

# funciton polish -- written by Paul Nieto -- 12/04/14
#	this function does the mathematical calculationf of
#	taking the individual digits of the number, squaring
#	them and then adding them together and returning them
#	to terms.
# Register use:
#	$t0	holds value of 10
#	$v0	return variable/running sum
#	$a0	holds digit passed to function
#	$t1	holds remainder
#	$t2	contains sqaured digit

	
polish:
	addi $t0, $0, 10
	addi $v0, $0, 0
loop2:
	rem $t1, $a0, $t0	# takes digits from the back
	mul $t2, $t1, $t1	# squares it
	add $v0, $t2, $v0	# add it to the running sum
	div $a0, $a0, $t0 	# cuts off digits already used
	bgt $a0, $t0, loop2

	mul $t2, $a0, $a0	# does previous steps for last
	add $v0, $t2, $v0	# digit of number
	add $a0, $0, $0
	add $a0, $v0, $0
	
	jr $ra



# Driver program provided by Stephen P. Leach -- written 12/15/08

	.text
	.globl main

main:	la	$a0, intro	# print intro
	li	$v0, 4
	syscall

loop:	la	$a0, req	# request value of n
	li	$v0, 4
	syscall

	li	$v0, 5		# read value of n
	syscall
	
	ble	$v0, $0, out	# if n is not positive, exit

	move	$a0, $v0	# set parameter for terms procedure

	jal	terms		# call terms procedure

	j	loop		# branch back for next value of n

out:	la	$a0, adios	# display closing
	li	$v0, 4
	syscall

	li	$v0, 10		# exit from the program
	syscall


	.data
intro:	.asciiz  "Welcome to the Polish sequence tester!"
req:	.asciiz  "\nEnter an integer (zero or negative to exit): "
text:	.asciiz  "First 16 terms: "
space:	.asciiz " "
adios:	.asciiz  "Come back soon!\n"
