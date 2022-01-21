clear;
close all; clc
rmse = @(org,est) norm(org(:) - est(:))./sqrt(numel(org));
load('real3d_data.mat')
%parameters
blcksize = [10 10 2];
overlap = 6;
searchSize = [25 25 10];
threshold = 360;
lam =1.8;
is2d = false;
iter = 2;
X_small=Qn;
Est = X_small;
for i = 1:iter
    i
    Est = Est + 0.3 * (X_small - Est);
    Est = lowRank3D(Est,blcksize,overlap,threshold,searchSize,is2d,lam);
    %fprintf('Denoised at step %d. RMSE = %1.4f \n', i, rmse(Est,A))
    i
end
%% bm4d
[den_BM4D, sigma_BM4D] = bm4d(Qn, 'Gauss', 0,'lc', 0, 1);
%% T_OSSVD
%standat_d=8;
blocksiwze=[111 111 128];eplison=.01;
beta=blocksiwze(1)/blocksiwze(2);
beta=.7;
iter=15;
a=blocksiwze(1);b=blocksiwze(2);c=blocksiwze(3);
de_tr_porposed_method=de_ibtsvt( ddn,iter,eplison,a,b,c,beta,'op');


%% Fig 15

seismic_plot_3D(Qn,Qn,0,0,0)
colormap(seismic )
text(-20,120,'b)','FontSize',14)
% a=1;
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
%% Fig 16
figure
subplot(1,2,1)
seismic_plot_3D(Est,Est,0,0,0)
colormap(seismic )
text(-20,120,'a)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
subplot(1,2,2)
% figure
seismic_plot_3D(Qn-Est,Qn-Est,0,0,0)
colormap(seismic )
text(-20,120,'b)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
%% 
figure
subplot(1,2,1)
seismic_plot_3D(den_BM4D,den_BM4D,0,0,0)
colormap(seismic)
text(-20,120,'c)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
subplot(1,2,2)
% figure
seismic_plot_3D(Qn-den_BM4D,Qn-den_BM4D,0,0,0)
colormap(seismic )
text(-20,120,'d)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
%% 
% de_tr_anvari_method=de_tr_anvari_method(40:150,40:150,:);
figure
subplot(1,2,1)
seismic_plot_3D(de_tossvd_method,de_tossvd_method,0,0,0)
colormap(seismic)
text(-20,120,'e)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
subplot(1,2,2)
% figure
seismic_plot_3D(datan-de_tossvd_method,datan-de_tossvd_method,0,0,0)
colormap(seismic )
text(-20,120,'f)','FontSize',14)
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')

%% fig 17
section=16;
data1=squeeze(Qn(section,:,:));
ause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
plotseis(data1,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% fig18
data2=squeeze(Est(section,:,:));
ddata=squeeze(Qn(section,:,:)-Est(section,:,:));
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
subplot(1,2,1)
plotseis(data2,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'a)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
plotseis(ddata,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'b)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20) 
%% 
data2=squeeze(detrace_ibstvt(section,:,:));
ddata=squeeze(Qn(section,:,:)-detrace_ibstvt(section,:,:));
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
subplot(1,2,1)
plotseis(data2,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'c)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
plotseis(ddata,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'d)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% 
data1=squeeze(den_BM4D(section,:,:));
ddata=squeeze(Qn(section,:,:)-den_BM4D(section,:,:));
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
subplot(1,2,1)
plotseis(data1,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'c)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
plotseis(ddata,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'d)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
%% 
data1=squeeze(de_tossvd_method(section,:,:));
ddata=squeeze(Qn(section,:,:)-de_tossvd_method(section,:,:));
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
subplot(1,2,1)
plotseis(data1,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'e)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)
subplot(1,2,2)
plotseis(ddata,(0:size(data1,1)-1)*dt,1:size(data1,2),[],[1.5  0.3059],1,1,[0.1,0,0])
text(-18,0,'f)','FontSize',20)
ax = gca;
ax.FontSize=20;
box on
xlabel('Trace No.','FontSize',20)
ylabel('Time (s) ','FontSize',20)

