function phaseCorrFigHandles = plotPhaseCorr(corrInputClasses, frequencyVector,visible)

%PLOTPHASECORR Plots the (Phase X output) correlation for each class


f = frequencyVector;
corr_limit = corrInputClasses.correlationLimit;

R_P_sp = corrInputClasses.phase.sp;
R_P_pe = corrInputClasses.phase.pe;
R_P_pi = corrInputClasses.phase.pi;
R_P_sp_pe = corrInputClasses.phase.crossCorrelation.SPPE;
R_P_pe_pi = corrInputClasses.phase.crossCorrelation.PEPI;
R_P_pi_sp = corrInputClasses.phase.crossCorrelation.PISP;



directCorr = figure;
% First Subplot
subplot(3,1,1)
plot(f,R_P_sp,'.'); hold on;
plot(f,ones(size(R_P_sp))*corr_limit,'r--')
plot(f,ones(size(R_P_sp))*corr_limit*-1,'r--')

title('Fase')
ylabel('Correla��o SP');
grid on;

% Second Subplot
subplot(3,1,2)
plot(f,R_P_pe,'.');
hold on;
plot(f,ones(size(R_P_pe))*corr_limit,'r--')
plot(f,ones(size(R_P_pe))*corr_limit*-1,'r--')

ylabel('Correla��o PE');
grid on;

% Third Subplot
subplot(3,1,3)
plot(f,R_P_pi,'.');
hold on;
plot(f,ones(size(R_P_pi))*corr_limit,'r--')
plot(f,ones(size(R_P_pi))*corr_limit*-1,'r--')

ylabel('Correla��o PI');
xlabel('Frequ�ncia (Hz)')
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cross Correlation Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

crossCorr = figure;
% First Subplot
subplot(3,1,1)
plot(f,R_P_sp,'.'); hold on;
plot(f,ones(size(R_P_sp))*corr_limit,'r--')
plot(f,ones(size(R_P_sp))*corr_limit*-1,'r--')

plot(f(find(sign(R_P_sp_pe) == -1)),...
    R_P_sp(sign(R_P_sp_pe) == -1),'g.');

title('Fase')
ylabel('Correla��o SP x PE');
grid on;

% Second Subplot
subplot(3,1,2)
plot(f,R_P_pe,'.');
hold on;
plot(f,ones(size(R_P_pe))*corr_limit,'r--')
plot(f,ones(size(R_P_pe))*corr_limit*-1,'r--')

plot(f(sign(R_P_pe_pi) == -1),...
    R_P_pe(sign(R_P_pe_pi) == -1),'g.');

ylabel('Correla��o PE x PI');
grid on;

% Third Subplot
subplot(3,1,3)
plot(f,R_P_pi,'.');
hold on;
plot(f,ones(size(R_P_pi))*corr_limit,'r--')
plot(f,ones(size(R_P_pi))*corr_limit*-1,'r--')

plot(f(find(sign(R_P_pi_sp) == -1)),...
    R_P_pi(sign(R_P_pi_sp) == -1),'g.');

ylabel('Correla��o PI x SP');
xlabel('Frequ�ncia (Hz)')
grid on;


set(directCorr, 'visible', visible)
set(crossCorr, 'visible', visible)
phaseCorrFigHandles.directCorr = directCorr;
phaseCorrFigHandles.crossCorr = crossCorr;

end