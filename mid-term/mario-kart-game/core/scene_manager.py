"""
Scene Manager - Handles transitions between game scenes.
Scenes: Title → Character Select → Cup Select → Race → Results
"""

import pygame
from typing import Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from core.game import Game


class Scene:
    """Base scene class."""
    
    def __init__(self, game: 'Game'):
        """Initialize scene with game reference."""
        self.game = game
        self.next_scene: Optional[str] = None
    
    def enter(self):
        """Called when scene becomes active."""
        pass
    
    def exit(self):
        """Called when scene is being left."""
        pass
    
    def handle_event(self, event: pygame.event.Event):
        """Handle pygame events."""
        pass
    
    def update(self, dt: float):
        """Update scene logic."""
        pass
    
    def render(self, screen: pygame.Surface, alpha: float):
        """Render scene."""
        pass


class SceneManager:
    """Manages scene transitions and current active scene."""
    
    def __init__(self, game: 'Game'):
        """Initialize scene manager."""
        self.game = game
        self.scenes = {}
        self.current_scene: Optional[Scene] = None
        self.scene_stack = []
        
        # Import and register scenes
        self._register_scenes()
        
        # Start with title scene
        self.change_scene('title')
    
    def _register_scenes(self):
        """Register all available scenes."""
        from ui.menu import TitleScene, CharacterSelectScene, CupSelectScene
        from ui.results import ResultsScene
        
        # Lazy import to avoid circular dependencies
        self.scene_classes = {
            'title': TitleScene,
            'character_select': CharacterSelectScene,
            'cup_select': CupSelectScene,
            'race': None,  # Will be imported when needed
            'results': ResultsScene
        }
    
    def change_scene(self, scene_name: str, **kwargs):
        """Change to a new scene."""
        # Exit current scene
        if self.current_scene:
            self.current_scene.exit()
        
        # Create new scene
        if scene_name == 'race':
            from tracks.track import RaceScene
            self.current_scene = RaceScene(self.game, **kwargs)
        else:
            scene_class = self.scene_classes.get(scene_name)
            if scene_class:
                self.current_scene = scene_class(self.game, **kwargs)
            else:
                raise ValueError(f"Unknown scene: {scene_name}")
        
        # Enter new scene
        self.current_scene.enter()
    
    def handle_escape(self):
        """Handle escape key press."""
        if self.current_scene:
            # Return to title from most scenes
            if not isinstance(self.current_scene, TitleScene):
                self.change_scene('title')
    
    def handle_event(self, event: pygame.event.Event):
        """Forward event to current scene."""
        if self.current_scene:
            self.current_scene.handle_event(event)
    
    def update(self, dt: float):
        """Update current scene."""
        if self.current_scene:
            self.current_scene.update(dt)
            
            # Check for scene transition
            if self.current_scene.next_scene:
                next_scene = self.current_scene.next_scene
                scene_data = getattr(self.current_scene, 'scene_data', {})
                self.change_scene(next_scene, **scene_data)
    
    def render(self, screen: pygame.Surface, alpha: float):
        """Render current scene."""
        if self.current_scene:
            self.current_scene.render(screen, alpha)


# Import here to avoid circular dependency
from ui.menu import TitleScene
