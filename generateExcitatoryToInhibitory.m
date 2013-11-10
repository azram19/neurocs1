function connectivityMatrix = generateExcitatoryToInhibitory(numHubs,numExcNeurons,numInhNeurons)
    
    connectivityMatrix = zeros(numInhNeurons,numExcNeurons);
    
    for i = 1:numHubs
        division = divideHub(i,numExcNeurons/numHubs);
        connectivityMatrix = connectExhibitoryToInhibitory(division,connectivityMatrix);
    end    
end