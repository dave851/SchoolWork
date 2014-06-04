/**
 * Filename: Sorter.java
 *
 * File:
 *	$Id$ 
 *
 * Revisions:
 *	$Log$ 
 *
 *  Implementation of merge sort and quick sort for integers.
 *
 *  @author zjb
 */
import java.util.*;
public class Sorter {
	
	private int compares;
	private int adds;

    /**
     *  Merges two lists, assumes that they are sorted.
     *
     *  @param list1 One sorted list
     *  @param list2 Another sorted list
     *  @return Merged list
     */
    private List<Integer> merge(List<Integer> list1, List<Integer> list2) {
        List<Integer> result = new ArrayList<Integer>();
        int index1 = 0, index2 = 0;
        int len1 = list1.size();
        int len2 = list2.size();
        while (index1 < len1 && index2 < len2 ) {
        	compares++;
            if (list1.get(index1) <= list2.get(index2)) {
                result.add(list1.get(index1));
                adds++;
                index1 = index1 + 1;
            } else {
                result.add(list2.get(index2));
                adds++;
                index2 = index2 + 1;
            }
        }
        if (index1 < len1) {
        	adds += list1.subList(index1, len1).size();
            result.addAll(list1.subList(index1, len1));
        }
        if (index2 < len2) {
        	adds += list2.subList(index2, len2).size();
            result.addAll(list2.subList(index2, len2));
        }
        return result;
    }

    /**
     * Sorts the given list using Merge Sort.
     *
     * @param nums List to be sorted
     * @return Sorted list
     */
    public List<Integer> mergeSort(List<Integer> nums) {
        
        if (nums.size() <= 1)
            return nums;

        List<Integer> odds = new ArrayList<Integer>();
        List<Integer> evens = new ArrayList<Integer>();
        boolean odd = true;
        for (Integer num : nums) {
            if (odd){
                odds.add(num);
            	adds++;
            }
            else 
                evens.add(num);
            	adds++;
            odd = !odd;
        }
        return merge(mergeSort(odds), mergeSort(evens));
    }


    /**
     * Sorts the given list using Quick Sort.
     *
     * @param nums List to be sorted
     * @return Sorted list
     */
    public List<Integer> quickSort(List<Integer> nums) {
        if (nums.size() <= 1)
            return nums;

        int pivot = nums.get(0);

        List<Integer> less = new ArrayList<Integer>();
        List<Integer> same = new ArrayList<Integer>();
        List<Integer> more = new ArrayList<Integer>();

        for (Integer num : nums) {
        	compares++;
            if (num < pivot){
                less.add(num);
                adds++;
            }
            else if (num > pivot){
                more.add(num);
                adds++;
            }
            else
                same.add(pivot);
            	adds++;
        }

        less = quickSort(less);
        more = quickSort(more);

        less.addAll(same);
        adds += same.size();
        less.addAll(more);
        adds += more.size();
        return less;
    }
    
    public void reset(){
    	compares = 0;
    	adds = 0;
    }
    
    public void printStats(){
    	System.out.println("Compares: "+compares+" Adds: "+adds);
    }

    public List<Integer> strandsort(List<Integer> L){
    	List<Integer> res = new ArrayList<Integer>();
    	List<Integer> inorder = new ArrayList<Integer>();
    	int i=0;
    	while( i < L.size()){
    		inorder.add(L.get(i));
    		adds++;
    		i++;
    		for(Integer num : L.subList(i, L.size()-1)){
    			if( num >= inorder.get(i)){
    				compares++;
    				inorder.add(num);
    				adds++;
    				i++;
    			}
    		}
    		res = merge(inorder, res);
    	}
    	return res;    	
    }
        
    /**
     * Main method, creates a random list of Integers and sorts them
     * using both merge sort and quick sort.
     *
     */
    public static void main(String[] args) {

        List<Integer> nums1 = new ArrayList<Integer>();
        List<Integer> nums2 = new ArrayList<Integer>();
        List<Integer> nums3 = new ArrayList<Integer>();
        List<Integer> nums4 = new ArrayList<Integer>();
        List<Integer> nums5 = new ArrayList<Integer>();
        List<Integer> nums6 = new ArrayList<Integer>();
        List<Integer> nums7 = new ArrayList<Integer>();
        List<Integer> nums8 = new ArrayList<Integer>();
        List<Integer> nums9 = new ArrayList<Integer>();
        List<Integer> nums10 = new ArrayList<Integer>();
        List<Integer> nums11 = new ArrayList<Integer>();
        List<Integer> nums12 = new ArrayList<Integer>();
        List<Integer> nums13 = new ArrayList<Integer>();
        List<Integer> nums14 = new ArrayList<Integer>();
        List<Integer> nums15 = new ArrayList<Integer>();
        
        // Random
        Random r = new Random();
        for (int i = 0; i < 5; i++) {
            nums1.add(r.nextInt(100));
        }
        for (int i = 0; i < 25; i++) {
            nums2.add(r.nextInt(100));
        }
        for (int i = 0; i < 50; i++) {
            nums3.add(r.nextInt(100));
        }
        for (int i = 0; i < 75; i++) {
            nums4.add(r.nextInt(100));
        }
        for (int i = 0; i < 120; i++) {
            nums5.add(r.nextInt(100));
        }
        
        
        // reverse ordered
        for(int i=5; i >=0 ; i--){
        	nums6.add(i);
        }
        for(int i=25; i >=0 ; i--){
        	nums7.add(i);
        }

        for(int i=50; i >=0 ; i--){
        	nums8.add(i);
        }

        for(int i=75; i >=0 ; i--){
        	nums9.add(i);
        }

        for(int i=120; i >=0 ; i--){
        	nums10.add(i);
        }
            
        
        
        
        // Ordered
        for(int i=0; i < 5  ; i++){
        	nums11.add(i);
        }
        for(int i=0; i < 25 ; i++){
        	nums12.add(i);
        }

        for(int i=0; i < 50 ; i++){
        	nums13.add(i);
        }

        for(int i=0; i < 75 ; i++){
        	nums14.add(i);
        }

        for(int i=0; i < 120 ; i++){
        	nums15.add(i);
        }


        /**System.out.println("Original list: ");
        for (Integer n : nums) {
            System.out.println(n);
        }
		*/
        
        Sorter s = new Sorter();

        System.out.println("Tests with Random ordered Lists size 5");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msorted = s.mergeSort(nums1);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsorted = s.quickSort(nums1);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ss = s.quickSort(nums1);
        //for (Integer n : ss) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with Random ordered Lists size 25");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR = s.mergeSort(nums2);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR = s.quickSort(nums2);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR = s.quickSort(nums2);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with Random ordered Lists size 50");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR2 = s.mergeSort(nums3);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR2 = s.quickSort(nums3);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR2 = s.quickSort(nums3);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        System.out.println("Tests with Random ordered Lists size 75");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR4 = s.mergeSort(nums4);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR4 = s.quickSort(nums4);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR4 = s.quickSort(nums4);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Tests with Random ordered Lists size 120");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR5 = s.mergeSort(nums5);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR5 = s.quickSort(nums5);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR5 = s.quickSort(nums5);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();


        System.out.println("Tests with Reversed ordered Lists size 5");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msorted6 = s.mergeSort(nums6);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsorted6 = s.quickSort(nums6);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ss6 = s.quickSort(nums6);
        //for (Integer n : ss) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with Reversed ordered Lists size 25");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR7 = s.mergeSort(nums7);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR7 = s.quickSort(nums7);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR7 = s.quickSort(nums7);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with Reversed ordered Lists size 50");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR8 = s.mergeSort(nums8);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR8 = s.quickSort(nums8);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR8 = s.quickSort(nums8);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        System.out.println("Tests with Reversed ordered Lists size 75");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR9 = s.mergeSort(nums9);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR9 = s.quickSort(nums9);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR9 = s.quickSort(nums9);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Tests with Reversed ordered Lists size 120");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR10 = s.mergeSort(nums10);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR10 = s.quickSort(nums10);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR10 = s.quickSort(nums10);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with ordered Lists size 5");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msorted11 = s.mergeSort(nums11);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsorted11 = s.quickSort(nums11);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ss11 = s.quickSort(nums11);
        //for (Integer n : ss) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with ordered Lists size 25");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR12 = s.mergeSort(nums12);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR12 = s.quickSort(nums12);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR12 = s.quickSort(nums12);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
        System.out.println("Tests with ordered Lists size 50");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR13 = s.mergeSort(nums13);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR13 = s.quickSort(nums13);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR13 = s.quickSort(nums13);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        System.out.println("Tests with ordered Lists size 75");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedR14 = s.mergeSort(nums14);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR14 = s.quickSort(nums14);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR14 = s.quickSort(nums14);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Tests with ordered Lists size 120");
        
        System.out.println("Merge-sorted list: ");
        List<Integer> msortedr15 = s.mergeSort(nums15);
        //for (Integer n : msorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("Quick-sorted list: ");
        List<Integer> qsortedR15 = s.quickSort(nums15);
        //for (Integer n : qsorted) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();
        
        System.out.println("strandSort-sorted list: ");
        List<Integer> ssR15 = s.quickSort(nums15);
        //for (Integer n : ssR) {
        //    System.out.println(n);
        //}
        s.printStats();
        s.reset();

        
    }

}