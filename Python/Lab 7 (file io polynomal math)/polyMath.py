""" 
file: polyMath
language: python
author: David Desrochers
description: math with polys
"""


class Zero():
    __slots__ = ()

class Poly():
    __slots__ = ("const", "poly")

def mkZero():
    return Zero()
    
def mkNonZero(c,p):
    """
    Makes Poly object

    mkNonZero(Int,Object Poly) -> Object Poly
    """
    ret = Poly()
    ret.const = c
    ret.poly = p
    return ret

def polyFromFileName(filename):
    """
    Builds Poly From file

    poltFromFileName(String) -> Poly Object
    """
    file=open(filename)
    polyout=mkZero()
    for line in file:
        Ints=[]
        lst=line.split()
        for number in lst:
            Ints=Ints+[int(number)]
        linePoly=mkNonZero(Ints[0],mkZero())
        while Ints[1]>0:
            linePoly=scaleByX(linePoly)
            Ints[1]=Ints[1]-1
        polyout=addPoly(polyout,linePoly)
    file.close()
    return polyout

######################  TEACHER CODE(Phil White) ##########################

def polyFromNum(c):
    return mkPoly(c, mkZero() )

def PolyX():
    return mkPoly(0, mkPoly(1, mkZero()))

def poly2str1(p):
    if isinstance(p,Zero):
        return "0"
    elif isinstance(p,Poly):
        return "(" + poly2str1(p.poly) + ")*x + " + str(p.const)
    else:
        raise TypeError( "Not a Polynomial" )
    
def poly2strR2(p,n):
    if isinstance(p,Zero):
        return "0"
    elif isinstance(p,Poly):
        return poly2strR2(p.poly, n+1) + " + " + \
               str(p.const) + "*x**" + str(n)
    else:
        raise TypeError( "Not a Polynomial" )

def poly2str2(p):
    p=standardize(p)
    return poly2strR2(p,0)
    
def poly2strR(p,n):
    if isinstance(p,Zero):
        return "0"
    elif isinstance(p,Poly):
        if isinstance(p.poly, Zero):
            return term2str( p.const, n)
        else:
            if p.const == 0:
                return poly2strR(p.poly, n+1)
            else:
                A=poly2strR(p.poly, n+1)
                B=term2str( p.const, n)
                return poly2strR(p.poly, n+1) + " + " + \
                       term2str( p.const, n)
    else:
        raise TypeError( "Not a Polynomial" )

def poly2str(p):
    return poly2strR(p,0)
    
def term2str( coef, exp ):
    r='THIS IS TO FIX SCOPE'
    if exp==0:
        r = str(coef)
    elif exp == 1:
        if coef == 1:
            r = "x"
        else:
            r = str(coef) + "*x"
    else:
        if coef == 1:
            r = "x**" + str(exp)
        else:
            r = str(coef) + "*x**" + str(exp)
    return r
#####################   /END TEACHER CODE  ##################################

def addPoly(poly1,poly2):
    """
    Adds two given polys

    addPoly(Poly object, Poly object) -> Poly object
    """
    if isinstance(poly1,Zero):
        return poly2
    elif isinstance(poly2,Zero):
        return poly1    
    elif isinstance(poly1,Poly) and isinstance(poly2,Poly):
        return mkNonZero(poly1.const+poly2.const, \
                                         addPoly(poly1.poly,poly2.poly))
    else:
        raise TypeError('Not a poly')

def scaleByX(poly):
    """
    Multiplys every term in poly by 'x'

    scaleByX(poly) -> Poly object
    """
    if isinstance(poly,Zero):
        return mkZero()    
    return mkNonZero(0,poly)


def scale(s,poly):
    """
    Multiples every term in poly by 's'

    scale(Int,Poly object) -> Poly Object
    """
    if s==0:
        return mkZero()
    elif isinstance(poly,Zero):
        return mkZero()
    elif isinstance(poly,Poly):
        return mkNonZero(poly.const*s,scale(s,poly.poly))
    else:
        raise TypeError('Not a poly!')

def mulPoly(poly1,poly2):
    """
    Muliples the two given polys

    mulPoly(Poly object, Poly object) -> Poly object
    """
    if isinstance(poly1,Zero) or isinstance(poly2,Zero):
        return mkZero()
    elif isinstance(poly2,Poly):
        return addPoly(scaleByX(mulPoly(poly1.poly,poly2)), \
                                               scale(poly1.const,poly2))
    else:
        raise TypeError('NOT A POLY!')

def powPoly(p,poly):
    """
    Takes a Poly and rasies it to power 'p'

    powPoly(Int,Poly object) -> Poly object
    """
    if p==0:
        return mkNonZero(1,mkZero())
    elif p==1:
        return poly
    else:
        return mulPoly(poly,powPoly(p-1,poly))

def standardize(poly):
    """
    Removes all un-needed terms

    standardize(Poly object) -> Poly object
    """
    if isinstance(poly.poly,Zero):
        return poly
    elif isinstance(poly,Poly):
        new=standardize(poly.poly)
        if isinstance(new,Zero) and poly.const == 0:
            return mkZero()
        else:
            return mkNonZero(poly.const,new)
    else:
        raise TypeError('NOT A POLY!!')
        

def DoMath(poly1,poly2,operation):
    """
    Takes 2 polys and an operation, then run the math

    DoMath(Poly object, Poly object, String) -> Poly object
    """
    if operation == '+':
        return addPoly(poly1,poly2)
    if operation == '*':
        return mulPoly(poly1,poly2)
    if operation[0] == '^':
        poly=input('Which Poly? (Enter A or B): ')
        if poly == 'A':
            print('('+poly2str(poly1)+')'+'**'+str(operation[1]))
        elif poly == 'B':
            print(poly2str(poly2))
        if poly == 'A' or poly == 'a' :
            return powPoly(int(operation[1]),poly1)
        elif poly == 'B'or poly == 'b' :
            return powPoly(int(operation[1]),poly2)
    
def main():
    poly1=polyFromFileName(input('Enter Polynomial A file: '))
    poly2=polyFromFileName(input('Enter Polynomial B file: '))
    print('Allowed operations: "+"-addition, "*"-Mulitplication,' \
                          '"^(Int)"-Raise a poly by power of (Int)')
    operation=input('Enter operation: ')
    if operation=='+' or operation=='*':
        print(' '+poly2str(poly1))
        print(operation+' '+poly2str(poly2))
    print('= '+poly2str(DoMath(poly1,poly2,operation)))

main()
input('Press Enter to close')
