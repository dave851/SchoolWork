""" 
file: pack
language: python
author: David Desrochers
description: bin packing
"""


def buildBoxList(filename):
    """
    Takes a file containing the dementions of boxs to be put into a bin.
    Then sorts the list

    buildBoxList(String) -> List
    """
    file=open(filename)
    boxList=[]
    for line in file:
        boxList=boxList+[int(line.strip())]
    boxList=sorted(boxList,reverse=True)
    return boxList   

def buildBin(binSize):
    """
    Builds a 2d 'bin' in the shape of a list of lists. All zero's

    buildBin(Integer) -> List
    """
    Bin=[]
    Bin=[[0 for col in range(binSize)]for row in range(binSize)]
    return Bin

def SpaceFree(Bin,row,colum,size):
    """
    Takes the bin, and top left of where you are trying to place a block
    and returns true or false condition.

    SpaceFree(List,Integer,Interger,Interger) -> Bollean True/False
    """
    i=0
    binSize=len(Bin[0])
    while i < size:
        j=0
        while j < size:
            if row+i >= binSize or colum+j >= binSize or Bin[row+i][colum+j] != 0:
                return False
            j=j+1
        i=i+1
    return True

def freeSpaces(Bin):
    """
    Counts the number of emty spaces in the Bin
    
    freeSpaces(List) -> Integer
    """
    count=0
    row=0
    while row < len(Bin):
        Bin[row]
        colum=0
        while colum < len(Bin[row]):
            if Bin[row][colum]==0:
                count=count+1
            colum=colum+1
        row=row+1
    return count

def placeBoxinBin(Bin,row,colum,size):
    """
    Takes a Box, a Bin and the location it will go and places the box.

    placeBoxinBin(List,Integer,Integer,Integer) -> List
    """
    rowi=0
    while rowi < size:
        Bin[row+rowi][colum]=size
        columi=0
        while columi < size:
            Bin[row+rowi][colum+columi]=size
            columi=columi+1
        rowi=rowi+1
    return Bin

def packBin(Bin,boxList):
    """
    Takes a Bin and list of Boxes and packs the Bin with the Boxes from largest
    to smallest. Also returns any Boxes that it could not pack.

    packBin(List,List) -> List , List
    """
    boxsNotPacked=[]
    size=len(Bin)
    for Box in boxList:
        boxPacked=False
        row=0
        while row < size:
            colum=0
            while colum < size :
                if SpaceFree(Bin,row,colum,Box):
                    packedBin=placeBoxinBin(Bin,row,colum,Box)
                    boxPacked=True
                    break
                colum=colum+1
            if boxPacked:
                break
            row=row+1
        if boxPacked==False:
            boxsNotPacked=boxsNotPacked+[Box]
    return packedBin,boxsNotPacked

def printBin(Bin):
    """
    Prints Bin as 2d box not a list

    printBin(List) -> List
    """
    for element in Bin:
        print(element)

def main():
    file=input('Block file: ')
    binSize=int(input('Enter square bin size: '))
    Bin=buildBin(binSize)
    boxList=buildBoxList(file)
    packedBin,boxsNotPacked=packBin(Bin,boxList)
    printBin(packedBin)
    print('Free Spaces: '+str(freeSpaces(Bin)))
    print('Unpacked blocks: '+str(boxsNotPacked))
    input('Press Enter to close')
    
main()
