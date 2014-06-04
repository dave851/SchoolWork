/**
 * Filename: Student.java
 *
 * File:
 *	$Id: Student.java,v 1.4 2013/09/21 17:07:39 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Student.java,v $
 *	Revision 1.4  2013/09/21 17:07:39  drd3073
 *	Added all documentaion and overrides
 *
 *	Revision 1.3  2013/09/21 05:35:37  drd3073
 *	LinkedQueue Started, insert needs work, will not insert unless list is emty
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
 * @author Dave
 */

public class Student implements Prioritizable {
	
	private String name;
	private int year;
	private double gpa;
	
	
	/**
	 * Constructor for the class. Sets all required variables. 
	 * 
	 * @param n - Name of student
	 * @param y - year of student
	 * @param g - Gpa of student
	 */
	public Student(String n, int y, double g){
		name = n;
		year = y;
		gpa = g;

	}
	
	/**
	 * Gets Gpa of object
	 * 
	 * @return Double, GPA of student
	 */
	public double getgpa(){
		return gpa;
	}
	
	/**
	 * Gets Year of student
	 * 
	 * @return year - Int representing year of student
	 */
	public int getyear(){
		return year;
	}
	
	/**
	 * Gets name of student
	 * 
	 * @return String name
	 */
	public String getname(){
		return name;
	}
	
	/**
	 * Determines the priority of the student, high priority students
	 * register first
	 * 
	 * @return Double priority
	 */
	public double getPriority(){		
		return year+(gpa/10);
	}
	
	/**Overrides defaults toString
	 * 
	 * Prints out a string representation of the student.
	 * 
	 * @return String in format "<Student name> in year <student year> 
	 *                             with GPA <student gpa>"
	 */
	@Override
	public String toString(){
		return name+" in year "+year+" with GPA "+gpa;
	}

}
