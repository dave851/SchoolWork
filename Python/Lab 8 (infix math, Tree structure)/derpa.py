""" 
file: derp
language: python
author: David Desrochers
description: derp the interpreter
"""



class MultiplyNode():
    __slots__ = ('left','right')

class DivideNode():
    __slots__ = ('left','right')

class AddNode():
    __slots__ = ('left','right')

class SubtractNode():
    __slots__ = ('left','right')

class LiteralNode():
    __slots__ = ('val')

class VariableNode():
    __slots__ = ('name')

def mkMultiplyNode(left,right):
    res=MultiplyNode()
    res.left=left
    res.right=right
    return res

def mkDivideNode(left,right):
    res=DivideNode()
    res.left=left
    rs.right=right
    return res

def mkAddNode(left,right):
    res=AddNode()
    res.left=left
    rs.right=right
    return res

def mkSubtractNode():
    res=SubstractNode()
    res.left=left
    rs.right=right
    return res

def mkLiteralNode(val):
    res=LiteralNode()
    res.val=val
    return res

def mkVariableNode(var):
    res=VariableNode()
    res.name=var
    return res

def buildDicFromFile(filename):
    Vars=dict()
    file=open(filename)
    for line in file:
        lst=line.split()
        Vars[lst[0]]=int(lst[1])
    return Vars

def parse(fun):
    if fun[0].isdigit():
        return mkLiteralNode(fun[0])
    elif fun[0]=='*':
        return mkMultiplyNode(parse(fun.pop()),parse(fun))
    elif fun[0]=='//':
        return mkDivideNode(parse(fun.pop()),parse(fun))
    elif fun[0]=='+':
        return mkAddNode(parse(fun.pop()),parse(fun))
    elif fun[0]=='-':
        return mkSubtractNode(parse(fun.pop()),parse(fun))
    elif type(fun[0])==str:
        return mkVariableNode(fun[0])
    else:
        raise TypeError('Parse input not defined')









