function division = divideHub(hub, nNeurons)
    division = randperm(nNeurons);
    
    startNeuron = (hub-1) * nNeurons;
    division = division + startNeuron;
    
    division = vec2mat(division, 4);
end