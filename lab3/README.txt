--------------------------------
LAB 3: LOGIC UNIT WITH MEMORY
CMPE 012 Spring 2018

Ashwin Chidambaram, 1513761
Section 01D, Rebecca
--------------------------------


----------------
LEARNING

<<Describe what you learned, what was surprising, what worked well and what did not.>>

In this lab I learned a lot about how multiplexers(MUX) works as well as the internal
workings of a MUX unit. Prior to knowing about the MUX, we did work using logic gate
block logic using AND and OR gates as well as variations using them such as INVERTs,
NAND, etc. And while all that is useful, when needing to pick between function performance 
the number of gates used to create a selector as well as keeping track of the various 
inputs and outputs can become very difficult. However, using a MUX can vastly simplify that 
process because it packages the logic into an easy to use block. While trying to learn about
the MUX, I also learned a bit about decoders and how they function too. During the actual
process of building this lab, I had various run ins but that was mainly due to the way I 
went about trying to solve the problem posed (which I will elaborate on in the Issues section
of this README).

----------------
ISSUES

<<Discuss issues you had building the circuit.>>

While attempting to build this circuit, I managed to build the individual portions required 
but the issue I ran into repeatedly was how to properly use the MUX. After doing multiple 
readings on the MUX I managed to comprehend its uses and how it worked, but I still couldn't
manage to see how it fit with all the pieces I had. The biggest problem, however, was that 
I maintained a fixed way of thinking and tried to make it work the wrong way pretty much 
for the first few days after the lab was assigned. The way I had approached the problem was 
assuming that the MUX would be taking the input directly from the Keypad as well as the register
and from there each output lead would connect to one of the logical functions that we needed
to perform and from there be output. And looking back on the way I was thinking of it knowing
what I know now, I don't really understand how I maintained that idea and tried to make it work.
But after pondering how each logical operation could fit together, I realized that the way I was 
thinking about the problem was in a one dimensional way of visualizing only one gate pair for
the AND and OR functions, and when I realized I'd have 4 pairs per function and a total of 4x4 
MUX inputs, it clicked and I was able to rebuild my original schematic according to the 
new idea and logically it checked out. While actually building it in MML, I accidentally made a 
mistake (or so I assume) where a logical error arose in the register that caused the program to
crash. But after rebuilding the circuit using MUX blocks instead of the gates that create the MUX
I was able to debug efficiently and create the circuit. Once that was done, I went back and created 
a truth table for the MUX and rebuilt the gates accordingly and I believe that the Lab3.lgi file I 
submitted should be correct and perform correctly.

----------------
DEBUGGING

<<Describe what you added to each module to make debugging easier.>>

I mainly added lights to all the logical operations to ensure that it was receiving an input and
for the MUX, I used the actual MUX block to check if my logic was functioning correctly as 
mentioned above. Once I was able to test whether the whole circuit worked, I removed the debug 
aspects of my circuit and rebuilt the MUX stand in block with its equivalent gates.

----------------
QUESTIONS

<<What is the difference between a bit-wise and reduction logic operation?>>

A bitwise logic operand takes either two bits or two other operand values and 
performs the respective operation and outputs a single bit result. Here we 
check the actual values of the inputs and compare them. A reduction logic operation, 
however, is based around the idea of taking a multiple bit input and and perform
bit-wise operations on each bit then output a single bit. In this lab, the MUX 
was used to perform a reduction logic operation because it was selecting a certain
function to be performed and the actual functions being performed were bit-wise 
operations.

<<What operations did we implement?>>

- Bit-Wise AND
- Bit-Wise OR
- Logical INVERT

<<Why might we want to use the other type of logic operations?>>

By using other logic operations, we could simplify the way that the overall logic could function. If 
we used more than just the normal AND, OR, and INVERT gates we have a larger variety of ways to 
effectively create a solution to this problem. And in a broader sense, by using these logic
operations, we could perform harder logical functions but with less confusion and clutter overall. 

