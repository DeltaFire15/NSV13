//Defines for fleets / fleet navigation

#define ALIGNMENT_BLACKLIST 0	//Use any system EXCEPT ones with their alignment being present in the given alignments list.
#define ALIGNMENT_WHITELIST 1	//ONLY use systems with alignments which are present in the given alignments list.

//Fleet ship tier defines.
//!!Keep this updated if you add new shipsets or tiers.
#define SHIP_TIER_INTENTIONAL_ERROR -666    //Failsafe for if someone forgot to set a ship tier. Yes, I could default it to untiered, but it's better if the coder immediately knows they forgot and can manually set it to that, or the correct one.
#define SHIP_TIER_NOT_AI -42                //This ship is a ship, but it is not an AI ship so it'll absolutely never be used in anything. Used instead of clearing up the subtype list because oh boy it's so incoherent.
#define MAX_SHIP_TIER 5                     //The highest ship tier used in random generation               
#define SHIP_TIER_UNTIERED -1               //Will not be used in random fleet generation.
#define SHIP_TIER_CORE 0                    //Ships that are the lifeblood of a fleet. Carriers. Command ships. That kinda stuff.
#define SHIP_TIER_ONE 1                     //Very small ships. Corvettes, Frigates, anything really light.
#define SHIP_TIER_TWO 2                     //Relatively Small and medium ships. Destroyers, Light Cruisers, Heavy Escorts.
#define SHIP_TIER_THREE 3                   //Medium to bigish ships. Cruisers. Nuke ships.
#define SHIP_TIER_FOUR 4                    //Scary Ships. Elites, of all forms and colors.
#define SHIP_TIER_FIVE 5                    //Big boys. Capital ships.

//Ship list stuff
GLOBAL_LIST_EMPTY(tiered_faction_ship_list) //List with ships sorted by faction and tier. Initialized by the starsystem controller.

#define SYNDICATE_SHIPS 1
#define NANOTRASEN_SHIPS 2
#define SPACEPIRATE_SHIPS 3
#define SOLGOV_SHIPS 4
GLOBAL_LIST_INIT(core_alignments, list(
    SYNDICATE_SHIPS,
    NANOTRASEN_SHIPS,
    SPACEPIRATE_SHIPS,
    SOLGOV_SHIPS))

GLOBAL_LIST_INIT(ship_basetypes, list(
    subtypesof(/obj/structure/overmap/syndicate),
    (subtypesof(/obj/structure/overmap/nanotrasen) - typesof(/obj/structure/overmap/nanotrasen/solgov)),
    subtypesof(/obj/structure/overmap/spacepirate),
    subtypesof(/obj/structure/overmap/nanotrasen/solgov)))  //Basetypes for our fun tiered list. Linked with the previous list and will be used as Key-Value pair in the ship list.

#define ITERATE_UPWARDS "upwards_mode"      //Small ships first, big ones later. Will cause a swarm of smol ships with maybe some bigger ones.
#define ITERATE_DOWNWARDS "downwards_mode"  //Big ships first, smol ones later. Will cause a capital ship force with a few escorts.
#define ITERATE_RANDOM "rng_mode"           //Pick random ships till we got no more points. True RNG.
#define ITERATE_PYRAMID "pyramid_mode"      //1 ship of higher tier needs X ships of the tier below to exist.
                                            //!!Core ships always get chosen first.

#define PYRAMID_WIDTH 2 //The amount of ships of a tier required to have one ship of the tier above. Provided the fleet uses Pyramid mode.

//Ship tier costs. Assumption: Ships within a tier are somewhat comparable but just with different specialities, whilst different tiers have big differences.
//#define TIER_COST_CORE 6    //Core ship amount is artificially restricted by the fleet point number. "Free" for now.
#define TIER_COST_ONE 1
#define TIER_COST_TWO 2
#define TIER_COST_THREE 4
#define TIER_COST_FOUR 7
#define TIER_COST_FIVE 16

#define CORE_SHIP_PREVALENCE 18    //One Core ship per how many points? Rounded up, minimum of one.

//Fleet Difficulty Defines
#define FLEET_DIFFICULTY_EASY 2 //if things end up being too hard, this is a safe number for a fight you _should_ always win.
#define FLEET_DIFFICULTY_MEDIUM 5
#define FLEET_DIFFICULTY_HARD 8
#define FLEET_DIFFICULTY_VERY_HARD 10
#define FLEET_DIFFICULTY_INSANE 15 //If you try to take on the rubicon ;)
#define FLEET_DIFFICULTY_WHAT_ARE_YOU_DOING 25
#define FLEET_DIFFICULTY_DEATH 30 //Suicide run

#define FLEET_POINTS_EASY 4
#define FLEET_POINTS_MEDIUM 10
#define FLEET_POINTS_HARD 18
#define FLEET_POINTS_VERY_HARD 28
#define FLEET_POINTS_INSANE 40
#define FLEET_POINTS_WHAT_ARE_YOU_DOING 56
#define FLEET_POINTS_DEATH 70
