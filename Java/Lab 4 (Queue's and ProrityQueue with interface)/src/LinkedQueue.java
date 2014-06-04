/**
 * Filename: LinkedQueue.java
 *
 * File:
 *	$Id: LinkedQueue.java,v 1.3 2013/09/21 17:07:39 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: LinkedQueue.java,v $
 *	Revision 1.3  2013/09/21 17:07:39  drd3073
 *	Added all documentaion and overrides
 *
 *	Revision 1.2  2013/09/21 05:44:32  drd3073
 *	Fixed insert (loop never incremented) and changed dequeue, was dequeueing from wrong end of list
 *
 *	Revision 1.1  2013/09/21 05:35:37  drd3073
 *	LinkedQueue Started, insert needs work, will not insert unless list is emty
 * 
 *
 * @author Dave
 */
import java.util.LinkedList;

public class LinkedQueue<T extends Prioritizable> implements PriorityQueue<T>{

	private LinkedList<T> Line;
	
	/**
	 * Constructor that initializes data structure.
	 */
	public LinkedQueue(){
		Line = new LinkedList<T>();
	}
	
	
	/**
	 * Tests to see if the current queue is empty
	 * 
	 * @return Boolean True if empty, false is not empty. 
	 */
	@Override
	public boolean isEmpty(){
		if(Line.size() == 0){
			return true;
		}
		else{
			return false;
		}
	}
	
	/**
	 * Removes the highest priority object from the list
	 * and returns the object
	 * 
	 * @return T object
	 */
	@Override
	public T dequeue(){
		return Line.pollFirst();
	}
	
	/**
	 * Inserts a T object into the priority queue at correct location
	 * 
	 * @param T - an object to be added, must implement prioritizable
	 */
	@Override
	public void insert(T student){
		for(int i = 0; i < Line.size(); i++){
			T current = Line.get(i);
			if(student.getPriority() > current.getPriority()){
				Line.add(i, student);
			}
		}
		Line.addLast(student);
	}
}