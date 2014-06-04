/**
 * ScheduleMaker.java
 * 
 * $Id: ScheduleMaker.java,v 1.2 2013/09/17 22:33:10 drd3073 Exp $
 *
 * $Log: ScheduleMaker.java,v $
 * Revision 1.2  2013/09/17 22:33:10  drd3073
 * PrettyPrint written, fixed can not find filename bug, Passes initial tests
 *
 * Revision 1.1  2013/09/14 14:38:24  drd3073
 * All Files created / downloaded, all methods stubbed.
 *
 *
 */
import java.util.Scanner;

/** 
 * Interactive schedule maker.  Loads a list of courses and gives
 * the user the option to add them to their schedule if they do not
 * create a conflict, and to print their schedule.
 *
 * @author zjb
 */
public class ScheduleMaker {

    /** 
     * Main method.
     *
     * @param args Ex2pects one command-line argument: the name of the file containing the courses.
     */
    public static void main(String[] args) {
	
	CourseList cl = new CourseList(args[0]);
	boolean done = false;
	Schedule sched = new Schedule();

	Scanner in = new Scanner(System.in);
	System.out.println("Welcome to CS2 Schedule Maker!");
	while (!done) {
	    System.out.println("\nChoices are");
	    System.out.println("1. Add a course to your schedule");
	    System.out.println("2. Print your schedule");
	    System.out.println("3. Quit");
	    System.out.print("What would you like to do? ");
	    int choice = in.nextInt();
            System.out.println();
	    if (choice == 1) {
		System.out.println("Here are the courses:");
		System.out.println(cl);
		System.out.print("What course would you like to add? ");
		int course = in.nextInt();
		if (sched.contains(cl.getCourse(course))) 
		    System.out.println("That course is already on your schedule.");
		else if (sched.add(cl.getCourse(course)))
		    System.out.println("Course successfully added.");
		else
		    System.out.println("Sorry, course could not be added to your schedule.");
	    } else if (choice == 2) {
		sched.prettyPrint();
	    } else if (choice == 3) {
		done = true;
	    } else {
		System.out.println("Not a valid option, please try again.");
	    }
	    in.close();
	}
	System.out.println("Thanks for using Schedule Maker.");
    }
}