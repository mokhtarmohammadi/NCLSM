clear;
close all; clc
rmse = @(org,est) norm(org(:) - est(:))./sqrt(numel(org));
load('data3d_sen.mat')
%parameters
blcksize = [8 8 4];
overlap = 4;
searchSize = [25 25 10];
threshold = 33;
lam =7.5;
is2d = false;
iter = 15;
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
standat_d=8;
blocksiwze=[50 50 64];eplison=.001;
beta=blocksiwze(1)/blocksiwze(2);
beta=.5;
iter=15;
a=blocksiwze(1);b=blocksiwze(2);c=blocksiwze(3);
de_tr_porposed_method=de_ibtsvt( ddn,iter,eplison,a,b,c,beta,'op',standat_d);


%% Fig 12
close all
subplot(1,2,1)
seismic_plot_3D(Q,Q,0,0,0)
text(-20,120,'a)','FontSize',16)
colormap(seismic)
% legend on
a=1;
caxis([-a a])
ax = gca;
ax.FontSize=16;
box on
xlabel('Crossline');ylabel('Inline');zlabel('Time(s)')
subplot(1,2,2)
seismic_plot_3D(Qn,Qn,0,0,0)
colormap(seismic )
text(-20,120,'b)','FontSize',14)
% a=1;
ax = gca;
ax.FontSize=14;
box on
caxis([-a a])
xlabel('Crossline');ylabel('Inline');zlabel('Time(ms)')
%% Fig 13
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

