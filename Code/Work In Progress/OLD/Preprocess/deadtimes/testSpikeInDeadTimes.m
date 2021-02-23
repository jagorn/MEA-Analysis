function testSpikeInDeadTimes(expId)

spikesFile = [dataPath '/' expId '/sorted/CONVERTED/CONVERTED.result.hdf5'];
deadTimesFile = [dataPath '/' expId '/sorted/dead_times.txt'];

spike_times = extractSpikeTimes(spikesFile);
dead_times = load(deadTimesFile); 
check_deadTimes(dead_times, spike_times);