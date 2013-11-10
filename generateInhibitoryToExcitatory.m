function connectivityMatrix = generateInhibitoryToExcitatory(numExcNeurons,numInhNeurons)

    connectivityMatrix = -rand(numExcNeurons,numInhNeurons);
end