function mosaics = computeBenchmarkRegularity(mosaics, regularities, mosaic_idx)

if  ~exist('mosaic_idx', 'var')
    mosaic_idx = 1:numel(mosaics);
end

for i_m = mosaic_idx
    
    r = regularities(i_m);
    nnri = r.nnri.ri;
    er = r.er.effective_radius;
    ci = r.ci.cov_index;
    pf = r.er.packing_factor;

    m = mosaics(i_m);
    mat_name = strcat('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Regularity/_benchmarks/', m.id, '.mat');
    load(mat_name, 'benchmark_regularity');
    
    b_nnris = zeros(numel(benchmark_regularity), 1);
    b_ers = zeros(numel(benchmark_regularity), 1);
    b_cis = zeros(numel(benchmark_regularity), 1);
    b_pfs = zeros(numel(benchmark_regularity), 1);
    for i_b = 1:numel(benchmark_regularity)
        b_nnris(i_b) = benchmark_regularity(i_b).nnri.ri;
        b_ers(i_b) = benchmark_regularity(i_b).er.effective_radius;
        b_cis(i_b) = benchmark_regularity(i_b).ci.cov_index;
        b_pfs(i_b) = benchmark_regularity(i_b).er.packing_factor;
    end
    mosaics(i_m).nnri = nnri;
    mosaics(i_m).benchmark_nnris = b_nnris;
    mosaics(i_m).er = er;
    mosaics(i_m).benchmark_ers = b_ers;
    mosaics(i_m).ci = ci;
    mosaics(i_m).benchmark_cis = b_cis;
    mosaics(i_m).pf = pf;
    mosaics(i_m).benchmark_pfs = b_pfs;
    mosaics(i_m).nnri_test = sum(b_nnris>nnri) / numel(b_nnris);
    mosaics(i_m).er_test = sum(b_ers>er) / numel(b_ers);
    mosaics(i_m).ci_test = sum(b_cis>ci) / numel(b_cis);
    mosaics(i_m).pf_test = sum(b_pfs>pf) / numel(b_pfs);
end