function [globalConnectivityMatrix, rewiredExcitatory2eConnectivity, excitatory2iConnectivity, inhibitory2iConnectivity, inhibitory2eConnectivity] = generateModularNetwork(nHubs, nExcitatory, nExcitatoryEdges, nInhibitory, p)
    excitatory2eConnectivity = generateExcitatoryToExcitatory(nHubs, nHubs * nExcitatory, nExcitatoryEdges); 
    rewiredExcitatory2eConnectivity = rewireExhibitory(nHubs, nExcitatory, excitatory2eConnectivity, p);
    excitatory2iConnectivity = generateExcitatoryToInhibitory(nHubs, nHubs * nExcitatory, nInhibitory);
    inhibitory2iConnectivity = generateInhibitoryToInhibitory(nInhibitory);
    inhibitory2eConnectivity = generateInhibitoryToExcitatory(nHubs * nExcitatory, nInhibitory);
    
    nNeurons = nInhibitory + nHubs * nExcitatory;
    globalConnectivityMatrix = zeros(nNeurons);
    globalConnectivityMatrix(1:nHubs*nExcitatory, 1:nHubs*nExcitatory) = rewiredExcitatory2eConnectivity;
    globalConnectivityMatrix(nHubs*nExcitatory+1:nNeurons, 1:nHubs * nExcitatory) = excitatory2iConnectivity;
    globalConnectivityMatrix(1:nHubs * nExcitatory, nHubs*nExcitatory+1:nNeurons) = inhibitory2eConnectivity;
    globalConnectivityMatrix(nHubs*nExcitatory+1:nNeurons, nHubs*nExcitatory+1:nNeurons) = inhibitory2iConnectivity;
end