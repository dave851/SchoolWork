""" 
file: selectMedian
language: python
author: David Desrochers
description: select median of unsorted list
"""


from time import *
import math


def buildList(filename):
    """
    Takes a filename in the format of:

    Office 70
    MedicalOffice 120
    PostOffice 170
    Mall 200

    where the first word is the building and the second is the
    distance from a reference point of zero.

    Then Builds a list of only the integers

    buildList(String) -> List of integers
    """ 
    file=open(filename)
    lst=[]
    for line in file:
        lst=lst+line.split()
    lstNum_str=lst[1::2]
    lstNum=[]
    for element in lstNum_str:
        lstNum=lstNum+[int(element)]
    file.close()
    return lstNum

def smallerList(lst,pivot):
    """
    Takes a unsorted list of integers and builds a list of all the
    integers smaller than the pivot.

    smallerList(List,Integer) -> List
    """
    smallerList=[]
    for element in lst:
        if element < pivot:
            smallerList=smallerList+[element]
    return smallerList

def largerList(lst,pivot):
    """
    Takes a unsorted list of integers and builds a list of all the
    integers larger than the pivot.

    smallerList(List,Integer) -> List
    """
    largerList=[]
    for element in lst:
        if element > pivot:
            largerList=largerList+[element]
    return largerList

def countP(lst,target):
    """
    Counts the number of times a target number appears in the given list

    countP(List,Integer) -> Integer
    """
    count=0
    for element in lst:
        if element==target:
            count=count+1
    return count

def quickSelect(lst,k):
    """
    Takes a unsorted list and find the kth smallest number.

    quickSelect(List,Interger) -> Interger
    """
    if len(lst) != 0:
        pivot=lst[len(lst)//2]
    smallList=smallerList(lst,pivot)
    largeList=largerList(lst,pivot)
    count=countP(lst,pivot)
    lenS=len(smallList)
    if k >= lenS and k < lenS+count:
           return pivot
    if lenS > k:
        return quickSelect(smallList,k)
    else:
        return quickSelect(largeList,k-lenS-count)

def median(lst):
    """
    Takes a unsorted list of integers and finds the median value.

    median(List) -> Integer
    """
    if len(lst)%2==1:        
        return quickSelect(lst,len(lst)//2)
    else:
        first=quickSelect(lst,(len(lst)-1)//2)
        second=quickSelect(lst,len(lst)//2)
        median=(first+second)/2
        return median        

def distance(lst,location):
    """
    Takes a list of integers and a reference point then
    finds the sum of the differences using absolute value

    distance(List, Integer) -> Integer
    """
    total=0
    for element in lst:
        total=total+math.fabs(location-element)
    return total
           
def main():
    filename=str(input('Enter Filename: '))
    lst=buildList(filename)
    a=clock()
    location=median(lst)
    b=clock()
    time=b-a
    print('Location should be: '+str(location))
    print('Sum of all distances customers walk: '+str(distance(lst,location)))
    print('Calculated in: '+str(time))
    input('Press enter to close')

main()
