# ============================================================
# shared_health — debug
# Usage: /function shared_health:debug
# A lancer manuellement apres qu'un joueur a pris des degats
# ============================================================

tellraw @a {"text":"=== SHARED_HEALTH DEBUG ===","color":"gold"}

# 1. Combien de joueurs sync ?
execute as @a[tag=hp_sync] run tellraw @s {"text":"  [hp_sync] HP=","color":"green","extra":[{"score":{"name":"@s","objective":"hp_cur"},"color":"white"},{"text":" prev=","color":"aqua"},{"score":{"name":"@s","objective":"hp_prev"},"color":"white"},{"text":" delta=","color":"aqua"},{"score":{"name":"@s","objective":"hp_delta"},"color":"yellow"}]}

# 2. Joueurs NON sync (probleme gamemode filter) ?
execute as @a[tag=!hp_sync] run tellraw @s {"text":"  [PAS SYNC] gamemode filter ne te tagge pas","color":"red"}

# 3. Target values
tellraw @a {"text":"  target_min=","color":"gold","extra":[{"score":{"name":"#target_min","objective":"timer"},"color":"white"}]}
tellraw @a {"text":"  target_max=","color":"gold","extra":[{"score":{"name":"#target_max","objective":"timer"},"color":"white"}]}

# 4. Tags actifs
execute as @a[tag=hp_changed] run tellraw @s {"text":"  [hp_changed]","color":"red"}
execute as @a[tag=hp_died] run tellraw @s {"text":"  [hp_died]","color":"dark_red"}
