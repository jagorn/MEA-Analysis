function loss = my_loss(params, x, y)
    loss = immse(y, funSigmoid(params, x));
end
