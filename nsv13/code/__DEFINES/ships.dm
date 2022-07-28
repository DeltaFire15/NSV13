#define MASS_TINY 1 //1 Player - Fighters
#define MASS_SMALL 2 //2-5 Players - FoB/Mining Ship
#define MASS_MEDIUM 3 //10-20 Players - Small Capital Ships
#define MASS_MEDIUM_LARGE 5 //10-20 Players - Small Capital Ships
#define MASS_LARGE 7 //20-40 Players - Medium Capital Ships
#define MASS_TITAN 150 //40+ Players - Large Capital Ships
#define MASS_IMMOBILE 200 //Things that should not be moving. See: stations

//Some defines for ship sensor jamming
#define SENSOR_GHOST_MIN_INTERVAL 15 SECONDS //Min time between sensor ghost refresh
#define SENSOR_GHOST_MAX_INTERVAL 40 SECONDS //Max time between sensor ghost refresh
#define SENSOR_GHOST_MIN_COUNT 5 //Minimum ghost count generated
#define SENSOR_GHOST_MAX_COUNT 10 //Maximum ghost count generated

//Defines for ship subsystems
#define SHSUBSYS_BASE_MALF_DISABLE_TIME 2 //Subsystem activation ticks ship subsystem generally get disabled on malfunction
#define SHSUBSYS_JAMMER_BUILDUP_CAP 20 //How many ticks of jamming a ship can have queued up due to a jammer subsystem
