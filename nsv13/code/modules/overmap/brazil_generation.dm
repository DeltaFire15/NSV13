///Connection styles
#define SPIDERWEB_CORE 0    //Picks the generated system closest to the center of the cluster, then builds a web from it.
#define SPIDERWEB_RNG 1     //Picks a random system from the generated systems, then builds a web from it.
#define RNG_MODE 2          //Does a bunch of random yet conclusive linking to determine core layout. Might lead to weird looks.

///Random stuff, magic numbers bad
#define TRADER_PROB 10
#define FLEET_PROB 10
#define MAX_TRIES_SYS_DISTANCE 300  //If we have to place a system more than 300 times we stop caring about distance

/datum/brazil_cluster
    var/name = "brazil cluster basetype - this one really shouldn't actually exist ingame"  //Cluster name purely for varedit info purposes (and whatever others want to do with it)
    var/list/cluster_systems = list()           //List of systems in this cluster. Filled on generation.
    var/layout_type = SPIDERWEB_CORE            //What type of layout system does this cluster use.
    var/nonrelaxation_penalty = 1.2             //An already present connection's length is multiplied with this when considered for relaxation. Will behave weirdly if <= 1 or high.
    var/min_amount = 0                          //Min amount of systems.
    var/max_amount = 0                          //Max amount of systems.
    var/min_distance = 5                        //How close can a system be to other systems of this cluster. Skipped if generation fails too much (e.g. there is alot of systems in a small space)
    var/random_connection_min_dist = 0          //If you for some cursed reason want random connections to have a min dist.
    var/random_connection_max_dist = 20         //How long can random jumplines be? Excludes layout ones.
    var/rngsyetem_max_connections = 4           //Hard cap on how many connections a system can have caused by the RNG phase.. the initial layout phase may cause more than this, though.
    var/random_connection_base_chance = 40      //Base chance for a random connection.
    var/random_connection_repeat_penalty = 20   //Penalty for already generated random connections this system has.
    var/random_connection_layout_penalty = 5    //Penalty for already generated layout connections this system has.
    var/x_minbound = 0                          //x coord the cluster begins.
    var/x_maxbound = 0                          //x coord the cluster ends.
    var/y_minbound = 0                          //y coord the cluster begins.
    var/y_maxbound = 0                          //y coord the cluster ends.
    var/cluster_sector = 0                      //Which sector do the generated systems belong to?
    var/list/external_links = list()            //Which starsystems outside this cluster get linked to the closest system in this cluster? Starsystem names (so we can just use star_system_by_id)
    var/random_external_links = 0               //How many random external links get generated? These use the random external link maxdist and might lead to not actually gen any if there's no closeby systems.
    var/random_external_link_max_dist = 20      //How long can these random external links be? Only relevant if the number of random external links is > 0

/datum/brazil_cluster/New()
    . = ..()
    generate_cluster()

/datum/brazil_cluster/proc/generate_cluster()  
    var/start_timeofday = REALTIMEOFDAY
    generate_systems()
    //generate_layout()
    //generate_additionals()
    //linkup()

/datum/brazil_cluster/proc/generate_systems()
    var/amount = max_amount > min_amount ? rand(min_amount, max_amount) : min_amount
    message_admins("Generating brazil cluster [name] with [amount] systems.")

    for(var/I=0;I<amount,I++)
        var/datum/star_system/random/randy = new /datum/star_system/random()
        randy.system_type = pick(
			list(
				tag = "radioactive",
				label = "Radioactive",
			), 0.5;
			list(
				tag = "blackhole",
				label = "Blackhole",
			),
			list(
				tag = "quasar",
				label = "Quasar",
			), 0.75;
			list(
				tag = "accretiondisk",
				label = "Accretion disk",
			),
			list(
				tag = "nebula",
				label = "Nebula",
			),
			list(
				tag = "supernova",
				label = "Supernova",
			),
			list(
				tag = "debris",
				label = "Asteroid field",
			),
		)
        randy.apply_system_effects()
        var/list/randy_systype = randy.system_type
        randy.name = (randy_systype.tag != "nebula") ? "S-[rand(0,10000)]" : "N-[rand(0,10000)]"
        var/randy_valid = FALSE

        var/failed_to_distance = 0

        while(!randy_valid)         
            randy.x = rand(x_minbound, x_maxbound)
            randy.y = rand(y_minbound, y_maxbound)
            var/syscheck_pass = TRUE
            for(var/datum/star_system/S in cluster_systems)
                if(!syscheck_pass)
                    break
                if(S.dist(randy) < min_distance && failed_to_distance <= MAX_TRIES_SYS_DISTANCE)// Maybe this is enough?
                    syscheck_pass = FALSE
                    failed_to_distance++
                    break
            if(syscheck_pass)
                randy_valid = TRUE

        randy.sector = cluster_sector //Yeah do I even need to explain this?
        randy.hidden = FALSE
        cluster_systems += randy
        if(prob(TRADER_PROB))
            //TRADER_PROB percent of systems have a trader for resupply.
            var/x = pick(subtypesof(/datum/trader))
            var/datum/trader/randytrader = new x
            var/obj/structure/overmap/trader/randystation = SSstar_system.spawn_anomaly(randytrader.station_type, randy)
            randystation.starting_system = randy.name
            randystation.current_system = randy
            randystation.set_trader(randytrader)
            randy.trader = randytrader
            randytrader.generate_missions()

        else if(prob(FLEET_PROB))
            var/x = pick(/datum/fleet/wolfpack, /datum/fleet/neutral, /datum/fleet/pirate/raiding, /datum/fleet/boarding, /datum/fleet/nanotrasen/light)
            var/datum/fleet/randyfleet = new x
            randyfleet.current_system = randy
            randyfleet.hide_movements = TRUE //Prevent the shot of spam this caused to R1497.
            randy.fleets += randyfleet
            randy.alignment = randyfleet.alignment
            randyfleet.assemble(randy)

        SSstar_system.systems += randy

/datum/brazil_cluster/proc/generate_layout()
    if(mode == SPIDERWEB_CORE || mode == SPIDERWEB_RNG)
        layout_dijkstra()
    else if(mode == RNG_MODE)
        layout_rng()
    else
        CRASH("Invalid mode for generation of brazil cluster [name]!")

/datum/brazil_cluster/proc/layout_dijkstra()

/datum/brazil_cluster/proc/layout_rng()