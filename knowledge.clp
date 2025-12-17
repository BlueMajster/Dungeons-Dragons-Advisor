(deftemplate user-answer
    (slot question-id (type SYMBOL))
    (slot value (type SYMBOL))
)

(deftemplate ui-request
    (slot type (type SYMBOL))
    (slot id (type SYMBOL))
    (multislot options)
)

(defrule ask-game
    (not (user-answer (question-id q_game)))
    =>
    (assert (ui-request (type question) (id q_game) (options opt_adventure opt_lotr opt_snowflake opt_rpg_thing)))
)
(defrule ask-nodnd
    (user-answer (question-id q_game) (value opt_rpg_thing))
    =>
    (assert (ui-request (type question) (id q_nodnd) (options opt_vampire)))

)
(defrule res-vampire
    (user-answer (question-id q_nodnd) (value opt_vampire))
    =>
    (assert (ui-request (type result) (id r_vampire) (options reset)))
)
                                                    ;;;(value opt_adventure | opt_lotr | opt_snowflake))
(defrule ask-hero
    (user-answer (question-id q_game) (value opt_adventure))
    =>
    (assert (ui-request (type question) (id q_hero) (options opt_serious opt_elf)))
)

(defrule res-human
    (user-answer (question-id q_human_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_human) (options reset)))
)

(defrule ask-fantasy
    (or (user-answer (question-id q_hero) (value opt_elf))
        (user-answer (question-id q_game) (value opt_lotr))
    )
    =>
    (assert (ui-request (type question) (id q_fantasy) (options opt_mee opt_tolkein)))
)

(defrule ask-tiny
    (user-answer (question-id q_fantasy) (value opt_mee))
    =>
    (assert (ui-request (type question) (id q_tiny) (options opt_kid opt_pedo opt_big)))
)

(defrule ask-silly
    (user-answer (question-id q_tiny) (value opt_kid))
    =>
    (assert (ui-request (type question) (id q_silly) (options opt_dark_humor opt_magic opt_gravitas)))
)

(defrule reach-gnome
    (user-answer (question-id q_silly) (value opt_magic))
    (not (user-answer (question-id q_gnome_choice)))
        =>
    (assert (ui-request (type question) (id q_gnome_choice) (options yes opt_magic_hobbit)))
)

(defrule res-gnome
    (user-answer (question-id q_gnome_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_gnome) (options reset)))
)

(defrule ask-tinkerer
    (user-answer (question-id q_gnome_choice) (value opt_magic_hobbit))
    =>
    (assert (ui-request (type question) (id q_tinker) (options opt_toys opt_mushroom)))
)

(defrule res-forest-gnome
    (user-answer (question-id q_tinker) (value opt_mushroom))
    =>
    (assert (ui-request (type result) (id r_forest_gnome) (options reset)))
)

(defrule reach-mountain-gnome
    (user-answer (question-id q_tinker) (value opt_toys))
    (not (user-answer (question-id q_mountain_gnome_choice)))
    =>
    (assert (ui-request (type question) (id q_mountain_gnome_choice) (options yes opt_deeper)))
)

(defrule res-mountain-gnome
    (user-answer (question-id q_mountain_gnome_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_mountain_gnome) (options reset)))
)

(defrule res-deep-gnome
    (user-answer (question-id q_mountain_gnome_choice) (value opt_deeper))
    =>
    (assert (ui-request (type result) (id r_deep_gnome) (options reset)))
)

(defrule reach-halfling
    (user-answer (question-id q_silly) (value opt_gravitas))
    (not (user-answer (question-id q_halfling_choice)))
        =>
    (assert (ui-request (type question) (id q_halfling_choice) (options yes opt_off_hobbit)))
)

(defrule res-halfling
    (user-answer (question-id q_halfling_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_halfling) (options reset)))
)

(defrule ask-dwarfy
    (user-answer (question-id q_halfling_choice) (value opt_off_hobbit))
    =>
    (assert (ui-request (type question) (id q_dwarfy) (options opt_nimble opt_hardy)))
)

(defrule res-lightfoot
    (user-answer (question-id q_dwarfy) (value opt_nimble))
    =>
    (assert (ui-request (type result) (id r_lightfoot) (options reset)))
)

(defrule res-stout
    (user-answer (question-id q_dwarfy) (value opt_hardy))
    =>
    (assert (ui-request (type result) (id r_stout) (options reset)))
)


(defrule ask_pretty
    (user-answer (question-id q_tiny) (value opt_pedo))
    =>
    (assert (ui-request (type question) (id q_pretty) (options opt_dlike opt_lift opt_pretty)))
)

(defrule ask_stronk
    (or (user-answer (question-id q_tiny) (value opt_big))
        (user-answer (question-id q_less_classic) (value opt_giant))
    )
    =>
    (assert (ui-request (type question) (id q_stronk) (options opt_gentl opt_muscle)))
)

(defrule res-firbolg
    (user-answer (question-id q_stronk) (value opt_gentl))
    =>
    (assert (ui-request (type result) (id r_firbolg) (options reset)))
)

(defrule res-goliath
    (or (user-answer (question-id q_stronk) (value opt_muscle))
        (user-answer (question-id q_dwarf_choice) (value opt_short))
    )
    =>
    (assert (ui-request (type result) (id r_goliath) (options reset)))
)

(defrule ask_less_classic
    (user-answer (question-id q_pretty) (value opt_dlike))
    =>
    (assert (ui-request (type question) (id q_less_classic) (options opt_giant opt_move)))
)

(defrule reach-elf
    (user-answer (question-id q_pretty) (value opt_pretty))
    (not (user-answer (question-id q_elf_choice)))
    =>
    (assert (ui-request (type question) (id q_elf_choice) (options yes opt_done)))
)

(defrule res-elf
    (user-answer (question-id q_elf_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_elf) (options reset)))
)

(defrule reach-dwarf
    (user-answer (question-id q_pretty) (value opt_lift))
    (not (user-answer (question-id q_dwarf_choice)))
    =>
    (assert (ui-request (type question) (id q_dwarf_choice) (options yes opt_short opt_drink)))
)

(defrule res-dwarf
    (user-answer (question-id q_dwarf_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_dwarf) (options reset)))
)

(defrule ask-nature
    (user-answer (question-id q_elf_choice) (value opt_done))
    =>
    (assert (ui-request (type question) (id q_nature) (options opt_mother_magic opt_wood opt_nright)))
)

(defrule res_high_elf
    (user-answer (question-id q_nature) (value opt_mother_magic))
    =>
    (assert (ui-request (type result) (id r_high_elf) (options reset)))
)

(defrule res_wood_elf
    (user-answer (question-id q_nature) (value opt_wood))
    =>
    (assert (ui-request (type result) (id r_wood_elf) (options reset)))
)

(defrule ask_problem
    (user-answer (question-id q_nature) (value opt_nright))
    =>
    (assert (ui-request (type question) (id q_problem) (options opt_feary opt_merm opt_half opt_dark_brood)))
)

(defrule ask_hills
    (user-answer (question-id q_dwarf_choice) (value opt_drink))
    =>
    (assert (ui-request (type question) (id q_hills) (options opt_hilly opt_stone opt_asshole)))
)

(defrule res_hill_dwarf
    (user-answer (question-id q_hills) (value opt_hilly))
    =>
    (assert (ui-request (type result) (id r_hill_dwarf) (options reset)))
)

(defrule res_mountain_dwarf
    (user-answer (question-id q_hills) (value opt_stone))
    =>
    (assert (ui-request (type result) (id r_mountain_dwarf) (options reset)))
)

(defrule res_duegar
    (or (user-answer (question-id q_edgelord) (value opt_mean_dwarf))
        (user-answer (question-id q_hills) (value opt_asshole))
    )
    =>
    (assert (ui-request (type result) (id r_duegar) (options reset)))
)

(defrule res_eladrin
    (user-answer (question-id q_problem) (value opt_feary))
    =>
    (assert (ui-request (type result) (id r_eladrin) (options reset)))
)

(defrule res_sea_elf
    (or (user-answer (question-id q_triton_choice) (value opt_elfy))
        (user-answer (question-id q_problem) (value opt_merm))
    )
    =>
    (assert (ui-request (type result) (id r_sea_elf) (options reset)))
)

(defrule res_half_elf
    (or (user-answer (question-id q_problem) (value opt_half))
        (user-answer (question-id q_monster_pretty) (value opt_magic_pretty))
    )
    =>
    (assert (ui-request (type result) (id r_half_elf) (options reset)))
)

(defrule reach_drow
    (or (user-answer (question-id q_edgelord) (value opt_dark_elf))
        (user-answer (question-id q_problem) (value opt_dark_brood))
    )
    (not (user-answer (question-id q_drow_choice)))
    =>
    (assert (ui-request (type question) (id q_drow_choice) (options yes opt_brooding)))
)

(defrule res_drow
    (user-answer (question-id q_drow_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_drow) (options reset)))
)

(defrule res_shadar_kai
    (user-answer (question-id q_drow_choice) (value opt_brooding))
    =>
    (assert (ui-request (type result) (id r_shadar_kai) (options reset)))
)

(defrule reach_human
    (or (user-answer (question-id q_hero) (value opt_serious))
        (user-answer (question-id q_dark) (value opt_right))
    )
    (not (user-answer (question-id q_human_choice)))
    =>
    (assert (ui-request (type question) (id q_human_choice) (options yes opt_wait)))
)

(defrule ask_ugh
    (user-answer (question-id q_human_choice) (value opt_wait))
    =>
    (assert (ui-request (type question) (id q_ugh) (options opt_lame)))
)

(defrule ask_monster_pretty
    (user-answer (question-id q_ugh) (value opt_lame))
    =>
    (assert (ui-request (type question) (id q_monster_pretty) (options opt_magic_pretty opt_monster_blood)))
)

(defrule res_half_orc
    (or (user-answer (question-id q_misunderstood) (value opt_parent))
        (user-answer (question-id q_monster_pretty) (value opt_monster_blood))
        (user-answer (question-id q_orc_choice) (value opt_stoopid))
        (user-answer (question-id q_allway) (value opt_touch))
    )
    =>
    (assert (ui-request (type result) (id r_half_orc) (options reset)))
)



(defrule ask-special
    (or (user-answer (question-id q_game) (value opt_snowflake))
        (user-answer (question-id q_fantasy) (value opt_tolkein))
    )
    =>
    (assert (ui-request (type question) (id q_special) (options opt_dark opt_dragon opt_dunno)))
)

(defrule ask-dark
    (user-answer (question-id q_special) (value opt_dark))
    =>
    (assert (ui-request (type question) (id q_dark) (options opt_darkness opt_right)))
)

(defrule ask-dragon
    (user-answer (question-id q_special) (value opt_dragon))
    =>
    (assert (ui-request (type question) (id q_dragon) (options opt_its_dnd)))
)

(defrule ask-animal-person
    (user-answer (question-id q_special) (value opt_dunno))
    =>
    (assert (ui-request (type question) (id q_animal_person) (options opt_furry opt_gross)))
)

(defrule ask-dragonborn
    (user-answer (question-id q_dragon) (value opt_its_dnd))
    =>
    (assert (ui-request (type question) (id q_dragonborn) (options opt_yay)))
)

(defrule ask-furry
    (or (user-answer (question-id q_uncommon) (value opt_animal))
        (user-answer (question-id q_animal_person) (value opt_furry))
    )
    =>
    (assert (ui-request (type question) (id q_furry) (options opt_scalie opt_owo opt_bird opt_horse_thing)))
)

(defrule reach-dragonborn
    (and(or (user-answer (question-id q_dragonborn) (value opt_yay))
        (user-answer (question-id q_scales) (value opt_mf_dragon))
        (user-answer (question-id q_scales_kind) (value opt_mf_dragon))
    )
    (not (user-answer (question-id q_dragonborn_choice))))
    =>
    (assert (ui-request (type question) (id q_dragonborn_choice) (options yes opt_kid_sized opt_not_dragon)))
)

(defrule ask-close
    (user-answer (question-id q_dragonborn_choice) (value opt_not_dragon))
    =>
    (assert (ui-request (type question) (id q_close) (options opt_fine opt_lemme_dragon)))
)

(defrule res-getout
    (user-answer (question-id q_close) (value opt_lemme_dragon))
    =>
    (assert (ui-request (type result) (id r_get_out) (options reset)))
)

(defrule res-dragonborn
   (or
      (user-answer (question-id q_dragonborn_choice) (value yes))
      (user-answer (question-id q_close) (value opt_fine))
   )
   =>
   (assert (ui-request (type result) (id r_dragonborn) (options reset)))
)

(defrule res-centaur
    (user-answer (question-id q_furry) (value opt_horse_thing))
    =>
    (assert (ui-request (type result) (id r_centaur) (options reset)))
)

(defrule ask-fursona
    (user-answer (question-id q_furry) (value opt_owo))
    =>
    (assert (ui-request (type question) (id q_fursona) (options opt_furry_meow opt_furry_moo opt_furry_elephant opt_furry_none)))
)

(defrule res-tabaxi
    (user-answer (question-id q_fursona) (value opt_furry_meow))
    =>
    (assert (ui-request (type result) (id r_tabaxi) (options reset)))
)

(defrule res-minotaur
    (user-answer (question-id q_fursona) (value opt_furry_moo))
    =>
    (assert (ui-request (type result) (id r_minotaur) (options reset)))
)

(defrule res-loxadon
    (user-answer (question-id q_fursona) (value opt_furry_elephant))
    =>
    (assert (ui-request (type result) (id r_loxadon) (options reset)))
)

(defrule res-shifter
    (user-answer (question-id q_fursona) (value opt_furry_none))
    =>
    (assert (ui-request (type result) (id r_shifter) (options reset)))
)

(defrule ask-bird
    (user-answer (question-id q_furry) (value opt_bird))
    =>
    (assert (ui-request (type question) (id q_bird) (options opt_air opt_caw)))
)

(defrule res-aarakocra
    (user-answer (question-id q_bird) (value opt_air))
    =>
    (assert (ui-request (type result) (id r_aarakocra) (options reset)))
)

(defrule res-kenku
    (user-answer (question-id q_bird) (value opt_caw))
    =>
    (assert (ui-request (type result) (id r_kenku) (options reset)))
)

(defrule ask-monstrous
    (user-answer (question-id q_dark) (value opt_darkness))
    =>
    (assert (ui-request (type question) (id q_monstrous) (options opt_noone_get opt_monster)))
)

(defrule ask-misunderstood
    (user-answer (question-id q_monstrous) (value opt_noone_get))
    =>
    (assert (ui-request (type question) (id q_misunderstood) (options opt_poncy opt_parent opt_devil opt_lizard)))
)

(defrule ask-edgelord
    (user-answer (question-id q_misunderstood) (value opt_poncy))
    =>
    (assert (ui-request (type question) (id q_edgelord) (options opt_mean_dwarf opt_dark_elf)))
)

(defrule res-halforc
    (user-answer (question-id q_misunderstood) (value opt_parent))
    =>
    (assert (ui-request (type result) (id r_half_orc) (options reset)))
)

(defrule res-tiefling
    (user-answer (question-id q_misunderstood) (value opt_devil))
    =>
    (assert (ui-request (type result) (id r_tiefling) (options reset)))
)

(defrule ask-scales-kind
    (or (user-answer (question-id q_furry) (value opt_scalie))
        (user-answer (question-id q_misunderstood) (value opt_lizard))
    )
    =>
    (assert (ui-request (type question) (id q_scales_kind) (options opt_reptile opt_snek opt_mf_dragon)))
)

(defrule ask-comic
    (user-answer (question-id q_monstrous) (value opt_monster))
    =>
    (assert (ui-request (type question) (id q_comic) (options opt_slaughter opt_funny)))
)

(defrule ask-scales
    (or (user-answer (question-id q_silly) (value opt_dark_humor))
        (user-answer (question-id q_comic) (value opt_slaughter))
    )
    =>
    (assert (ui-request (type question) (id q_scales) (options yes no)))
)

(defrule ask-power
    (user-answer (question-id q_comic) (value opt_funny))
    =>
    (assert (ui-request (type question) (id q_power) (options opt_power_strength opt_power_intellect)))
)

(defrule res-kobold
    (or (user-answer (question-id q_scales) (value yes))
        (user-answer (question-id q_dragonborn_choice) (value opt_kid_sized))
    )
    =>
    (assert (ui-request (type result) (id r_kobold) (options reset)))
)

(defrule res-goblin
    (or (user-answer (question-id q_small) (value yes))
        (user-answer (question-id q_scales) (value no))
    )
    =>
    (assert (ui-request (type result) (id r_goblin) (options reset)))
)

(defrule res-lizardfolk
    (user-answer (question-id q_scales_kind) (value opt_reptile))
    =>
    (assert (ui-request (type result) (id r_lizardfolk) (options reset)))
)

(defrule res-yuan-ti
    (or (user-answer (question-id q_conquer) (value opt_deception))
        (user-answer (question-id q_scales_kind) (value opt_snek))
    )
    =>
    (assert (ui-request (type result) (id r_yuan_ti) (options reset)))
)

(defrule ask-surprise
    (user-answer (question-id q_power) (value opt_power_strength))
    =>
    (assert (ui-request (type question) (id q_surprise) (options opt_head_on opt_ambush)))
)

(defrule ask-conquer
    (user-answer (question-id q_power) (value opt_power_intellect))
    =>
    (assert (ui-request (type question) (id q_conquer) (options opt_deception opt_mind)))
)

(defrule ask-allway
    (user-answer (question-id q_uncommon) (value opt_classy_monster))
    =>
    (assert (ui-request (type question) (id q_allway) (options opt_touch opt_full_monster)))
)

(defrule ask-small
    (user-answer (question-id q_allway) (value opt_full_monster))
    =>
    (assert (ui-request (type question) (id q_small) (options yes no)))
)

(defrule reach-orc
    (or (user-answer (question-id q_surprise) (value opt_head_on))
        (user-answer (question-id q_small) (value no))
    )
    (not (user-answer (question-id q_orc_choice)))
    =>
    (assert (ui-request (type question) (id q_orc_choice) (options yes opt_stoopid)))
)

(defrule res-orc
    (user-answer (question-id q_orc_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_orc) (options reset)))
)

(defrule ask-weird
    (user-answer (question-id q_animal_person) (value opt_gross))
    =>
    (assert (ui-request (type question) (id q_weird) (options opt_familiar opt_f_you)))
)

(defrule ask-uncommon
    (or (user-answer (question-id q_weird) (value opt_familiar))
        (user-answer (question-id q_less_classic) (value opt_move))
    )
    =>
    (assert (ui-request (type question) (id q_uncommon) (options opt_god opt_aquaman opt_robot opt_doppel opt_classy_monster opt_animal)))
    
)

(defrule res-changelings
    (user-answer (question-id q_uncommon) (value opt_doppel))
    =>
    (assert (ui-request (type result) (id r_changelings) (options reset)))
)

(defrule res-warforged
    (user-answer (question-id q_uncommon) (value opt_robot))
    =>
    (assert (ui-request (type result) (id r_warforged) (options reset)))
)

(defrule reach-triton
    (user-answer (question-id q_uncommon) (value opt_aquaman))
    (not (user-answer (question-id q_triton_choice)))
    =>
    (assert (ui-request (type question) (id q_triton_choice) (options yes opt_elfy)))
)

(defrule res-triton
    (user-answer (question-id q_triton_choice) (value yes))
    =>
    (assert (ui-request (type result) (id r_triton) (options reset)))
)

(defrule res-aasimar
    (user-answer (question-id q_uncommon) (value opt_god))
    =>
    (assert (ui-request (type result) (id r_aasimar) (options reset)))
)

(defrule res-banned
    (user-answer (question-id q_weird) (value opt_f_you))
    =>
    (assert (ui-request (type result) (id r_banned) (options reset)))
)

(defrule res-bugbear
    (user-answer (question-id q_surprise) (value opt_ambush))
    =>
    (assert (ui-request (type result) (id r_bugbear) (options reset)))
)

(defrule res-hobgoblin
    (user-answer (question-id q_conquer) (value opt_mind))
    =>
    (assert (ui-request (type result) (id r_hobgoblin) (options reset)))
)
