"""
File: puzzle.py
Lang: Python
Name: David Desrochers
"""
from copy import deepcopy

class Tile():
    """
    Class that contains all information about a single
    given tile
    """
    __slots__ = ('north', 'south', 'east', 'west')
    
    def __init__(self,line):
        self.north=line[0]
        self.south=line[1]
        self.east=line[2]
        self.west=line[3]
    
class config():
    """
    Holds an array and the list of tiles available
    """
    __slots__ = ('board', 'tilesNotPlaced')
    
    def __init__(self, board, tiles):
        self.board=board
        self.tilesNotPlaced=tiles
        
def Tilelst(filename, Dim):
    """
    Generates the list of tile objects with the given filename
    """
    file=open(filename)
    lst=[]
    for line in file:
        lst.append(Tile(line.split()))
    file.close()
    if len(lst) != (Dim*Dim):
        raise FileError('Incorrect number of tiles')
    return lst

def InitBoard(Dim, tiles):
    """
    Creats the board full of Nones and the list of tiles
    """
    board=[[None for col in range(Dim)] for row in range(Dim)]
    out=config(board, tiles)
    return out

def isvalid(config):
    """
    Takes a config object and returns boolean if it is valid or invalid
    """
    board=config.board
    if board[0][0] != None and board[0][1] != None:    
        if board[0][0].east != board[0][1].west:
            return False    
    if board[0][1] != None and board[0][2] != None:
        if board[0][1].east != board[0][2].west:
            return False
    if board[1][0] != None and board[0][0] != None:
        if board[1][0].north != board[0][0].south:
            return False
    if board[1][0] != None and board[1][1] != None:
        if board[1][0].east != board[1][1].west:
            return False
    if board[1][1] != None and board[1][2] != None:
        if board[1][1].east != board[1][2].west:
            return False
    if board[1][1] != None and board[0][1] != None:
        if board[1][1].north != board[0][1].south:
            return False
    if board[1][1] != None and board[2][1] != None:
        if board[1][1].south != board[2][1].north:
            return False
    if board[2][0] != None and board[2][1] != None:
        if board[2][0].east != board[2][1].west:
            return False
    if board[2][1] != None and board[2][2] != None:
        if board[2][1].east != board[2][2].west:
            return False
    if board[2][0] != None and board[1][0] != None:
        if board[2][0].north != board[1][0].south:
            return False
    if board[2][2] != None and board[1][2] != None:
        if board[2][2].north != board[1][2].south:
            return False
    if board[1][2] != None and board[0][2] != None:
        if board[1][2].north != board[0][2].south:
            return False
    return True

def successors(config):
    """
    Generates a list of next possible configs
    """
    out=[]
    row = 0
    col = 0
    if config.board[2][2] != None:
        return []
    while config.board[row][col] != None:
        if col < len(config.board)-1:
            col+=1
        else:
            col = 0
            if row < len(config.board)-1:
                row+=1                
    for tile in config.tilesNotPlaced:
        current=deepcopy(config)
        current.board[row][col] = tile
        out.append(current)
    return out

def isGoal(config):
    """
    Checks the current config to see if we are finished
    """
    board = config.board
    for row in board:
        for col in row:
            if col == None:
                return False
    return True

def solve(config):
    """
    Uses backtracking to search for a valid solution
    """
    if isGoal(config):
        return config
    else:
        for config in successors(config):
            if isvalid(config):
                solution = solve(config)
                if solution != None :
                    return solution
        return None

def printConfig(config):
    """
    Takes a config object and prints out the board in a readable manner or 
    no solution if there is no valid solution
    """
    if config == None:
        print('No Solution')
    else:
        board=config.board
        for row in range(3):
            rowText = ''
            for col in range(3):
                if board[row][col] == '.':
                    rowText+='    '
                else:
                    rowText+=' '+board[row][col].north+'  '
            print(rowText)
            rowText=''
            for col in range(3):
                if board[row][col] == '.':
                    rowText+='    '
                else:
                    rowText+=board[row][col].west+' '+board[row][col].east+' '
            print(rowText)
            rowText=''
            for col in range(3):
                if board[row][col] == '.':
                    rowText+='    '
                else:
                    rowText+=' '+board[row][col].south+'  '
            print(rowText)

def main():
    file=str(input('Enter Tile File: '))
    Dim=3
    config=InitBoard(Dim, Tilelst(file, Dim))
    solved=solve(config)
    printConfig(solved)
    
if __name__ == "__main__":
    main()