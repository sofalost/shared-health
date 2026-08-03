# Shared Health

Minecraft datapack (MC 26.x, pack_format 107.1) that synchronizes the health bars of all players on the server. Everyone shares a single health pool — when one player takes damage, everyone's HP drops. When one heals, everyone heals.

## How it works

Every tick, the pack compares each player's current HP against their previous-tick snapshot. If HP changed, the new value is broadcast to all other players via `attribute` modifications. An anti-feedback mechanism (`hp_prev` scoreboard) prevents infinite re-sync loops.

Damage propagation, healing propagation, death (HP=0) and respawn are all handled correctly — deaths and respawns are filtered out so they don't propagate.

## Install

Download `shared_health.zip` from the [latest release](../../releases), drop it into your world's `datapacks/` folder, then run `/reload`.

## Requirements

- Minecraft 26.x (pack_format 107.1)
- `function/` directory convention (singular, not `functions/`)
