
"""
file: stack.py
language: python2/3
author: Sean Strout
author: David Desrochers
descrption: A linked node implementation of a stack
"""

from .myNode import EmptyListNode, ListNode

class Stack:
    __slots__ = ( "top" )
    
    def __init__(self):
        self.top = EmptyListNode()      # the top node in the stack
    
def push(element, stack):
    """Add an element to the top of the stack"""
    newnode = ListNode(element, stack.top)
    stack.top = newnode
    
def top(stack):
    """Access the top element oi the stack without removing it"""
    if emptyStack(stack):
        raise IndexError("top on empty stack") 
    return stack.top.data

def pop(stack):
    """Remove the top element in the stack (returns None)"""
    if emptyStack(stack):
        raise IndexError("pop on empty stack") 
    stack.top = stack.top.next
    
def emptyStack(stack):
    """Is the stack empty?"""
    return isinstance(stack.top, EmptyListNode)