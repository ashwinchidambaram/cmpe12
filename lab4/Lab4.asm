# Program File: FeedBabe
# Name: Ashwin Chidambaram
# CruzID: 1513761
# Section 01D, Rebecca
# 05/10/18
# CMPE 12
# Purpose: Replicate functionality of FEEDBABE code from Lab 1 in MIPS

.data # Define program text calls
	prompt: .asciiz "Please input a number: "
	divThree: .asciiz "FEED"
	divFour: .asciiz "BABE"
	space: .asciiz "\n"

.text # Define the program instructions
main:
	
	# Prompt for number of numbers to iterate through
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Read the integer and save it in $v0
	li $v0, 5
	syscall
	
	move $s0, $v0 # Move value from $v0 to $s0 to save for later use
	
	addi $t0, $zero, 1 # Set $t0 to 1 so that we can iterate from 1 onwards
	
	# Create some basic data registers (used to divide $t0)
	li $t3, 3 
	li $t4, 4
	
	# In this case, using $t6 as a way of checking whether we need to output the actual numerical value insead of FEED, BABE, or FEEDBABE
	li $t6, 1
	
	# Begin while loop till $t0 == $s0 <-- Inital input value
	while: 
		bgt $t0, $s0, exit # Set condition for while loop to exit as until $t0 > input val ($s0)
		li $t1, 0 # Using $t1 as a way to check if $t0 has successfully been divided by 3 or 4
		
		three: # Check if divisible by 3; if so, go to divByThree
			divu $t0, $t3
			mfhi $t2
			beqz $t2, divByThree
		
		four: # Check if divisible by 4; if so, go to divByFour
			divu $t0, $t4
			mfhi $t2
			beqz $t2, divByFour
			
		none: # If not divisible by 3 or 4 go to undivisible 
			bne $t1, $t6, undivisible 
		
		increment: # Add 1 to t0 to increment loop
			addi $t0, $t0, 1 
			
		newLine: # Print a newline for necessary spacing
		li $v0, 4
		la $a0, space
		syscall
		
		j while # Jump back to start of loop so that this actually functions as a loop
		
	exit:
		# Signal end of loop (Causes program to run indefinetely if not)
		li $v0, 10
		syscall 
		
# ------------------------------------------ If Statement Functions --------------------------------------------------
		
	divByThree: # If divisible by 3
		li $v0, 4
		la $a0, divThree # Get FEED message text
		syscall
		
		li $t1, 1 # By setting $t1 to 1, I affirm a statement above to NOT print numerical value of $t0 at present iteration
		
		j four # Go to "four" to check if divisible by 4
		
		
	divByFour: # If divisible by 4
		li $v0, 4
		la $a0, divFour # Get BABE message text
		syscall
		
		li $t1, 1 # By setting $t1 to 1, I affirm a statement above to NOT print numerical value of $t0 at present iteration
		
		j none # Go to "none" because it is next in processing line, however, this is not necessary and can go to increment. Just personal pref

	undivisible: # If not divisible by 3 or 4
		li $v0, 1
		add $a0, $t0, $zero # Set $a0 to value of $t0 so it can be printed
		syscall 
		
		j increment # Go to increment so $t0 can increase by 1 for next loop iteration 
		


