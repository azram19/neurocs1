load('complexityvsindex.mat')
load('complexityvsprobability.mat')
figure(1)
plot(complexityvsindex(:,2),complexityvsindex(:,1),'LineStyle','none','Marker','o','MarkerFaceColor',[0 0 1]);
xlabel('Small-world index','FontSize',11);
ylabel('Neural complexity','FontSize',11);
title('Dependance of neural complexity on small-world index','FontSize',13)
axis([1.5, 5, 0, 0.06]);
figure(2)
plot(complexityvsprobability(:,2),complexityvsprobability(:,1),'LineStyle','none','Marker','o','MarkerFaceColor',[0 0 1]);
xlabel('Rewiring probability','FontSize',11);
ylabel('Neural complexity','FontSize',11);
title('Dependance of neural complexity on rewiring probability','FontSize',13)
axis([0,0.5, 0, 0.06]);