
"""
241 Lab 8 - Derp the Interpreter

Derp is a simple interpreter that parses and evaluates preorder expressions 
containing basic arithmetic operators (*,//,-+).  It performs arithmetic with
integer only operands that are either literals or variables (read from a 
symbol table).  It dumps the symbol table, produces the expression infix with 
parentheses to denote order of operation, and evaluates/produces the result of 
the expression.

Author: Sean Strout (sps@cs.rit.edu)

Author: David Desrochers
"""

##############################################################################
# structure definitions for parse tree
##############################################################################

class MultiplyNode:
    """Represents an multiply operator, *"""
    
    __slots__ = ('left', 'right')
    
class DivideNode:
    """Represents an integer divide operator, //"""

    __slots__ = ('left', 'right')
    
class AddNode:
    """Represents an addition operator, +"""

    __slots__ = ('left', 'right')
    
class SubtractNode:
    """Represents an addition operator, -"""

    __slots__ = ('left', 'right')
    
class LiteralNode:
    """Represents an operand node"""
    
    __slots__ = ('val')
    
class VariableNode:
    """Represents a variable node"""
    
    __slots__ = ('name')
    
##############################################################################
# structure creation routines for parse tree
##############################################################################
        
def mkMultiplyNode(left, right):
    """mkMultiplyNode(): Node * Node -> MultiplyNode
    Creates and returns an multiply node."""
    
    node = MultiplyNode()
    node.left = left
    node.right = right
    return node
    
def mkDivideNode(left, right):
    """mkDivideNode(): Node * Node -> DivideNode
    Creates and returns an divide node."""

    node = DivideNode()
    node.left = left
    node.right = right
    return node

def mkAddNode(left, right):
    """mkAddNode(): Node * Node -> AddNode
    Creates and returns an add node."""

    node = AddNode()
    node.left = left
    node.right = right
    return node

def mkSubtractNode(left, right):
    """mkSubtractNode(): Node * Node -> SubtractNode
    Creates and returns a subtract node."""

    node = SubtractNode()
    node.left = left
    node.right = right
    return node    
    
def mkLiteralNode(val):
    """mkOperatorNode(): int -> LiteralNode
    Creates and returns a literal node."""
    
    node = LiteralNode()
    node.val = val
    return node
    
def mkVariableNode(name):
    """mkVariableNode(): String -> VariableNode
    Creates and returns an variable node."""

    node = VariableNode()
    node.name = name
    return node   
        
##############################################################################
# parse
############################################################################## 
    
def parse(tokens):
    """parse: list(String) -> Node
    From an inorder stream of tokens, and a symbol table, construct and
    return the tree, as a collection of Nodes, that represent the
    expression.
    """
    i=tokens[0]
    tokens.pop(0)
    
    if i=='*':
        return mkMultiplyNode(parse(tokens),parse(tokens))
    elif i=='//':
        return mkDivideNode(parse(tokens),parse(tokens))
    elif i=='+':
        return mkAddNode(parse(tokens),parse(tokens))
    elif i=='-':
        return mkSubtractNode(parse(tokens),parse(tokens))
    elif i.isdigit():
        return mkLiteralNode(int(i))
    elif type(i)==str and len(i)==1:
        return mkVariableNode(i)
    else:
        raise TypeError('Parse input not defined')
            
##############################################################################
# infix
##############################################################################
        
def infix(node):
    """infix: Node -> String | TypeError
    Perform an inorder traversal of the node and return a string that
    represents the infix expression."""
    if isinstance(node,LiteralNode):
        return node.val
    elif isinstance(node,VariableNode):
        return node.name
    elif isinstance(node,MultiplyNode):
        return '( '+str(infix(node.left))+' * '+str(infix(node.right))+' )'
    elif isinstance(node,DivideNode):
        return '( '+str(infix(node.left))+' // '+str(infix(node.right))+' )'
    elif isinstance(node,AddNode):
        return '( '+str(infix(node.left))+' + '+str(infix(node.right))+' )'
    elif isinstance(node,SubtractNode):
        return '( '+str(infix(node.left))+' - '+str(infix(node.right))+' )'
    else:
        raise TypeError( "bstToString's input not a binary tree" )
 
##############################################################################
# evaluate
##############################################################################    
      
def evaluate(node, symTbl):
    """evaluate: Node * dict(key=String, value=int) -> int | TypeError
    Given the expression at the node, return the integer result of evaluating
    the node.
    Precondition: all variable names must exist in symTbl"""
    if isinstance(node,MultiplyNode):
        return evaluate(node.left,symTbl) * evaluate(node.right,symTbl)
    elif isinstance(node,DivideNode):
        if evaluate(node.right,symTbl) == 0 :
            raise TypeError("CAN'T DIVIDE BY ZERO")            
        return evaluate(node.left,symTbl) // evaluate(node.right,symTbl)
    elif isinstance(node,AddNode):
        return evaluate(node.left,symTbl) + evaluate(node.right,symTbl)
    elif isinstance(node,SubtractNode):
        return evaluate(node.left,symTbl) - evaluate(node.right,symTbl)
    elif isinstance(node,LiteralNode):
        return node.val
    elif isinstance(node,VariableNode):
        return symTbl[node.name]
    else:
        raise TypeError('Var not in dictionary or Input not a expression Tree')

###############################################################################
# Build Dict
###############################################################################

def buildDicFromFile(filename):
    """
    Takes a filename and build the dictary of vaurbles

    buildDicFromFile('string') -> Dict
    """
    Vars=dict()
    file=open(filename)
    for line in file:
        lst=line.split()
        Vars[lst[0]]=int(lst[1])
    return Vars

##############################################################################
# main
##############################################################################
                     
def main():
    """main: None -> None
    The main program prompts for the symbol table file, and a prefix 
    expression.  It produces the infix expression, and the integer result of
    evaluating the expression"""
    
    print("Hello Herp, welcome to Derp v1.0 :)")    
    inFile = input("Herp, enter symbol table file: ")    
    Vars=buildDicFromFile(inFile)
    for entry in Vars:
        print('Name :',entry,'=>','Value',Vars[entry])   
    print("Herp, enter prefix expressions, e.g.: + 10 20 (RETURN to quit)...")
    while True:
        prefixExp = input("derp> ")
        if prefixExp == "":
            break       
        fun=prefixExp.split()
        tree=parse(fun)
        Exp=infix(tree)
        print("Derping the infix expression: "+Exp)
        Eval=evaluate(tree,Vars)
        print("Derping the evaluation: "+str(Eval))        
    input("Goodbye Herp :(")
    
if __name__ == "__main__":
    main()
