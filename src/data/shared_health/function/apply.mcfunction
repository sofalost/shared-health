# ============================================================
# shared_health — apply (macro)
# /damage n'accepte pas un score : on passe par une macro.
# $(amount) = ecart en HP reels (float, ex: 3.5)
# generic_kill : bypass armure/resistance/absorption, montant exact.
# ============================================================

$damage @s $(amount) minecraft:generic_kill
