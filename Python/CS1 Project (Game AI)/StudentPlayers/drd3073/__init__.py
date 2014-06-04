"""
Quoridor student player starter file
 
Author: Adam Oest
Author: David Desrochers <drd3073@rit.edu>
Author: Jonathan Davis <jmd3177@rit.edu>
Date: July, 2012
"""

# If you get this error checked for in the code that follows
# this comment, either run quoridor.py or
# create a new file in the same directory as quoridor.py,
# in which you import your module and call your own functions
# for testing purposes
if __name__ == "__main__":
    import sys
    sys.stderr.write("You cannot run this file on its own.")
    sys.exit()

# Imports the player move class as well as the board size constant
from Model.interface import PlayerMove, BOARD_DIM
from .playerData import PlayerData
from .myQueue import *
from .myStack import push, pop, emptyStack, Stack, top
from copy import deepcopy

def init(logger, playerId, numWalls, playerHomes):
    """
        Part 1 - 4
    
        The engine calls this function once at the beginning of the game.
        The student player module uses this function to initialize its data
        structures to the initial game state.

        Parameters
            logger: a reference to the logger object. The player model uses
                logger.write(msg) and logger.error(msg) to log diagnostic
                information.
                
            playerId: this player's number, from 1 to 4
        
            numWalls: the number of walls each player is given initially
            
            playerHomes: An ordered tuple of player locations
                         A location is a 2-element tuple of (row,column).
                         If any player has already been eliminated from
                         the game (rare), there will be a bool False in
                         that player's spot in the tuple instead of a
                    
        returns:
            a PlayerData object containing all of this player module's data
    """
    # This is where you must initialize all the information in your PlayerData
    # object. It should store things like how many players and initial
    # configuration of the board.
    #
    # Sample code body
    #
    # In the example code body below, the PlayerData class contained in the
    # file playerData.py is just used as an example. Feel free to alter it.
    # Just make sure it contains everything you need.
    playerData = PlayerData(logger, playerId, list(playerHomes), BOARD_DIM, numWalls)
    return playerData

def last_move(playerData, move):
    """
        Parts 1 - 4
    
        The engine calls this function after any player module, including this one,
        makes a valid move in the game.
        
        The engine also calls this function repeatedly at the start of the game if
        there have been some moves specified in the configuration file's PRE_MOVE
        variable.

        The student player module updates its data structure with the information
        about the move.

        Parameters
            playerData: this player's data, originally built by this
                        module in init()
        
            move: the instance of PlayerMove that describes the move just made
        
        returns:
            this player module's updated (playerData) data structure
    """
    
    # Update your playerData object with the latest move.
    # Remember that this code is called even for your own moves.
    if move.move== True:
        playerData.playerLocations[move.playerId-1]=(move.r2,move.c2)
    if move.move== False:
        if move.r1==move.r2:
            playerData.board[(move.r1-1,move.c1)].remove([move.r1,move.c1])
            playerData.board[(move.r1-1,move.c1+1)].remove([move.r1,move.c1+1])
            playerData.board[(move.r1,move.c1)].remove([move.r1-1,move.c1])
            playerData.board[(move.r1,move.c1+1)].remove([move.r1-1,move.c1+1])
            midpoint = (move.r1,move.c1+1)
            playerData.walls[midpoint]=[(move.r1,move.c1),(move.r2,move.c2)]
        if move.c1==move.c2:
            playerData.board[(move.r1,move.c1-1)].remove([move.r1,move.c1])
            playerData.board[(move.r1,move.c1)].remove([move.r1,move.c1-1])
            playerData.board[(move.r1+1,move.c1-1)].remove([move.r1+1,move.c1])
            playerData.board[(move.r1+1,move.c1)].remove([move.r1+1,move.c1-1])
            midpoint = (move.r1+1,move.c1)
            playerData.walls[midpoint]=[(move.r1,move.c1),(move.r2,move.c2)]
        playerData.numWalls[move.playerId-1]-=1
    playerData.movesmade[move.playerId-1]+=1
    return playerData

def get_neighbors(playerData, r, c):
    """
        Part 1
    
        This function is used only in part 1 mode. The engine calls it after
        all PRE_MOVEs have been made. (See the config.cfg file.)

        Parameters
            playerData: this player's data, originally built by this
                        module in init()
            r: row coordinate of starting position for this player's piece
            c: column coordinate of starting position for this player's piece
        
        returns:
            a list of coordinate pairs (a list of lists, e.g. [[0,0], [0,2]],
            not a list of tuples) denoting all the reachable neighboring squares
            from the given coordinate. "Neighboring" means exactly one move
            away.
    """
    
    # Use your playerData object to get a list of neighbors    
    return playerData.board[(r,c)]

def get_shortest_path(playerData, source, destination):
    """
        Part 1
    
        This function is only called in part 1 mode. The engine calls it when
        a shortest path is requested by the user via the graphical interface.

        Parameters
            playerData: this player's data, originally built by this
                        module in init()
            r1: row coordinate of starting position
            c1: column coordinate of starting position
            r2: row coordinate of destination position
            c2: column coordinate of destination position
        
        returns:
            a sequence of coordinate tuples that form the shortest path
            from the starting position to the destination, inclusive.
            The format is a tuple or list of coordinate pairs (row,column)
            ordered from starting position to destination position.
            An example would be [(0,0), (0,1), (1,1)].
            If there is no path, an empty list, [], should be returned.
    """
    
    # Use your playerData object to find a shortest path using breadth-first
    # search (BFS).
    # You will probably find the get_neighbors function helpful.
    dispenser = Queue()
    enqueue(source, dispenser)
    pred={}
    pred[source]= None
    while not emptyQueue(dispenser):
        current= front(dispenser)
        dequeue(dispenser)
        if current in destination:
            destination=current
            break
        for neighbor in playerData.board[current]:
            neighbor= (neighbor[0],neighbor[1])
            if neighbor not in pred:
                pred[neighbor]= current
                enqueue(neighbor, dispenser)
    return constructPath(pred, source, destination)

def constructPath(pred, source, destination):
    """
    Sub Function of get_shortest_path that returns the path of moves for the inputed player
    """
    stack=Stack()
    path=[]
    if isinstance(destination, set):
        for point in destination:
            if point in pred:
                temp= destination
                while temp != source:
                    push(temp, stack)
                    temp=pred[temp]
                while not emptyStack(stack):
                    path.append(top(stack))
                    pop(stack)
    else:
        if destination in pred:
                temp= destination
                while temp != source:
                    push(temp, stack)
                    temp=pred[temp]
                while not emptyStack(stack):
                    path.append(top(stack))
                    pop(stack)      
    return path

def Checkrow(BOARD_DIM, playerId):
    """
    Build the set to represent the top row
    """
    if playerId == 1:            
        s=set()
        for col in range(BOARD_DIM):
            s.add((0,col))
        return s
    if playerId == 2:            
            s=set()
            for col in range(BOARD_DIM):
                s.add((8,col))
            return s
    if playerId == 3:            
            s=set()
            for row in range(BOARD_DIM):
                s.add((row,8))
            return s
    if playerId == 4:            
            s=set()
            for row in range(BOARD_DIM):
                s.add((row, 0))
            return s
    
def move(playerData):
    """
        Parts 2 - 4
    
        The engine calls this function at each moment when it is this
        player's turn to make a move. This function decides what kind of
        move, wall placement or piece move, to make.
        
        Parameters
            playerData: this player's data, originally built by this
                        module in init()
        
        returns:
            the move chosen, in the form of an instance of PlayerMove
    """
    
    # This function is called when it's your turn to move
        
    # Here you'll figure out what kind of move to make and then return that
    # move. We recommend that you don't update your data structures here,
    # but rather in last_move. If you do it here, you'll need a special case
    # check in last_move to make sure you don't update your data structures
    # twice.
        
    # In part 3, any legal move is acceptable. In part 4, you will want to
    # implement a strategy
    paths=[]
    iD=1
    for key in playerData.playerLocations:
        if key == False:
            paths.append(True)
        else:
            paths.append(len(get_shortest_path(playerData, key, Checkrow(BOARD_DIM, iD))))
        iD+=1
    OurPath=paths[playerData.playerId-1]
    if OurPath <= 1:
        return PwnMove(playerData)      
    if OurPath <= min(paths):
        return PwnMove(playerData)
    elif playerData.numWalls[playerData.playerId-1] > 0:
        return wallMove(playerData)
    return PwnMove(playerData)
 
def wallMove(playerData):
    """
    Returns a move object given the playerData object
    """
    paths=[]
    iD=1
    for key in playerData.playerLocations:
        if key == False:
            paths.append(9999999)
        elif key == playerData.playerLocations[playerData.playerId-1]:
            paths.append(9999999)
        else:
            paths.append(len(get_shortest_path(playerData, key, Checkrow(BOARD_DIM, iD))))
        iD+=1
    lowId=paths.index(min(paths))
    AttackP=get_shortest_path(playerData, playerData.playerLocations[lowId], Checkrow(BOARD_DIM, lowId+1))
    r1=AttackP[0][0]
    c1=AttackP[0][1]
    moveL=[]
    i=0
    while i < 3:
        moveL.append(PlayerMove(playerData.playerId, False, r1, c1, r1+2, c1))
        moveL.append(PlayerMove(playerData.playerId, False, r1, c1, r1, c1+2))
        moveL.append(PlayerMove(playerData.playerId, False, r1, c1, r1-2, c1))
        moveL.append(PlayerMove(playerData.playerId, False, r1, c1, r1, c1-2))
        if i == 0:
            r1-=1
        if i == 1:
            c1+=1
        if i == 2:
            r1+=1
        i+=1
    moves={}
    for move in moveL:
        if ValidWall(playerData, move.r1, move.c1, move.r2, move.c2):
            if not(isBlock(playerData, move)):
                data=PlayerData(playerData.logger,deepcopy(playerData.playerId), deepcopy(playerData.playerLocations), BOARD_DIM, deepcopy(playerData.numWalls))
                data.walls=deepcopy(playerData.walls)
                data.board=deepcopy(playerData.board)
                data.movesmade=deepcopy(playerData.movesmade)
                data.numWalls=deepcopy(playerData.numWalls)
                last_move(data, move)
                score=0
                iD=1
                for key in playerData.playerLocations:
                    if key == False:
                        pass
                    elif key == playerData.playerLocations[playerData.playerId-1]:
                        pass
                    else:
                        score+=len(get_shortest_path(data, key, Checkrow(BOARD_DIM, iD)))
                    iD+=1
                moves[score] = move
    best=None
    for key in moves:
        if best == None or key > best:
            best = key
    if best == None:
        return PwnMove(playerData)
    data=PlayerData(playerData.logger,deepcopy(playerData.playerId), deepcopy(playerData.playerLocations), BOARD_DIM, deepcopy(playerData.numWalls))
    data.walls=deepcopy(playerData.walls)
    data.board=deepcopy(playerData.board)
    data.movesmade=deepcopy(playerData.movesmade)
    data.numWalls=deepcopy(playerData.numWalls)
    last_move(data, moves[best])
    befor = len(AttackP)
    after = len(get_shortest_path(data, playerData.playerLocations[lowId], Checkrow(BOARD_DIM, lowId+1)))
    if after <= befor:
        return PwnMove(playerData)
    return moves[best]
    
def PwnMove(playerData):
    """
    Takes in PlayerData config and returns the next move the pawn should make along the shortest path
    deals with jump rules
 
    PwnMove(playerData object) -> move object
    """
    r1=playerData.playerLocations[playerData.playerId-1][0]
    c1=playerData.playerLocations[playerData.playerId-1][1]
    path = get_shortest_path(playerData, (r1,c1), Checkrow(BOARD_DIM, playerData.playerId))
    neighbors = get_neighbors(playerData, playerData.playerLocations[playerData.playerId-1][0], playerData.playerLocations[playerData.playerId-1][1])
    move = PlayerMove(playerData.playerId, True, r1, c1, path[0][0], path[0][1])
    if path[0] in playerData.playerLocations:
        otherPL = get_neighbors(playerData, path[0][0], path[0][1])
        validN=deepcopy(otherPL)           
        for cell in otherPL: 
            if (cell[0],cell[1]) in playerData.playerLocations:
                validN.remove(cell)
        if len(path) > 1:
            if [path[1][0],path[1][1]] in otherPL and not(path[1] in playerData.playerLocations):
                rowj=None
                colj=None
                Up = None
                Left = None
                if [r1+2,c1] in validN:
                    rowj=get_shortest_path(playerData, (r1+2,c1), Checkrow(BOARD_DIM, playerData.playerId))
                    Up = False
                if [r1, c1+2] in validN:
                    colj=get_shortest_path(playerData, (r1,c1+2), Checkrow(BOARD_DIM, playerData.playerId))
                    Left = False
                if [r1-2,c1] in validN:
                    rowj=get_shortest_path(playerData, (r1-2,c1), Checkrow(BOARD_DIM, playerData.playerId))
                    Up = True
                if [r1, c1-2] in validN:
                    colj=get_shortest_path(playerData, (r1,c1-2), Checkrow(BOARD_DIM, playerData.playerId))
                    Left = True
                if colj == None and rowj == None:
                    return PlayerMove(playerData.playerId, True, r1, c1, path[1][0], path[1][1])
                if colj != None:
                    if Left:
                        return PlayerMove(playerData.playerId, True, r1, c1, r1, c1-2)
                    else:
                        return PlayerMove(playerData.playerId, True, r1, c1, r1, c1+2)
                if rowj != None:
                    if Up:
                        return PlayerMove(playerData.playerId, True, r1, c1, r1-2, c1)
                    else:
                        return PlayerMove(playerData.playerId, True, r1, c1, r1+2, c1)
        if validN != []:
            min=None
            for tile in validN:
                current = get_shortest_path(playerData, (tile[0], tile[1]), Checkrow(BOARD_DIM, playerData.playerId))
                if min == None or len(current) < len(min):
                    min = current
            move = PlayerMove(playerData.playerId, True, r1, c1, min[0][0], min[0][1])
        elif validN == [] and playerData.numWalls[playerData.playerId-1] <= 0:
            move = PlayerMove(playerData.playerId, True, r1, c1, r1, c1)
        elif validN == []:
            move = wallMove(playerData)
    return move 
        
def ValidWall(playerData, r1, c1, r2, c2):
    """
    Returns a boolean if a wall placement is not overlapping
    another wall or off the board
    """
    if not(r1 == r2 or c1 == c2):
        return False
    if r1 == 0 and r2 == 0:
        return False
    if r1 == BOARD_DIM or r2 == BOARD_DIM:
        return False    
    if c1 == 0 and c2 == 0:
        return False
    if c1 == BOARD_DIM or c2 == BOARD_DIM:
        return False
    if r1 < 0 or c1 < 0 :
        return False
    if r2 < 0 or c2 < 0 :
        return False
    if r1 > BOARD_DIM or c1 > BOARD_DIM:
        return False
    if r2 > BOARD_DIM or c2 > BOARD_DIM:
        return False
    if r1 == r2:
        if c2-c1 != 2:
            return False
        midpoint = (r1,c1+1)
    elif c1 == c2:
        if r2-r1 != 2:
            return False
        midpoint = (r1+1, c1)      
    if midpoint in playerData.walls:
        return False
    if (r1,c1) in playerData.walls or (r2,c2) in playerData.walls:
        if (r1,c1) in playerData.walls:
            for key in playerData.walls[(r1,c1)]:
                if key == midpoint:
                    return False
        if (r2,c2) in playerData.walls:
            for key in playerData.walls[(r2,c2)]:
                if key == midpoint:
                    return False
    return True

def isBlock(playerData, move):
    """
    Returns a boolean if the move object will cause the player
    to be blocked in
    """
    data=PlayerData(playerData.logger,deepcopy(playerData.playerId), deepcopy(playerData.playerLocations), BOARD_DIM, deepcopy(playerData.numWalls))
    data.walls=deepcopy(playerData.walls)
    data.board=deepcopy(playerData.board)
    data.movesmade=deepcopy(playerData.movesmade)
    data.numWalls=deepcopy(playerData.numWalls)
    last_move(data, move)
    iD=1
    for key in data.playerLocations:
        if key == False:
            iD+=1
        else:
            path=get_shortest_path(data, key, Checkrow(BOARD_DIM, iD))
            if get_shortest_path(data, key, Checkrow(BOARD_DIM, iD)) == []:
                return True
            iD+=1
    return False

def player_invalidated(playerData, playerId):
    """
        Part 3 - 4
    
        The engine calls this function when another player has made
        an invalid move or has raised an exception ("crashed").
        
        Parameters
            playerData: this player's data, originally built by this
                        module in init()
            playerId: the ID of the player being invalidated
        
        returns:
            this player's updated playerData
    """
    
    # Update your player data to reflect the invalidation.
    # FYI, the player's piece is removed from the board,
    # but not its walls.
    
    playerData.playerLocations[playerId-1]=False
    
    # When you are working on part 4, there is a small chance you'd
    # want to change your strategy when a player is kicked out.
    
    return playerData