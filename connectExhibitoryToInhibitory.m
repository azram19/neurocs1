function connectivityMatrix = connectExhibitoryToInhibitory(hubsGroups, oldConnectivityMatrix)
    connectivityMatrix = oldConnectivityMatrix;
       
    availableNeurons = [];
    for i = 1:size(oldConnectivityMatrix,1)
      %  disp(oldConnectivityMatrix(i, :));
        available = sum(oldConnectivityMatrix(i,:))
        if(available == 0)
            availableNeurons = [i availableNeurons]; 
        end
    end
    
    connectorNeurons = randsample(availableNeurons,size(hubsGroups,1))
    
    for k = 1:size(hubsGroups,1)
        connectivityMatrix(connectorNeurons(k),hubsGroups(k,:)) = 1;
    end
end