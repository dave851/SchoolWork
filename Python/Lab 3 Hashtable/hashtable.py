""" 
file: hashtable.py
language: python3
author: David Desrochers
author: sps@cs.rit.edu Sean Strout 
author: jeh@cs.rit.edu James Heliotis 
author: anh@cs.rit.edu Arthur Nunes-Harwitt
description: open addressing Hash Table for CS 242 Lecture
"""

class HashTable( object ):
    """
       The HashTable data structure contains a collection of values
       where each value is located by a hashable key.
       No two values may have the same key, but more than one
       key may have the same value.
    """

    __slots__ = ( "table", "size" )

    def __init__( self, capacity=100 ):
        """
           Create a hash table.
           The capacity parameter determines its initial size.
        """
        self.table = [None for i in range(capacity)] 
        self.size = 0

    def __str__( self ):
        """
           Return the entire contents of this hash table,
           one chain of entries per line.
        """
        result = ""
        for i in range( len( self.table ) ):
            result += str( i ) + ": "
            result += str( self.table[i] ) + "\n"
        return result

    class _Entry( object ):
        """
           A nested class used to hold key/value pairs.
        """

        __slots__ = ( "key", "value" )

        def __init__( self, entryKey, entryValue ):
            self.key = entryKey
            self.value = entryValue

        def __str__( self ):
            return "(" + str( self.key ) + ", " + str( self.value ) + ")"

def hash_function( val, n ):
    """
       Compute a hash of the val string that is in [0 ... n).
    """
    #hashcode = hash( val ) % n
    hashcode = 0
    for i in range(len(val)-1):
        hashcode+=ord(val[i])+ord(val[0])+ord(val[-1])
    #hashcode = len(val) % n
    return hashcode % n

def keys( hTable ):
    """
       Return a list of keys in the given hashTable.
    """
    result = []
    for entry in hTable.table:
        if entry != None:
            for object in entry:
                result.append( object.key )
    return result

def contains( hTable, key ):
    """
       Return True if hTable has an entry with the given key.
    """
    index = hash_function( key, len( hTable.table ) )
    if hTable.table[index] != None:
        for entry in hTable.table[index]:
            if entry.key == key:
                return True
    else:
        return False

def put( hTable, key, value ):
    """
       Using the given hash table, set the given key to the
       given value. If the key already exists, the given value
       will replace the previous one already in the table.
       If the table is full, an Exception is raised.
    """
    if load(hTable) >= 0.75:
        rehash(hTable)
    index=hash_function( key, len(hTable.table)) 
    if hTable.table[index] == None:
         hTable.table[index] = [HashTable._Entry(key, value)]
         hTable.size+=1
    else:
        for entry in hTable.table[index]:
            if entry.key == key:
                entry.value=value
                break
        else:
             hTable.table[index].append(HashTable._Entry(key, value)) 
             hTable.size+=1
        
def get( hTable, key ):
    """
       Return the value associated with the given key in
       the given hash table.
       Precondition: contains(hTable, key)
    """
    index=hash_function( key, len(hTable.table))
    if len(hTable.table[index]) > 1:
        for entry in hTable.table[index]:
            if entry.key == key:
                return entry.value
    else:
        return hTable.table[index][0].value

def load(hashT):
    """
    Helps determine how full the current table is
    load(hash table) -> int
    """
    return hashT.size/(len(hashT.table)-1)

def rehash(hTable):
    """
    When table load gets to high the size is expanded and 
    all keys are hashed into the larger table
    """
    newT = HashTable(len(hTable.table)*2+1)
    for entry in hTable.table:
        if entry != None:
            for key in entry:
                put(newT, key.key, key.value)
    hTable.table=newT.table
    hTable.size=newT.size

def imbalance(hashT):
    """
    Checks how ballanced hash table is
    imbalance(hash table) -> INT
    """
    non_empty_chains=0
    len_of_all_non_empty_chains=0
    for entry in hashT.table:
        if entry != None:
            non_empty_chains+=1
            len_of_all_non_empty_chains+=len(entry)
    return (len_of_all_non_empty_chains/non_empty_chains) -1
