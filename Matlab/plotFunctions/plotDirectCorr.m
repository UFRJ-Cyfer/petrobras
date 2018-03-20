function energyDirectCorrFigHandles = plotDirectCorr(corrInputClasses, frequencyVector, normalized, visible)

%PLOTDIRECTCORR Plots the direct input X output correlation 
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
        normalizedEnergy = null;
    case 1
        normalizedPlot = 1;
        R_sp = corrInputClasses.normalizedEnergy.SP;
        R_pe = corrInputClasses.normalizedEnergy.PE;
        R_pi = corrInputClasses.normalizedEnergy.PI;
        energy = null;
    case 2
        regularPlot = 1;
        normalizedPlot = 1;
        R_sp = corrInputClasses.normalizedEnergy.SP;
        R_pe = corrInputClasses.normalizedEnergy.PE;
        R_pi = corrInputClasses.normalizedEnergy.PI;
        
        R_sp_ = corrInputClasses.energy.SP;
        R_pe_ = corrInputClasses.energy.PE;
        R_pi_ = corrInputClasses.energy.PI;
    otherwise
        warning('The last argument must be 0, 1 or 2');
        exit;
end

if normalizedPlot
    normalizedEnergy = figure;
    % First Subplot
    subplot(3,1,1)
    plot(f,R_sp,'.'); hold on;
    plot(f,ones(size(R_sp))*corr_limit,'r--')
    plot(f,ones(size(R_sp))*corr_limit*-1,'r--')
    
    title('Energia Normalizada')
    ylabel('Correlação SP');
    grid on;
    
    % Second Subplot
    subplot(3,1,2)
    plot(f,R_pe,'.');
    hold on;
    plot(f,ones(size(R_pe))*corr_limit,'r--')
    plot(f,ones(size(R_pe))*corr_limit*-1,'r--')
    
    ylabel('Correlação PE');
    grid on;
    
    % Third Subplot
    subplot(3,1,3)
    plot(f,R_pi,'.');
    hold on;
    plot(f,ones(size(R_pi))*corr_limit,'r--')
    plot(f,ones(size(R_pi))*corr_limit*-1,'r--')
    
    ylabel('Correlação PI');
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
    
    title('Energia')
    ylabel('Correlação SP');
    grid on;
    
    % Second Subplot
    subplot(3,1,2)
    plot(f,R_pe_,'.');
    hold on;
    plot(f,ones(size(R_pe_))*corr_limit,'r--')
    plot(f,ones(size(R_pe_))*corr_limit*-1,'r--')
    
    ylabel('Correlação PE');
    grid on;
    
    % Third Subplot
    subplot(3,1,3)
    plot(f,R_pi_,'.');
    hold on;
    plot(f,ones(size(R_pi_))*corr_limit,'r--')
    plot(f,ones(size(R_pi_))*corr_limit*-1,'r--')
    
    ylabel('Correlação PI');
    xlabel('Frequência (Hz)')
    grid on;
    
end
set(energy, 'visible', visible)
set(normalizedEnergy, 'visible', visible)
energyDirectCorrFigHandles.energy = energy;
energyDirectCorrFigHandles.normalizedEnergy = normalizedEnergy;

end