function [neuralComplexity, smallWorldIndex] = runSimulation(nModules,nExcitNeurons,nExcitEdges,nInhibNeurons,p,simTime,discard)

% generate modular network as in Question 1 with probability p
[gcm, e2ecm, e2icm, i2icm, i2ecm] = generateModularNetwork(nModules, nExcitNeurons, nExcitEdges, nInhibNeurons, p);

% gcm = global connectivity matrix
% e2ecm = rewired excitatory-excitatory connectivity matrix
% e2icm = excitatory-inhibitory connectivity matrix
% i2icm = inhibitory-inhibitory connectivity matrix
% i2ecm = inhibitory-excitatory connectivity matrix

layer = {};

N1 = nExcitNeurons*nModules;
M1 = 1;

N2 = nInhibNeurons;
M2 = 1;

% Layer 1 (excitatory neurons)
layer{1}.S = {};
layer{1}.S{1} = e2ecm;
layer{1}.S{2} = i2ecm;

layer{1}.rows = N1;
layer{1}.columns = M1;

r = rand(N1,M1);
layer{1}.a = 0.02*ones(N1,M1);
layer{1}.b = 0.2*ones(N1,M1);
layer{1}.c = -65+15*r.^2;
layer{1}.d = 8-6*r.^2;

layer{1}.delay{1} = round(rand(N1)*20);
layer{1}.delay{2} = ones(N1, N2);

layer{1}.factor{1} = 17;
layer{1}.factor{2} = 2;

% Layer 2 (inhibitory neurons)
layer{2} = {};
layer{2}.S{1} = e2icm;
layer{2}.S{2} = i2icm;

layer{2}.rows = N2;
layer{2}.columns = M2;

r = rand(N2,M2);
layer{2}.a = 0.02 + 0.08 * r;
layer{2}.b = 0.25 - 0.05*r;
layer{2}.c = -65*ones(N2,M2);
layer{2}.d = 2*ones(N2,M2);

layer{2}.delay{1} = ones(N2, N1);
layer{2}.delay{2} = ones(N2, N2);

layer{2}.factor{1} = 50;
layer{2}.factor{2} = 1;


Dmax = 100; % maximum propagation delay
Tmax = simTime; % simulation time
I = 15; % base current

% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end

layer{1}.I = zeros(N1,M1);
layer{2}.I = zeros(N2,M2);

lambda = 0.01; % parameter for Poisson process of background firing

v1=zeros(Tmax,N1*M1);
v2=zeros(Tmax,N2*M2);
   
u1=zeros(Tmax,N1*M1);
u2=zeros(Tmax,N2*M2);

% SIMULATE
for t = 1:Tmax
   
   % Display time every 10ms
   if mod(t,10) == 0
      t
   end
   
   % background firing (to prevent activation from dying out)
   randomExc = poissrnd(lambda, N1, M1);
   randomInh = poissrnd(lambda, N2, M2);
   
   layer{1}.I = randomExc * I;
   layer{2}.I = randomInh * I;
   
   % Update all the neurons
   for lr=1:length(layer)
      layer = IzNeuronUpdate(layer,lr,t,Dmax);
   end
   
   v1(t,1:N1*M1) = layer{1}.v;
   v2(t,1:N2*M2) = layer{2}.v;
   
   u1(t,1:N1*M1) = layer{1}.u;
   u2(t,1:N2*M2) = layer{2}.u;
      
end

firings1 = layer{1}.firings;
firings2 = layer{2}.firings;

% Add Dirac pulses (mainly for presentation)
if ~isempty(firings1)
   v1(sub2ind(size(v1),firings1(:,1),firings1(:,2))) = 30;
end
if ~isempty(firings2)
   v2(sub2ind(size(v2),firings2(:,1),firings2(:,2))) = 30;
end

% compute mean firing rates (downsampled)
windowSize = 50;
shiftSize = 20;
[time,meanFrRts] = meanFiringRates(firings1, windowSize, shiftSize, nModules, Tmax);

% discard first second's worth of data
if (discard)
    time(1:50)=[];
    meanFrRts(1:50,:)=[];
end
    
% to render the series covariance stationary we apply differencing twice
% using the function aks_diff
diffMFRs=aks_diff(meanFrRts');
diffMFRs=aks_diff(diffMFRs);

% now we can approximate neural complexity by calculating the interaction
% complexity C(S)
neuralComplexity = interactionComplexity(diffMFRs, nModules);
cmExc2Exc=gcm(1:800,1:800); % connectivity matrix of only excitatory-excitatory connections
smallWorldIndex = SmallWorldIndex(cmExc2Exc);

end