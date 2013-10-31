[gcm, e2ecm, e2icm, i2icm, i2ecm] = generateModularNetwork(8, 100, 1000, 200, 0.2);

layer = {};

% Layer 1 (regular spiking)
layer{1}.S = {};
layer{1}.S{1} = e2ecm;
layer{1}.S{2} = i2ecm;

N1 = 800;
M1 = 1;

N2 = 200;
M2 = 1;

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
Ib = 0; % base current
I = 15;

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


% Plot membrane potentials

figure(1)
clf

subplot(2,1,1)
plot(1:Tmax,v1)
title('Population 1 membrane potentials')
ylabel('Voltage (mV)')
ylim([-90 40])
% xlabel('Time (ms)')

subplot(2,1,2)
plot(1:Tmax,v2)
% plot(1:Tmax,v2(:,1))
title('Population 2 membrane potentials')
ylabel('Voltage (mV)')
ylim([-90 40])
xlabel('Time (ms)')


% Plot recovery variable

figure(2)
clf

subplot(2,1,1)
plot(1:Tmax,u1)
title('Population 1 recovery variables')
% xlabel('Time (ms)')

subplot(2,1,2)
plot(1:Tmax,u2)
% plot(1:Tmax,u2(:,1))
title('Population 2 recovery variables')
xlabel('Time (ms)')


% Raster plots of firings

figure(3)
clf

subplot(2,1,1)
if ~isempty(firings1)
   plot(firings1(:,1),firings1(:,2),'.')
end
% xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N1*M1+1])
set(gca,'YDir','reverse')
title('Population 1 firings')

subplot(2,1,2)
if ~isempty(firings2)
   plot(firings2(:,1),firings2(:,2),'.')
end
xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N2*M2+1])
set(gca,'YDir','reverse')
title('Population 2 firings')

figure(4)
clf

%exc
subplot(2,1,1)
meanFiringsRate = zeros(50, 8);
%Take each 50s window shifted by 20s
hubRanges = [100,200,300,400,500,600,700,800];
for i = 1:50
   offset = (i-1)*20 + 1;
   firingsInThisWindow = firings1(offset:offset+50, 2);
   firingsByHub = hist(firingsInThisWindow, hubRanges);
   meanFiringsRate(i, :) = firingsByHub/50*20;
end
plot(meanFiringsRate,'-')
xlim([0 1000])

%inh
subplot(2,1,2)
meanFiringsRate = zeros(50, 8);
%Take each 50s window shifted by 20s
hubRanges = [100,200,300,400,500,600,700,800];
for i = 1:50
   offset = (i-1)*20 + 1;
   firingsInThisWindow = firings2(offset:offset+50, 2);
   firingsByHub = hist(firingsInThisWindow, hubRanges);
   meanFiringsRate(i, :) = firingsByHub/50*20;
end
plot(meanFiringsRate,'-')
drawnow