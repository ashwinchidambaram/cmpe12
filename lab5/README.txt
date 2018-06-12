--------------------------------
LAB 5: HEX TO DECIMAL CONVERSION
CMPE 12 Spring 2018

Name: Ashwin Chidambaram
CruzID : 1513761
Section - 01D
Rebecca
--------------------------------


----------------
LEARNING

While doing this lab, I better learned how the computer stores the data it has and the data 
it receives as an input and what it interprets it as. I also learned how to use an array in 
MIPS as well as iterating through to both store and read it. To me, it was surprising to 
learn that a computer would be able to interpret a value stored within itself as any base
number. For example, in this lab we were asked to store a value into register $s0, but when I 
first went about tackling the problem, I attempted to simply convert the entire input to 
binary and store that value, however, after speaking with a TA they helped me understand that 
the value would still be the same to a computer regardless. 

Overall, understanding how to perform the task asked by this lab was the hard part. However, 
after breaking the lab into parts I would like to accomplish as well as how I would like to
accomplish them, I just built each part and made them function together as a whole. What did 
not work well for me was understanding how to implement an array, but after several practice
tests I did with arrays, I managed to roughly grasp its functionality and managed to
implement it. As for what worked well, being able to modularize the entire program helped me 
tremendously since it allowed me to keep my code clean as well as a workspace uncluttered. My 
biggest problem was that I did not want to accidentally modify a part of my assembly code that 
I did not intend to change, and by doing this, I did not run into that problem.


----------------
ANSWERS TO QUESTIONS

1.
<<Insert your answer>>

2. The largest input value that this program can take is 0x7FFFFFFF.

3. The smallest input value that this program can take is 0x90000000. 

4. The main difference between unsigned and signed arithmetic in MIPS is that any 
unsigned arithmetic does not have the ability to represent negative values. I used
signed arithmetic since we need to be able to represent negative values in our assembly 
code. The advantage of doing this means that it could deal with overflow as well as perform
negative value calculations. 

5. If we had to take in an ascii binary input and output its decimal value, I would go about 
doing it in the following way.
		a) Take in ascii input
		b) Iterate through the array to see how many digits there are
		c) Create a self-modifying loop that will grow to expand to fill the digits
		d) Multiply 2^n with 1 or 0 and sum it to a register that will just grow
		e) Output value
