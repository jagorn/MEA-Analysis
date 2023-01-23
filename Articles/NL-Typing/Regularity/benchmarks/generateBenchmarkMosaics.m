function generateBenchmarkMosaics(cellsTable, mosaics, rfs, roi_size, n_simulations, mosaic_idx, do_override)

n_mosaics = numel(mosaics);
n_cells = numel(cellsTable);

if  ~exist('mosaic_idx', 'var')
    mosaic_idx = 1:n_mosaics;
end

if  ~exist('do_override', 'var')
    do_override = false;
end

for i_m = mosaic_idx
    mosaic = mosaics(i_m);
    
    benchmark_file = strcat('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Regularity/_benchmarks/', mosaic.id, '.mat');
    benchmark_is_fine = false;
    if exist(benchmark_file, 'file')
        load(benchmark_file, 'benchmark_mosaics');
        b = benchmark_mosaics(1);
        if b.size == sum(b.idx) && b.size == mosaic.size
            benchmark_is_fine = true;
        else
            fprintf("benchmarks for mosaic %s is outdated.\n", mosaic.id);
        end
    end
    
    if benchmark_is_fine && ~do_override
        fprintf("benchmarks for mosaic %s (%i/%i) already exist.\n", mosaic.id, i_m, sum(mosaic_idx>0));
    else
        
        fprintf("Computing benchmarks for mosaic %s (%i/%i)\n", mosaic.id, i_m, sum(mosaic_idx>0));
        
        clear benchmark_mosaics;
        benchmark_mosaics(n_simulations) = struct();
        
        for i_s = 1:n_simulations
            
            benchmark_mosaics(i_s).id = strcat("benchmark ", num2str(i_s), " ", mosaic.id);
            benchmark_mosaics(i_s).type = "benchmark";
            benchmark_mosaics(i_s).mosaic = mosaic.id;
            benchmark_mosaics(i_s).polarity = mosaic.polarity;
            benchmark_mosaics(i_s).experiment = mosaic.experiment;
            benchmark_mosaics(i_s).size = mosaic.size;
            
            exp_idx = find(strcmp([cellsTable.experiment], mosaic.experiment));
            benchmark_idx = exp_idx(randperm(numel(exp_idx), mosaic.size));
            benchmark_idx = unfind(benchmark_idx, n_cells)';
            benchmark_mosaics(i_s).idx = benchmark_idx;
        end
        benchmark_regularity = checkMosaicRegularity(benchmark_mosaics, rfs, roi_size);
        
        save(benchmark_file, 'benchmark_mosaics', 'benchmark_regularity');
    end
end

