# Program File: Hex to Decimal Conversion 
# Name: Ashwin Chidambaram
# CruzID: 1513761
# Section 01D, Rebecca
# 05/21/18
# CMPE 12
# Purpose: Convert from hex value to decimal value

######### - PSUEDO CODE - ################################################################################################
# Print out the first message "Input a hex number: "									##
# Find value from memory location											##
# Store value of memory into register 											##
# Offset stored value by 2 to ignore '0x' and print out remaining array							##
# Print out second message "The decimal value is: "									##
# Store 1st byte from array to a register to check if it is negative							##
# Convert stored byte from its ascii symbol value to its decimal value (F - 15)						##
# Check if stored value >= 8												##
#	True; Jump to Line 20												##
#	False; Jump to Line 28												##
#															##
# True:															##
# 	Print out negative sign 											##
# 	Store value into array to be iterated through									##
#	Convert each ascii hex value to its decimal representation							##
#	Multiply each hex bye with its positions respective 16 base power value (16^7, 16^6, ... etc)			##
#	Sum each product to a register and output when all values are calculated 					##
#															##
# False:														##
# 	Store value into array to be iterated through									##	
#	Convert each ascii hex value to its decimal representation							##
#	Multiply each hex bye with its positions respective 16 base power value (16^7, 16^6, ... etc)			##
#	Sum each product to a register and output when all values are calculated 					##
######### - PSUEDO CODE - ################################################################################################


.data # Define program text calls
	prompt: .asciiz "Input a hex number: "
	output: .asciiz "The decimal value is: "
	newLine: .asciiz "\n"
	hexcompArray: .space 32

.text # Define the program instructions
main:
	jal printInMessage		# Prompt for storing hex number to convert into decimal number
	
	jal space			# newLine
	
	jal printHexVal			# Print hex input value
	
	jal space			# newLine
	
	jal printOutMessage		# Print decimal output message
	
	jal space			# newLine
	
	j checkIfCompliment		# Check if first bit is 1 or 0
	
	# Decimal value will be output in above function
		
###########################################################################################################################################################################		
# ---------------------------------------------------------------------------- Function Calls -----------------------------------------------------------------------------
printInMessage:		 	# Prints starting message "Input a hex number: "
	li $v0, 4
	la $a0, prompt				# Output "prompt"
	syscall
	
	jr $ra

printHexVal:			# Prints out hexadecimal input from Program Argument 
	lw $t7,($a1)				# Store register location of $a1 into $t7 so that we can use it later
	move $s5, $t7
	
	li $v0, 4
	la $a0, ($t7)				# Store register location in $t7 into $a0 so it can be called
	syscall
	
	jr $ra
	
printOutMessage: 				# Prints predecimal value message "The decimal value is: "
	li $v0, 4
	la $a0, output				# Output "output"
	syscall
	jr $ra
	
checkIfCompliment:		# Checks if the input is negative

	# Variables to be used 
	li $s5, 2				# Starting byte of input array
		
	# Getting value of byte at position $s5
	add $t6, $s5, $t7			# Offset $t7 position by x (to ignore Ox) and store into $t6
	lb $t6, ($t6)				# Store value at $t6 into $t6

	jal convertToNorm
		
	bge $t1, 8, getNegDecimalValue
	ble $t1, 7, getPosDecimalValue
	j exit
	
# --------------------------------------------------------------------- Inner Function Calls -------------------------------------------------------------------------
convertToNorm:			# Convert ascii char into normal form

	# Convert to 0-9 or A-F
	subi $t1, $t6, 48	# By subtracting 48 from $t6 we can check if it is a value that is 0-9 or A-F. Check [1] for detialed reasoning
	bgt $t1, 9, hex		# If ASCII char is A-F go to hex
	ble $t1, 9, dec		# If ASCII char is 0-9 go to dec
	
	hex:
		subi $t1, $t1, 7

		j back
	
	dec:
		j back
	
complement: 			# Check if negative
	li $t9, 15
	sub $t1, $t9, $t1
	
	j back
	
getNegDecimalValue:		# Gets the negative decimal value of hex input

	# Variables to be used 
	li $s4, 1				# Register used to remember that value is negative
	li $s5, 2				# Starting byte of input array
	li $t2, 10				# Loop exit condition
	li $t8, 0				# Location in Hex Array 
	
	loopThroughNArray:	# Loop through array and store decimal conversion of hex into array
		beq $t2, $s5, outArray		# Loop exit condition
			
		# Getting value of byte at position $s5
		add $t6, $s5, $t7		# Offset $t7 position by x (to ignore Ox) and store into $t6
		lb $t6, ($t6)			# Store value at $t6 into $t6
		
		jal convertToNorm		# Convert from ascii value to decimal representation
			
		jal complement			# Check if value is negative
		
		sb $t1, hexcompArray($t8)	# Store value of $t1 into position $t8 of Hex Array
		addi $t8, $t8, 1		# Increment array position by 1
		
		addi $s5, $s5, 1		# Increment loop array
			
		j loopThroughNArray		# Jump back to loop start
		
getPosDecimalValue:		# Gets the positive decimal value of hex input

	# Variables to be used 
	li $s5, 2				# Starting byte of input array
	li $t2, 10				# Loop exit condition
	li $t8, 0				# Location in Hex Array 
	
	loopThroughPArray:	# Loop through array and store decimal conversion of hex into array
		beq $t2, $s5, outArray		# Loop exit condition
			
		# Getting value of byte at position $s5
		add $t6, $s5, $t7		# Offset $t7 position by x (to ignore Ox) and store into $t6
		lb $t6, ($t6)			# Store value at $t6 into $t6
		
		jal convertToNorm		# Convert from ascii value to decimal representation
			
		sb $t1, hexcompArray($t8)	# Store value of $t1 into position $t8 of Hex Array
		addi $t8, $t8, 1		# Increment array position by 1
		
		addi $s5, $s5, 1		# Increment loop array
			
		j loopThroughPArray		# Jump back to loop start
		
outArray:

#jal storeTo$s0	
		
# Declare variable values used in findDecimal
li $t8, 0
li $t4, 7

	findDecimal:	# Convert hex array into one decimal value (sum of all values)
		li $t8, 0		# Array position
		li $t4, 0		# Sum value
		
	convert:
			
		# x(16^7)
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 268435456
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^6) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 16777216
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^5) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 1048576
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^4) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 65536
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^3) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 4096
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^2) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 256
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^1) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 16
		add $t4, $t4, $t3
		addi $t8, $t8, 1
			
		# x(16^0) + before
		lb $t1, hexcompArray($t8)
		mulo $t3, $t1, 1
		add $t4, $t4, $t3
		addi $t8, $t8, 1
		
		beq $s4, 1, negVal
		
		print:
		
			move $s0, $t4		# Store in $s0
			
			# Output decimal value
			li $v0, 1
			move $a0, $s0
			syscall
			
		j exit

negVal:
	addi $t4, $t4, 1		# Sum value
	mul $t4, $t4, -1		# Since number is negative
	
	j print
# --------------------------------------------------------------------- Easy Access Function Calls -------------------------------------------------------------------------
back:				# Jump back to last linked spot (jal)
	jr $ra
	
space:				# Adds a newline space for code convention
	li $v0, 4
	la $a0, newLine		# Print "newLine" (\n)
	syscall
	
	jr $ra

exit:				# Terminate program signal
	li $v0, 10
	syscall 
	
# ------------------------------------------------------------------------------- Notes -------------------------------------------------------------------------
	
# [1] If we look at the ASCII table, we notice that the decimal value for ASCII 9 is 57, but the actual decimal value for it should be 9.
#	So, if we subtract 48 from 57, we get the value of 9 which matches the ASCII 9 to Decimal 9. Similarly, ASCII 8 matches to  
#	Decimal 8 and so on. While this can be used to determine if an ASCII char is 9 all the way to 0, it can't differentiate A-F.
#	To solve that, we look at the diff between the ASCII F value and Decimal F value which was 55. Since we had just subtracted 48
#	from the ASCII value, we just needed to subtract 7 more (48 + 7 = 55) to hit the correct decimal value for an ASCII Hex char. 
#	Originally I implemented this as a means to convert each hex byte into binary, but I no longer needed it so I scrapped it for parts
#	used in other parts of the program.

	
	
	
