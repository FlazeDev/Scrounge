# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Running the game**: Open the project in Godot Editor and press F5 or click the Play button to run the main scene (`Scenes/player.tscn`).
- **Editing scenes**: Use Godot Editor to modify `.tscn` files. Avoid editing them directly as they are binary-like (though stored as text, they are fragile).
- **Running scripts**: GDScript files are interpreted by the Godot engine; no separate build step is needed.
- **Testing**: There are no automated tests currently. Manual testing via the Godot editor is expected.

## Code Architecture

The project follows a component-based architecture for the player entity:

- **Player Node** (`Scenes/player.tscn`): A `CharacterBody3D` that acts as the main player controller.
  - Attached components:
    - `InputComponent.gd`: Handles input polling and exposes normalized direction (`inputDir`) and boolean flags for jump, sprint, and quit.
    - `MovementComponent.gd`: Applies movement logic based on input, including walking, sprinting, gravity, and jumping. It updates the `CharacterBody3D`'s velocity.
    - `CameraComponent.gd`: Controls the camera rotation via mouse input and adds a subtle head bob effect based on movement.
    - **Implemented**: `InventoryComponent.gd`: Manages usable items that can be equipped, used, swapped, and dropped.

- **Data Flow**:
  1. In `player.gd::_physics_process()`, the `InputComponent.tick()` method reads input and updates its variables.
  2. The `MovementComponent` uses `InputComponent`'s state to set movement direction and actions (jump, sprint).
  3. `MovementComponent.tick()` computes velocity and applies physics via `move_and_slide()`.
  4. `CameraComponent.tick()` updates head bob, and `input_tick()` processes mouse events for camera rotation.
  5. **Implemented**: The `player.gd` interacts with `InventoryComponent` to:
     - Use equipped items (call `use_item`)
     - Swap between equipped items (call `swap_item`)
     - Drop equipped items (call `drop_item`)

- **Key Practices**:
  - Components are designed to be reusable and rely on exported properties (`body`, `cam`, `head`) set in the editor.
  - Input actions are defined in `project.godot` under the `[input]` section (up, down, left, right, jump, sprint, quit, interact, use, swap, drop).
  - The player's mouse mode is captured during gameplay and released on quit.

## Implemented Inventory System (Modular Design)

The inventory system follows the existing component pattern:

1. **`Scripts/InventoryComponent.gd`**:
   - Extends `Node` (like other components)
   - Exported properties for hand and drop point connections (set in editor)
   - Variables:
     - `invSlots`: Array tracking two item slots (primary/secondary)
   - Methods:
     - `add_item(item:Node3D)`: Adds item to first available slot, returns boolean success
     - `use_item()`: Uses the equipped primary item (if it has a UsableComponent)
     - `swap_item()`: Exchanges primary and secondary items
     - `drop_item()`: Drops the primary item at the drop point
     - `update_model(item:Node)`: Updates the visual representation in the hand
   - Flags processed in `tick()`: use, swap, drop (set from input)

2. **Integration with Player**:
   - In `Scenes/player.tscn`, an `InventoryComponent` node is a child of the player
   - In `player.gd`: `@onready var inventory := $InventoryComponent`
   - Inventory flags are set in `_physics_process()` based on input:
     - `inventory.use = input.wantsUse`
     - `inventory.swap = input.wantsSwap`
     - `inventory.drop = input.wantsDrop`
   - `inventory.tick()` is called to process the flags

3. **Item Representation**:
   - Items are Node3D scenes that can be duplicated and added to slots
   - For usable items, they should contain a `UsableComponent` with a `use()` method
   - The inventory component remains agnostic to item specifics - it only stores and manages the data

4. **Input Actions** (defined in `project.godot`):
   - `use`: Mouse left button (for using equipped items)
   - `swap`: 'F' key (for swapping primary/secondary items)
   - `drop`: 'Q' key (for dropping the primary item)
   - `interact`: 'E' key (for general interaction, handled by InteractionComponent)

This approach maintains the existing pattern: small, focused components that communicate through well-defined interfaces, making the system easy to extend and maintain.
## Implemented Dash Feature

The dash feature allows the player to burst forward in the direction the camera is facing, consuming stamina.

- **InputComponent.gd**: Added `wantsDash` flag set when the dash action is pressed (default key binding can be set in `project.godot`).
- **MovementComponent.gd**: When `dash` is true and stamina sufficient, the character's velocity is set to the camera's forward vector (including vertical tilt) multiplied by `dashSpeed`. Stamina is reduced by a configurable amount.
- **StaminaComponent.gd**: Used to track and consume stamina for dashing.

This dash can be used in any direction, including upward or downward, depending on camera orientation.

## Project Structure

- `Scripts/`: Contains GDScript components (`InputComponent.gd`, `MovementComponent.gd`, `CameraComponent.gd`, `player.gd`, `InventoryComponent.gd`).
- `Scenes/`: Contains the player scene (`player.tscn`) and a test scene (`test.tscn`).
- `addons/`: Includes third-party plugins (Godot Super Wakatime and Godot Git Plugin).
- `project.godot`: Project configuration, including input mappings and plugin settings.
