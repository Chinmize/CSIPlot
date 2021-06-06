clear all
%% csireader.m
%
% read and plot CSI from UDPs created using the nexmon CSI extractor (nexmon.org/csi)
% modify the configuration section to your needs
% make sure you run >mex unpack_float.c before reading values from bcm4358 or bcm4366c0 for the first time
%
% the example.pcap file contains 4(core 0-1, nss 0-1) packets captured on a bcm4358

%% configuration
CHIP = '43455c0';             % wifi chip (possible values 4339, 4358, 43455c0, 4366c0)
BW = 20;                           % bandwidth
FILE1 = './data/output_loc3_2.pcap';     % capture file
% FILE2 = './output_loc3_2.pcap';     % capture file
% FILE3 = './output_loc4_2.pcap';     % capture file
% FILE4 = './output_loc5_2.pcap';     % capture file
NPKTS_MAX = 1000;       % max number of UDPs to process

%% read file
HOFFSET = 16;           % header offset
NFFT = BW*3.2;          % fft size
p = readpcap();
p.open(FILE1);
n = min(length(p.all()),NPKTS_MAX);
p.from_start();
csi_buff_1 = complex(zeros(n,NFFT),0);
k = 1;
while (k <= n)
    f = p.next();
    if isempty(f)
        disp('no more frames');
        break;
    end
    if f.header.orig_len-(HOFFSET-1)*4 ~= NFFT*4
        disp('skipped frame with incorrect size');
        continue;
    end
    payload = f.payload;
    H = payload(HOFFSET:HOFFSET+NFFT-1);
    if (strcmp(CHIP,'4339') || strcmp(CHIP,'43455c0'))
        Hout = typecast(H, 'int16');
    elseif (strcmp(CHIP,'4358'))
        Hout = unpack_float(int32(0), int32(NFFT), H);
    elseif (strcmp(CHIP,'4366c0'))
        Hout = unpack_float(int32(1), int32(NFFT), H);
    else
        disp('invalid CHIP');
        break;
    end
    Hout = reshape(Hout,2,[]).';
    cmplx = double(Hout(1:NFFT,1))+1j*double(Hout(1:NFFT,2));
    csi_buff_1(k,:) = cmplx.';
    k = k + 1;
end

% %%
% p.open(FILE2);
% p.from_start();
% csi_buff_2 = complex(zeros(n,NFFT),0);
% k = 1;
% while (k <= n)
%     f = p.next();
%     if isempty(f)
%         disp('no more frames');
%         break;
%     end
%     if f.header.orig_len-(HOFFSET-1)*4 ~= NFFT*4
%         disp('skipped frame with incorrect size');
%         continue;
%     end
%     payload = f.payload;
%     H = payload(HOFFSET:HOFFSET+NFFT-1);
%     if (strcmp(CHIP,'4339') || strcmp(CHIP,'43455c0'))
%         Hout = typecast(H, 'int16');
%     elseif (strcmp(CHIP,'4358'))
%         Hout = unpack_float(int32(0), int32(NFFT), H);
%     elseif (strcmp(CHIP,'4366c0'))
%         Hout = unpack_float(int32(1), int32(NFFT), H);
%     else
%         disp('invalid CHIP');
%         break;
%     end
%     Hout = reshape(Hout,2,[]).';
%     cmplx = double(Hout(1:NFFT,1))+1j*double(Hout(1:NFFT,2));
%     csi_buff_2(k,:) = cmplx.';
%     k = k + 1;
% end

% %%
% p.open(FILE3);
% p.from_start();
% csi_buff_3 = complex(zeros(n,NFFT),0);
% k = 1;
% while (k <= n)
%     f = p.next();
%     if isempty(f)
%         disp('no more frames');
%         break;
%     end
%     if f.header.orig_len-(HOFFSET-1)*4 ~= NFFT*4
%         disp('skipped frame with incorrect size');
%         continue;
%     end
%     payload = f.payload;
%     H = payload(HOFFSET:HOFFSET+NFFT-1);
%     if (strcmp(CHIP,'4339') || strcmp(CHIP,'43455c0'))
%         Hout = typecast(H, 'int16');
%     elseif (strcmp(CHIP,'4358'))
%         Hout = unpack_float(int32(0), int32(NFFT), H);
%     elseif (strcmp(CHIP,'4366c0'))
%         Hout = unpack_float(int32(1), int32(NFFT), H);
%     else
%         disp('invalid CHIP');
%         break;
%     end
%     Hout = reshape(Hout,2,[]).';
%     cmplx = double(Hout(1:NFFT,1))+1j*double(Hout(1:NFFT,2));
%     csi_buff_3(k,:) = cmplx.';
%     k = k + 1;
% end

% %%
% p.open(FILE4);
% p.from_start();
% csi_buff_4 = complex(zeros(n,NFFT),0);
% k = 1;
% while (k <= n)
%     f = p.next();
%     if isempty(f)
%         disp('no more frames');
%         break;
%     end
%     if f.header.orig_len-(HOFFSET-1)*4 ~= NFFT*4
%         disp('skipped frame with incorrect size');
%         continue;
%     end
%     payload = f.payload;
%     H = payload(HOFFSET:HOFFSET+NFFT-1);
%     if (strcmp(CHIP,'4339') || strcmp(CHIP,'43455c0'))
%         Hout = typecast(H, 'int16');
%     elseif (strcmp(CHIP,'4358'))
%         Hout = unpack_float(int32(0), int32(NFFT), H);
%     elseif (strcmp(CHIP,'4366c0'))
%         Hout = unpack_float(int32(1), int32(NFFT), H);
%     else
%         disp('invalid CHIP');
%         break;
%     end
%     Hout = reshape(Hout,2,[]).';
%     cmplx = double(Hout(1:NFFT,1))+1j*double(Hout(1:NFFT,2));
%     csi_buff_4(k,:) = cmplx.';
%     k = k + 1;
% end
% 
% %% plot
%% plotcsi2(csi_buff_1, NFFT, false)
% 
% 
% %%
% % NFFT = NFFT - 12;
% % csi_buff = fftshift(csi_buff,2);
% % csi_buff(:,1:6)=[];
% % csi_buff(:,54:58)=[];
% % csi_buff(:,27)=[];
% % csi_phase = rad2deg(angle(csi_buff));
% % for cs = 1:size(csi_buff,1)
% %     csi = abs(csi_buff(cs,:));
% % %     if normalize
% % %         csi = csi./max(csi);
% % %     end
% %     csi_buff(cs,:) = csi;
% % end

%%
NFFT = NFFT - 12;
csi_buff_1 = fftshift(csi_buff_1,2);
csi_buff_1(:,1:6)=[];
csi_buff_1(:,54:58)=[];
csi_buff_1(:,27)=[];
csi_phase = rad2deg(angle(csi_buff_1));
for cs = 1:size(csi_buff_1,1)
    csi = abs(csi_buff_1(cs,:));
%     if normalize
%         csi = csi./max(csi);
%     end
    csi_buff_1(cs,:) = csi;
end

% %%
% NFFT = NFFT - 12;
% csi_buff_2 = fftshift(csi_buff_2,2);
% csi_buff_2(:,1:6)=[];
% csi_buff_2(:,54:58)=[];
% csi_buff_2(:,27)=[];
% csi_phase = rad2deg(angle(csi_buff_2));
% for cs = 1:size(csi_buff_2,1)
%     csi = abs(csi_buff_2(cs,:));
% %     if normalize
% %         csi = csi./max(csi);
% %     end
%     csi_buff_2(cs,:) = csi;
% end

% %%
% NFFT = NFFT - 12;
% csi_buff_3 = fftshift(csi_buff_3,2);
% csi_buff_3(:,1:6)=[];
% csi_buff_3(:,54:58)=[];
% csi_buff_3(:,27)=[];
% csi_phase = rad2deg(angle(csi_buff_3));
% for cs = 1:size(csi_buff_3,1)
%     csi = abs(csi_buff_3(cs,:));
% %     if normalize
% %         csi = csi./max(csi);
% %     end
%     csi_buff_3(cs,:) = csi;
% end

% %%
% NFFT = NFFT - 12;
% csi_buff_4 = fftshift(csi_buff_4,2);
% csi_buff_4(:,1:6)=[];
% csi_buff_4(:,54:58)=[];
% csi_buff_4(:,27)=[];
% csi_phase = rad2deg(angle(csi_buff_4));
% for cs = 1:size(csi_buff_4,1)
%     csi = abs(csi_buff_4(cs,:));
% %     if normalize
% %         csi = csi./max(csi);
% %     end
%     csi_buff_4(cs,:) = csi;
% end

%%
csi_buff3_1 = csi_buff_1 / 10;
for i=1:n
    if csi_buff3_1(i,27) > 100
        csi_buff3_1(i,27) = 30;
    end
end

for i=1:1000
    max_val = max(csi_buff3_1(i,:));
    min_val = min(csi_buff3_1(i,:));
    csi_buff3_1(i,:) = (csi_buff3_1(i,:) - min_val) / (max_val - min_val);
end

% %%
% csi_buff3_2 = csi_buff_2 / 10;
% for i=1:n
%     if csi_buff3_2(i,27) > 100
%         csi_buff3_2(i,27) = 30;
%     end
% end

% %%
% csi_buff3_3 = csi_buff_3 / 10;
% for i=1:n
%     if csi_buff3_3(i,27) > 100
%         csi_buff3_3(i,27) = 30;
%     end
% end

% %%
% csi_buff3_4 = csi_buff_4 / 10;
% for i=1:n
%     if csi_buff3_4(i,27) > 100
%         csi_buff3_4(i,27) = 30;
%     end
% end

% %
% max_val = max(csi_buff3_1,[],2);
% min_val = min(csi_buff3_1,[],2);
% for i=1:n
%     csi_buff3_1(i,:) = (csi_buff3_1(i,:) - min_val(i)) / (max_val(i) - min_val(i));
% end
% 
% %%
% max_val = max(csi_buff3_2,[],2);
% min_val = min(csi_buff3_2,[],2);
% for i=1:n
%     csi_buff3_2(i,:) = (csi_buff3_2(i,:) - min_val(i)) / (max_val(i) - min_val(i));
% end
% 
% %%
% max_val = max(csi_buff3_3,[],2);
% min_val = min(csi_buff3_3,[],2);
% for i=1:n
%     csi_buff3_3(i,:) = (csi_buff3_3(i,:) - min_val(i)) / (max_val(i) - min_val(i));
% end
% 
% %%
% max_val = max(csi_buff3_4,[],2);
% min_val = min(csi_buff3_4,[],2);
% for i=1:n
%     csi_buff3_4(i,:) = (csi_buff3_4(i,:) - min_val(i)) / (max_val(i) - min_val(i));
% end


%%
% rst = zeros(1,496);
% j=1;
% for i=100:20:10000
%     csi_buff3 = zeros(i,52);
%     csi_buff3(1:i/4,:) = csi_buff3_1(1:i/4,:);
%     csi_buff3(i/4+1:i/2,:) = csi_buff3_2(1:i/4,:);
%     csi_buff3(i/2+1:i/2+i/4,:) = csi_buff3_3(1:i/4,:);
%     csi_buff3(i/2+i/4+1:i,:) = csi_buff3_4(1:i/4,:);
%     rst(1,j) = sum(var(csi_buff3(1:i,:),1))^0.5;
%     j = j + 1;
% end

%%
spNum = 1000;
spNum2 = 0;
carrierNum = 52;
x=1:1:carrierNum;

for i=1:spNum
    if abs(csi_buff_1(i, 23)) > 200 && abs(csi_buff_1(i, 7)) > 200 && abs(csi_buff_1(i, 27)) < 1000 && abs(csi_buff_1(i, 28)) < 1000 && abs(csi_buff_1(i, 1)) > 100
        spNum2 = spNum2 + 1;
    end
end

csi_buff2 = zeros(spNum2, carrierNum);
num = 1;
for i=1:spNum
    if abs(csi_buff_1(i, 23)) > 200 && abs(csi_buff_1(i, 7)) > 200 && abs(csi_buff_1(i, 27)) < 1000 && abs(csi_buff_1(i, 28)) < 1000 && abs(csi_buff_1(i, 1)) > 100
        csi_buff2(num, :) = csi_buff_1(i, :);
        num = num + 1;
    end
end

%%
figure
data_plot = zeros(1, carrierNum);
for i=1:spNum
    if abs(csi_buff3_1(i, 22)) > 0.5
        for j=1:carrierNum
                data_plot(j)=abs(csi_buff3_1(i, j));
        end
        axis([1 52 0 1]);
        plot(x, data_plot, 'color', [54/255 130/255 190/255], 'linewidth', 0.1);
        hold on
    end
end
% figure
% data_plot = zeros(1, carrierNum);
% for i=1:spNum2
%     for j=1:carrierNum
%             data_plot(j)=abs(csi_buff2(i, j));
%     end
%     axis([1 52 0 1000]);
%     plot(x, data_plot, 'color', [54/255 130/255 190/255], 'linewidth', 0.1);
%     hold on
% end
grid;
xlabel('Subcarriers');
ylabel('Amplitude(dB)');
set(gcf,'position',[0,0,400,200]); 
set(gca,'xtick',[1:7:52]);
% set(gca,'yticklabel',[0:20:100]);
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
