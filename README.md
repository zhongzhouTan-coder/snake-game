# Snake Game with Custom Textures

A modern snake game built in Godot with support for custom snake textures and multiple visual styles.

## Features

### Core Gameplay
- Classic snake mechanics with smooth movement
- Food collection and score tracking
- Collision detection and game over states
- Configurable game speed that increases as you eat

### Visual Customization
- **Multiple Snake Skins**: Choose from 5 different visual styles
  - Default: Classic solid colors
  - Scales: Circular scale pattern
  - Stripes: Diagonal striped design
  - Rainbow: Dynamic rainbow colors  
  - Gradient: Linear color gradient
- **Texture Support**: Load custom PNG/JPG textures for snake segments
- **Real-time Switching**: Change skins during gameplay
- **Toggle Mode**: Switch between textured and solid color modes

### Controls
- **Arrow Keys**: Move the snake
- **1-5 Keys**: Switch to specific snake skins
- **Enter/Space**: Cycle through available skins
- **T Key**: Toggle between textured and solid color modes
- **Enter** (when game over): Restart the game

### User Interface
- Live skin display showing current snake appearance
- Score tracking and display
- On-screen control instructions
- Game over screen with restart option

## Adding Custom Textures

1. Create 32x32 pixel PNG or JPG images
2. Name them using the pattern:
   - `snake_head_[skinname].png` - For the snake head
   - `snake_body_[skinname].png` - For the snake body
3. Place them in the `assets/textures/` folder
4. The game will automatically detect and load them on startup

Example: Create `snake_head_myskin.png` and `snake_body_myskin.png` for a custom "MySkin" texture.

## Project Structure

```
snake-game/
├── assets/
│   └── textures/           # Custom texture files go here
├── scenes/
│   ├── main.tscn          # Main game scene
│   └── ui.tscn            # User interface overlay
├── scripts/
│   ├── snake_game.gd      # Main game logic and controls
│   ├── grid_system.gd     # Grid and snake mechanics
│   ├── grid_render.gd     # Rendering and texture system
│   ├── ui_controller.gd   # UI management
│   └── texture_generator.gd # Tool to create sample textures
└── autoload/              # Game autoload scripts
```

## Technical Implementation

The texture system features:
- **Automatic texture loading** from the assets folder
- **Procedural texture generation** as fallback for missing files
- **Hardware-accelerated rendering** using Godot's draw_texture_rect
- **Memory-efficient caching** with dictionary-based texture storage
- **Runtime skin switching** without performance impact

## Getting Started

1. Open the project in Godot 4.x
2. Run the main scene (`scenes/main.tscn`)
3. Use arrow keys to move and number keys to change skins
4. Optionally add custom textures to `assets/textures/`

## Future Enhancements

- Animated snake textures
- User-selectable texture packs
- Texture editor integration
- Online texture sharing
- Particle effects for food collection

## License

This project is open source. See LICENSE file for details.

---

Enjoy your customizable snake game! 🐍✨
