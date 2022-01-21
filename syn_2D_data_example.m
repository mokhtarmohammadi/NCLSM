clear; close all; clc
rng('default');
    load data_n5.mat;
    sigma=5;
% Y = d + sigma * randn(size(d));
% Parameters 
 blcksize = [10 10];
searchSize = [18 18];
 overlap = 3;
threshold = 35;
lam = 4;
delta = 0.2;
 is2d = true;
Est = Y;
for i = 1:3
    i
    Est = Est + delta * (Y - Est);
    Est = lowRank3D(Est,blcksize,overlap,threshold,searchSize,is2d,lam);
%     fprintf('Denoised at step %d. PSNR = %2.2f dB \n', i, csnr(Est,S,0,0))
end
snr(S,Est-S)
%% bm3d
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
wav_type='bump';
ef_rank=8;
[m,n]=size(data);
t=(0:m-1)*dt;
for i=1:n
    i
    opt_out(:,i) = opt_shrink_wsst_den(data(:,i),t,voiceperoctave,ef_rank,gamma,wav_type);
end
%% SSA
Rank=5;
high_freq_cut=60; dt=0.002;
 [ssa_out]=ssa_denoising(data,dt,Rank,high_freq_cut);
 %% Fig3
 u=1.4441;
 subplot 121
plotseis(d,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'a)','FontSize',20)
subplot 122
plotseis(Y,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'b)','FontSize',20)
%% Fig4
figure
 subplot 121
plotseis(Est,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'a)','FontSize',20)
subplot 122
plotseis(Y-Est,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'b)','FontSize',20)

figure
 subplot 121
plotseis(opt_out,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'c)','FontSize',20)
subplot 122
plotseis(Y-opt_out,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'d)','FontSize',20)
figure
 subplot 121
plotseis(DenData,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'e)','FontSize',20)
subplot 122
plotseis(Y-DenData,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'f)','FontSize',20)
figure

 subplot 121
plotseis(ssa_out,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'g)','FontSize',20)
subplot 122
plotseis(Y-ssa_out,(0:size(d,1)-1)*dt,1:size(d,2),[],[1.5 u],1,1,[.1,0,0]);
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
text(-8,0,'h)','FontSize',20)

%% Fig5
figure;
cmp=d;
dd=Y;nlm=DenData(:,1:76);dt=0.002;den_dataa=Est;
optslr=ssa_2D_out;optwsst_outt=opt_out;
ause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
freq=(1/dt)*(0:size(dd,1)-1)/size(dd,1);
A_free=sum(abs(fft(cmp)),2)/size(cmp,2);
A_noisy=sum(abs(fft(dd)),2)/size(dd,2);
A_opt=sum(abs(fft(den_dataa)),2)/size(den_dataa,2);
A_nlm=sum(abs(fft(nlm)),2)/size(nlm,2);
A_optslr=sum(abs(fft(optslr)),2)/size(optslr,2);
A_optwsst_out=sum(abs(fft(optwsst_outt)),2)/size(optwsst_outt,2);
A_free=A_free/max(A_free);
A_noisy=A_noisy/max(A_noisy);
A_opt=A_opt/max(A_opt);
A_nlm=A_nlm/max(A_nlm);
A_optslr=A_optslr/max(A_optslr);
A_optwsst_out=A_optwsst_out/max(A_optwsst_out);
plot(freq,A_free,'--p','linewidth',2)
hold on
plot(freq,A_noisy,'k','linewidth',1,'markersize',6,'markerfacecolor','y')
hold on
plot(freq,A_opt,'k-o','linewidth',1,'markersize',6,'markerfacecolor','g')
plot(freq,A_nlm,'k-^','linewidth',1,'markersize',6,'markerfacecolor','c')
plot(freq,A_optslr,'k:','linewidth',1,'markersize',6)
plot(freq,A_optwsst_out,'k-*','linewidth',1,'markersize',6,'markerfacecolor','b')
xlabel('Frequency (Hz)','FontSize',20)
ylabel('Amplitude','FontSize',20)
% title('Average Amplitude Spectrum','FontSize',20)
legend('Clean data', 'Noisy data','Proposed  method','BM3D','f-x SSA','Opt-Wsst')
ax = gca;
ax.FontSize=20;
box on
%% Fig 7
figure
subplot 321
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(dd(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'Noisy Trace')
text(-68,1,'a)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)
subplot 322
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(den_dataa(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'proposed method')
text(-68,1,'b)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)
subplot 323
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(optslr(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'OptSLR method')
text(-68,1,'c)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)
subplot 324
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(optwsst_outt(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'OptWSST method')
text(-68,1,'d)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)
subplot 325
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(nlm(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'NLM method')
text(-68,1,'e)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)
subplot 326
plot(d(:,28),'linewidth',1,'markersize',6,'markerfacecolor','k')
hold on 
plot(win_out(:,28),'--','linewidth',1,'markersize',6)
legend(' Clean Trace', 'DRR method')
text(-68,1,'f)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
xlabel('Time(ms)','FontSize',14)
ylabel(' Amplitude','FontSize',14)

