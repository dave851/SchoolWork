/**
 * Registrar.java
 *
 * File:
 *	$Id: Registrar.java,v 1.4 2013/09/21 17:07:39 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Registrar.java,v $
 *	Revision 1.4  2013/09/21 17:07:39  drd3073
 *	Added all documentaion and overrides
 *
 *	Revision 1.3  2013/09/21 05:08:34  drd3073
 *	Student Written, compiles, no clear errors.
 *
 *	Revision 1.2  2013/09/21 05:05:39  drd3073
 *	Registrar now compiles. Changed gpa storage to double.
 *
 *	Revision 1.1  2013/09/21 05:03:07  drd3073
 *	First draft, does not currently compile. All Files in place for part 1
 *
 *
 * @author Dave
 */
import java.util.Scanner;

public class Registrar {
	
	
	/**
	 * Provides prompts in the console of the options you have
	 * and will gather all necessary information. 
	 * 
	 * Note:
	 * Does not actually contain the data structure, must have object 
	 * implementing ProrityQueue interface.
	 * 
	 */
	public static void main(String[] args) {
		PriorityQueue<Student> line = new LinkedQueue<Student>();
		Scanner scan = new Scanner(System.in);
		boolean NotDone = true;
		while(NotDone){
			System.out.println("Enter an option");
			System.out.println("1 to Add student to the queue");
			System.out.println("2 to Remove and print the first student");
			System.out.println("3 to quit");
			System.out.print("Your choice: ");
			int choice = scan.nextInt();
			if(choice == 1){
				String Name = "";
				int Year = 0;
				double GPA = 0;
				System.out.print("Student name: ");
				Name = scan.next();
				System.out.print("Year: ");
				Year = scan.nextInt();
				System.out.print("GPA: ");
				GPA = scan.nextDouble();
				Student student = new Student(Name, Year, GPA);
				line.insert(student);
			}
			else if(choice == 2){
				if(line.isEmpty()){
					System.out.println("Queue is empty.");
				}
				else{
					Student top = line.dequeue();
					System.out.println("Regerestering "+top.toString());
				}
			}
			else if(choice == 3){
				NotDone = false;
			}
			else{
				System.out.println("Not a valid Choice");
			}
		}
		scan.close();
	}
}