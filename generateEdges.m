function edges = generateEdges(hub, nEdges, nNeurons)
    startNeuron = (hub-1) * nNeurons;
    
    k = randperm(nNeurons/2*(nNeurons-1),nEdges);
    %k = 1:21;
    q = floor(sqrt(8*(k-1)+1)/2 + 3/2);
    p = k - (q-1).*(q-2)/2;
    
    edges = [p;q]';
    edges = edges + startNeuron;
end
