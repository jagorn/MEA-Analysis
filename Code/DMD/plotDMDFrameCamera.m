function plotDMDFrameCamera(stim_id, stim_version, frame_id, polarity)

h = getHomography('DMD', 'CAMERA');
plotDMDFrame(stim_id, stim_version, frame_id, 'Homography', h, 'Polarity', polarity)