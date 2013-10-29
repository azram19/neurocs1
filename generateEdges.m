  function edges = generateEdges(hub, nEdges, nNeurons)
    startNeuron = (hub-1) * nNeurons;
    
    k = randperm(nNeurons*nNeurons,nEdges);
    
    p = ceil(k / nNeurons);
    q = mod(k, nNeurons) + 1;
    
    edges = [p;q]';
    edges = edges + startNeuron;
end
