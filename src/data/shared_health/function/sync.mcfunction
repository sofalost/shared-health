# ============================================================
# shared_health — sync
# Execute AS chaque joueur synchronise, quand #target_hp existe.
# ============================================================

# Ecart entre ce joueur et la cible (en HP entiers)
scoreboard players operation #diff timer = @s hp_cur
scoreboard players operation #diff timer -= #target_hp timer

# Deadzone 1 HP + joueur vivant -> stocker le montant et appliquer
# int 1 : SNBT sans suffixe "f", la macro produit un nombre valide pour /damage
execute if score #diff timer matches 1.. if score @s hp_cur matches 1.. store result storage shared_health:tmp amount int 1 run scoreboard players get #diff timer
execute if score #diff timer matches 1.. if score @s hp_cur matches 1.. run function shared_health:apply with storage shared_health:tmp

# Memoriser pour le prochain tick
# Degats appliques -> hp_prev = cible (casse la boucle de feedback)
execute if score #diff timer matches 1.. if score @s hp_cur matches 1.. run scoreboard players operation @s hp_prev = #target_hp timer
# Pas de degats (ecart insuffisant ou joueur mort) -> hp_prev = hp_cur
execute unless score #diff timer matches 1.. run scoreboard players operation @s hp_prev = @s hp_cur
execute if score #diff timer matches 1.. unless score @s hp_cur matches 1.. run scoreboard players operation @s hp_prev = @s hp_cur
