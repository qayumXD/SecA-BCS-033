"""
Main Game Class - Handles game loop, scene management, and core systems.
"""

import pygame
import json
from pathlib import Path
from core.scene_manager import SceneManager
from core.input_handler import InputHandler
from utils.asset_loader import AssetLoader


class Game:
    """Main game controller with fixed timestep game loop."""
    
    def __init__(self):
        """Initialize game systems and load configuration."""
        # Load configuration
        config_path = Path(__file__).parent.parent / "config.json"
        with open(config_path, 'r') as f:
            self.config = json.load(f)
        
        # Setup display
        self.screen_width = self.config['game']['screen_width']
        self.screen_height = self.config['game']['screen_height']
        self.screen = pygame.display.set_mode((self.screen_width, self.screen_height))
        pygame.display.set_caption(self.config['game']['title'])
        
        # Game systems
        self.clock = pygame.time.Clock()
        self.fps = self.config['game']['fps']
        self.dt = 1.0 / self.fps  # Fixed timestep
        self.running = True
        
        # Initialize subsystems
        self.asset_loader = AssetLoader()
        self.input_handler = InputHandler()
        self.scene_manager = SceneManager(self)
        
        # Performance tracking
        self.frame_count = 0
        self.accumulator = 0.0
        
    def run(self):
        """Main game loop with fixed timestep."""
        last_time = pygame.time.get_ticks() / 1000.0
        
        while self.running:
            # Calculate delta time
            current_time = pygame.time.get_ticks() / 1000.0
            frame_time = current_time - last_time
            last_time = current_time
            
            # Cap frame time to prevent spiral of death
            if frame_time > 0.25:
                frame_time = 0.25
            
            self.accumulator += frame_time
            
            # Handle events
            self.handle_events()
            
            # Fixed timestep updates
            while self.accumulator >= self.dt:
                self.update(self.dt)
                self.accumulator -= self.dt
            
            # Render with interpolation factor
            alpha = self.accumulator / self.dt
            self.render(alpha)
            
            # Cap framerate
            self.clock.tick(self.fps)
            self.frame_count += 1
    
    def handle_events(self):
        """Process all pygame events."""
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    self.scene_manager.handle_escape()
            
            # Pass event to current scene
            self.scene_manager.handle_event(event)
        
        # Update input handler state
        self.input_handler.update()
    
    def update(self, dt: float):
        """Update game logic with fixed timestep."""
        self.scene_manager.update(dt)
    
    def render(self, alpha: float):
        """Render current frame with interpolation."""
        self.screen.fill((0, 0, 0))
        self.scene_manager.render(self.screen, alpha)
        pygame.display.flip()
    
    def quit(self):
        """Gracefully shutdown the game."""
        self.running = False
