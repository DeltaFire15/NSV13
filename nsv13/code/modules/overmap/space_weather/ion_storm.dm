
/datum/space_weather/ion_storm
    name = "Ion Storm"
    desc = "Great care should be taken with electrical systems."
    begin_desc = "The particles created will have potential to severely hamper electronics."
    end_desc = "Electronics should no longer be at risk of malfunctions."
    cycle_interval = 30 SECONDS
    default_duration = 10 MINUTES

/datum/space_weather/ion_storm/on_cycle()
    . = ..()

    //WIP
