function plotSubclassMeanFeatures(classId)
subclasses = getSubclasses(classId);
plotClassMeanFeatures(subclasses);
suptitle(strcat(classId, ": subclasses features"));