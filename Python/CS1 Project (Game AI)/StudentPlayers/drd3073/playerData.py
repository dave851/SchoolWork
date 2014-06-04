"""
Quoridor II: Student Computer Player

A sample class you may use to hold your state data
Author: Adam Oest (amo9149@rit.edu)
Author: David Desrochers
Author: YOUR NAME HERE (your email address)
Author: YOUR NAME HERE (your email address)
"""

class PlayerData(object):
    """A sample class for your player data"""
    
    # Add other slots as needed
    __slots__ = ('logger', 'playerId', 'playerLocations', 'numPlayers', 'walls', 'board', 'movesmade', 'numWalls')
    
    # make sure endpoints don;t match in midpoint
    #make sure starts don;t match midpoints
    
    def __init__(self, logger, playerId, playerLocations, BOARD_DIM, numWalls):
        """
        __init__: 
        Constructs and returns an instance of PlayerData.
            self - new instance
            logger - the engine logger
            playerId - my player ID (1-4)
            playerLocations - list of player start coordinates
        """
        
        self.logger = logger
        self.playerId = playerId
        self.playerLocations = playerLocations
        self.numPlayers = len(playerLocations)
        self.walls={}
        self.board=buildboard(BOARD_DIM)
        self.movesmade=[0 for i in range(len(playerLocations))]
        self.numWalls=[numWalls for i in range(self.numPlayers)]
        # initialize any other slots you require here
        
    def __str__(self):
        """
        __str__: PlayerData -> string
        Returns a string representation of the PlayerData object.
            self - the PlayerData object
        """
        result = "PlayerData= " \
                    + "playerId: " + str(self.playerId) \
                    + ", playerLocations: " + str(self.playerLocations) \
                    + ", numPlayers:" + str(self.numPlayers)
                
        # add any more string concatenation for your other slots here
                
        return result

def buildboard(dim):
    """
    Builds a board without any walls
    """
    board={}
    r=0
    while r in range(dim):
        c=0
        while c in range(dim):
            board[r,c]= []
            if r+1 < dim:
                board[r,c].append([r+1,c])
            if r-1 < dim and r-1 >= 0:
                board[r,c].append([r-1,c])
            if c+1 < dim:
                board[r,c].append([r,c+1])
            if c-1 < dim and c-1 >= 0:
                board[r,c].append([r,c-1])
            c+=1
        r+=1
    return board

def buildWallSet(dim):
    out=[]
    r=0
    while r in range(dim):
        c=0
        while c in range(dim):
            out.append([r,c])
            c+=1
        r+=1
    return out
    