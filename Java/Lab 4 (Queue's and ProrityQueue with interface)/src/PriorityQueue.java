/**
 * 
 */

/**
 * Interface for a generic priority queue.  Does not specify whether
 * small or large priority values are "high" priority.
 * @author zjb
 *
 */
public interface PriorityQueue<T extends Prioritizable> {

	/**
	 * Is there anything in the queue?
	 * @return queue is empty.
	 */
	boolean isEmpty();
	
	/**
	 * Add an item to the queue (at the appropriate location)
	 * @param toInsert Item to be added
	 */
	void insert(T toInsert);
	
	/**
	 * Removes and returns the item at the front of the queue.
	 * @return Removed element
	 */
	T dequeue();
}