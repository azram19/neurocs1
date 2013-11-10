function connectivityMatrix = generateExcitatoryToExcitatory(nHubs,nExcNeurons, nEdges)
    
    nNeurons = nExcNeurons/nHubs;

    connectivityMatrix = zeros(nExcNeurons);

    for hub = 1:nHubs
        edges = generateEdges(hub,nEdges,nNeurons);
        for j = 1:length(edges)
            edge = edges(j,:);
            connectivityMatrix(edge(1), edge(2)) = 1;
    	end
    end
end