function lgc = unfind(idx, N)
    %Go from indicies into logical (for vectors only)
    lgc = false(1, N);
    lgc(idx) = true;
end