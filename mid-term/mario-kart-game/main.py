"""
Mario Kart Racing Game - Main Entry Point
A complete Mario Kart-style racing game with multiplayer, items, and advanced physics.
"""

import pygame
import sys
from core.game import Game


def main():
    """Initialize and run the game."""
    pygame.init()
    
    try:
        game = Game()
        game.run()
    except Exception as e:
        print(f"Fatal error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        pygame.quit()
        sys.exit()


if __name__ == "__main__":
    main()
