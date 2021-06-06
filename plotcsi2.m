function [] = plotcsi( csi, nfft, normalize )
%PLOTCSI Summary of this function goes here
%   Detailed explanation goes here
nfft = nfft - 12;
csi_buff = fftshift(csi,2);
csi_buff(:,1:6)=[];
csi_buff(:,54:58)=[];
csi_buff(:,27)=[];
csi_phase = rad2deg(angle(csi_buff));
for cs = 1:size(csi_buff,1)
    csi = abs(csi_buff(cs,:));
    if normalize
        csi = csi./max(csi);
    end
    csi_buff(cs,:) = csi;
end

%%
spNum = 1;
spNum2 = 0;
carrierNum = 52;
x=1:1:carrierNum;

for i=1:spNum
    if abs(csi_buff(i, 23)) > 200 && abs(csi_buff(i, 7)) > 200 && abs(csi_buff(i, 27)) < 1000 && abs(csi_buff(i, 28)) < 1000 && abs(csi_buff(i, 1)) > 100
        spNum2 = spNum2 + 1;
    end
end

csi_buff2 = zeros(spNum2, carrierNum);
num = 1;
for i=1:spNum
    if abs(csi_buff(i, 23)) > 200 && abs(csi_buff(i, 7)) > 200 && abs(csi_buff(i, 27)) < 1000 && abs(csi_buff(i, 28)) < 1000 && abs(csi_buff(i, 1)) > 100
        csi_buff2(num, :) = csi_buff(i, :);
        num = num + 1;
    end
end

%%
figure
data_plot = zeros(1, carrierNum);
for i=1:spNum2
    for j=1:carrierNum
            data_plot(j)=abs(csi_buff2(i, j));
    end
    axis([1 52 0 1000]);
    plot(x, data_plot, 'color', [54/255 130/255 190/255], 'linewidth', 0.1);
    hold on
end
grid;
xlabel('Subcarriers');
ylabel('Amplitude(dB)');
set(gcf,'position',[0,0,400,200]); 
set(gca,'xtick',[1:7:52]);
set(gca,'yticklabel',[0:20:100]);
set(gca,'FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FrontSize',5,'LineWidth',1.5);

%%
figure
X = zeros(1, carrierNum * spNum2);
Y = zeros(1, carrierNum * spNum2);
Z = zeros(1, carrierNum * spNum2);

for i = 1 : spNum2
    for j = 1 : carrierNum
        X(1, (i - 1) * carrierNum + j) = i;
        Y(1, (i - 1) * carrierNum + j) = j;
        Z(1, (i - 1) * carrierNum + j) = abs(csi_buff2(i, j));
    end
end

grid;
[x1, y1] = meshgrid(linspace(min(X),max(X),3000),linspace(min(Y),max(Y),3000));
z1 = griddata(X, Y, Z, x1, y1);
surf(x1, y1, z1, 'edgecolor', 'none')
axis([0 spNum2 1 52 0 1000]);
xlabel('Sample Index');
ylabel('Subcarriers');
zlabel('Amplitude(dB)');
set(gcf,'position',[0,0,400,200]); 
set(gca,'xtick',[0:200:spNum2]);
set(gca,'ytick',[1:10:52]);
set(gca,'ztick',[0:200:1000]);
set(gca,'zticklabel',[0:20:100]);
set(gca,'FontName','Times New Roman');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% x = -(nfft/2):1:(nfft/2-1);
% subplot(3,1,3)
% imagesc(x,[1 size(csi_buff,1)],csi_buff)
% myAxis = axis();
% axis([min(x)-0.5, max(x)+0.5, myAxis(3), myAxis(4)])
% set(gca,'Ydir','reverse')
% xlabel('Subcarrier')
% ylabel('Packet number')
% 
% for cs = 1:size(csi_buff,1)
%     max_y = max(csi_buff(cs,:));
%     csi = csi_buff(cs,:);
% 
%     subplot(3,1,1)
%     plot(x,csi);
%     grid on
%     myAxis = axis();
%     axis([min(x)-0.5, max(x)+0.5, 0, max_y])
%     xlabel('Subcarrier')
%     ylabel('Magnitude')
%     title('Channel State Information')
%     text(max(x),max_y-(0.05*max_y),['Packet #',num2str(cs),' of ',num2str(size(csi_buff,1))],'HorizontalAlignment','right','Color',[0.75 0.75 0.75]);
%     
%     subplot(3,1,2)
%     plot(x,csi_phase(cs,:));
%     grid on
%     myAxis = axis();
%     axis([min(x)-0.5, max(x)+0.5, -180, 180])
%     xlabel('Subcarrier')
%     ylabel('Phase')
%     disp('Press any key to continue..');
%     waitforbuttonpress();
% end
% close

end

