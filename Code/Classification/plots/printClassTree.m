function printClassTree(class, spaces)
% Prints the clustering tree with all clusters and subclusters.

if ~exist('class','var')
    class = "";
end

if ~exist('spaces','var')
    spaces = "";
end
    
    classes = getSubclasses(class);
    for class = classes
        fprintf(strcat(spaces, class,"\n"))
        printClassTree(class, strcat(spaces, '\t'));
    end
end

