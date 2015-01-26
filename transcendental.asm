# Paul Nieto -- 12/4/2014
# exp.asm - this is a program that approximates different powers of
# the transidental number e using an infinite sum (which in
# this case will not be infinite). This function can be described as 
# e^x= 1 + x/1 + (x^2)/2! + (x^3)/3 + ... and so on until the most
# recent calculated value is smaller than 1.0e-15. Because the terms
# eventually get so small this can still be a very close apromixation.
	


# funciton main -- written by Paul Nieto -- 12/7/14
#	Introduces user to program, prompts user to
# input power of e to calculate. Calls the exp function.
# Register Use:
#	$a0	syscall parameter
#	$v0	syscall paramter
#	$f10	exit value variable
#	$f0	syscall input variable 
#	$f12	exponent user variable

	.text
	.globl main

main:	la	$a0, intro	# print intro
	li	$v0, 4
	syscall

	li.s $f10, 999.0 

loop:	
	la	$a0, req	# request value of n
	li	$v0, 4
	syscall

	li	$v0, 6		# read value of n as a float
	syscall

	mov.s $f12, $f0 	# transferes loaded in value to $f12
	
	c.eq.s	$f0, $f10	# if n 999, exit
	bc1t exit

	jal	exp		# call exp procedure

	j	loop		# branch back for next value of n
	
exit:
	la	$a0, adios	# display closing
	li	$v0, 4
	syscall

	li	$v0, 10	# exit from the program
	syscall



# function exp -- written by Paul Nieto -- 04/10/09
#	Calculates the e to the power that the user
#  entered. The function calculates this by using the
#  following, in this case, finite sum.
#  e^x= 1 + x/1 + (x^2)/2! + (x^3)/3 + ... and so on
#  until the most recent calculated value is smaller
#  than 1.0e-15. 
# Register use:
#	$v0	syscall variable
#	$f0	return variable
#	$f1	comparison/factorial sum variable
#	$f2	contains exponent sum
#	$f3	total sum variable
#	$f4	stores $f12 with pos/neg for comparison
#	$f5	temporary/incrementing factorial variable
#	$f7	constant variable
#	$f11	stores 1.0e-15 for exit comparison
#	$f12	passed user paramter



exp:
	li.s $f11, 0.000000000000001
	li.s $f1, 0.0
	li.s $f0, 1.0


	mov.s $f4, $f12		#move f12 into another register
	abs.s $f12, $f12
	c.eq.s $f12, $f1
	bc1t EXIT

				#start calculation

	add.s $f0, $f0, $f12	#adds x for the first time

	li.s $f1, 1.0
	li.s $f5, 2.0
	li.s $f7, 1.0

	mul.s $f2, $f12, $f12	#priming calculations
	mul.s $f1, $f5, $f1

	div.s $f3, $f2, $f1	#brings values together and
	add.s $f0, $f0, $f3	#adds them to running sum

	
MASTERLOOP:
	add.s $f5, $f5, $f7

	mul.s $f2, $f2, $f12	#creates exponent
	mul.s $f1, $f1, $f5	#creates factorial

	
	div.s $f3, $f2, $f1	#brings values together and
	add.s $f0, $f0, $f3	#adds them to running sum


	c.lt.s $f3, $f11	#checks for precision
	bc1t prexit

	j MASTERLOOP


prexit:				#tests for negativity
	li.s $f5, 0.0
	c.le.s $f5, $f4
	bc1t EXIT
	

	li.s $f5, 1.0
	div.s $f0, $f5, $f0

EXIT:
	
	la	$a0, approx1 
	li	$v0, 4
	syscall

	li $v0, 2
	syscall

	la	$a0, approx2 
	li	$v0, 4
	syscall

	mov.s $f12, $f0

	li $v0, 2
	syscall

	jr $ra	



	.data
intro:	.asciiz  "Let's test our experimental function!"
req:	.asciiz  "\nEnter an value for e^x (or 999 to exit): "
approx1: .asciiz  "Our approximation for e^"
approx2: .asciiz  " is "
adios:	.asciiz  "Come back soon!\n"