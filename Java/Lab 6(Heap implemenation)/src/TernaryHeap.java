/**
 * Filename: TernaryHeap.java
 *
 * File:
 *	$Id: TernaryHeap.java,v 1.3 2013/10/19 16:57:52 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: TernaryHeap.java,v $
 *	Revision 1.3  2013/10/19 16:57:52  drd3073
 *	Using base convertion to calculate rows. Fixed the list to grow in predictiable fashion
 *
 *	Revision 1.2  2013/10/19 02:49:29  drd3073
 *	Prints mostly correct, problems getting the row number due to log base 3 not avaible
 *
 *	Revision 1.1  2013/10/19 01:51:57  drd3073
 *	Turned lecture code for 3 children, sorting properly printing with whitespace gap reversed.
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class TernaryHeap<T extends Comparable<T>> {

	/**
	 * Swaps - Int value of number of swaps performed on heap
	 * theHeap - List representation of heap
	 */
	private int swaps;
	private List<T> theHeap;
	
	/**
	 * Constructs an empty heap object
	 */
	public TernaryHeap(){
		swaps = 0;
		theHeap = new ArrayList<T>();
	}
	
	/**
     * Removes and returns minimum element in the heap.
     *
     * @return minimal element, or null if empty heap.
     */
    public T removeMin() {
        if (theHeap.isEmpty())
            return null;
        // keep the top of the heap to return later
        T toReturn = theHeap.get(0);
        // if that wasn't the last one, take the end of the heap to the
        // root and bubble it down.
        if (theHeap.size() > 1) {
            theHeap.set(0,theHeap.remove(theHeap.size()-1));
            int minc,whereamI = 0;
            while ((minc = minChild(whereamI)) != whereamI) {
                // bubbling down
                T temp = theHeap.get(whereamI);
                theHeap.set(whereamI, theHeap.get(minc));
                theHeap.set(minc, temp);
                swaps++;
                whereamI = minc;
            }
        } else {
            // simply remove the root and be happy!
            theHeap.remove(0);
        }
        return toReturn;
    }
    
    /**
     * Computes the smallest of the node and two children.
     * 
     * @param index
     * @return index of element with smallest value
     */
    private int minChild(int index) {
        int minc = index;
        // children of index are 3*index+1, 3*index+2, 3*index+3
        // if first child exists, is it smaller than me?
        if (3*index+1 < theHeap.size()) {
            if (theHeap.get(3*index+1).compareTo(theHeap.get(index)) < 0) {
                minc = 3*index+1;
            }
            // how about a second child?  Compare to whichever of the
            // parent and first child was smaller.
            if (3*index+2 < theHeap.size()) {
                if (theHeap.get(3*index+2).compareTo(theHeap.get(minc)) < 0) {
                    minc = 3*index+2;
                }
            }
            // third child check
            if (3*index+3 < theHeap.size()) {
                if (theHeap.get(3*index+3).compareTo(theHeap.get(minc)) < 0) {
                    minc = 3*index+3;
                }
            }
        }
        return minc;
    }

    /**
     * Inserts an element into the heap.
     *
     * @param toInsert Item to insert
     */
    public void insert(T toInsert) {
        // put at the end and bubble up!
        theHeap.add(toInsert);
        int whereamI = theHeap.size()-1;
        int parentLoc = whereamI/3;
        // bubble if I am not root and am smaller than my parent.
        while ((whereamI > 0) && 
               (theHeap.get(whereamI).compareTo(theHeap.get(parentLoc)) < 0)) {
            T temp = theHeap.get(whereamI);
            theHeap.set(whereamI, theHeap.get(parentLoc));
            theHeap.set(parentLoc,temp);	
            swaps++;
            whereamI = parentLoc;
            parentLoc = whereamI/3;
        }
    }
    
    /**
     * Is the heap empty?
     *
     * @return Whether the heap is empty
     */
    public boolean isEmpty() {
        return theHeap.isEmpty();
    }
	
    /**
     * Pretty-prints the heap. All elements are assumed to be three characters
     * wide. Elements in the lowest level of the heap are separated by a single
     * space. Elements above the lowest level are evenly spaced such that each
     * element appears above the middle of its three children (or where that 
     * element would be if it existed).
     */
    public void printHeap(){
    	int rows = (int) Math.round((Math.log10(theHeap.size())/Math.log10(3))+1);
    	int currRow = 0;
    	int elements = 1;
    	int whereamI = 0;
    	ArrayList<Integer> spaceList = spaceList(rows);
    	while(currRow < rows){
    		String out = "";
    		String gap = "";
    		int i = 0;
    		while( i < spaceList.get(currRow)){
    			gap+=" ";
    			i++;
    		}
    		while(whereamI < elements && whereamI < theHeap.size()){
    			out+= gap + theHeap.get(whereamI) + gap;
    			whereamI++;
    		}
    		elements = (elements * 3) + 1;
    		System.out.println(out);
    		currRow++;
    	}
    }
    
    /**
     * Helper to calculate spaces for pretty print
     */
    private ArrayList<Integer> spaceList(int rows){
    	ArrayList<Integer> temp = new ArrayList<Integer>();
    	temp.add(1);
    	int last = 0;
    	while(rows > 1){
    		temp.add(temp.get(last)*3+3);
    		last++;
    		rows--;
    	}
    	ArrayList<Integer> out = new ArrayList<Integer>();
    	int index = temp.size()-1;
    	while(index >= 0){
    		out.add(temp.get(index));
    		index--;
    	}
    	return out;
    }
   
    /**
     * Number of swaps counted since last reset.
     * 
     * @return Number of swaps
     */
    public int numSwaps(){
    	return swaps;
    }
    
    /**
     * Resets swap counter
     */
    public void reset(){
    	swaps = 0;
    }
    
	/**
	 * Sorts random numbers, prints number of swaps for each data length.
	 */
	public static void main(String[] args) {

		//generate list and heap objects.
		List<Integer> list1 = new ArrayList<Integer>(50);
		TernaryHeap<Integer> Heap1 = new TernaryHeap<Integer>();
		List<Integer> list2 = new ArrayList<Integer>(250);
		TernaryHeap<Integer> Heap2 = new TernaryHeap<Integer>();
		List<Integer> list3 = new ArrayList<Integer>(500);
		TernaryHeap<Integer> Heap3 = new TernaryHeap<Integer>();
		List<Integer> list4 = new ArrayList<Integer>(1000);
		TernaryHeap<Integer> Heap4 = new TernaryHeap<Integer>();
		List<Integer> list5 = new ArrayList<Integer>(2000);
		TernaryHeap<Integer> Heap5 = new TernaryHeap<Integer>();
		
		
		// Fill Lists
		Random R = new Random();
		for(int i = 500; i > 0; i--){
			list1.add(R.nextInt(50));
		}
		for(int i = 1000; i > 0; i--){
			list2.add(R.nextInt(250));
		}
		for(int i = 1500; i > 0; i--){
			list3.add(R.nextInt(500));
		}
		for(int i = 2000; i > 0; i--){
			list4.add(R.nextInt(1000));
		}
		for(int i = 2500; i > 0; i--){
			list5.add(R.nextInt(2000));
		}
		
		
		//Fill Heaps
		for(Integer i : list1){
			Heap1.insert(i);
		}
		for(Integer i : list2){
			Heap2.insert(i);
		}
		for(Integer i : list3){
			Heap3.insert(i);
		}
		for(Integer i : list4){
			Heap4.insert(i);
		}
		for(Integer i : list5){
			Heap5.insert(i);
		}
		
		
		//test printing
		List<Integer> listP = new ArrayList<Integer>();
		TernaryHeap<Integer> HeapP = new TernaryHeap<Integer>();
		
		for(int i = 100; i < 120; i++){
			listP.add(i);
		}
		
		for(Integer i : listP){
			HeapP.insert(i);
		}
		
		HeapP.printHeap();
		System.out.println();
		
		
		
		//Build sorted list objects
		List<Integer> sorted1 = new ArrayList<Integer>(50);
		List<Integer> sorted2 = new ArrayList<Integer>(250);
		List<Integer> sorted3 = new ArrayList<Integer>(500);
		List<Integer> sorted4 = new ArrayList<Integer>(1000);
		List<Integer> sorted5 = new ArrayList<Integer>(2000);
		
		
		//Fill sorted Lists
		while(!Heap1.isEmpty()){
			sorted1.add(Heap1.removeMin());
		}
		while(!Heap2.isEmpty()){
			sorted2.add(Heap2.removeMin());
		}
		while(!Heap3.isEmpty()){
			sorted3.add(Heap3.removeMin());
		}
		while(!Heap4.isEmpty()){
			sorted4.add(Heap4.removeMin());
		}
		while(!Heap5.isEmpty()){
			sorted5.add(Heap5.removeMin());
		}
		
		// Print stats
		System.out.println("Swaps for size 500: "+ Heap1.numSwaps());
		System.out.println("Swaps for size 1000: "+ Heap2.numSwaps());
		System.out.println("Swaps for size 1500: "+ Heap3.numSwaps());
		System.out.println("Swaps for size 2000: "+ Heap4.numSwaps());
		System.out.println("Swaps for size 2500: "+ Heap5.numSwaps());
		
		
		System.out.println((3+5)/7);
		System.out.println((3+5)/(float)7);
		System.out.println((float)((3+5)/7));
		System.out.println((3+5) / 7.0);
		
		String fu = new String("foo");
		System.out.println(fu.equals("foo"));
		
	}
}
