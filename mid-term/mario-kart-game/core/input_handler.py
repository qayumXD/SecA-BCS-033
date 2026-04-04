"""
Input Handler - Manages keyboard and gamepad input for up to 4 players.
"""

import pygame
from typing import Dict, List, Tuple


class PlayerInput:
    """Stores input state for a single player."""
    
    def __init__(self):
        """Initialize input state."""
        self.accelerate = False
        self.brake = False
        self.left = False
        self.right = False
        self.use_item = False
        self.drift = False
        self.look_back = False


class InputHandler:
    """Handles input for multiple players with keyboard and gamepad support."""
    
    # Keyboard mappings for 4 players
    KEYBOARD_MAPS = [
        # Player 1 (Arrow keys + RShift/RCtrl)
        {
            'accelerate': pygame.K_UP,
            'brake': pygame.K_DOWN,
            'left': pygame.K_LEFT,
            'right': pygame.K_RIGHT,
            'use_item': pygame.K_RSHIFT,
            'drift': pygame.K_RCTRL,
            'look_back': pygame.K_BACKSPACE
        },
        # Player 2 (WASD + Space/LShift)
        {
            'accelerate': pygame.K_w,
            'brake': pygame.K_s,
            'left': pygame.K_a,
            'right': pygame.K_d,
            'use_item': pygame.K_SPACE,
            'drift': pygame.K_LSHIFT,
            'look_back': pygame.K_TAB
        },
        # Player 3 (IJKL + U/O)
        {
            'accelerate': pygame.K_i,
            'brake': pygame.K_k,
            'left': pygame.K_j,
            'right': pygame.K_l,
            'use_item': pygame.K_u,
            'drift': pygame.K_o,
            'look_back': pygame.K_p
        },
        # Player 4 (Numpad)
        {
            'accelerate': pygame.K_KP8,
            'brake': pygame.K_KP5,
            'left': pygame.K_KP4,
            'right': pygame.K_KP6,
            'use_item': pygame.K_KP0,
            'drift': pygame.K_KP_ENTER,
            'look_back': pygame.K_KP_PERIOD
        }
    ]
    
    def __init__(self):
        """Initialize input handler."""
        self.player_inputs: List[PlayerInput] = [PlayerInput() for _ in range(4)]
        self.keys = pygame.key.get_pressed()
    
    def update(self):
        """Update input states for all players."""
        self.keys = pygame.key.get_pressed()
        
        for player_id, key_map in enumerate(self.KEYBOARD_MAPS):
            if player_id < len(self.player_inputs):
                inp = self.player_inputs[player_id]
                inp.accelerate = self.keys[key_map['accelerate']]
                inp.brake = self.keys[key_map['brake']]
                inp.left = self.keys[key_map['left']]
                inp.right = self.keys[key_map['right']]
                inp.use_item = self.keys[key_map['use_item']]
                inp.drift = self.keys[key_map['drift']]
                inp.look_back = self.keys[key_map['look_back']]
    
    def get_player_input(self, player_id: int) -> PlayerInput:
        """Get input state for specific player."""
        if 0 <= player_id < len(self.player_inputs):
            return self.player_inputs[player_id]
        return PlayerInput()
