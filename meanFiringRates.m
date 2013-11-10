function [time,mFRs] = meanFiringRates(firings,windowSize,shiftSize,nModules,Tmax)

% computes the mean firing rate of nModules modules over a Tmax run.
% it does so by downsampling the firing rates to obtain the mean by
% computing the average number of firings in a window of windowSize shifted
% every shiftSize

mFRs = zeros(windowSize, nModules);

hubRanges = [50,150,250,350,450,550,650,750];

nDataPoints=round(Tmax/shiftSize);

for i = 1:nDataPoints
   offset = (i-1)*shiftSize;
   indicesOfFiringsInThisWindow = firings(:, 1)>=offset & firings(:,1)<=offset+windowSize;
   firingsInThisWindow=firings(indicesOfFiringsInThisWindow,2);
   firingsByHub = hist(firingsInThisWindow, hubRanges);
   mFRs(i, :) = firingsByHub/shiftSize;
   time(i)=offset;
end

end