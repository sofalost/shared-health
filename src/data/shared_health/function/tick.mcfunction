# ============================================================
# shared_health — tick
# MC 26.2 / pack_format 107.1
#
# Principe : tous les joueurs partagent la même barre de vie.
# Quand un joueur prend des dégâts, tous les autres aussi.
# Quand un joueur soigne, tous les autres aussi.
#
# Méthode : chaque tick, détecter les changements de Health NBT,
# prendre la santé la plus basse parmi les joueurs modifiés
# (les dégâts priment sur le soin), et appliquer à tout le monde.
#
# Mort/respawn non propagés (filtre hp_cur ET hp_prev > 0).
# ============================================================

# 1. Lire la santé courante (× 10 pour précision entière)
execute as @a store result score @s hp_cur run data get entity @s Health 10

# 2. Amorçage : nouveau joueur → hp_prev = hp_cur (pas de faux delta)
execute as @a unless score @s hp_init matches 1 run scoreboard players operation @s hp_prev = @s hp_cur
execute as @a unless score @s hp_init matches 1 run scoreboard players set @s hp_init 1

# 3. Delta = changement ce tick
execute as @a run scoreboard players operation @s hp_delta = @s hp_cur
execute as @a run scoreboard players operation @s hp_delta -= @s hp_prev

# 4. Marquer les joueurs dont la vie a changé
#    Filtre : hp_cur ET hp_prev > 0 (ignore mort/respawn)
tag @a remove hp_changed
execute as @a if score @s hp_delta matches ..-1 if score @s hp_cur matches 1.. if score @s hp_prev matches 1.. run tag @s add hp_changed
execute as @a if score @s hp_delta matches 1.. if score @s hp_cur matches 1.. if score @s hp_prev matches 1.. run tag @s add hp_changed

# 5. Cible = santé la plus basse parmi les joueurs modifiés
#    (les dégâts priment sur le soin en cas de changement simultané)
scoreboard players set #target_hp timer 99999
execute as @a[tag=hp_changed] if score @s hp_cur < #target_hp timer run scoreboard players operation #target_hp timer = @s hp_cur

# 6. Synchroniser : appliquer #target_hp à tous les joueurs
#    store result entity Health float 0.1 : 200 → 20.0f
execute if score #target_hp timer matches ..99998 as @a store result entity @s Health float 0.1 run scoreboard players get #target_hp timer

# 7. Mémoriser pour le prochain tick
#    Pas de sync → hp_prev = hp_cur (inchangé)
#    Sync → hp_prev = #target_hp (valeur synchronisée, casse la boucle)
execute if score #target_hp timer matches 99999 as @a run scoreboard players operation @s hp_prev = @s hp_cur
execute if score #target_hp timer matches ..99998 as @a run scoreboard players operation @s hp_prev = #target_hp timer
