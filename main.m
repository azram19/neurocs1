clear all
close all

nModules = 8; % number of modules
nExcitNeurons = 100; % number of excitatory neurons of each module
nExcitEdges = 1000; % number of excitatory-excitatory edges within each module
nInhibNeurons = 200; % number of inhibitory neurons
p = 0; % rewiring probability

% generate modular network
[gcm, e2ecm, e2icm, i2icm, i2ecm] = generateModularNetwork(nModules, nExcitNeurons, nExcitEdges, nInhibNeurons, p);
figure(1)
spy(gcm)
title(['Connectivity matrix for p = ' num2str(p,1)],'FontSize',13);
% gcm = global connectivity matrix
% e2ecm = rewired excitatory-excitatory connectivity matrix
% e2icm = excitatory-inhibitory connectivity matrix
% i2icm = inhibitory-inhibitory connectivity matrix
% i2ecm = inhibitory-excitatory connectivity matrix

layer = {};

N1 = 800;
M1 = 1;

N2 = 200;
M2 = 1;

% Layer 1 (regular spiking)
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

% Layer 2 (regular spiking)
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
Tmax = 1000; % simulation time
I = 15; % base current

% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end

lambda = 0.01;

layer{1}.I = zeros(N1,M1);
layer{2}.I = zeros(N2,M2);

% SIMULATE
for t = 1:Tmax
   
   % Display time every 10ms
   if mod(t,10) == 0
      t
   end
   
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



% Raster plots of firings

figure(2)
clf

subplot(2,1,1)
if ~isempty(firings1)
   plot(firings1(:,1),firings1(:,2),'.')
end
% xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number','FontSize',11)
ylim([0 N1*M1+1])
set(gca,'YDir','reverse')
title(['Excitatory neurons firings for p = ' num2str(p,1)],'FontSize',13)

subplot(2,1,2)
if ~isempty(firings2)
   plot(firings2(:,1),firings2(:,2),'.')
end
xlabel('Time (ms)','FontSize',11)
xlim([0 Tmax])
ylabel('Neuron number','FontSize',11)
ylim([0 N2*M2+1])
set(gca,'YDir','reverse')
title(['Inhibitory neurons firings for p = ' num2str(p,1)],'FontSize',13);

% compute and plot mean firing rates
windowSize = 50;
shiftSize = 20;
[time,meanFrRts] = meanFiringRates(firings1, windowSize, shiftSize, nModules, nExcitNeurons, Tmax);

figure(3)
clf
plot(time,meanFrRts,'-')
ylabel('Mean Firing Rate','FontSize',11)
xlabel('Time (ms)','FontSize',11)
legend('Hub 1','Hub 2','Hub 3', 'Hub 4', 'Hub 5', 'Hub 6', 'Hub 7', 'Hub 8');
title(['Mean firing rate for excitatory hubs for p = ' num2str(p,1)],'FontSize',13);
