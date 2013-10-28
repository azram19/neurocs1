function connectivityMatrix = connectExhibitoryToInhibitory(hubsGroups, oldConnectivityMatrix)
    connectivityMatrix = oldConnectivityMatrix;
    
    
    availableNeurons = [];
    for i = 1:length(oldConnectivityMatrix)
        disp(oldConnectivityMatrix(i, :));
        available = sum(oldConnectivityMatrix(i,:));
        if(available == 0)
            availableNeurons = [i availableNeurons]; 
        end
        disp(available);
    end
    availableNeurons
end