""" 
file: storeLocation
language: python
author: David Desrochers
description: select median of a sorted list
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

def sortlst(lst):
    """
    Sorts a list of integers from smallest to largest using
    insertion sort.
    
    sortlst(List) -> List
    """
    count=1
    while count<len(lst):        
        save=lst[count]
        while count>0 and lst[count-1]>save:
            lst[count]=lst[count-1]
            count=count-1
        lst[count]=save
        count=count+1
    return lst
    
def median(lst):
    """
    Takes a sorted list of integers and finds the median value.

    median(List) -> Integer
    """
    if len(lst)%2==1:        
        return lst[len(lst)-1//2]
    else:
        first=lst[(len(lst)-1)//2]
        second=lst[len(lst)//2]
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
    lstNum=buildList(filename)
    a=clock()
    lstSort=sortlst(lstNum)
    location=median(lstSort)
    b=clock()
    time=b-a
    print('Location should be: '+str(location))
    print('Sum of all distances customers walk: '+str(distance(lstSort,location)))
    print('Calculated in: '+str(time))
    input('Press enter to close')

main()
