# Program File: FLOATING POINT MATH 
# Name: Ashwin Chidambaram
# CruzID: 1513761
# Section 01D, Rebecca
# 06/04/18
# CMPE 12
# Purpose: Perform floating point functions

# ========================================================================================================================================================================= #		
# ---------------------------------------------------------------------------- PSEUDOCODE --------------------------------------------------------------------------------- #
# ========================================================================================================================================================================= #
# PrintFloat: *Print out Sign, Exponent, Mantissa*
	# Take in input from test file
	# Store input into register x
	
	# Sign Bit:
		# Output message
		# Shift register 31 bits to the right (logical not arithmetic) to isolate sign bit
		# Store signed bit into a register to be output
		
	# Exponent:
		# Output message
		# Shift register in which input was stored 1 bit left (logical)
		# Shift register again, but right by 24 bits to isolate exponent 
		# Isolated exponent would be stored in its hex value so convert
		# Create hex to binary converter and convert (Just divide 2^n by value)
	
	# Mantissa:
		# Output message
		# Shift stored register left (logical) to isolate 23 bit bit mantissa
		# Shift back to origin to keep clean and easy to use
		# Thread value through previously built binary conversion mech to get binary output
		
	# Jump back to main
	
# CompareFloat: *Compare values of A and B*
	# Store values of A and B into registers 
	# Branch if A > B or B > A
	# If A is greater, return 1
	# If B greater, return -1
	# If A = B, return 0
	# EDIT: WHEN NEG COMPARED, IT TAKES LARGER NUM NOT CLOSER TO 0
		# Fixed by inverting answer 
		# If A > B (neg) return -1
		# If B > A (neg) return 1
		
	# Jump back to main
		
# AddFloats: *Add floating point numbers*
	# Store value of A and B into registers
	# Break A and B into Sign, Exponents, and Mantissas and store 
	# Check what the sign of the output would be by checking which signs
		# (+) + (+) = (+)
		# (-) + (-) = (-)
		# (^+) + (-) = (+)
		# (+) + (^-) = (-)
	# Check exponents of A and B
	# Lower exponent will allign to larger one
	# Add hidden bit (1.) to both mantissas
	# Allign based on exponent of larger value
	# Once alligned, add values before decimal together and store
	# Make normal to pass through normalize
	# Add values after decimal together and store
	# Pass stored values ($a0, $a1, $a2, $a3) into normalize to make into normalized form
	# Return from NormalizeFloat and store value into $v0
	
	# Jump back to main 
	
# MultFloats: *Multiply floating point numbers*
	# Store value of A and B into registers
	# Break A and B down into Sign, Exponent, Mantissa
	# Add exponents and store into $a3
	# Check what the sign bit will be:
		# (+) * (+) = (+)
		# (-) * (-) = (+)
		# (+) * (-) = (-)
		# (-) * (+) = (-)
	# Multiply mantissa values of A and B
	# Should be stored in lo and hi registers
	# Store lo and hi into registers to be passed through normalize 
	# Check for number of bits output, since overflow
	# Normalize for overflow 
	# Pass arguemnts through NormalizeFloat 
	# Store returned value into $v0
	
# NormalizeFloat:
	# Gets arguments ($a0, $a1, $a2, $a3) from either SumFloats or MultFloats
	# Prepare the mantissa values that were input ($a1, $a2) for being stored
	# Shift inputs into a usable manner where we can get the 23 bits of a mantissa
	# Once formatted, check if 24th bit (not including leading hidden bit) is a 1 or 0
		# If 1, round mantissa up by adding 0x00000001
		# If 0, don't round the value
	# Once (not)rounded check if the resultant value increased in size by 1 bit
		# If yes, increase exponent 
		# If no, prepare to store to combine all components 
		
	# Combine Sign, Exponent, Mantissa:
		# Make sure target register is 0'ed (0x00000000)
		# Add signed bit (should be right alligned)
			# Results in either 0x00000000 or 0x00000001
		# Shift register over by 8 bits (logical) to make room for exponent 
		# Add exponent value (should be right alligned and bias taken into account)
			# 0x0000000A + 0x000000BC
		# Shift register over again by a value of 23 bits to make room for mantissa
		# Mantissa should be right alligned with leading 1 removed 
		# Add mantissa 
			# 0xXYZ00000 + 0x00DEFGHI
		# Result should be a properly formatted floating point value
		# Return to parent function to be stored into $t0 (or maybe store here)

# ========================================================================================================================================================================= #		
# ---------------------------------------------------------------------------- DATA + MACROS ------------------------------------------------------------------------------ #
# ========================================================================================================================================================================= #
.data																					
newLine: .asciiz "\n"
spacer: .asciiz " "	
sign: .asciiz "SIGN: "
exponent: .asciiz "EXPONENT: "
mantissa: .asciiz "MANTISSA: "


########## - NEWLINE - ###################
# Insert new line			##
.macro space				##
	li $v0, 4			##
	la $a0, newLine			##
	syscall				##
					##
.end_macro				##
##########################################

########## - SPACE - #####################
# Insert new line			##
.macro gapSpace				##
	li $v0, 4			##
	la $a0, spacer			##
	syscall				##
					##
.end_macro				##
##########################################

############## - EXIT - ##################
# Exit program 				##
.macro exit				##
	li $v0, 10			##
	syscall 			##
					##
.end_macro				##
##########################################

######## - PRINT STATEMENT - #############
# Print out a statement 		##
.macro printStatement (%statement)	##
	li $v0, 4			##										
	la $a0, %statement		##									
	syscall				##
					##
.end_macro 				##
##########################################

######## - PRINT STATEMENT - #############
# Print out an integer			##
.macro printValue (%value)		##
	li $v0, 1			##										
	la $a0, (%value)		##									
	syscall				##
					##
.end_macro 				##
##########################################
																	
# ========================================================================================================================================================================== #		
# ---------------------------------------------------------------------------- ASSEMBLY CODE ------------------------------------------------------------------------------- #
# ========================================================================================================================================================================== #																																																																		
.text

# ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< PRINT FLOAT ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< #
PrintFloat:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	move $t3, $a0

    ###################### - SIGN - ######################################################################################
	li $t7, 1				# Location pointer							##
															##
	Sign:														##
	# Check sign value												##
	srl $t1, $t3, 31			# Shift register by 31 bits to isolate first bit			##
															##
	printStatement (sign)			# Print out "SIGN: " statement						##
															##
	printValue ($t1)			# Print out value of $t1 (sign value)					##
															##
    ###################### - SIGN - ######################################################################################

	loc1a:
		space				# Move to new line

    ###################### - EXPONENT - ##########################################################################################################
	li $t7, 2				# Location pointer										##
																		##
	Exponent:																##
		# Print "EXPOENENT: " text													##
		printStatement (exponent)													##
																		##
		# Get exponent value														##
		sll $t1, $t3, 1			# Shift register left by 1 bit to remove sign							##
		srl $t1, $t1, 24		# Shift register right by 24 bits to isolate Exponent						##
																		##	
		# Store register value not in $t1, since $t1 is used as a conversion mech							##
		move $t9, $t1															##
		li $t2, 7			# Since 8 bit val										##
																		##
		# Convert exponent value to binary												##
		exponentToBinary:														##
			jal findExponentVal	# Finds value of 2^n										##
																		##
		# Print out bit value (1 or 0)													##															##
			jal conversion		# Convert value											##
			j exponentToBinary	# Jump back for loop										##
																		##
    ###################### - EXPONENT - ##########################################################################################################

	loc1b:
		space				# Move to new line

    ############################ - MANTISSA - ####################################################################################################
	li $t7, 3				# Location pointer										##
																		##
	Mantissa:																##
	# Print "MANTISSA: " text														##
		printStatement (mantissa)													##																##
																		##
		# Get mantissa value														##
		sll $t1, $t3, 9			# Shift register left by 9 bit to remove sign + exponent					##
		srl $t1, $t1, 9			# Shift register right by 9 bits to isolate mantissa						##
																		##	
		# Store register value not in $t1, since $t1 is used as a conversion mech							##
		move $t9, $t1															##
		li $t2, 22			# Since 24 bit val										##
																		##
		# Convert exponent value to binary												##
		mantissaToBinary:														##
			jal findExponentVal	# Finds value of 2^n										##
																		##
		# Print out bit value (1 or 0)													##
																		##
			jal conversion														##
			j mantissaToBinary	# Jump back for loop										##
																		##
    ############################ - MANTISSA - ####################################################################################################

	loc1c:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra

# ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< COMPARE FLOATS ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< #
CompareFloats:

	subi $sp, $sp, 4
	sw $ra, ($sp)

	move $t4, $a0				# Store value of A ($a0) into $t4
	move $t5, $a1				# Store value of B ($a1) into $t5

### - COMPARE FLOAT VALUES -  #############################################
compareFloatValues:			     ## Checks of val neg or pos ##
					     ##############################
					     				 ##
	srl $s1, $t4, 31			# Get sign of first val	 ##
	srl $s4, $t5, 31			# Get sign of second val ##
									 ##
	beq $s1, $s4, equalSign			# If A == B 		 ##	
	bgt $t4, $t5, greaterThan		# If A > B		 ##
	blt $t4, $t5, lessThan			# If A < B		 ##
									 ##
	Branches:							 ##
		equalSign:			# If value is neg	 ##	
			beq $t4, $t5, equal	# If A == B 		 ##
			beq $s1, 1, negBranch				 ##
			beq $s0, 0, posBranch				 ##	
									 ##
			negBranch:					 ##
				bgt $t4, $t5, lessThan			 ##
				blt $t4, $t5, greaterThan		 ##
									 ##
			posBranch:					 ##
				bgt $t4, $t5, greaterThan		 ##
				blt $t4, $t5, lessThan			 ##
									 ##
		equal: 							 ##
			li $t0, 0					 ##
			j storeCompare					 ##
									 ##
		greaterThan:						 ##
			li $t0, 1					 ##
			j storeCompare					 ##
									 ##
		lessThan:						 ##
			li $t0, -1					 ##
			j storeCompare					 ##
									 ##
	storeCompare:							 ##
   		move $v0, $t0			# Store val in $v0	 ##
   									 ##
# Return to main							 ##
	lw $ra, ($sp)							 ##
	addi $sp, $sp, 4						 ##
									 ##
	jr $ra								 ##
									 ##
### - COMPARE FLOAT VALUES -  #############################################

# ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< ADD FLOATS ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< #
AddFloats:	# Add floats worked, but removed due to issues with how it interacted with mult
j end	############# Using to skip over code block

	#subi $sp, $sp, 4
	#sw $ra, ($sp)
	
	#jal clearRegisters

jal CollectData
    
    ################## - PREPARE MANTISSA & EXPONENT - ###########################################
    # Caluclate the exponent value after removing bias (127)					##
    li $t1, 31				# For bit shift						##
    sub $s2, $s2, 127										##
    sub $s5, $s5, 127										##
    												##
    # Prepare Mantissa for shifting based on exponent 						##
    MantissaHiddenBit:										##
    	# Add (Ox800000); the 1. to the mantissa to get 1.xxxx_xxxx . . . format		##
   	addi $s3, $s3, 0x00800000		# A						##
   	addi $s6, $s6, 0x00800000		# B						##
   												##
   												##
    ################## - PREPARE MANTISSA & EXPONENT - ###########################################

    ################## - GET SIGN BIT - ##########################################################
    move $t1, $a0				# Store A into $t1				##
    move $t2, $a1				# Store B into $t2				##
    												##
    bgt $t1, 0, checkBPos			# If A is positive, check if B is as well	##
    blt $t1, 0, checkBNeg			# If A is negative, check if B is as well	##
    li $t0, -1					# Used to onvert value				##
    												##
    checkBPos:											##
    	bgt $a1, 0, positiveSignBit		# If B positive too				##
    												##
    	move $t1, $a1				# Store value of $a1 to invert it		##
    	sub $t0, $zero, $t1			# Invert value of $t1				##
    												##
    	j InvertedB										##
    												##
    checkBNeg:											##
    	blt $a1, 0, negativeSignBit		# If B negative too				##
    												##
    	move $t1, $a0				# Store value of $a1 to invert it		##
    	sub $t0, $zero, $t1			# Invert value of $t1				##
    												##
    	j InvertedA										##
    												##
    positiveSignBit:				# If both are positive numbers			##
    	li $a0, 0x00000000									##
    	j MantissaShift										##
    												##
    negativeSignBit:				# If both are negative numbers 			##
    	li $a0, 0x00000001									##
    	j MantissaShift										##
    												##
    checkLargerVal:				# Determine larger val to get sign bit		##
    	InvertedA:										##
    		bgt $t1, $t2, negativeSignBit	# A < B						##
    		bgt $t2, $t1, positiveSignBit	# B < A						##
    												##
    	InvertedB:										##
    		bgt $t2, $t1, negativeSignBit	# B < A						##
    		bgt $t1, $t2, positiveSignBit	# A < B						##
    												##
    ################## - GET SIGN BIT - ##########################################################
 										
    ################## - MANTISSA SHIFT - ########################################################
    MantissaShift:										##
    												##
    #------------------> NEG/POS EXPONENT CHECK <-----------------------------------------------##
       												##
    # Check direction in which exponent should move						##		
    blt $s2, 0, B_Less0			# Check if A is negative				##
    j normalExpoHandle			# If both are not negative				##
    												##
    B_Less0:				# Check if B is negative				##	
    	blt $s5, 0, bothLess		# If both A and B are negative				##
    												##
    	j normalExpoHandle		# If both A and B are not negative			##
    												##
    #------------------> NEGATIVE EXPONENT <----------------------------------------------------##
    												##
    bothLess:				# If both A and B are negative exponents 		##
    	move $t8, $s2			# Move exponent for later use				##
    	move $t9, $s5			# Move exponent for later use				##
    	li $t6, -1										##
    												##
    	bgt $s5, $s2, A_LeadN		# If B must allign to A					##
    	bgt $s2, $s5, B_LeadN		# If A must allign to B					##
    												##
    	A_LeadN:										##
    		move $a3, $s2		# Set exponent value to that of A			##
    												##
    		mult $t6, $t9		# Invert exponent of B					##
    		mflo $t7		# Store inverted value					##
    												##
    		sub $t6, $t7, $t8	# Find the number of bits to move			##
    												##
    		sllv $s6, $s6, $t6	# Shift mantissa by n bits to the left			##
    												##	
    		srl $t3, $s6, 23	# Shift to get values before decimal place		##
    		sll $t4, $s6, 9		# Get values after decimal place			##
    		srl $t4, $t4, 9		# Shift back to origin					##
    		sll $s3, $s3, 9		# Get rid of hidden bit 				##
    		srl $s3, $s3, 9		# Shift back to origin					##
    												##
    		add $t4, $t4, $s3	# Add two mantissa values				##
    												##
    		j CheckPostDecimalValue								##	
    												##
    	B_LeadN:										##
    		move $a3, $s5		# Set exponent value to that of B			##
    												##
    		mult $t6, $t8		# Invert exponent of B					##
    		mflo $t7		# Store inverted value					##
    												##
    		sub $t6, $t7, $t9	# Find the number of bits to move			##
    												##
    		sllv $s3, $s3, $t6	# Shift mantissa by n bits to the left			##
    												##
    		srl $t3, $s3, 23	# Shift to get values before decimal place		##
    		sll $t4, $s3, 9		# Get values after decimal place			##
    		srl $t4, $t4, 9		# Shift back to origin					##
    		sll $s6, $s6, 9		# Get rid of hidden bit 				##
    		srl $s6, $s6, 9		# Shift back to origin					##
    												##
    		add $t4, $t4, $s6	# Add two mantissa values				##
    												##	
    		move $t9, $t4		# Store sum for later use				##
    												##
    		j CheckPostDecimalValue								##################
    														##
    	CheckPostDecimalValue:											##
    	    	move $t1, $t4					# To check if number of bits is 23 or 24	##
    														##
    		jal countNumOfBits				# Count number of bits				##
    														##
    		addi $t3, $t3, 1				# Add value of 1. 				##
    														##
    		beq $t0, 24, addToPreDec									##
    		j makeDecNormal											##
    														##
    		addToPreDec:											##
    			addi $t3, $t3, 1			# Add another 1					##
    														##
    			j makeDecNormal										##		
    														##
    	makeDecNormal:												##
    		move $s0, $t3					# Store value of $t3				##
    		li $t0, 0					# Initalize 0					##
    														##
    		newDecimal:											##
    			beq $t3, 0x00000001, makeDecNormalA	# Find where leading 1 is			##
    														##
    			srl $t3, $t3, 1				# Shift by 1 bit				##
    			addi $t0, $t0, 1			# Increment $t0					##
    														##
    			j newDecimal										##
    														##
    		makeDecNormalA:											##
    			subi $t0, $t0, 23									##
    														##
    			bgt $t0, 0, shift_Right									##
    			blt $t0, 0, shift_Left									##
    			beq $t0, 0, no_shift									##
    														##	
    			shift_Right:										##
    				srlv $s0, $s0, $t0		# Shift right to move hidden bit into position	##
    														##
    				j fillEmpty									##
    														##
    			shift_Left:										##
    				# Determine number of bits to shift						##
    				li $t6, -1									##
    				mult $t6, $t0									##
    				mflo $t0									##
    														##
    				sllv $s0, $s0, $t0		# Shift left to move hidden bit into position	##
    														##
    				j fillEmpty									##
    														##
    			no_shift:										##
    				j fillEmpty							##################
    												##
    	fillEmpty:										##
    		#j end										##
    												##
    #------------------> POSITIVE EXPONENT <----------------------------------------------------##
    												##
    # Determine how much mantissa must move by							##
    normalExpoHandle:										##
   	# Shift mantissa values of A, B to leftmost bit so there's room to allign by exponent	##
   	sll $s3, $s3, 8										##
   	sll $s6, $s6, 8										##
   												##
    	bgt $s2, $s5, A_Lead		# If B must allign to A					##
    	bgt $s5, $s2, B_Lead		# If A must allign to B					##
    												##
    	A_Lead:											##
    		move $a3, $s2		# Set exponent value to that of A			##
    												##
    		sub $t1, $s2, $s5	# Determine num of bits to shift B 			##
    		srlv $s6, $s6, $t1	# Shift B by n num of bits				##
    												##
    		j addMantissa									##
    												##
    	B_Lead:											##
    		move $a3, $s5		# Set exponent value to that of B			##
    												##
    		sub $t1, $s5, $s2	# Determine num of bits to shift A			##
    		srlv $s3, $s3, $t1	# Shift A by n num of bits				##
    												##
    		j addMantissa									##
    												##
    ################## - MANTISSA SHIFT - ########################################################
 
    ################## - ADD MANTISSA & CHECK OVERFLOW - #################################################
    													##
    # Add mantissas 											##
    addMantissa:											##
    	srl $s3, $s3, 8			# Shift back to original location				##
    	srl $s6, $s6, 8			# Shift back to original location				##
    													##
    	add $t1, $s3, $s6		# Add both mantissas						##
													##
    # Check if there may be some overflow and if so add to exponent 					##
    overflowCheck:											##
    move $a1, $t1											##
    li $t0, 0				# Initialize counter						##
    													##
    jal countNumOfBits											##
    													##
    roundOrNot:												##
    	beq $t0, 24, doNotAddExpo	# If A and B are added w/no overflow, there should be 24 bits	##
    	bgt $t0, 24, doAddExpo		# If A and B are added w/overflow, there should be 25 bits	##
    													##
    	doNotAddExpo:											##
    		j normalize										##
    													##	
    	doAddExpo:											##
    		addi $a3, $a3, 1	# Increase exponent value by 1					##
    													##
    		move $t1, $a1		# Store value of $a1 into $t1					##
    													##
    		# Shift register over 31 bits to see if the sum needs to be rounded or not		##
    		sll $t1, $t1, 31									##
    													##
    		beq $t1, 0x80000000, roundMantissa	# If the last digit is 1, round mantissa value	##
    		j make24bit										##
    													##
    		roundMantissa:										##
    			move $t1, $a1	# To be able to thread through function again			##
    													##
    			sll $t1, $t1, 1		# Remove 25th bit					##
    			addi $t1, $t1, 1	# Add 1 to round up					##
    													##
    			j overflowCheck									##
    													##
    		make24bit:										##
    			srl $t0, $t0, 1	       # Shift register right by 1 bit to go back to 24 bit val	##
    													##
    			j normalize									##
													##
    ################## - ADD MANTISSA & CHECK OVERFLOW - #################################################
    
normalize:
addi $a3, $a3, 127				# Add exponent bias

jal NormalizeFloat

	#lw $ra, ($sp)
	#addi $sp, $sp, 4
	
	#jr $ra

end:	############## Skip over code block

jr $ra							 

# ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< MULT FLOATS ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< #
MultFloats:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	jal clearRegisters
	
	move $t4, $a0			# Store value of A ($a0) into $t4			
	move $t5, $a1			# Store value of B ($a1) into $t5	
	
	jal CollectData			# Will collect all needed information from A and B
	
    ####### - SIGN BIT - #########################################################################################	
	# Check if both A and B have the same sign								##
	# If yes, sign is positive 										##
	# If no, sign is negative										##
														##
	CheckIfSameSigns:											##
		beq $s1, $s4, SameSign			# If same sign						##
		j NotSameSign				# If not the same sign					##
														##
	# If both A and B have the same sign									##
	SameSign:												##
		li $a0, 0											##
		b multMantissa				# Jump to mantissa multiplication			##
														##
	# In both A and B don't have the same sign								##
	NotSameSign:												##
		li $a0, 1											##
		b multMantissa				# Jump to mantissa multiplication			##
														##
	#########################################################################################		##
	# EXPLANATION: In this situation, if A were to be multiplied by B we would need to see	#		##
	# 	what the output value is to determine the sign. But since we are multiplying	#		##
	#	we follow sign rules. A*B = (+), (-A)*(-B) = (+), (-A)*B = (-), A*(-B) = (-)	#		##
    ####### - SIGN BIT - #########################################################################################
    
    ####### - MANTISSA MULTIPLICATION - ##########################################################
    	# Multiply both mantissa values and store into #$a1 and $a2				##
    	multMantissa:										##
    												##
    		move $s0, $s3			# To count number of bits after decimal		##
    		move $s1, $s6			# To count number of bits after decimal		##
    												##
		addi $s0, $s0, 0x00800000	# Add HB 1.xxxxx . . . 				##
		addi $s1, $s1, 0x00800000	# Add HB 1.xxxxx . . . 				##
												##
		move $t2, $s0			# To check number of decimal places		##
		move $t3, $s1			# To check number of decimal places		##
												##
		# Multiply mantissas								##
		mult $s1, $s0									##
												##
		# Store mantissa values into two registers since there is possible overflow	##
		mfhi $a1									##
		mflo $a2									##
												##
    ####### - MANTISSA MULTIPLICATION - ##########################################################
    
    ####### - DECIMAL POINT LOCATION - ########################################### 
    	li $t0, -18				# Initialize counter		##
    										##
    	checkADecimal:								##
    		beq $t2, 0x00000000, checkBDecimal				##			
    										##
    		sll $t2, $t2, 1			# Shift A over by 1 bit		##
    		addi $t0, $t0, 1		# Decrement counter		##
    										##
    		j checkADecimal							##
    										##
    	checkBDecimal:								##
    		beq $t3, 0x00000000, getDecimalLocation				##
    										##
    		sll $t3, $t3, 1			# Shift B over by 1 bit		##
    		addi $t0, $t0, 1		# Decrement counter		##
    										##
    		j checkADecimal							##
    										##
    	getDecimalLocation:							##
    	# Branch condition on when yes and no					##
    	beq $t0, 45, sumExp			# Rounding exception		##
    	beq $t0, 44, sumExp			# Rounding exception		##
    	beq $t0, 43, sumExp			# Rounding exception		##
    										##
    	j CFERE									##
    										##
    ####### - DECIMAL POINT LOCATION - ########################################### 
        										
    ####### - CHECK FOR EXPONENT ROUND EFFECT  - #################################################
    CFERE:											##
    	# Check if the multiplication resulted in needing to increase exponent 			##
    	move $t6, $a1				# To find decimal location			##
    	move $t7, $a2				# To find decimal location			##
    												##
    	# Shift bits of $a2									##
    	a2Shift:										##
    		beq $t7, 0x00000000, a1Shift							##	
    												##
    		sll $t7, $t7, 4									##
    		subi $t0, $t0, 4								##
    												##
    		j a2Shift									##
    												##
    	# Shift bits of $a1 to isolate hidden leading bits					##
    	a1Shift:										##
    		srlv $t6, $t6, $t0								##
												##
    	# Check if exponent should be increased							##
    	bgt $t6, 0x00000001, increaseExponentValue						##
    	j sumExp										##
    												##
    	increaseExponentValue:									##
    	addi $a3, $a3, 1		# Increase exponent value				##
    												##
    	move $t6, $a1			# To get value to move to $a2				##
    												##
    	sll $t6, $t6, 31		# Get bit to add to $a2					##
    	srl $a1, $a1, 1			# Remove bit that will be moving to $a2			##
    	srl $a2, $a2, 1			# Shift $a2 over one bit to make room for incoming bit	##
    	add $a2, $a2, $t6		# Add bit to $a2					##
    												##
    	j sumExp										##
    												##
    ####### - CHECK FOR EXPONENT ROUND EFFECT  - #################################################
    
    ####### - GET EXPONENT VALUE - ###############################
    	# Get value of exponent 				##
    	sumExp:							##
    								##
    	# Remove bias from exponents 				##
    								##
    	# Add the exponent values of A and B 			##			
    	add $a3, $a3, $s2					##
    	add $a3, $a3, $s5					##
    								##
    	# Remove a bias of 127*2 since bias for both A and B	##
    	subi $a3, $a3, 127					##
    								##
    ####### - GET EXPONENT VALUE - ###############################
    
jal NormalizeFloat

jal clearRegisters

	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra

# ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< NORMALIZE FLOATS ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< #
NormalizeFloat:
	
	li $t0, 0
	li $t1, 32
	
    ####### - PREPARE $a1 AND $a2 FOR NORMALIZATION - ############################################################
	# Shift register $a1 to the left till it is left alligned to get in form of 01xxxxxx			##
	ShiftA1:												##
		bge $a1, 0x01000000, fillRegister	# Branch when left alligned (Checks if $a1 > 01000000)	##
														##
		sll $a1, $a1, 1				# Shift 1 bit left 					##
														##
		subi $t1, $t1, 1		# For seeing how many bits to shift				##
		addi $t0, $t0, 1		# For seeing how many bits to shift				##
														##
		j ShiftA1											##
														##
	fillRegister:												##
		move $t8, $a2			# For moving around $a2 register				##
														##
		srlv $t8, $t8, $t1		# Shift $t8 to get the value we want to add to register		##
														##
		add $a1, $a1, $t8		# Add to register						##
														##
    ####### - PREPARE $a1 AND $a2 FOR NORMALIZATION - ############################################################

    ####### - CHECK FOR ROUNDING - #######################################################################################
	checkForRound:													##		
		# Check if we need to round value 									##
															##
		sll $t8, $a1, 31			# Shift currently 25 bit $a1 to get 25th bit to check for round	##
															##
		beq $t8, 0x80000000, round_value	# If sign bit is 1						##
		beq $t8, 0x00000000, noround_value	# If sign bit is 0						##
															##
		# If the value must be rounded										##
		round_value:												##
			# Shift $a1 right 1 bit to get rid of rounding bit						##
			srl $a1, $a1, 1											##
															##
			addi $a1, $a1, 0x00000001		# Add 1 to register to round up				##
															##
			sll $a1, $a1, 9				# Get rid of hidden bit					##
															##
			srl $a1, $a1, 9 			# Return to normal					##
															##								##
				j normalizeFloatValue									##
															##								##
		noround_value:												##
			# Shift $a1 to get rid of leading 1 and sign bit						##
			sll $a1, $a1, 8			# Remove hidden bit						##
			srl $a1, $a1, 9											##
			j normalizeFloatValue										##
															##
    ####### - CHECK FOR ROUNDING - #######################################################################################
    
    ####### - NORMALIZE VALUES - #################################
	normalizeFloatValue:					##
								##
		# Move sign to $s0				##
		move $s0, $a0					##
								##
		# Shift sign over 8 bits to add exponent 	##
		sll $s0, $s0, 8					##
								##
		# Add exponent 					##
		add $s0, $s0, $a3				##
								##
		# Shift $s0 left to made room for mantissa	##
		sll $s0, $s0, 23				##
								##
		# Add mantissa 					##
		add $s0, $s0, $a1				##
								##
    ####### - NORMALIZE VALUES - #################################
    
    ####### - STORE TO $v0 - #############
	moveMultValue:			##		
		move $v0, $s0		##
					##
    ####### - STORE TO $v0 - #############		
												
j back	

# ========================================================================================================================================================================= #		
# ---------------------------------------------------------------------------- Function Calls ----------------------------------------------------------------------------- #
# ========================================================================================================================================================================= #

### - EXPONENT LOOP - ####################################################################
findExponentVal:					      ## Find exponential value ##			
							      ############################		
# $t0 - stores the value of 2^n								##
# $t1 - the 2 that $t0 is multiplied by							##
# $t8 - n value										##
											##
# While $t8 is != 0, perform exponent function. Multiply $t0 by $t1 (2) and store 	##
# value into $t0. Decrement $t8 by 1 and loop again.					##
											##
move $t8, $t2	# 6 is just a value for now, can be replaced with appropriate value	##
li $t0, 1   										##
li $t1, 2										##
											##
	expLoop: # OUTPUT VALUE - $t0							##
		beqz $t8, back	# Set branch condition					##
											##
		mult $t0, $t1								##
		mflo $t0								##
											##
		subi $t8, $t8, 1	# Increment loop count				##
		j expLoop		# Jump back					##
											##
#### - CONVERT TO BINARY + OUTPUT - ######################################################################
conversion:									   ## Convert to binary	##
										   #######################			
# $t0 - Exponential value of 2 (2^n)									##
# $t2 - Loop counter used to determine if number to be convered has been fully done so			##
# $t8 - Stores bit value (1 or 0) to be output								##
# $t9 -	Value to be divided; will be decremnted by number removed within code				##										
													##
# Conversion will take a value ($t9) and divide it by an exponential value of 2 ($t0)			##
# If divisible, it will output 1, if not then 0. Loop will continue till number is converted to binary	##
													##
	div $t9, $t0		# Divides value to be converted by exponential value (128, 64 ...)	##			
													##				
	mflo $t8		# Store value (1 or 0) into $t8						##			
	mfhi $t9		# $t9 now equals value post division					##			
													##				
	# Print binary digit 										##			
	printValue ($t8) 										##			
													##				
	beqz $t2, location	# Set loop condition							##			
	subi $t2, $t2, 1	# Subtract counter by 1							##
													##
	j back												##
													##
### - LOCATION POINTER - #################################################################################
location: 						## Location points in code ##
		      					#############################		     
	beq $t7, 1, loc1a	# After SIGN		    			   ##
	beq $t7, 2, loc1b	# After EXPONENT				   ##
	beq $t7, 3, loc1c	# AFTER MANTISSA				   ##
										   ##
										   ##
###################### - FP VALUE COLLECTION + STORAGE - #########################################
CollectData:											##
	move $t4, $a0			# Store value of A ($a0) into $t4			##
	move $t5, $a1			# Store value of B ($a1) into $t5			##
	li $t9, 8388608										##
												##
	# Sign 											##
	srl $s1, $t4, 31		# Shift reg left 31 bits to get sign			##
	#move $t1, $s1										##
	srl $s4, $t5, 31		# Shift reg left 31 bits to get sign			##
												##
	# Exponent 										##
	sll $s2, $t4, 1			# Shift reg left 1 bit to remove sign			##	
	srl $s2, $s2, 24		# Shift reg right 24 bits to isolate Exponent		##
	#move $t6, $s2										##
												##
	sll $s5, $t5, 1			# Shift reg left 1 bit to remove sign			##	
	srl $s5, $s5, 24		# Shift reg right 24 bits to isolate Exponent		##
	#move $t9, $s5										##
												##
	# Mantissa										##
	sll $s3, $t4, 9			# Shift reg left 9 bit to remove sign + exponent	##				
	srl $s3, $s3, 9			# Shift reg right 9 bits to isolate mantissa		##
	#move $t5, $s3										##
												##
	sll $s6, $t5, 9			# Shift reg left 9 bit to remove sign + exponent	##				
	srl $s6, $s6, 9			# Shift reg right 9 bits to isolate mantissa		##
	move $t3, $s6										##
												##
												##
	j back											##
												##
#### - BACK- #####################################################################################
countNumOfBits:					       # Count num of bits in x ##
						       ###########################
	beq $t1, 0x00000000, back	# Set loop exit condition		##
    										##
    	srl $t1, $t1, 1			# Shift register right by 1 bit		##
    	addi $t0, $t0, 1		# Increment counter by 1		##
    										##
    	j countNumOfBits							##
    										##
##################################################################################
        back:	       ## Jump back to location ##
		       ###########################
	jr $ra					##
						##
### - CLEAR REGISTERS - ##########################	
clearRegisters:		## Clear all registers	##
			##########################
						##
	# Clear s registers			##
	add $s0, $0, $0				##
	add $s1, $0, $0				##
	add $s2, $0, $0				##
	add $s3, $0, $0				##
	add $s4, $0, $0				##
	add $s5, $0, $0				##
	add $s6, $0, $0				##
	add $s7, $0, $0				##
						##
	# Clear t registers			##
	add $t0, $0, $0				##		
	add $t1, $0, $0				##
	add $t2, $0, $0				##
	add $t3, $0, $0				##
	add $t4, $0, $0				##
	add $t5, $0, $0				##
	add $t6, $0, $0				##
	add $t7, $0, $0				##
	add $t8, $0, $0				##
	add $t9, $0, $0				##
						##
	j back					##
						##
### - BACK TO MAIN PROGRAM - #####################
backToMain:	      ## Jump to master program ##
		      ############################
	lw $ra, ($sp)				##	
	jr $ra					##
##################################################









