# ============================================================
# shared_health — load
# MC 26.2 / pack_format 107.1
# Synchronise vie, mort, soins et absorption entre joueurs.
# ============================================================

scoreboard objectives add hp_cur dummy
scoreboard objectives add hp_prev dummy
scoreboard objectives add hp_delta dummy
scoreboard objectives add hp_init dummy
scoreboard objectives add abs_cur dummy
scoreboard objectives add abs_prev dummy
scoreboard objectives add abs_delta dummy

scoreboard objectives add timer dummy
scoreboard objectives add const dummy

scoreboard players set 1 const 1
scoreboard players set 4 const 4

tellraw @a {"text":"[shared_health] loaded — vie, mort, soins et absorption partages","color":"red"}
