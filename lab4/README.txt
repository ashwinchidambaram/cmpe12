--------------------------------
LAB 4: FEEDBABE IN MIPS
CMPE 12 Spring 2018

Name: Ashwin Chidambaram
CruzID : 1513761
Section - 01D
Rebecca
--------------------------------


----------------
LEARNING

While trying to create the assembly code for this lab, I ran into issues of first not being able 
to comprehend the syntax used for it as well as what different registers did and the lack of 
general syntax I would take for granted in a higher level language like Java or C++. However, 
after working with MIPS and practicing writing different assembly code I managed to get better 
grasp of how to use the registers to perform functions I wanted it to. 

What surprised me most is the way that .data is used to define the variables used within the main 
part of the code, and the way .text is used to define the instructions of the program itself. 
It was also interesting the way an if loop is made in assembly code by setting a condition then 
referring to a call not within the actual if statement. 

After working through this assembly code, I found that by building it by part by part, it was 
much easier to create a solution as a whole. I went through it by first building a part for 
querying from the user for the value N, then debating on what type of loop to create and how I 
would go about doing so. Eventually I decided a while loop would be an easy counter to implement, 
then I built and tested it to make sure it would iterate 1 through N. After successfully 
implementing that, I tested division and how best to get the remainder when divided by 3, 4, 
or 12 and doing the assembly language version of a modulus function. While trying to learn 
assembly language, I found out that the hi and lo registers can be used to store a remainder when 
a number is divided and so I utilized that to see if I could use that and it was possible. Once 
I had the different parts built upon each other, I went back and removed some testing scripts I 
had and fine tuned some issues I was having with printing.


----------------
ANSWERS TO QUESTIONS

1. In theory, N should be able to store a value of up to 4,294,967,296 (2^32) before the 
program fails. My reasoning behind this, is that in MIPS32, each register is 32 bit and 
the highest value for a 32 bit number is 2^32. The limit, in this case, is determined by 
the size of the register in which N is stored ($v0). 

2. The range of addresses used to store "Please input a number: " in my code ranges 
from 0x10010000 to 0x10010013. 

3. The pseudo-ops that I used in my assembly code were li, la, bgt, beqz, and bne. They 
assembled instructions manage to produce the correct results because the pseudo ops we 
used essentially translate from our easy use into easy use for the computer. For example, 
if I had decided to use rem instead of mfhi in my assembly code, rem would've translated 
to div x, y and mfhi z. Similarly, each one of the pseudo-ops I used have their own 
translations which break it down for the computer to understand what it is being asked to do.

4. In my assembly code, I used a total of 12 registers, however, 3 of which were special 
registers. I feel like I could not have used fewer registers than I have. During my first 
attempt at creating the assembly code for this assignment I divided N by 3, 4, and then 12. 
Each one of the division processes took 1 register and excluding the 5 registers shared 
between each process. However, I removed the process for dividing by 12 and instead just 
removed the new line I added after FEED and BABE. This meant that if N was divisible by 3 
it would output FEED and if by 4, then it would output BABE right after the previous FEED.