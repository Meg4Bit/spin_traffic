#define RED 0
#define GREEN 1
#define N 3

bool sn_lock;
bool ne_lock;
bool ew_lock;
bool es_lock;
bool wn_lock;
bool pedestrian_lock;
chan mutex = [1] of {bit}
bool ne_req;
bool sn_req;
bool ew_req;
bool es_req;
bool wn_req;
bool req;

proctype environment(chan c) {
    do
        :: if 
            :: true -> c!true;
            :: true -> skip;
           fi
    od
}

proctype NE(chan car_req) {
    bit ne_light;
    bit blocker;
    byte limit;
    do
        :: car_req ? ne_req ->
            do
                :: mutex!1 ->
                    if
                    :: !sn_lock && !ew_lock && !es_lock && !wn_lock && !pedestrian_lock ->
                        ne_lock = true;
                        mutex?blocker;
                        ne_light = GREEN;
                        printf("Car passed from north to east\n");
                        // wait (!N_SENSE) /* waits until all cars pass */
                        ne_light = RED;
                        ne_lock = false;
                        ne_req = false;
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype SN(chan car_req) {
    bit sn_light;
    bit blocker;
    do
        :: car_req ? sn_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock && !es_lock ->
                        sn_lock = true;
                        mutex?blocker;
                        sn_light = GREEN;
                        printf("Car passed from south to north\n");
                        // wait (!N_SENSE) /* waits until all cars pass */
                        sn_light = RED;
                        sn_lock = false;
                        sn_req = false;
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype EW(chan car_req) {
    bit ew_light;
    bit blocker;
    do
        :: car_req ? ew_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !sn_lock && !wn_lock && !pedestrian_lock ->
                        ew_lock = true;
                        mutex?blocker;
                        ew_light = GREEN;
                        printf("Car passed from east to west\n");
                        // wait (!N_SENSE) /* waits until all cars pass */
                        ew_light = RED;
                        ew_lock = false;
                        ew_req = false;
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype ES(chan car_req) {
    bit es_light;
    bit blocker;
    do
        :: car_req ? es_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !sn_lock && !pedestrian_lock ->
                        es_lock = true;
                        mutex?blocker;
                        es_light = GREEN;
                        printf("Car passed from east to south\n");
                        // wait (!N_SENSE) /* waits until all cars pass */
                        es_light = RED;
                        es_lock = false;
                        es_req = false;
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype WN(chan car_req) {
    bit wn_light;
    bit blocker;
    byte limit;
    do
        :: car_req ? wn_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock ->
                        //if 
                        //:: limit > 3 ->
                        //    mutex?blocker;
                        //    skip;
                        //:: else ->
                            wn_lock = true;
                            mutex?blocker;
                            wn_light = GREEN;
                            printf("Car passed from west to north\n");
                            // wait (!N_SENSE) /* waits until all cars pass */
                            wn_light = RED;
                            wn_lock = false;
                            wn_req = false;
                            limit = limit + 1;
                            break;
                        //fi
                    :: else -> mutex?blocker; limit = 0;
                    fi
            od
    od
}

proctype pedestrian(chan pedestrian_req) {
    bit light;
    bit blocker;
    byte limit;
    do
        :: limit > 3 ->
            if
            :: ne_req || ew_req || es_req -> skip;
            :: else -> limit = 0;
            fi
        :: pedestrian_req ? req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock && !es_lock ->
                        pedestrian_lock = true;
                        mutex?blocker;
                        light = GREEN;
                        printf("Pedestrian crossed the road\n");
                        // wait (!N_SENSE) /* waits until all cars pass */
                        light = RED;
                        pedestrian_lock = false;
                        req = false;
                        limit = limit + 1;
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

init {
    chan ch[6] = [1] of {bool};
    run environment(ch[0]);
    run NE(ch[0]);
    run environment(ch[1]);
    run SN(ch[1]);
    run environment(ch[2]);
    run EW(ch[2]);
    run environment(ch[3]);
    run ES(ch[3]);
    run environment(ch[4]);
    run WN(ch[4]);
    run environment(ch[5]);
    run pedestrian(ch[5]);
}

ltl safety1{[]!(ne_lock == GREEN && sn_lock == GREEN && ew_lock == GREEN && es_lock == GREEN && wn_lock == GREEN && pedestrian_lock == GREEN)};
ltl safety2{[]!(ne_lock == GREEN && (sn_lock == GREEN || ew_lock == GREEN || es_lock == GREEN || wn_lock == GREEN || pedestrian_lock == GREEN))};
ltl safety3{[]!(pedestrian_lock == GREEN && (ew_lock == GREEN || es_lock == GREEN || ne_lock == GREEN))};

ltl liveness1{[](ne_req && ne_lock == RED -> <>(ne_lock == GREEN))};
