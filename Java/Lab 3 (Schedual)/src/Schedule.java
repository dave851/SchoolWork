/**
 * Schedule.java
 *
 * File:
 *	$Id: Schedule.java,v 1.4 2013/09/18 01:37:03 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Schedule.java,v $
 *	Revision 1.4  2013/09/18 01:37:03  drd3073
 *	Descriptions of functions added, code-style fixes
 *
 *	Revision 1.3  2013/09/17 22:33:09  drd3073
 *	PrettyPrint written, fixed can not find filename bug, Passes initial tests
 *
 *	Revision 1.2  2013/09/15 16:06:27  drd3073
 *	Added classes file, work in progress, does not currently compile
 *
 *	Revision 1.1  2013/09/14 14:38:23  drd3073
 *	All Files created / downloaded, all methods stubbed.
 *
 *
 *Schedule is a class that holds a list of courses and can add 
 *courses as well as print the current schedule in a end-user
 *friendly manner
 *
 * @author Dave
 */
import java.util.ArrayList;

public class Schedule {
	
	private ArrayList<Course> Courses;
	
	/**
	 * Constructor, initializes data structures
	 */
	public Schedule(){
		Courses = new ArrayList<Course>();
	}
	
	
	/**
	 * Function to add a course to schedule
	 * will not add if it is conflicting with 
	 * previous course
	 * 
	 * @param args
	 * c - Course to add
	 * 
	 * Returns:
	 * Whether the course was successfully added
	 */
	public boolean add(Course c){
		for(Course t : Courses){
			if(t.inConflict(c)){
				return false;
			}
		}
		Courses.add(c);
		return true;
	}
	
	
	/**
	 * Test whether a course is in schedule already
	 * 
	 * @param
	 * c - Course to look for
	 * 
	 * Returns:
	 * True if the course is on the schedule.
	 */
	public boolean contains(Course c){
		for(Course t : Courses){
			if(t.equals(c)){
				return true;
			}	
		}
		return false;
	}
	
	
	/**
	 * Prints schedule in a day-by-day format
	 * for easy reading. 
	 *  
	 */
	public void prettyPrint(){
		System.out.println("----Monday----");
			for(Course c : Courses){
				if(c.inDay(0) != ""){
					System.out.println(c.inDay(0));
				}
			}
		
		System.out.println("----Tuesday----");	
			for(Course c : Courses){
				if(c.inDay(1) != ""){
					System.out.println(c.inDay(1));
				}
			}
		
		System.out.println("----Wednesday----");
			for(Course c : Courses){
				if(c.inDay(2) != ""){
					System.out.println(c.inDay(2));
				}
			}
		
		System.out.println("----Thursday----");
			for(Course c : Courses){
				if(c.inDay(3) != ""){
					System.out.println(c.inDay(3));
				}
			}
		
		System.out.println("----Friday----");
		for(Course c : Courses){
				if(c.inDay(4) != ""){
					System.out.println(c.inDay(4));
				}
			}
	}
	
	
	/**
	 * Used to check how many courses are in the schedule
	 * Overrides default toString function
	 */
	public String toString(){
		return "Schedule with "+Courses.size()+" courses";
	}
}
