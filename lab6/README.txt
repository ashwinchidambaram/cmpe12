--------------------------------
LAB 6: FLOATING POINT MATH
CMPE 12 Spring 2018

Name: Ashwin Chidambaram
CruzID : 1513761
Section - 01D
Rebecca
--------------------------------


----------------
LEARNING

During this lab, I learned a lot about how to work with floating point values as well as how they 
functioned. While trying to create the Add and Mult functions, I got lots of practice on adding and 
multiplying floating point values and seeing how even the smallest bit could drastically alter the 
value of a floating point result. Another thing I noticed was that rounding errors that occurred during 
the function of the code could add up and throw the value of the result ever so slightly off. To me that 
was surprising since I did not know that rounding errors could occur and that led me to further investigate 
how floating point numbers are generally handled. And from what I saw, generally these values are truncated 
to preserve the value and be rid of rounding error. A skill that I feel as though I gained from this lab is 
how to efficiently debug my code and to encapsulate segments of my code to make sure that I didn't 
accidentally alter a part that was working fine.  


----------------
ANSWERS TO QUESTIONS

1.
I wrote test code mainly for testing overall function of my program. I made 5 different .asm files that
composed of one function each and would function individually. Once I tested it to make sure it worked, 
I would implement in the main file and then test from there to make sure it correctly functioned. For 
the rest of my program I instead performed periodic tests after every few functions to make sure the 
values that should be stored within certain functions were actually stored correctly. I also did my own 
math on the side to check values side by side and see if an idea that I would like to implement would 
actually work.

2.
Floating point overflow is when a value that is being stored as a floating point number, can not be fully
represented within the allocated space given. An example of this would be:

1.000 1010 1010 0011 1100 0101 | 1110 100

The values to the left of '|' is overflow bits. Generally these can be rounded based on the first overflow 
bit. 1 = round, 0 = no round

3.
I did have issues with rounding within my assembly code. To overcome this issue, I isolated the first 
overflow bit and checked if the value of it was 1 or 0. In the situation it was 1, I would add 1 to the 
mantissa to round up. In the situation the overflow bit was 0, I did nothing.

4.
I wrote several smaller functions in my assembly code listed below:

- CollectData: Used to collect information about A and B and separate both into its sign bit, exponent, and 
	mantissa
- findExponentVal: A function used to find the value of 2^n
- conversion: A function used to convert a decimal/hex value into binary
- location: A pointer function used to navigate inside my PrintFloat function 
- back: A function used to return to last location (from any jal)
- clearRegisters: clear S and T registers

In addition to this, there were several branch functions embedded within places of my code that performed 
tasks specific to the parent function.
