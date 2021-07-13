function registerExpImages(exp_id, img_extension)

if ~exist('img_extension', 'var')
    img_extension = 'jpg';
end
exp_images = dir(strcat(processedPath(exp_id), '/*.', img_extension));

if isempty(exp_images)
    disp('no images were found');
else
    
    chosen_img = 1;
    while chosen_img > 0
        
        fprintf('the following images exist in %s:\n', exp_id)
        for i_img = 1:numel(exp_images)
            fprintf('\t%i: %s\n', i_img, exp_images(i_img).name);
        end
        fprintf('\nwhich image would you like to register? (1-%i, or 0 for none)\n', numel(exp_images));
        
        chosen_img = input('');
        if chosen_img > numel(exp_images)
            chosen_img = input('image id out of range. Which image would you like to register?\n');
            
        elseif chosen_img > 0
            [~, name, ext] = fileparts(exp_images(chosen_img).name);
            setH_Photo2MEA(exp_id, name, ext)
            disp('image registered');
        end
    end
end