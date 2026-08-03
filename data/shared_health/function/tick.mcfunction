# ============================================================
# shared_health — tick
# MC 26.2 / pack_format 107.1
# ============================================================

# 0. Perimetre : survival/adventure uniquement
tag @a remove hp_sync
tag @a[gamemode=!spectator] add hp_sync
tag @a[gamemode=creative] remove hp_sync
execute as @a[tag=!hp_sync] run scoreboard players set @s hp_init 0

# 1. Lire Health + AbsorptionAmount
execute as @a[tag=hp_sync] store result score @s hp_cur run data get entity @s Health 1
execute as @a[tag=hp_sync] store result score @s abs_cur run data get entity @s AbsorptionAmount 1

# 2. Amorcage
execute as @a[tag=hp_sync] unless score @s hp_init matches 1 run scoreboard players operation @s hp_prev = @s hp_cur
execute as @a[tag=hp_sync] unless score @s hp_init matches 1 run scoreboard players operation @s abs_prev = @s abs_cur
execute as @a[tag=hp_sync] unless score @s hp_init matches 1 run scoreboard players set @s hp_init 1

# 3. Deltas
execute as @a[tag=hp_sync] run scoreboard players operation @s hp_delta = @s hp_cur
execute as @a[tag=hp_sync] run scoreboard players operation @s hp_delta -= @s hp_prev
execute as @a[tag=hp_sync] run scoreboard players operation @s abs_delta = @s abs_cur
execute as @a[tag=hp_sync] run scoreboard players operation @s abs_delta -= @s abs_prev

# 4. MORT SYNC : joueur passe a 0 HP (hp_cur=0, hp_prev>0)
#    -> tout le monde meurt (pas de respawn instantane/sync)
tag @a remove hp_died
execute as @a[tag=hp_sync] if score @s hp_cur matches 0 if score @s hp_prev matches 1.. run tag @s add hp_died
execute if entity @a[tag=hp_died] as @a[tag=hp_sync] run damage @s 1000 minecraft:generic_kill

# 5. CIBLE DEGATS : MIN parmi ceux qui ont perdu de la vie
tag @a remove hp_changed
execute as @a[tag=hp_sync] if score @s hp_delta matches ..-1 if score @s hp_cur matches 1.. if score @s hp_prev matches 1.. run tag @s add hp_changed
scoreboard players set #target_min timer 99999
execute as @a[tag=hp_changed] if score @s hp_cur < #target_min timer run scoreboard players operation #target_min timer = @s hp_cur

# 6. CIBLE SOINS : MAX parmi ceux qui ont gagne >= 2 HP (filtre regen 1 HP/tick)
tag @a remove hp_healed
execute as @a[tag=hp_sync] if score @s hp_delta matches 2.. if score @s hp_prev matches 1.. run tag @s add hp_healed
scoreboard players set #target_max timer 0
execute as @a[tag=hp_healed] if score @s hp_cur > #target_max timer run scoreboard players operation #target_max timer = @s hp_cur

# 7. ABSORPTION : source detection state-based (refresh continu, pas juste au gain)
execute as @a[tag=hp_sync,tag=hp_abs_given] if score @s abs_cur matches 0 run tag @s remove hp_abs_given
tag @a remove hp_abs_src
execute as @a[tag=hp_sync,tag=!hp_abs_given] if score @s abs_cur matches 1.. run tag @s add hp_abs_src
scoreboard players set #target_abs timer 0
execute as @a[tag=hp_abs_src] if score @s abs_cur > #target_abs timer run scoreboard players operation #target_abs timer = @s abs_cur

# 8. SYNC par joueur (uniquement si un changement ce tick)
scoreboard players set #has_change timer 0
execute if entity @a[tag=hp_died] run scoreboard players set #has_change timer 1
execute if entity @a[tag=hp_changed] run scoreboard players set #has_change timer 1
execute if entity @a[tag=hp_healed] run scoreboard players set #has_change timer 1
execute if entity @a[tag=hp_abs_src] run scoreboard players set #has_change timer 1
execute if score #has_change timer matches 1 unless entity @a[tag=hp_died] as @a[tag=hp_sync] run function shared_health:sync

# 9. Relecture + memorisation (casse le feedback loop)
execute as @a[tag=hp_sync] store result score @s hp_cur run data get entity @s Health 1
execute as @a[tag=hp_sync] store result score @s abs_cur run data get entity @s AbsorptionAmount 1
execute as @a[tag=hp_sync] run scoreboard players operation @s hp_prev = @s hp_cur
execute as @a[tag=hp_sync] run scoreboard players operation @s abs_prev = @s abs_cur
