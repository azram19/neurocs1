function connectivityMatrix = generateExcitatoryToExcitatory(nHubs,nExcNeurons)
    
    nEdges = 1000;
    nNeurons = nExcNeurons/nHubs;

    connectivityMatrix = zeros(nExcNeurons);

    for i = 1:nHubs
        edges = generateEdges(i,nEdges,nNeurons);
        for j = 1:length(edges)
            edge = edges(j,:);
            connectivityMatrix(edge(1), edge(2)) = 1;
    	end
    end
end