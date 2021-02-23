function mea_map = getMapMEA()
load('PositionsMEA.mat', 'Positions')
mea_map = double(Positions);
