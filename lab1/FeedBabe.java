// Name: Ashwin Chidambaram 
// Cruz ID: 1513761
// 04/05/18
// CMPE 16

public class FeedBabe {
    public static void main(String args[]) {
        //Variables 
        int modThree; //Stores mod value of i by 3
        int modFour; //Stores mod value of i by 4
        
        //Value check
        for (int i = 1; i <= 500; i++) {
            //Perform mod on i
            modThree = i % 3;
            modFour = i % 4;
            
            //when 3 true; 4 true
            if (modThree == 0 && modFour == 0) {
                System.out.println("FEEDBABE");
            }
            
            //when 3 true; 4 false
            else if (modThree == 0 && modFour != 0) {
                System.out.println("FEED");
            }
            
            //when 3 false; 4 true
            else if (modThree != 0 && modFour == 0) {
                System.out.println("BABE");
            }
            
            //when 3 false; 4 false
            else if (modThree != 0 && modFour != 0) {
                System.out.println(i);
            }
        }
    } 
} //FeedBabe()

