function corrFigureHandles = plotCorrMain(corrInputClasses, frequencyVector)



f = frequencyVector;

% corrInputClasses.correlationLimit = corr_limit;
% 
% corrInputClasses.normalizedEnergy.SP = R_sp;
% corrInputClasses.normalizedEnergy.PE = R_pe;
% corrInputClasses.normalizedEnergy.PI = R_pi;
% 
% corrInputClasses.energy.SP = R_sp_;
% corrInputClasses.energy.PE = R_pe_;
% corrInputClasses.energy.PI = R_pi_;
% 
% corrInputClasses.phase.sp = R_P_sp;
% corrInputClasses.phase.pe = R_P_pe;
% corrInputClasses.phase.pi = R_P_pi;
% 
% corrInputClasses.normalizedEnergy.crossCorrelation.SPPE = R_sp_pe;
% corrInputClasses.normalizedEnergy.crossCorrelation.PEPI = R_pe_pi;
% corrInputClasses.normalizedEnergy.crossCorrelation.PISP = R_pi_sp;
% 
% corrInputClasses.energy.crossCorrelation.SPPE = R_sp_pe_;
% corrInputClasses.energy.crossCorrelation.PEPI = R_pe_pi_;
% corrInputClasses.energy.crossCorrelation.PISP = R_pi_sp_;
% 
% corrInputClasses.phase.crossCorrelation.SPPE = R_P_sp_pe;
% corrInputClasses.phase.crossCorrelation.PEPI = R_P_pe_pi;
% corrInputClasses.phase.crossCorrelation.PISP = R_P_pi_sp;

normalizedEnergyCrossCorr = figure;
% First Subplot
subplot(3,1,1)
plot(f,R_sp,'.'); hold on;
plot(f,ones(size(R_sp))*corr_limit,'r--')
plot(f,ones(size(R_sp))*corr_limit*-1,'r--')
R_sp_pe = R_sp.*R_pe.*(abs(R_sp)>corr_limit).*(abs(R_pe)>corr_limit);

 plot(f(find(sign(R_sp_pe) == -1)),...
    R_sp(sign(R_sp_pe) == -1),'g.');
 
title('Correlações Comparadas')
ylabel('Correlação SP x PE');
grid on;

% Second Subplot
subplot(3,1,2)
plot(f,R_pe,'.');
hold on;
plot(f,ones(size(R_pe))*corr_limit,'r--')
plot(f,ones(size(R_pe))*corr_limit*-1,'r--')
R_pe_pi = R_pe.*R_pi.*(abs(R_pe)>corr_limit).*(abs(R_pi)>corr_limit);

 plot(f(sign(R_pe_pi) == -1),...
    R_pe(sign(R_pe_pi) == -1),'g.');
 
ylabel('Correlação PE x PI');
grid on;

% Third Subplot
subplot(3,1,3)
plot(f,R_pi,'.');
hold on;
plot(f,ones(size(R_pi))*corr_limit,'r--')
plot(f,ones(size(R_pi))*corr_limit*-1,'r--')
R_pi_sp = R_pi.*R_sp.*(abs(R_pi)>corr_limit).*(abs(R_sp)>corr_limit);

 plot(f(find(sign(R_pi_sp) == -1)),...
    R_pi(sign(R_pi_sp) == -1),'g.');

ylabel('Correlação PI x SP');
xlabel('Frequência (Hz)')
grid on;



end