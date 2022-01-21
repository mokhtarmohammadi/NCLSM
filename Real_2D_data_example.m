clear; close all; clc
rng('default');
    load X1.mat;
    
% Parameters 
 blcksize = [8 8];
searchSize = [36 36];
 overlap = 5;
threshold = 300;
lam = 7800;
delta = 0.2;
 is2d = true;
Est = Y;
for i = 1:3
    i
    Est = Est + delta * (Y - Est);
    Est = lowRank3D(Est,blcksize,overlap,threshold,searchSize,is2d,lam);
%     fprintf('Denoised at step %d. PSNR = %2.2f dB \n', i, csnr(Est,S,0,0))
end
%% 
Data=d;
NoisyData=Y;
y(:,:)=[Data Data];
z(:,:)=[NoisyData NoisyData];
sigma=est_noise(z);

min_valz=min(min(min(z)));
max_valz=max(max(max(z)));
z=(z-min_valz)/(max_valz-min_valz);

min_valy=min(min(min(y)));
max_valy=max(max(max(y)));
y=(y-min_valy)/(max_valy-min_valy);

[PSNR, DenData] = BM3D(1,z,'lp', 0);

DenData=max(DenData,0); DenData=min(DenData,1);
z=z*(max_valz-min_valz)+min_valz;
y=y*(max_valy-min_valy)+min_valy;
DenData=DenData*(max_valz-min_valz)+min_valz;
%% OPt-WSST
voiceperoctave=16;
% gamma=.077;
wav_type='cmhat';
ef_rank=20;
[m,n]=size(data);
t=(0:m-1)*dt;
for i=1:n
    i
    opt_out(:,i) = opt_shrink_wsst_den(data(:,i),t,voiceperoctave,ef_rank,gamma,wav_type);
end
%% SSA
Rank=45;
high_freq_cut=80; dt=0.002;
 [ssa_out]=ssa_denoising(data,dt,Rank,high_freq_cut);
 %% Fig 8
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,data,clims); 
colormap(seismic)
colorbar
text(-35.5,0,'a)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% Fig 9
figure
subplot(1,2,1)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,Est,clims); 
colormap(seismic)
colorbar
% legend on
text(-35.5,0,'a)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,Y-Est,clims); 
colormap(seismic)
colorbar
% text(-10,0,'a)','FontSize',20)
text(-35.5,0,'b)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% Opt-wsst
figure
subplot(1,2,1)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,opt_out,clims); 
colormap(seismic)
colorbar
% legend on
text(-35.5,0,'c)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,Y-opt_out,clims); 
colormap(seismic)
colorbar
% text(-10,0,'a)','FontSize',20)
text(-35.5,0,'d)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% BM3D
figure
subplot(1,2,1)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,DenData,clims); 
colormap(seismic)
colorbar
% legend on
text(-35.5,0,'e)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,Y-DenData,clims); 
colormap(seismic)
colorbar
% text(-10,0,'a)','FontSize',20)
text(-35.5,0,'f)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% SSA
figure
subplot(1,2,1)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,ssa_out,clims); 
colormap(seismic)
colorbar
% legend on
text(-35.5,0,'g)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
clims = [-12000 12000];
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,Y-ssa_out,clims); 
colormap(seismic)
colorbar
% text(-10,0,'a)','FontSize',20)
text(-35.5,0,'h)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% Fig 10
clims = [0 1];
cormat=c_corr(Y,Est, 5);
cormat2=c_corr(Y,opt_out, 5);
cormat3=c_corr(Y,DenData(:,1:256), 5);
cormat4=c_corr(Y,ssa_2D_out, 5);
subplot(2,2,1)
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,abs(cormat),clims);
colorbar
text(-35.5,0,'a)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(2,2,2)
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,abs(cormat2),clims);
colorbar
text(-35.5,0,'b)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20) 
subplot(2,2,3)
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,abs(cormat3),clims); 
colorbar
text(-35.5,0,'c)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(2,2,4)
imagesc((1:size(data,2)),(0:size(data,1)-1)*.002,abs(cormat4),clims);
colorbar
text(-35.5,0,'d)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% Fig 11
figure
dd=Y;nlm=DenData(:,1:76);dt=0.002;den_dataa=Est;
optslr=ssa_2D_out;optwsst_outt=opt_out;
ause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
freq=(1/dt)*(0:size(dd,1)-1)/size(dd,1);
A_noisy=sum(abs(fft(dd)),2)/size(dd,2);
A_opt=sum(abs(fft(den_dataa)),2)/size(den_dataa,2);
A_nlm=sum(abs(fft(nlm)),2)/size(nlm,2);
A_optslr=sum(abs(fft(optslr)),2)/size(optslr,2);
A_optwsst_out=sum(abs(fft(optwsst_outt)),2)/size(optwsst_outt,2);
A_noisy=A_noisy/max(A_noisy);
A_opt=A_opt/max(A_opt);
A_nlm=A_nlm/max(A_nlm);
A_optslr=A_optslr/max(A_optslr);
A_optwsst_out=A_optwsst_out/max(A_optwsst_out);

plot(freq,A_noisy,'k','linewidth',1,'markersize',6,'markerfacecolor','y')
hold on
plot(freq,A_opt,'k-o','linewidth',1,'markersize',6,'markerfacecolor','g')
plot(freq,A_nlm,'k-^','linewidth',1,'markersize',6,'markerfacecolor','c')
plot(freq,A_optslr,'k:','linewidth',1,'markersize',6)
plot(freq,A_optwsst_out,'k-*','linewidth',1,'markersize',6,'markerfacecolor','b')
xlabel('Frequency (Hz)','FontSize',20)
ylabel('Amplitude','FontSize',20)
% title('Average Amplitude Spectrum','FontSize',20)
legend('Real data','Proposed  method','BM3D','f-x SSA','Opt-Wsst')
ax = gca;
ax.FontSize=20;
box on


