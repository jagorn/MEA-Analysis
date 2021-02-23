function Is = patternNormalizedIntensities(xs, ys)
% Light intensity compensation used to assure
% equal intensity for each spot in the pattern

assert(length(xs) == length(ys))
Is = 1 / sum(1 ./ spot_attenuation(xs, ys));
