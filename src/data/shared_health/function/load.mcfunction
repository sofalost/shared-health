# ============================================================
# shared_health — load
# MC 26.2 / pack_format 107.1
# ============================================================

# Objectifs
# hp_cur   : Health NBT × 10 (précision 0.1 HP)
# hp_prev  : hp_cur au tick précédent (détection de changement)
# hp_delta : hp_cur - hp_prev
# hp_init  : 1 une fois amorcé (évite faux delta au 1er tick)
scoreboard objectives add hp_cur dummy
scoreboard objectives add hp_prev dummy
scoreboard objectives add hp_delta dummy
scoreboard objectives add hp_init dummy

# timer : fake players (#target_hp)
scoreboard objectives add timer dummy

tellraw @a {"text":"[shared_health] loaded — toutes les barres de vie sont synchronisees","color":"red"}
