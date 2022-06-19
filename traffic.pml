#define RED 0
#define GREEN 1
#define N 3

bool sn_lock;
bool ne_lock;
bool ew_lock;
bool es_lock;
bool wn_lock;
bool pedestrian_lock;
bool ne_req;
bool sn_req;
bool ew_req;
bool es_req;
bool wn_req;
bool req;

byte limit[6];

chan control_chan[6] = [1] of {bit}

chan mutex = [1] of {bit}
chan mutex2 = [1] of {bit}

proctype environment(chan c) {
    do
        :: true -> c!true;
    od
}

proctype NE(chan car_req) {
    bit ne_light;
    bit blocker;
    control_chan[0]!1;
    do
        :: car_req ? ne_req ->
            do
                :: mutex!1 ->
                    if
                    :: !sn_lock && !ew_lock && !es_lock && !wn_lock && !pedestrian_lock ->
                        ne_lock = true;
                        ne_light = GREEN;
                        printf("Car passed from north to east\n");
                        ne_light = RED;
                        ne_lock = false;
                        ne_req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[0] = limit[0] + 1;
                        if
                        :: limit[0] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[0]!1;
                        :: else -> mutex2?blocker;
                        fi
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype SN(chan car_req) {
    bit sn_light;
    bit blocker;
    control_chan[1]!1;
    do
        :: car_req ? sn_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock && !es_lock ->
                        sn_lock = true;
                        sn_light = GREEN;
                        printf("Car passed from south to north\n");
                        sn_light = RED;
                        sn_lock = false;
                        sn_req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[1] = limit[1] + 1;
                        if
                        :: limit[1] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[1]!1;
                        :: else -> mutex2?blocker;
                        fi
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype EW(chan car_req) {
    bit ew_light;
    bit blocker;
    control_chan[2]!1;
    do
        :: car_req ? ew_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !sn_lock && !wn_lock && !pedestrian_lock ->
                        ew_lock = true;
                        ew_light = GREEN;
                        printf("Car passed from east to west\n");
                        ew_light = RED;
                        ew_lock = false;
                        ew_req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[2] = limit[2] + 1;
                        if
                        :: limit[2] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[2]!1;
                        :: else -> mutex2?blocker;
                        fi
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype ES(chan car_req) {
    bit es_light;
    bit blocker;
    control_chan[3]!1;
    do
        :: car_req ? es_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !sn_lock && !pedestrian_lock ->
                        es_lock = true;
                        es_light = GREEN;
                        printf("Car passed from east to south\n");
                        es_light = RED;
                        es_lock = false;
                        es_req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[3] = limit[3] + 1;
                        if
                        :: limit[3] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[3]!1;
                        :: else -> mutex2?blocker;
                        fi
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype WN(chan car_req) {
    bit wn_light;
    bit blocker;
    control_chan[4]!1;
    do
        :: car_req ? wn_req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock ->
                        wn_lock = true;
                        wn_light = GREEN;
                        printf("Car passed from west to north\n");
                        wn_light = RED;
                        wn_lock = false;
                        wn_req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[4] = limit[4] + 1;
                        if
                        :: limit[4] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[4]!1;
                        :: else -> mutex2?blocker;
                        fi
                        break;
                    :: else -> mutex?blocker;
                    fi
            od
    od
}

proctype pedestrian(chan pedestrian_req) {
    bit light;
    bit blocker;
    control_chan[5]!1;
    do
        :: pedestrian_req ? req ->
            do
                :: mutex!1 ->
                    if
                    :: !ne_lock && !ew_lock && !es_lock ->
                        pedestrian_lock = true;
                        light = GREEN;
                        printf("Pedestrian crossed the road\n");
                        light = RED;
                        pedestrian_lock = false;
                        req = false;
                        mutex?blocker;
                        mutex2!1;
                        limit[5] = limit[5] + 1;
                        if
                        :: limit[5] > N -> 
                            if
                            :: limit[0] > N && limit[1] > N && limit[2] > N && limit[3] > N && limit[4] > N && limit[5] > N ->
                                control_chan[0]?blocker;
                                limit[0] = 0;
                                control_chan[1]?blocker;
                                limit[1] = 0;
                                control_chan[2]?blocker;
                                limit[2] = 0;
                                control_chan[3]?blocker;
                                limit[3] = 0;
                                control_chan[4]?blocker;
                                limit[4] = 0;
                                control_chan[5]?blocker;
                                limit[5] = 0;
                            :: else -> skip;
                            fi
                            mutex2?blocker; control_chan[5]!1;
                        :: else -> mutex2?blocker;
                        fi
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

ltl liveness1{[]((ne_req && (ne_lock == RED)) -> <>(ne_lock == GREEN))};
ltl liveness2{[]((sn_req && (sn_lock == RED)) -> <>(sn_lock == GREEN))};


ltl fairness1{[]<>!((ne_lock == GREEN) && ne_req)};
