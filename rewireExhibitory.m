function connectivityMatrix = rewireExhibitory(nHubs, nNeurons, connectivityMatrix, p)
    for hub = 1:nHubs
       startNeuron = (hub-1) * nNeurons + 1;
       endNeuron = hub * nNeurons;
       for neuron = startNeuron:endNeuron
            for secondNeuron = startNeuron:endNeuron
                if connectivityMatrix(secondNeuron, neuron) == 1
                    if rand(1) < p
                        newHub = randi(nHubs);
                        while newHub == hub
                            newHub = randi(nHubs);
                        end
                        
                        newNeuron = randi(nNeurons);
                        newNeuron = newNeuron + (newHub-1) * nNeurons;
                        
                        connectivityMatrix(newNeuron, neuron) = 1;
                        connectivityMatrix(secondNeuron, neuron) = 0;
                    end
                end
            end
       end
    end
    figure(1)
    clf
    spy(connectivityMatrix);
end