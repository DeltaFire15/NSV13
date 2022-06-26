
//ERR - database null response

/obj/structure/overmap/undefined
    name = "unknown vessel"
    desc = "Error - no database entry found."
    //icon = TEMP
    //icon_state = TEMP
    faction = "4442A"
    ai_controlled = TRUE
    ai_behaviour = AI_AGGRESSIVE
    ai_flags = AI_FLAG_DESTROYER
    ship_flags = SHIP_SENSOR_CLOAK | SHIP_AI_UNTARGETTABLE

/obj/structure/overmap/undefined/alpha
    obj_integrity = 200
    max_integrity = 200
    integrity_failure = 200
    mass = MASS_TINY
    ai_flags = AI_FLAG_SWARMER | AI_FLAG_NO_RESUPPLY
