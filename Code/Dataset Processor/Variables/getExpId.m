function exp_id = getExpId()
% returns the id of the experiment of the current dataset
% assuming the current dataset is composed of one only experiment)

load(getDatasetMat, 'experiments');
if(numel(experiments) == 1)
    exp_id = char(experiments{1});
else
    error('getExpId error: Current Dataset contains multiple experiments.')
end
