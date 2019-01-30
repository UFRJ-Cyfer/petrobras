function this = corrAnalysisChannel(this, inputVariable, variableString,channel,chArray)

inputVariable = inputVariable';
inputVariable = inputVariable(chArray==channel,:);
sp_class = repmat(this.target(1,chArray==channel)',1,size(inputVariable,2));
pe_class = repmat(this.target(2,chArray==channel)',1,size(inputVariable,2));
pi_class = repmat(this.target(3,chArray==channel)',1,size(inputVariable,2));

corr_limit = 2/sqrt(size(inputVariable,1));

% Normalized Energy Correlation
this.corrStruct.(variableString).SP = mean((sp_class-repmat(mean(sp_class),size(sp_class,1),1)).*...
    (inputVariable-repmat(mean(inputVariable),size(inputVariable,1),1)) ./ repmat(std(sp_class,1),size(sp_class,1),1) ...
    ./ repmat(std(inputVariable,1),size(inputVariable,1),1));

this.corrStruct.(variableString).PE = mean((pe_class-repmat(mean(pe_class),size(pe_class,1),1)).*...
    (inputVariable-repmat(mean(inputVariable),size(inputVariable,1),1)) ./ repmat(std(pe_class,1),size(pe_class,1),1) ...
    ./ repmat(std(inputVariable,1),size(inputVariable,1),1));

this.corrStruct.(variableString).PI = mean((pi_class-repmat(mean(pi_class),size(pi_class,1),1)).*...
    (inputVariable-repmat(mean(inputVariable),size(inputVariable,1),1)) ./ repmat(std(pi_class,1),size(pi_class,1),1) ...
    ./ repmat(std(inputVariable,1),size(inputVariable,1),1));


R_sp = this.corrStruct.(variableString).SP;
R_pe = this.corrStruct.(variableString).PE;
R_pi = this.corrStruct.(variableString).PI;

% Normalized Energy Cross-Correlation
% this.corrStruct.(variableString).SPPE = R_sp.*R_pe.*(abs(R_sp)>corr_limit).*(abs(R_pe)>corr_limit);
% this.corrStruct.(variableString).PEPI = R_pe.*R_pi.*(abs(R_pe)>corr_limit).*(abs(R_pi)>corr_limit);
% this.corrStruct.(variableString).PISP = R_pi.*R_sp.*(abs(R_pi)>corr_limit).*(abs(R_sp)>corr_limit);

this.corrStruct.(variableString).SPPE = R_sp.*R_pe;
this.corrStruct.(variableString).PEPI = R_pe.*R_pi;
this.corrStruct.(variableString).PISP = R_pi.*R_sp;

R_sp_pe = this.corrStruct.(variableString).SPPE;
R_pe_pi = this.corrStruct.(variableString).PEPI;
R_pi_sp = this.corrStruct.(variableString).PISP;

this.corrStruct.(variableString).gIndexSPPE = (sign(R_sp_pe) == -1);
this.corrStruct.(variableString).gIndexPEPI = (sign(R_pe_pi) == -1);
this.corrStruct.(variableString).gIndexPISP = (sign(R_pi_sp) == -1);

% this.variableString = inputVariable';
end