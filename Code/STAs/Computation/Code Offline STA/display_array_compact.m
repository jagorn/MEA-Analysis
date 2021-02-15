function s = display_array_compact( l )
%DISPLAY_ARRAY_COMPACT

 if isequal(sort(l(:)'), (min(l):max(l)))
     s = [ num2str(min(l)) ':' num2str(max(l))];
     
 else
     s = int2str(l(:)');
 end

end

