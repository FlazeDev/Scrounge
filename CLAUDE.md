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
    - **Planned**: `InventoryComponent.gd`: Will manage shard currency and two weapon slots (primary/secondary).

- **Data Flow**:
  1. In `player.gd::_physics_process()`, the `InputComponent.tick()` method reads input and updates its variables.
  2. The `MovementComponent` uses `InputComponent`'s state to set movement direction and actions (jump, sprint).
  3. `MovementComponent.tick()` computes velocity and applies physics via `move_and_slide()`.
  4. `CameraComponent.tick()` updates head bob, and `input_tick()` processes mouse events for camera rotation.
  5. **Planned**: The `player.gd` will interact with `InventoryComponent` to:
     - Add shards when collected
     - Equip weapons to primary/secondary slots
     - Swap weapons between slots
     - Check shard count for purchases

- **Key Practices**:
  - Components are designed to be reusable and rely on exported properties (`body`, `cam`, `head`) set in the editor.
  - Input actions are defined in `project.godot` under the `[input]` section (up, down, left, right, jump, sprint, quit).
    - **Planned**: Add input actions for inventory (e.g., `swap_weapons`, `use_item`).
  - The player's mouse mode is captured during gameplay and released on quit.

## Planned Inventory System (Modular Design)

To maintain consistency with existing components, the inventory system should be implemented as follows:

1. **Create `Scripts/InventoryComponent.gd`**:
   - Extends `Node` (like other components)
   - Exported properties for potential UI connections (optional)
   - Variables:
     - `shards`: Integer tracking collected currency
     - `primary_slot`: Object/Dictionary representing equipped primary weapon (or null)
     - `secondary_slot`: Object/Dictionary representing equipped secondary weapon (or null)
   - Methods:
     - `add_shards(amount)`: Increases shard count
     - `use_shards(amount)`: Decreases shards if sufficient funds, returns boolean success
     - `equip_weapon(weapon_data, slot)`: Places weapon in specified slot (0=primary, 1=secondary)
     - `swap_slots()`: Exchanges primary and secondary weapons
     - `get_shard_count()`: Returns current shard amount
     - `get_weapon_in_slot(slot)`: Returns weapon data for given slot

2. **Integration with Player**:
   - In `Scenes/player.tscn`, add an `InventoryComponent` node as a child of the player
   - In `player.gd`: `@onready var inventory := %InventoryComponent`
   - Use inventory methods in `_physics_process()` or `_input()` for:
     - Collecting shards (call `add_shards`)
     - Picking up weapons (call `equip_weapon`)
     - Swapping weapons (call `swap_slots` on input action)
     - Purchasing upgrades (check shards with `get_shard_count()` then `use_shards`)

3. **Weapon Representation**:
   - For simplicity, weapons can be represented as dictionaries: `{name: "Pistol", damage: 10, ammo: 30}`
   - Or as references to weapon scenes/resources for more complex behavior
   - The inventory component remains agnostic to weapon specifics - it only stores and manages the data

4. **Input Actions** (to add in `project.godot`):
   - `swap_weapons`: Key binding for swapping primary/secondary (e.g., 'Q' key)
   - `use_item`: Key binding for using consumable items (if implemented)

This approach maintains the existing pattern: small, focused components that communicate through well-defined interfaces, making the system easy to extend and maintain.

## Project Structure

- `Scripts/`: Contains GDScript components (`InputComponent.gd`, `MovementComponent.gd`, `CameraComponent.gd`, `player.gd`) and **planned** `InventoryComponent.gd`.
- `Scenes/`: Contains the player scene (`player.tscn`) and a test scene (`test.tscn`).
- `addons/`: Includes third-party plugins (Godot Super Wakatime and Godot Git Plugin).
- `project.godot`: Project configuration, including input mappings and plugin settings.
