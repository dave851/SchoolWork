""" 
file: zigzags
language: python
author: David Desrochers
description: Drawing zigzags recursivly
"""


from turtle import *


def zigzags(n, d):
    """
    Drawns zig-zags of alternating color recurisivly

    n is the depth of recursion, d id the ditance of one line segment

    Pre-condition: Starts at middle of the verticle line
    facing east relitive the part its on.

    Post-condition: Ends in same position as the pre-condition
    """
    
    if n<1:
        pass
        #Stopping condition
    else:
        if n%2==1:
            pencolor('red')
        else:
            pencolor('green')
            #Pen color check, even munbers are green, odds are red
        down()
        rt(90)
        fd(d/2)
        rt(90)
        fd(d)
        lt(45)
        zigzags(n-1, d/2)
        up()
        lt(135)
        fd(d)
        lt(90)
        fd(d)
        rt(90)
        fd(d)
        lt(45)
        zigzags(n-1, d/2)
        if n%2==1:
            pencolor('red')
        else:
            pencolor('green')
            #Second pen color check to prevent writting over with a
            #diffent color.
        down()
        rt(45)
        bk(d)
        rt(90)
        fd(d/2)
        lt(90)

        
n=int(input('Enter Depth of Recursion: '))

title('Zig Zags')

reset()
speed(10)
zigzags(n, 100)


input('Hit Enter to Close')
bye()














