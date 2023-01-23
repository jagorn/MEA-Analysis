function mosaics = annotatePreviousValidation(mosaics, mosaics_old)

old_mosaics_used = false(size(mosaics_old));

for i_m = 1:numel(mosaics)
    m = mosaics(i_m);
    t = m.type;
    e = m.experiment;
    
    matches_previous_validation =  strcmp([mosaics_old.experiment], e) & strcmp([mosaics_old.class], t);
    old_mosaics_used = old_mosaics_used | matches_previous_validation;
    if any(matches_previous_validation)
        mosaics(i_m).ks_validated = true;
        try
            mosaics(i_m).Label = mosaics_old(matches_previous_validation).Label;
        catch
            mosaics(i_m).Label = "N/A";
        end
    else
        mosaics(i_m).ks_validated = false;
        mosaics(i_m).Label = "N/A";
    end
    
    
end

if ~all(old_mosaics_used)
    find(~old_mosaics_used)
    error("some mosaics have not been used:");
end
