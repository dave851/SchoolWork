/**
 * Course.java
 *
 * File:
 *	$Id: Course.java,v 1.4 2013/09/18 01:37:03 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Course.java,v $
 *	Revision 1.4  2013/09/18 01:37:03  drd3073
 *	Descriptions of functions added, code-style fixes
 *
 *	Revision 1.3  2013/09/17 22:33:10  drd3073
 *	PrettyPrint written, fixed can not find filename bug, Passes initial tests
 *
 *	Revision 1.2  2013/09/15 16:06:27  drd3073
 *	Added classes file, work in progress, does not currently compile
 *
 *	Revision 1.1  2013/09/14 14:38:24  drd3073
 *	All Files created / downloaded, all methods stubbed.
 *
 *Courses is a class to hold information about a course
 *such as calculus, also provides useful functions
 *to interact with each other or display information 
 *about the course. 
 *
 * @author Dave
 */
import java.util.ArrayList;

public class Course {

	public static final String dayString = "MTWRF";
	private String name;
	private ArrayList<Boolean> days;
	private int start;
	private int end;
	
	
	/**
	 * Constructor for a Course object. Initializes and
	 * sets main variables. 
	 * 
	 * @param 
	 * n - Name of the course
	 * days - List of days that the course is held on
	 * startT - Starting time (in hours, 24-hour clock)
	 * endT - Ending time (in hours, 24-hour clock)
	 */
	public Course(String n, ArrayList<Boolean> daysBool, int startT, int endT){
		name = n;
		days = daysBool;
		start = startT;
		end = endT;	
	}
	
	
	/**
	 * Function to tell if two course objects are the
	 * same course. Overrides default equals. 
	 * 
	 * @param
	 * other - Object to be tested against
	 * 
	 * Returns:
	 * True if the object passed in is a Course with the same name, days, 
	 * start and end time as this Course
	 */
	public boolean equals(Object other){
		Course o = (Course) other;
		if(name.equals(o.name)){
			if(days.equals(o.days)){
				if(start == o.start){
					if(end == o.end){
						return true;
					}
				}
			}
		}
		return false;
	}
	
	
	/**
	 * Determines if two courses overlap on any day
	 * 
	 * @param 
	 * other - Course to test against
	 * 
	 * Returns:
	 * True if the passed-in Course overlaps in time (on any day) with this Course.
	 */
	public boolean inConflict(Course other){
		if(this.equals(other)){
			return true;
		}
		for(int i=0; i < 5; i++ ){
			if(days.get(i).equals(other.days.get(i))){
				if((start > other.start) && (start < other.end)){
					return true;
				}
				if((end < other.end) && (end > other.start)){
					return true;
				}
			}	
		}
		return false;
	}
	
	
	/**
	 * String representation of course.
	 * Overrides standard toString
	 * 
	 * @param
	 * Returns:
	 * String representation
	 *  
	 */
	public String toString(){
		String line = name+": ";
		for(int i=0; i < 5; i++){
			if(days.get(i)){
				line = line + dayString.charAt(i);
			}
		}
		line = line + " at "+start+"-"+end;
		return line;
	}
	
	
	/**
	 * Given a interger representation of a day
	 * this function will return the times if the class
	 * meets or an empty string if the class does not meet
	 * 
	 * @param 
	 * day - Day of the week, where 0 = Monday ... 4 = Friday
	 * 
	 * Returns:
	 * String, or the empty String if the course does not meet 
	 * on the given day.
	 * 
	 * Ex.  8-10: Calculus
	 */
	public String inDay(int day){
		String meet = "";
		if(days.get(day)){
			meet = start+"-"+end+": "+name; 
		}
		return meet;
	}
}
