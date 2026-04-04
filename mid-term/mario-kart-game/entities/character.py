"""
Character System - Defines playable characters with unique stats.
"""

from typing import Dict
from dataclasses import dataclass


@dataclass
class CharacterStats:
    """Character statistics that affect kart performance."""
    speed: int
    acceleration: int
    handling: int
    weight: int
    mini_turbo: int


class Character:
    """Represents a playable character."""
    
    # Character definitions
    CHARACTERS = {
        'mario': {'name': 'Mario', 'color': (255, 0, 0)},
        'luigi': {'name': 'Luigi', 'color': (0, 200, 0)},
        'peach': {'name': 'Peach', 'color': (255, 182, 193)},
        'yoshi': {'name': 'Yoshi', 'color': (0, 255, 0)},
        'bowser': {'name': 'Bowser', 'color': (255, 140, 0)},
        'toad': {'name': 'Toad', 'color': (255, 0, 255)},
        'donkey_kong': {'name': 'Donkey Kong', 'color': (139, 69, 19)},
        'rosalina': {'name': 'Rosalina', 'color': (135, 206, 250)}
    }
    
    def __init__(self, character_id: str, stats: Dict[str, int]):
        """
        Initialize character.
        
        Args:
            character_id: Character identifier (e.g., 'mario')
            stats: Dictionary of character stats
        """
        self.id = character_id
        self.name = self.CHARACTERS[character_id]['name']
        self.color = self.CHARACTERS[character_id]['color']
        
        self.stats = CharacterStats(
            speed=stats['speed'],
            acceleration=stats['acceleration'],
            handling=stats['handling'],
            weight=stats['weight'],
            mini_turbo=stats['mini_turbo']
        )
    
    @classmethod
    def get_all_characters(cls) -> List[str]:
        """Get list of all character IDs."""
        return list(cls.CHARACTERS.keys())
    
    @classmethod
    def get_character_name(cls, character_id: str) -> str:
        """Get display name for character."""
        return cls.CHARACTERS.get(character_id, {}).get('name', 'Unknown')
    
    @classmethod
    def get_character_color(cls, character_id: str) -> Tuple[int, int, int]:
        """Get color for character."""
        return cls.CHARACTERS.get(character_id, {}).get('color', (255, 255, 255))
