module Heros exposing (..)


baseImgUrl : String
baseImgUrl =
    "https://api.opendota.com"


type HeroVec
    = Position { x : Float, y : Float }
    | NoPosition


type alias Hero =
    { name : String
    , iconUrl : String
    , vec : HeroVec
    }


initHeros : List Hero
initHeros =
    [ { name = "Anti-Mage"
      , iconUrl = "/apps/dota2/images/heroes/antimage_icon.png"
      , vec = NoPosition
      }
    , { name = "Axe"
      , iconUrl = "/apps/dota2/images/heroes/axe_icon.png"
      , vec = NoPosition
      }
    , { name = "Bane"
      , iconUrl = "/apps/dota2/images/heroes/bane_icon.png"
      , vec = NoPosition
      }
    , { name = "Bloodseeker"
      , iconUrl = "/apps/dota2/images/heroes/bloodseeker_icon.png"
      , vec = NoPosition
      }
    , { name = "Crystal Maiden"
      , iconUrl = "/apps/dota2/images/heroes/crystal_maiden_icon.png"
      , vec = NoPosition
      }
    , { name = "Drow Ranger"
      , iconUrl = "/apps/dota2/images/heroes/drow_ranger_icon.png"
      , vec = NoPosition
      }
    , { name = "Earthshaker"
      , iconUrl = "/apps/dota2/images/heroes/earthshaker_icon.png"
      , vec = NoPosition
      }
    , { name = "Juggernaut"
      , iconUrl = "/apps/dota2/images/heroes/juggernaut_icon.png"
      , vec = NoPosition
      }
    , { name = "Mirana"
      , iconUrl = "/apps/dota2/images/heroes/mirana_icon.png"
      , vec = NoPosition
      }
    , { name = "Morphling"
      , iconUrl = "/apps/dota2/images/heroes/morphling_icon.png"
      , vec = NoPosition
      }
    , { name = "Shadow Fiend"
      , iconUrl = "/apps/dota2/images/heroes/nevermore_icon.png"
      , vec = NoPosition
      }
    , { name = "Phantom Lancer"
      , iconUrl = "/apps/dota2/images/heroes/phantom_lancer_icon.png"
      , vec = NoPosition
      }
    , { name = "Puck"
      , iconUrl = "/apps/dota2/images/heroes/puck_icon.png"
      , vec = NoPosition
      }
    , { name = "Pudge"
      , iconUrl = "/apps/dota2/images/heroes/pudge_icon.png"
      , vec = NoPosition
      }
    , { name = "Razor"
      , iconUrl = "/apps/dota2/images/heroes/razor_icon.png"
      , vec = NoPosition
      }
    , { name = "Sand King"
      , iconUrl = "/apps/dota2/images/heroes/sand_king_icon.png"
      , vec = NoPosition
      }
    , { name = "Storm Spirit"
      , iconUrl = "/apps/dota2/images/heroes/storm_spirit_icon.png"
      , vec = NoPosition
      }
    , { name = "Sven"
      , iconUrl = "/apps/dota2/images/heroes/sven_icon.png"
      , vec = NoPosition
      }
    , { name = "Tiny"
      , iconUrl = "/apps/dota2/images/heroes/tiny_icon.png"
      , vec = NoPosition
      }
    , { name = "Vengeful Spirit"
      , iconUrl = "/apps/dota2/images/heroes/vengefulspirit_icon.png"
      , vec = NoPosition
      }
    , { name = "Windranger"
      , iconUrl = "/apps/dota2/images/heroes/windrunner_icon.png"
      , vec = NoPosition
      }
    , { name = "Zeus"
      , iconUrl = "/apps/dota2/images/heroes/zuus_icon.png"
      , vec = NoPosition
      }
    , { name = "Kunkka"
      , iconUrl = "/apps/dota2/images/heroes/kunkka_icon.png"
      , vec = NoPosition
      }
    , { name = "Lina"
      , iconUrl = "/apps/dota2/images/heroes/lina_icon.png"
      , vec = NoPosition
      }
    , { name = "Lion"
      , iconUrl = "/apps/dota2/images/heroes/lion_icon.png"
      , vec = NoPosition
      }
    , { name = "Shadow Shaman"
      , iconUrl = "/apps/dota2/images/heroes/shadow_shaman_icon.png"
      , vec = NoPosition
      }
    , { name = "Slardar"
      , iconUrl = "/apps/dota2/images/heroes/slardar_icon.png"
      , vec = NoPosition
      }
    , { name = "Tidehunter"
      , iconUrl = "/apps/dota2/images/heroes/tidehunter_icon.png"
      , vec = NoPosition
      }
    , { name = "Witch Doctor"
      , iconUrl = "/apps/dota2/images/heroes/witch_doctor_icon.png"
      , vec = NoPosition
      }
    , { name = "Lich"
      , iconUrl = "/apps/dota2/images/heroes/lich_icon.png"
      , vec = NoPosition
      }
    , { name = "Riki"
      , iconUrl = "/apps/dota2/images/heroes/riki_icon.png"
      , vec = NoPosition
      }
    , { name = "Enigma"
      , iconUrl = "/apps/dota2/images/heroes/enigma_icon.png"
      , vec = NoPosition
      }
    , { name = "Tinker"
      , iconUrl = "/apps/dota2/images/heroes/tinker_icon.png"
      , vec = NoPosition
      }
    , { name = "Sniper"
      , iconUrl = "/apps/dota2/images/heroes/sniper_icon.png"
      , vec = NoPosition
      }
    , { name = "Necrophos"
      , iconUrl = "/apps/dota2/images/heroes/necrolyte_icon.png"
      , vec = NoPosition
      }
    , { name = "Warlock"
      , iconUrl = "/apps/dota2/images/heroes/warlock_icon.png"
      , vec = NoPosition
      }
    , { name = "Beastmaster"
      , iconUrl = "/apps/dota2/images/heroes/beastmaster_icon.png"
      , vec = NoPosition
      }
    , { name = "Queen of Pain"
      , iconUrl = "/apps/dota2/images/heroes/queenofpain_icon.png"
      , vec = NoPosition
      }
    , { name = "Venomancer"
      , iconUrl = "/apps/dota2/images/heroes/venomancer_icon.png"
      , vec = NoPosition
      }
    , { name = "Faceless Void"
      , iconUrl = "/apps/dota2/images/heroes/faceless_void_icon.png"
      , vec = NoPosition
      }
    , { name = "Wraith King"
      , iconUrl = "/apps/dota2/images/heroes/skeleton_king_icon.png"
      , vec = NoPosition
      }
    , { name = "Death Prophet"
      , iconUrl = "/apps/dota2/images/heroes/death_prophet_icon.png"
      , vec = NoPosition
      }
    , { name = "Phantom Assassin"
      , iconUrl = "/apps/dota2/images/heroes/phantom_assassin_icon.png"
      , vec = NoPosition
      }
    , { name = "Pugna"
      , iconUrl = "/apps/dota2/images/heroes/pugna_icon.png"
      , vec = NoPosition
      }
    , { name = "Templar Assassin"
      , iconUrl = "/apps/dota2/images/heroes/templar_assassin_icon.png"
      , vec = NoPosition
      }
    , { name = "Viper"
      , iconUrl = "/apps/dota2/images/heroes/viper_icon.png"
      , vec = NoPosition
      }
    , { name = "Luna"
      , iconUrl = "/apps/dota2/images/heroes/luna_icon.png"
      , vec = NoPosition
      }
    , { name = "Dragon Knight"
      , iconUrl = "/apps/dota2/images/heroes/dragon_knight_icon.png"
      , vec = NoPosition
      }
    , { name = "Dazzle"
      , iconUrl = "/apps/dota2/images/heroes/dazzle_icon.png"
      , vec = NoPosition
      }
    , { name = "Clockwerk"
      , iconUrl = "/apps/dota2/images/heroes/rattletrap_icon.png"
      , vec = NoPosition
      }
    , { name = "Leshrac"
      , iconUrl = "/apps/dota2/images/heroes/leshrac_icon.png"
      , vec = NoPosition
      }
    , { name = "Nature's Prophet"
      , iconUrl = "/apps/dota2/images/heroes/furion_icon.png"
      , vec = NoPosition
      }
    , { name = "Lifestealer"
      , iconUrl = "/apps/dota2/images/heroes/life_stealer_icon.png"
      , vec = NoPosition
      }
    , { name = "Dark Seer"
      , iconUrl = "/apps/dota2/images/heroes/dark_seer_icon.png"
      , vec = NoPosition
      }
    , { name = "Clinkz"
      , iconUrl = "/apps/dota2/images/heroes/clinkz_icon.png"
      , vec = NoPosition
      }
    , { name = "Omniknight"
      , iconUrl = "/apps/dota2/images/heroes/omniknight_icon.png"
      , vec = NoPosition
      }
    , { name = "Enchantress"
      , iconUrl = "/apps/dota2/images/heroes/enchantress_icon.png"
      , vec = NoPosition
      }
    , { name = "Huskar"
      , iconUrl = "/apps/dota2/images/heroes/huskar_icon.png"
      , vec = NoPosition
      }
    , { name = "Night Stalker"
      , iconUrl = "/apps/dota2/images/heroes/night_stalker_icon.png"
      , vec = NoPosition
      }
    , { name = "Broodmother"
      , iconUrl = "/apps/dota2/images/heroes/broodmother_icon.png"
      , vec = NoPosition
      }
    , { name = "Bounty Hunter"
      , iconUrl = "/apps/dota2/images/heroes/bounty_hunter_icon.png"
      , vec = NoPosition
      }
    , { name = "Weaver"
      , iconUrl = "/apps/dota2/images/heroes/weaver_icon.png"
      , vec = NoPosition
      }
    , { name = "Jakiro"
      , iconUrl = "/apps/dota2/images/heroes/jakiro_icon.png"
      , vec = NoPosition
      }
    , { name = "Batrider"
      , iconUrl = "/apps/dota2/images/heroes/batrider_icon.png"
      , vec = NoPosition
      }
    , { name = "Chen"
      , iconUrl = "/apps/dota2/images/heroes/chen_icon.png"
      , vec = NoPosition
      }
    , { name = "Spectre"
      , iconUrl = "/apps/dota2/images/heroes/spectre_icon.png"
      , vec = NoPosition
      }
    , { name = "Ancient Apparition"
      , iconUrl = "/apps/dota2/images/heroes/ancient_apparition_icon.png"
      , vec = NoPosition
      }
    , { name = "Doom"
      , iconUrl = "/apps/dota2/images/heroes/doom_bringer_icon.png"
      , vec = NoPosition
      }
    , { name = "Ursa"
      , iconUrl = "/apps/dota2/images/heroes/ursa_icon.png"
      , vec = NoPosition
      }
    , { name = "Spirit Breaker"
      , iconUrl = "/apps/dota2/images/heroes/spirit_breaker_icon.png"
      , vec = NoPosition
      }
    , { name = "Gyrocopter"
      , iconUrl = "/apps/dota2/images/heroes/gyrocopter_icon.png"
      , vec = NoPosition
      }
    , { name = "Alchemist"
      , iconUrl = "/apps/dota2/images/heroes/alchemist_icon.png"
      , vec = NoPosition
      }
    , { name = "Invoker"
      , iconUrl = "/apps/dota2/images/heroes/invoker_icon.png"
      , vec = NoPosition
      }
    , { name = "Silencer"
      , iconUrl = "/apps/dota2/images/heroes/silencer_icon.png"
      , vec = NoPosition
      }
    , { name = "Outworld Devourer"
      , iconUrl = "/apps/dota2/images/heroes/obsidian_destroyer_icon.png"
      , vec = NoPosition
      }
    , { name = "Lycan"
      , iconUrl = "/apps/dota2/images/heroes/lycan_icon.png"
      , vec = NoPosition
      }
    , { name = "Brewmaster"
      , iconUrl = "/apps/dota2/images/heroes/brewmaster_icon.png"
      , vec = NoPosition
      }
    , { name = "Shadow Demon"
      , iconUrl = "/apps/dota2/images/heroes/shadow_demon_icon.png"
      , vec = NoPosition
      }
    , { name = "Lone Druid"
      , iconUrl = "/apps/dota2/images/heroes/lone_druid_icon.png"
      , vec = NoPosition
      }
    , { name = "Chaos Knight"
      , iconUrl = "/apps/dota2/images/heroes/chaos_knight_icon.png"
      , vec = NoPosition
      }
    , { name = "Meepo"
      , iconUrl = "/apps/dota2/images/heroes/meepo_icon.png"
      , vec = NoPosition
      }
    , { name = "Treant Protector"
      , iconUrl = "/apps/dota2/images/heroes/treant_icon.png"
      , vec = NoPosition
      }
    , { name = "Ogre Magi"
      , iconUrl = "/apps/dota2/images/heroes/ogre_magi_icon.png"
      , vec = NoPosition
      }
    , { name = "Undying"
      , iconUrl = "/apps/dota2/images/heroes/undying_icon.png"
      , vec = NoPosition
      }
    , { name = "Rubick"
      , iconUrl = "/apps/dota2/images/heroes/rubick_icon.png"
      , vec = NoPosition
      }
    , { name = "Disruptor"
      , iconUrl = "/apps/dota2/images/heroes/disruptor_icon.png"
      , vec = NoPosition
      }
    , { name = "Nyx Assassin"
      , iconUrl = "/apps/dota2/images/heroes/nyx_assassin_icon.png"
      , vec = NoPosition
      }
    , { name = "Naga Siren"
      , iconUrl = "/apps/dota2/images/heroes/naga_siren_icon.png"
      , vec = NoPosition
      }
    , { name = "Keeper of the Light"
      , iconUrl = "/apps/dota2/images/heroes/keeper_of_the_light_icon.png"
      , vec = NoPosition
      }
    , { name = "Io"
      , iconUrl = "/apps/dota2/images/heroes/wisp_icon.png"
      , vec = NoPosition
      }
    , { name = "Visage"
      , iconUrl = "/apps/dota2/images/heroes/visage_icon.png"
      , vec = NoPosition
      }
    , { name = "Slark"
      , iconUrl = "/apps/dota2/images/heroes/slark_icon.png"
      , vec = NoPosition
      }
    , { name = "Medusa"
      , iconUrl = "/apps/dota2/images/heroes/medusa_icon.png"
      , vec = NoPosition
      }
    , { name = "Troll Warlord"
      , iconUrl = "/apps/dota2/images/heroes/troll_warlord_icon.png"
      , vec = NoPosition
      }
    , { name = "Centaur Warrunner"
      , iconUrl = "/apps/dota2/images/heroes/centaur_icon.png"
      , vec = NoPosition
      }
    , { name = "Magnus"
      , iconUrl = "/apps/dota2/images/heroes/magnataur_icon.png"
      , vec = NoPosition
      }
    , { name = "Timbersaw"
      , iconUrl = "/apps/dota2/images/heroes/shredder_icon.png"
      , vec = NoPosition
      }
    , { name = "Bristleback"
      , iconUrl = "/apps/dota2/images/heroes/bristleback_icon.png"
      , vec = NoPosition
      }
    , { name = "Tusk"
      , iconUrl = "/apps/dota2/images/heroes/tusk_icon.png"
      , vec = NoPosition
      }
    , { name = "Skywrath Mage"
      , iconUrl = "/apps/dota2/images/heroes/skywrath_mage_icon.png"
      , vec = NoPosition
      }
    , { name = "Abaddon"
      , iconUrl = "/apps/dota2/images/heroes/abaddon_icon.png"
      , vec = NoPosition
      }
    , { name = "Elder Titan"
      , iconUrl = "/apps/dota2/images/heroes/elder_titan_icon.png"
      , vec = NoPosition
      }
    , { name = "Legion Commander"
      , iconUrl = "/apps/dota2/images/heroes/legion_commander_icon.png"
      , vec = NoPosition
      }
    , { name = "Techies"
      , iconUrl = "/apps/dota2/images/heroes/techies_icon.png"
      , vec = NoPosition
      }
    , { name = "Ember Spirit"
      , iconUrl = "/apps/dota2/images/heroes/ember_spirit_icon.png"
      , vec = NoPosition
      }
    , { name = "Earth Spirit"
      , iconUrl = "/apps/dota2/images/heroes/earth_spirit_icon.png"
      , vec = NoPosition
      }
    , { name = "Underlord"
      , iconUrl = "/apps/dota2/images/heroes/abyssal_underlord_icon.png"
      , vec = NoPosition
      }
    , { name = "Terrorblade"
      , iconUrl = "/apps/dota2/images/heroes/terrorblade_icon.png"
      , vec = NoPosition
      }
    , { name = "Phoenix"
      , iconUrl = "/apps/dota2/images/heroes/phoenix_icon.png"
      , vec = NoPosition
      }
    , { name = "Oracle"
      , iconUrl = "/apps/dota2/images/heroes/oracle_icon.png"
      , vec = NoPosition
      }
    , { name = "Winter Wyvern"
      , iconUrl = "/apps/dota2/images/heroes/winter_wyvern_icon.png"
      , vec = NoPosition
      }
    , { name = "Arc Warden"
      , iconUrl = "/apps/dota2/images/heroes/arc_warden_icon.png"
      , vec = NoPosition
      }
    , { name = "Monkey King"
      , iconUrl = "/apps/dota2/images/heroes/monkey_king_icon.png"
      , vec = NoPosition
      }
    , { name = "Dark Willow"
      , iconUrl = "/apps/dota2/images/heroes/dark_willow_icon.png"
      , vec = NoPosition
      }
    , { name = "Pangolier"
      , iconUrl = "/apps/dota2/images/heroes/pangolier_icon.png"
      , vec = NoPosition
      }
    ]
