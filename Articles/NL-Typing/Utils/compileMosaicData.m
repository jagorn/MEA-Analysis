function mosaics = compileMosaicData(mosaics, rfs, psths, stas)

for i_mosaic = 1:numel(mosaics)
    m_idx = mosaics(i_mosaic).idx;
    m_rfs = rfs(m_idx); 
    [somas_x, somas_y] = centroid(m_rfs);
    
    mosaics(i_mosaic).somas = [somas_x; somas_y]';
    mosaics(i_mosaic).rfs = m_rfs;
    mosaics(i_mosaic).psths = psths(m_idx, :);
    mosaics(i_mosaic).stas = stas(m_idx);
    
end
