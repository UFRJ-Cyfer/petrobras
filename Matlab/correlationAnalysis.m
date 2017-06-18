function corrInputClasses = correlationAnalysis(mainVallen)

y_classes = mainVallen.sparseCodification;
E_not_norm = mainVallen.energy';
E = mainVallen.normalizedEnergy';
P = mainVallen.phase';

sp_class = repmat(y_classes(1,:)',1,size(E,2));
pe_class = repmat(y_classes(2,:)',1,size(E,2));
pi_class = repmat(y_classes(3,:)',1,size(E,2));

corr_limit = 2/sqrt(size(E,1));

% Normalized Energy Correlation
R_sp = mean((sp_class-repmat(mean(sp_class),size(sp_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(sp_class,1),size(sp_class,1),1) ...
    ./ repmat(std(E,1),size(E,1),1));

R_pe = mean((pe_class-repmat(mean(pe_class),size(pe_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(pe_class,1),size(pe_class,1),1) ...
    ./ repmat(std(E,1),size(E,1),1));

R_pi = mean((pi_class-repmat(mean(pi_class),size(pi_class,1),1)).*...
    (E-repmat(mean(E),size(E,1),1)) ./ repmat(std(pi_class,1),size(pi_class,1),1) ...
    ./ repmat(std(E,1),size(E,1),1));

% Energy Correlation
R_sp_ = mean((sp_class-repmat(mean(sp_class),size(sp_class,1),1)).*...
    (E_not_norm-repmat(mean(E_not_norm),size(E_not_norm,1),1)) ./ repmat(std(sp_class,1),size(sp_class,1),1) ...
    ./ repmat(std(E_not_norm,1),size(E_not_norm,1),1));

R_pe_ = mean((pe_class-repmat(mean(pe_class),size(pe_class,1),1)).*...
    (E_not_norm-repmat(mean(E_not_norm),size(E_not_norm,1),1)) ./ repmat(std(pe_class,1),size(pe_class,1),1) ...
    ./ repmat(std(E_not_norm,1),size(E_not_norm,1),1));

R_pi_ = mean((pi_class-repmat(mean(pi_class),size(pi_class,1),1)).*...
    (E_not_norm-repmat(mean(E_not_norm),size(E_not_norm,1),1)) ./ repmat(std(pi_class,1),size(pi_class,1),1) ...
    ./ repmat(std(E_not_norm,1),size(E_not_norm,1),1));


% Phase Correlation
R_P_sp = mean((sp_class-repmat(mean(sp_class),size(sp_class,1),1)) .*...
    (P-repmat(mean(P),size(P,1),1)) ./ repmat(std(sp_class,1),size(sp_class,1),1) ...
    ./ repmat(std(P,1),size(P,1),1));

R_P_pe = mean((pe_class-repmat(mean(pe_class),size(pe_class,1),1)).*...
    (P-repmat(mean(P),size(P,1),1)) ./ repmat(std(pe_class,1),size(pe_class,1),1) ...
    ./ repmat(std(P,1),size(P,1),1));

R_P_pi = mean((pi_class-repmat(mean(pi_class),size(pi_class,1),1)).*...
    (P-repmat(mean(P),size(P,1),1)) ./ repmat(std(pi_class,1),size(pi_class,1),1) ...
    ./ repmat(std(P,1),size(P,1),1));

% Normalized Energy Cross-Correlation
R_sp_pe = R_sp.*R_pe.*(abs(R_sp)>corr_limit).*(abs(R_pe)>corr_limit);
R_pe_pi = R_pe.*R_pi.*(abs(R_pe)>corr_limit).*(abs(R_pi)>corr_limit);
R_pi_sp = R_pi.*R_sp.*(abs(R_pi)>corr_limit).*(abs(R_sp)>corr_limit);

% Energy Cross-Correlation
R_sp_pe_ = R_sp_.*R_pe_.*(abs(R_sp_)>corr_limit).*(abs(R_pe_)>corr_limit);
R_pe_pi_ = R_pe_.*R_pi_.*(abs(R_pe_)>corr_limit).*(abs(R_pi_)>corr_limit);
R_pi_sp_ = R_pi_.*R_sp_.*(abs(R_pi_)>corr_limit).*(abs(R_sp_)>corr_limit);

% Phase Cross-Correlation
R_P_sp_pe = R_P_sp.*R_P_pe.*(abs(R_P_sp)>corr_limit).*(abs(R_P_pe)>corr_limit);
R_P_pe_pi = R_P_pe.*R_P_pi.*(abs(R_P_pe)>corr_limit).*(abs(R_P_pi)>corr_limit);
R_P_pi_sp = R_P_pi.*R_P_sp.*(abs(R_P_pi)>corr_limit).*(abs(R_P_sp)>corr_limit);


% Output Assignments

corrInputClasses.correlationLimit = corr_limit;

corrInputClasses.normalizedEnergy.SP = R_sp;
corrInputClasses.normalizedEnergy.PE = R_pe;
corrInputClasses.normalizedEnergy.PI = R_pi;

corrInputClasses.energy.SP = R_sp_;
corrInputClasses.energy.PE = R_pe_;
corrInputClasses.energy.PI = R_pi_;

corrInputClasses.phase.sp = R_P_sp;
corrInputClasses.phase.pe = R_P_pe;
corrInputClasses.phase.pi = R_P_pi;

corrInputClasses.normalizedEnergy.crossCorrelation.SPPE = R_sp_pe;
corrInputClasses.normalizedEnergy.crossCorrelation.PEPI = R_pe_pi;
corrInputClasses.normalizedEnergy.crossCorrelation.PISP = R_pi_sp;

corrInputClasses.energy.crossCorrelation.SPPE = R_sp_pe_;
corrInputClasses.energy.crossCorrelation.PEPI = R_pe_pi_;
corrInputClasses.energy.crossCorrelation.PISP = R_pi_sp_;

corrInputClasses.phase.crossCorrelation.SPPE = R_P_sp_pe;
corrInputClasses.phase.crossCorrelation.PEPI = R_P_pe_pi;
corrInputClasses.phase.crossCorrelation.PISP = R_P_pi_sp;

end