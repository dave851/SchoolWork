/**
 * Filename: MagicBag.java
 *
 * File:
 *	$Id: MagicBag.java,v 1.2 2013/11/02 22:12:23 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: MagicBag.java,v $
 *	Revision 1.2  2013/11/02 22:12:23  drd3073
 *	Docutmentation added
 *
 *	Revision 1.1  2013/11/01 01:56:06  drd3073
 *	Flawless victory
 * 
 *
 * @author Dave
 */
import java.util.*;

public class MagicBag<E> implements Collection<E>, Iterable<E> {

	/**
	 * List of elements in the magic bag
	 */
	private List<E> rabbits;
	
	/**
	 * Creates a magic bag
	 */
	public MagicBag(){
		rabbits = new ArrayList<E>();
	}
	
	/**
	 * Adds an item to the magic bag
	 * 
	 * However, if item is already in the bag, both vanish
	 * 
	 * @param item - item to add.
	 */
	public boolean add(E item){
		boolean inBag = false;
		boolean added = false;
		for(E rab : rabbits){
			if(rab.equals(item)){
				rabbits.remove(item);
				inBag = true;
				break;
			}
		}
		if(!inBag){
			rabbits.add(item);
			added = true;
		}
		return added;
	}
	
	/**
	 * Adds a Collection item to the magic bag
	 * 
	 * However, if item is already in the bag, both vanish
	 * 
	 * @param c - Collection to add.
	 */
	public boolean addAll(Collection<? extends E> c){
		boolean added = true;
		for(E rab : c){
			if(!add(rab)){
				added = false;
			}
		}
		return added;
	}
	
	/**
	 * Empty the bag
	 */
	public void clear(){
		rabbits.clear();
	}
	
	/**
	 * Unsupported, will throw exception
	 */
	public boolean contains(Object o){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Unsupported, will throw exception
	 */
	public boolean containsAll(Collection<?> c){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Since the contents are unknown, all magic bags are equal
	 * 
	 * @return boolean - true if object is a magic bag, false otherwise
	 */
	@Override
	public boolean equals(Object o){
		return (o instanceof MagicBag) && !(o == null);
	}
	
	/**
	 * Returns boolean true if empty, false if not empty
	 */
	public boolean isEmpty(){
		return rabbits.isEmpty();
	}
	
	/**
	 * Creates and returns an iterator for the magic bag
	 * 
	 * However, iterator gives random ordering of what is in the bag
	 */
	public Iterator<E> iterator(){
		return new BagIterator();
	}
	
	public class BagIterator implements Iterator<E>{

		/** 
		 * Stores last element seen, used for removes
		 */
		private E last;
		
		/**
		 * Returns a boolean true if iterator can continue
		 * one position forward
		 */
		public boolean hasNext() {
			return !isEmpty();
		}

		/**
		 * Returns the relative next element in the bag
		 */
		public E next() {
			last = pull();
			add(last);
			return last;
		}

		/**
		 * Removes last element seen from bag
		 */
		public void remove() {
			add(last);
			last = null;
		}
		
	}
	
	/**
	 * Gets a random item out of the bag
	 * 
	 * @return E - item pulled out of bag
	 */
	public E pull(){
		if(isEmpty()){
			return null;
		}
		Collections.shuffle(rabbits);
		return rabbits.remove(0);
	}
	
	/**
	 * Unsupported, throws exception
	 */
	public boolean remove(Object o){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Unsupported, throws exception
	 */
	public boolean removeAll(Collection<?> c){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Unsupported, throws exception
	 */
	public boolean retainAll(Collection<?> c){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Returns integer of the number of items in the bag.
	 */
	public int size(){
		return rabbits.size();
	}
	
	/**
	 * Unsupported, throws exception
	 */
	public Object[] toArray(){
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Unsupported, throws exception
	 */
	public <T> T[] toArray(T[] a){
		throw new UnsupportedOperationException();
	}

}
