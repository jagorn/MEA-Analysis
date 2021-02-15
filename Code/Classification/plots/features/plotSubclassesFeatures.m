function plotSubclassesFeatures(classId)

subclasses = getSubclasses(classId);
for subclass = subclasses
    plotClassFeatures(subclass);
end
    


