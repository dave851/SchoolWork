"""
Batch program for the Quoridor game.  

Place this file in the same directory as quoridor.py

Author: Adam Oest (amo9149@rit.edu)
"""

import Engine
import time
import sys
import itertools
import operator
import random
from Engine.config import GlobalConfig
from Engine.config import Config

def main():
    """Run the engine and start the game"""
    
    if len(sys.argv) < 3:
        print("Usage: multiplegames.py player1,player2(,playerx)? games_per_pairing [config_file]")
        sys.exit(0)
    
    players = sys.argv[1].split(",")
    rrPlay = abs(int(sys.argv[2]))
    
    if len(players) != 2:
        print("Exactly 2 players are required")
        sys.exit(0)
        
    # Get config
    if len(sys.argv) < 4:
        cfg = Config(GlobalConfig.DEFAULT_CFG)
    else:
        cfg = Config(sys.argv[3])    
    
    cfg.data['UI'] = False
    cfg.data['STDOUT_LOGGING'] = False
            
    # build player win dictionary
    playerWins = {}
    for player in players:
        if player.strip()in playerWins.keys():
            print("Player names must be unique.  Clone your player module to play against yourself.")
            sys.exit(0)
        playerWins[player.strip()] = 0
       
    # round-robin the players   
    game = 1
    # play all pairings the players   
    while game <= rrPlay:
        pairings = []
        for pairing in itertools.permutations(playerWins.keys(), 2):
            pairings.append(pairing)
        random.shuffle(pairings)
        for pairing in pairings:
            if game <= rrPlay:
                print ("Game: %s Pairing: %s" % (game, pairing))
                cfg.data['PLAYER_MODULES'] = pairing
                s = time.clock()
                winningPlayer, valid = Engine.run(cfg)
                if winningPlayer != False:
                    print ("\tWinner: %s" % (cfg.data['PLAYER_MODULES'][winningPlayer - 1]))
                    playerWins[cfg.data['PLAYER_MODULES'][winningPlayer - 1]] += 1                   
                else:
                    print ("\tNo winner.")
                print ("\tValid players: " + str(valid))
                print ("\tTime: %s seconds." % (time.clock() - s))
                            
                game += 1
    
    # sort dictionary by wins and display rankings
    rank = 1
    for item in sorted(playerWins.items(), key=operator.itemgetter(1), reverse=True):
        print("Rank", rank, "is player", item[0], "with", item[1], "wins.")
        rank += 1
            
if __name__ == "__main__":
    main()
    
#import profile
#profile.run("main()")