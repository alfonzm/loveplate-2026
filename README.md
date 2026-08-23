# love-boilerplate-2026

[LÖVE](https://love2d.org/) game boilerplate. Entry: `main.lua` → `conf.lua` sets `G` (title, resolution, scale, flags).

## Flow

`Director` holds the active scene. Each frame: `Flux` / `Timer` / `Director:update` / `Director:draw`. Scenes extend `lib/alphonsus/scene.lua`.

## ECS framework

This project uses a **lightweight ECS**: entities are plain tables (usually `GameObject` subclasses); there are no component types—**systems run only on entities that have the right keys**.

[`knife.system`](https://github.com/airstruck/knife/blob/master/system.lua) builds a matcher from an **aspect list** (field names). Each frame, `Scene:update` walks `scene.entities` and calls `system(entity, entity, dt)`; the wrapper pulls `entity[field]` for each aspect and bails if required fields are missing.

**Aspect prefixes** (see `lib/knife/system.lua`): plain names are required fields. A leading `-` still means “required”: the entity is skipped if that key is missing (e.g. collision uses `-collider` and `-physicsBody`). Other sigils (`?`, `!`, `~`) are for optional / inverted matches.

**Adding a system:** create `systems/foo.lua` returning `System({ 'aspect1', 'aspect2' }, function (...) ... end)`, `require` it in `scene.lua`, and invoke it in the same loop as the others (order = pipeline order).

## Folders

- `scenes/` — Game states / rooms (`demo.lua` is the starter scene).
- `entities/` — Game objects (`GameObject` subclasses: circle, text, particles, UI widgets).
- `systems/` — ECS-style processors via `knife.system` (per-entity: `update`, `movable`, `draw`, collisions, etc.).
- `lib/alphonsus/` — Engine glue: `Scene`, `Director`, `Input`, `pixelate`, `cameraFollow`, `gameObject`.
- `lib/` — Third-party / shared: `knife`, `flux`, `windfield`, `lume`, `classic` (OOP).
- `config/` — `controls.lua`, `collisions.lua` (physics collision classes).
- `assets/` — Asset loader.
- `particles/` — LÖVE particle preset tables.

## Systems

Run order in `Scene:update` (each matches entities that have the listed fields / tags):

- `update` — calls `entity:update(dt)` if `update` is a function.
- `typingAnimation` — drives text typing animation state.
- `magnet` — homes `movable` entities toward a target; calls `onMagnetTargetReached` hook.
- `moveToAngle` — if `moveToAngle` is set, overwrites `movable.velocity` from `angle` and `speed` (needs `movable` on the entity).
- `movable` — integrates acceleration, velocity, drag, angular velocity/drag; writes `x`, `y`, `angle`.
- `movesWith` — copies `x`/`y` from the referenced parent entity.
- `collision` — syncs `physicsBody` to entity transform; runs `onCollide` when windfield reports enter against configured classes (`config/collisions.lua`).
- `hp` — if `hp` exists and `hp <= 0`, calls `die()`.
- `remove` — if `toRemove`, destroys physics body, runs `onRemove`, removes from the scene list.

## Getting started

1. Copy this repo as a starting point.
2. Add your assets under `assets/`.
3. Create entities in `entities/` extending `GameObject`.
4. Create a scene in `scenes/` extending `Scene`.
5. Switch to your scene in `main.lua` via `Director:switch()`.

## Notes

- Physics: `Scene` owns a `windfield` world; entities with colliders get bodies on `add`.
- Camera: `lib/alphonsus/cameraFollow.lua` — call `setTarget(entity)` from a scene; `Scene` applies `scene.camera` in `draw`.
- Debug: press `Tab` for FPS/entity count, `` ` `` for collider overlay.
- Restart scene: press `R`.
