"""
Camera System - Handles viewport and split-screen rendering.
"""

import pygame
from typing import Tuple, Optional
from entities.kart import Kart


class Camera:
    """Camera that follows a kart with smooth interpolation."""
    
    def __init__(self, viewport: pygame.Rect, track_width: int, track_height: int):
        """
        Initialize camera.
        
        Args:
            viewport: Screen area this camera renders to
            track_width: Total track width in pixels
            track_height: Total track height in pixels
        """
        self.viewport = viewport
        self.track_width = track_width
        self.track_height = track_height
        
        # Camera position (center of view)
        self.x = 0.0
        self.y = 0.0
        
        # Target to follow
        self.target: Optional[Kart] = None
        
        # Smooth following
        self.smoothness = 0.1
        self.offset_y = -50  # Camera slightly ahead of kart
        
        # Zoom
        self.zoom = 1.0
        self.target_zoom = 1.0
    
    def set_target(self, kart: Kart):
        """Set the kart this camera should follow."""
        self.target = kart
        if kart:
            self.x = kart.x
            self.y = kart.y
    
    def update(self, dt: float):
        """Update camera position to follow target."""
        if not self.target:
            return
        
        # Calculate target position
        target_x = self.target.x
        target_y = self.target.y + self.offset_y
        
        # Smooth interpolation
        self.x += (target_x - self.x) * self.smoothness
        self.y += (target_y - self.y) * self.smoothness
        
        # Clamp to track bounds
        half_width = self.viewport.width / (2 * self.zoom)
        half_height = self.viewport.height / (2 * self.zoom)
        
        self.x = max(half_width, min(self.x, self.track_width - half_width))
        self.y = max(half_height, min(self.y, self.track_height - half_height))
        
        # Smooth zoom
        self.zoom += (self.target_zoom - self.zoom) * 0.05
    
    def world_to_screen(self, world_x: float, world_y: float) -> Tuple[int, int]:
        """Convert world coordinates to screen coordinates."""
        screen_x = (world_x - self.x) * self.zoom + self.viewport.width / 2 + self.viewport.x
        screen_y = (world_y - self.y) * self.zoom + self.viewport.height / 2 + self.viewport.y
        return int(screen_x), int(screen_y)
    
    def screen_to_world(self, screen_x: int, screen_y: int) -> Tuple[float, float]:
        """Convert screen coordinates to world coordinates."""
        world_x = (screen_x - self.viewport.x - self.viewport.width / 2) / self.zoom + self.x
        world_y = (screen_y - self.viewport.y - self.viewport.height / 2) / self.zoom + self.y
        return world_x, world_y
    
    def apply(self, surface: pygame.Surface) -> pygame.Surface:
        """
        Create a subsurface for this camera's viewport.
        
        Args:
            surface: Main screen surface
            
        Returns:
            Subsurface for this camera's viewport
        """
        return surface.subsurface(self.viewport)


class SplitScreenManager:
    """Manages multiple cameras for split-screen multiplayer."""
    
    def __init__(self, screen_width: int, screen_height: int, num_players: int):
        """
        Initialize split-screen manager.
        
        Args:
            screen_width: Total screen width
            screen_height: Total screen height
            num_players: Number of players (1-4)
        """
        self.screen_width = screen_width
        self.screen_height = screen_height
        self.num_players = num_players
        self.cameras: List[Camera] = []
        
        self._setup_viewports()
    
    def _setup_viewports(self):
        """Setup camera viewports based on player count."""
        self.cameras.clear()
        
        if self.num_players == 1:
            # Full screen
            viewport = pygame.Rect(0, 0, self.screen_width, self.screen_height)
            self.cameras.append(Camera(viewport, 3000, 3000))
        
        elif self.num_players == 2:
            # Horizontal split
            h = self.screen_height // 2
            viewport1 = pygame.Rect(0, 0, self.screen_width, h)
            viewport2 = pygame.Rect(0, h, self.screen_width, h)
            self.cameras.append(Camera(viewport1, 3000, 3000))
            self.cameras.append(Camera(viewport2, 3000, 3000))
        
        elif self.num_players == 3:
            # Top half full, bottom half split
            h = self.screen_height // 2
            w = self.screen_width // 2
            viewport1 = pygame.Rect(0, 0, self.screen_width, h)
            viewport2 = pygame.Rect(0, h, w, h)
            viewport3 = pygame.Rect(w, h, w, h)
            self.cameras.append(Camera(viewport1, 3000, 3000))
            self.cameras.append(Camera(viewport2, 3000, 3000))
            self.cameras.append(Camera(viewport3, 3000, 3000))
        
        elif self.num_players == 4:
            # Quad split
            h = self.screen_height // 2
            w = self.screen_width // 2
            viewports = [
                pygame.Rect(0, 0, w, h),
                pygame.Rect(w, 0, w, h),
                pygame.Rect(0, h, w, h),
                pygame.Rect(w, h, w, h)
            ]
            for vp in viewports:
                self.cameras.append(Camera(vp, 3000, 3000))
    
    def get_camera(self, player_id: int) -> Optional[Camera]:
        """Get camera for specific player."""
        if 0 <= player_id < len(self.cameras):
            return self.cameras[player_id]
        return None
    
    def update(self, dt: float):
        """Update all cameras."""
        for camera in self.cameras:
            camera.update(dt)
