set type double
insheet using tests/fixtures/data.csv, comma names clear
fastdid2s y x, time(time) cluster(state) gvar(g) inference(native jackknife)
