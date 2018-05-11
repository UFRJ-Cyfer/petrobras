function energyCrossCorrFigHandles = plotCrossCorr(corrInputClasses, frequencyVector, normalized, visible)

%PLOTCROSSCORR Creates plots for the cross correlations

% This function calculates the cross correlation for energy only (for now)

f = frequencyVector;
regularPlot = 0;
normalizedPlot = 0;
corr_limit = corrInputClasses.correlationLimit;


switch normalized
    case 0
        regularPlot = 1;
        R_sp_ = corrInputClasses.energy.SP;
        R_pe_ = corrInputClasses.energy.PE;
        R_pi_ = corrInputClasses.energy.PI;
        
        R_sp_pe_ = corrInputClasses.energy.crossCorrelation.SPPE;
        R_pe_pi_ = corrInputClasses.energy.crossCorrelation.PEPI;
        R_pi_sp_ = corrInputClasses.energy.crossCorrelation.PISP;
        normalizedEnergy = [];
    case 1
        normalizedPlot = 1;
        R_sp = corrInputClasses.normalizedEnergy.SP;
        R_pe = corrInputClasses.normalizedEnergy.PE;
        R_pi = corrInputClasses.normalizedEnergy.PI;
        
        R_sp_pe = corrInputClasses.normalizedEnergy.crossCorrelation.SPPE;
        R_pe_pi = corrInputClasses.normalizedEnergy.crossCorrelation.PEPI;
        R_pi_sp = corrInputClasses.normalizedEnergy.crossCorrelation.PISP;
        energy = [];
    case 2
        regularPlot = 1;
        normalizedPlot = 1;
        R_sp = corrInputClasses.normalizedEnergy.SP;
        R_pe = corrInputClasses.normalizedEnergy.PE;
        R_pi = corrInputClasses.normalizedEnergy.PI;
        
        R_sp_pe = corrInputClasses.normalizedEnergy.crossCorrelation.SPPE;
        R_pe_pi = corrInputClasses.normalizedEnergy.crossCorrelation.PEPI;
        R_pi_sp = corrInputClasses.normalizedEnergy.crossCorrelation.PISP;
        
        R_sp_ = corrInputClasses.energy.SP;
        R_pe_ = corrInputClasses.energy.PE;
        R_pi_ = corrInputClasses.energy.PI;
        
        R_sp_pe_ = corrInputClasses.energy.crossCorrelation.SPPE;
        R_pe_pi_ = corrInputClasses.energy.crossCorrelation.PEPI;
        R_pi_sp_ = corrInputClasses.energy.crossCorrelation.PISP;
    otherwise
        warning('The last argument must be 0, 1 or 2');
%         exit;
end

if normalizedPlot
    normalizedEnergy = figure;
    
%     First Subplot
    subplot(3,1,1)
    plot(f,R_sp,'.'); hold on;
    plot(f,ones(size(R_sp))*corr_limit,'r--')
    plot(f,ones(size(R_sp))*corr_limit*-1,'r--')
    
    plot(f(find(sign(R_sp_pe) == -1)),...
        R_sp(sign(R_sp_pe) == -1),'g.');
    
    title('Energia Normalizada')
    ylabel('Correlação SP x PE');
    grid on;
    
    % Second Subplot
    subplot(3,1,2)
    plot(f,R_pe,'.');
    hold on;
    plot(f,ones(size(R_pe))*corr_limit,'r--')
    plot(f,ones(size(R_pe))*corr_limit*-1,'r--')
    
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
    
    plot(f(find(sign(R_pi_sp) == -1)),...
        R_pi(sign(R_pi_sp) == -1),'g.');
    
    ylabel('Correlação PI x SP');
    xlabel('Frequência (Hz)')
    grid on;
end

if regularPlot
    
    energy = figure;
    % First Subplot
    subplot(3,1,1)
    plot(f,R_sp_,'.'); hold on;
    plot(f,ones(size(R_sp_))*corr_limit,'r--')
    plot(f,ones(size(R_sp_))*corr_limit*-1,'r--')
    
    plot(f(find(sign(R_sp_pe_) == -1)),...
        R_sp_(sign(R_sp_pe_) == -1),'g.');
    
    title('Energia')
    ylabel('Correlação SP x PE');
    grid on;
    
    % Second Subplot
    subplot(3,1,2)
    plot(f,R_pe_,'.');
    hold on;
    plot(f,ones(size(R_pe_))*corr_limit,'r--')
    plot(f,ones(size(R_pe_))*corr_limit*-1,'r--')
    
    plot(f(sign(R_pe_pi_) == -1),...
        R_pe_(sign(R_pe_pi_) == -1),'g.');
    
    ylabel('Correlação PE x PI');
    grid on;
    
    % Third Subplot
    subplot(3,1,3)
    plot(f,R_pi_,'.');
    hold on;
    plot(f,ones(size(R_pi_))*corr_limit,'r--')
    plot(f,ones(size(R_pi_))*corr_limit*-1,'r--')
    
    plot(f(find(sign(R_pi_sp_) == -1)),...
        R_pi_(sign(R_pi_sp_) == -1),'g.');
    
    ylabel('Correlação PI x SP');
    xlabel('Frequência (Hz)')
    grid on;
    
end
set(energy, 'visible', visible)
set(normalizedEnergy, 'visible', visible)
energyCrossCorrFigHandles.energy = energy;
energyCrossCorrFigHandles.normalizedEnergy = normalizedEnergy;

end