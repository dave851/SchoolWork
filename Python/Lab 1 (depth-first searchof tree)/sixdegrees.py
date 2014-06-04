"""
Name: David Desrochers
lab 1: Six Degrees of Kevin Bacon
Language: Python
"""

# Modifyed Lecture code
"""
    Constructs a graph from a file and computes a path for
    user-specified start and end points using depth-first search.

Definition:
    Graph : A graph is a dictionary that maps node names to Nodes.

file: routing.py
Author: Zack Butler
Author: ben k steele
Author: Sean Strout (sps@cs.rit.edu)
"""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# data structures
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

class Node():
    """
     Node represents a node in a graph using adjacency lists.
         Node.name is a String.
         Node.neighbors is a ListOfNode.
    """
    __slots__ = ( 'name', 'neighbors' )
    
    def __init__( self, name ):
        """
        __init__: Node * String -> None
        Constructs a node object with the given name and no neighbors.
        """
        self.name = name
        self.neighbors = []
        
    def __str__( self ):
        """
        __str__ : Node -> String
        Returns a string with the name of the node and its neighbors' names.
        """
        result = str( self.name ) + ': '
        if len( self.neighbors ) > 0:
            for i in range( len( self.neighbors ) - 1 ): # last is different
                result += str( self.neighbors[i].name ) + ', '
            result += str( self.neighbors[-1].name )   # -1 index accesses last 
        return result
        
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# utility functions
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

def loadGraph( filename ):
    """
     loadGraph : String -> dict( String:Node )
     Loads graph data from the file with the given name.  loadGraph assumes 
     that each line starts with the name of a movie as one word and the actors First and last name following.
     loadGraph forms edges in both directions between the moive and actors.
     loadGraph creates Node instances as needed and returns a list of nodes 
     representing the graph.
     Pre-conditions: file content is well-formed, containing Movie title as one word whith actors first and last 
     name following. 
    """
    graph = {}
    for line in open( filename ):
        contents = line.split()
        if contents[0] not in graph:
            Movie = Node( contents[0] )
            graph[contents[0]] = Movie
        else:
            Movie = graph[contents[0]]
        if len(contents) > 2: 
            Actors=contents[1:]
        else:
            raise TypeError('Improper Text File')
        while len(Actors) > 1:
            currA=Actors[0]+' '+Actors[1]
            if currA not in graph:
                ActorNode = Node(currA)
                graph[currA] = ActorNode
            else:
                ActorNode = graph[currA]
            if ActorNode not in Movie.neighbors:
                Movie.neighbors.append( ActorNode )
            if Movie not in ActorNode.neighbors:
                ActorNode.neighbors.append( Movie )
            Actors = Actors[2:]
    return graph

def printGraph( graph ):
    """
     printGraph : dict( String:Node ) -> None
     Prints a graph by simply printing each of its nodes.
    """
    for Node in graph:
        print( graph[Node] )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# phase 1: algorithm to see if it is possible to reach the finish.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

def visitDFS(  node, visited ):
    """
     visitDFS : Node ListOfNode -> None
     visitDFS visits all the neighbors of node in a depth-first fashion.
     effect: visited list grows as function recurses.
    """
    if not isinstance(  node, Node ):
        raise TypeError(  node, "is not a valid graph node." )

    for neighbor in node.neighbors:
        if not neighbor in visited:
            visited.append(  neighbor )
            visitDFS(  neighbor, visited )

def canReachDFS(  start, finish ):
    """
     canReachDFS : Node Node -> Boolean
     canReachDFS returns whether or not finish is reachable from start.
     A Node is reachable from a start location if and only if both
     nodes are in the same connected component of the graph.
    """
    visited = [start]
    visitDFS(  start, visited )     # auxiliary, recursive function.
    return finish in visited 


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# phase 2: algorithm to build a path from the start to the finish.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

def buildPathDFS(  start, finish, visited ):
    """
     buildPathDFS : Node, Node, ListOfNode -> ListOfNode
     Takes two Node objects representing the start and finish in a graph,
     along with a list of nodes visited, 
     and searches to produce a list of nodes forming a path.
     The list contains only the start node if there is no path.
     effect: visited list grows as function recurses.
    """
    if start == finish :          # Node equality
        return [start]
    for neigh in start.neighbors:
        if not neigh in visited:
            visited.append(  neigh )
            path = buildPathDFS(  neigh, finish, visited )
            if path != None:
                return [start] + path


def printPathDFS(  start, finish ):
    """
     printPathDFS : Node Node -> None
     printPathDFS performs a depth-first search given a start and finish,
     and prints the resulting path.
     effect: prints the path found or the message "No path exists."
    """
    # start node needs to be marked as visited when we start
    visited = [start]

    # By passing in a named visited list, we can see the
    # final status of the visited list when the search is complete.
    path = buildPathDFS( start, finish, visited ) # auxiliary recursive func.

    if path == None or len(path) > 6:
        print(  "No path exists or path is over 3 links." )
    else:
        #print(path)
        i=0
        while i in range(len(path)):
            if i%2 == 0:
                print(  " ", path[i].name )
            elif i%2 == 1:
                print('  was in', path[i].name, 'with')
            i=i+1


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# main program
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

def main():
    """
     main : None -> None
     The program prompts for a graph file, builds the graph,
     prompts for a start and a finish node name, and
     prints the resulting path.
    """
    # read in the data:
    fname = input( 'Enter Movie data filename: ' )
    if fname == '':
        return
    graph = loadGraph( fname )

    printGraph( graph )

    # get start and finish from the user
    startName = input( 'Enter starting Actors name: ' )
    if startName not in graph:
        raise ValueError( startName + ' not in Movie!' )
    start = graph[startName]
   
    finishName =  input( 'Enter finish Actors name: ' )
    if finishName not in graph:
        raise ValueError( finishName + ' not in Movie!' )
    finish = graph[finishName]

    # proceed only if start and finish are valid Node instances

    if isinstance( start, Node ) and isinstance( finish, Node ):

        print( 'Looking for link: ' )
        if canReachDFS(  start, finish ):
            print( 'Link from ', start.name, 'to', finish.name, 'found!')

        # now get the path
        printPathDFS(  start, finish )
    else:
        print( 'Either start or finish are not in the graph.' )

# # run the program
if __name__ == "__main__":
    main()