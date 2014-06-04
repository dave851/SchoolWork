
/*
 * Student.java
 *
 * Version:
 * $Id: Student.java,v 1.1 2013/10/13 23:18:12 drd3073 Exp $
 *
 * Revisions:
 * $Log: Student.java,v $
 * Revision 1.1  2013/10/13 23:18:12  drd3073
 * Put, get written, error getting table index, returning negative numbers
 *
 */

/**
 * Simple class to hold student data.
 *
 * @author zjb
 */
public class Student {

    private String name, major;
    private int year, ID;

    /**
     * Constructor for use with file reading.
     * @param line Line containing all student data, fields delimited with asterisks.
     */
    public Student(String line) {
        String[] tokens = line.split("\\*");
        name = tokens[0];
        major = tokens[1];
        year = Integer.parseInt(tokens[2]);
        ID = Integer.parseInt(tokens[3]);
    }

    /**
     * Constructor for use with main program.
     * @param name Student name
     * @param major Student major
     * @param year Student year level (1-5)
     * @param id Student ID number
     */
    public Student(String name, String major, int year, int id) {
        this.name = name;
        this.major = major;
        this.year = year;
        this.ID = id;
        
    }

    /**
     * Accessor for name.
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Accessor for ID.
     * @return ID
     */
    public int getId() {
        return ID;
    }

    /**
     * Creates a string with all information in a nicely-formatted way.
     * @return String representation of Student data
     */
    public String toString() {
        return ID + ": " + name + " (" + major + "-" + year + ")";
    }
}