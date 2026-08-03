# ============================================================
# shared_health — sync (par joueur)
# Cibles #target_min, #target_max, #target_abs definies dans tick.
# Degats prioritaire sur soins : si #target_min != 99999, soins skip.
# ============================================================

# --- DEGATS : joueur au-dessus du MIN -> damage ---
scoreboard players operation #diff timer = @s hp_cur
scoreboard players operation #diff timer -= #target_min timer
execute if score #diff timer matches 1.. if score @s hp_cur matches 1.. store result storage shared_health:tmp amount int 1 run scoreboard players get #diff timer
execute if score #diff timer matches 1.. if score @s hp_cur matches 1.. run function shared_health:apply_damage with storage shared_health:tmp

# --- SOINS : joueur sous le MAX -> instant_health ---
# Uniquement si pas de degats ce tick. hp_prev>0 exclut le respawn.
scoreboard players operation #heal timer = #target_max timer
scoreboard players operation #heal timer -= @s hp_cur
execute if score #target_min timer matches 99999 if score #heal timer matches 1.. if score @s hp_sprev matches 1.. run scoreboard players operation #amp timer = #heal timer
execute if score #target_min timer matches 99999 if score #heal timer matches 1.. if score @s hp_sprev matches 1.. run scoreboard players operation #amp timer -= 1 const
execute if score #target_min timer matches 99999 if score #heal timer matches 1.. if score @s hp_sprev matches 1.. run scoreboard players operation #amp timer /= 4 const
execute if score #target_min timer matches 99999 if score #heal timer matches 1.. if score @s hp_sprev matches 1.. store result storage shared_health:tmp amp int 1 run scoreboard players get #amp timer
execute if score #target_min timer matches 99999 if score #heal timer matches 1.. if score @s hp_sprev matches 1.. run function shared_health:apply_heal with storage shared_health:tmp

# --- ABSORPTION : joueur sans absorption + source genuine -> effect ---
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 run scoreboard players operation #abs_amp timer = #target_abs timer
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 run scoreboard players operation #abs_amp timer -= 1 const
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 run scoreboard players operation #abs_amp timer /= 4 const
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 store result storage shared_health:tmp amp int 1 run scoreboard players get #abs_amp timer
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 run function shared_health:apply_abs with storage shared_health:tmp
execute if score #target_abs timer matches 1.. if score @s abs_cur matches 0 run tag @s add hp_abs_given
