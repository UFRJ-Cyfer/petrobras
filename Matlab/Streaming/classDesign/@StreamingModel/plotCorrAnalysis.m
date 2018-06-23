function this = plotCorrAnalysis(this)

fieldNames = fieldnames(this.corrStruct);
f = this.frequencyArray;
corr_limit = 1.96/sqrt(size(this.target,2));

for variableIndex = 1:length(fieldNames)
    var = fieldNames{variableIndex};
    this.figHandles(variableIndex) = figure(100+variableIndex);
    subplot(3,1,1)
    hold off;
    plot(f,this.corrStruct.(var).SP,'.'); hold on;
    plot(f,ones(size(this.corrStruct.(var).SP))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var).SP))*corr_limit*-1,'r--')
    
    plot(f(find(sign(this.corrStruct.(var).SPPE) == -1)),...
        this.corrStruct.(var).SP(sign(this.corrStruct.(var).SPPE) == -1),'g.');
    
    titleVar = [upper(var(1)) var(2:end)];
    titleVar = (regexprep(titleVar, '([A-Z])', ' $1'));
    titleVar(1) = [];
    
    title(titleVar)
    ylabel('Correlation NP x SP'); % SP x PE
    grid on;
    
    % Second Subplot
    subplot(3,1,2)
    hold off;
    plot(f,this.corrStruct.(var).PE,'.');
    hold on;
    plot(f,ones(size(this.corrStruct.(var).PE))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var).PE))*corr_limit*-1,'r--')
    
    plot(f(sign(this.corrStruct.(var).PEPI) == -1),...
        this.corrStruct.(var).PE(sign(this.corrStruct.(var).PEPI) == -1),'g.');
    
    ylabel('Correlation SP x UP'); %PE x PI
    grid on;
    
    % Third Subplot
    subplot(3,1,3)
    hold off;
    plot(f,this.corrStruct.(var).PI,'.');
    hold on;
    plot(f,ones(size(this.corrStruct.(var).PI))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var).PI))*corr_limit*-1,'r--')
    
    plot(f(find(sign(this.corrStruct.(var).PISP) == -1)),...
        this.corrStruct.(var).PI(sign(this.corrStruct.(var).PISP) == -1),'g.');
    
    ylabel('Correlation UP x NP'); % PI x SP
    xlabel('Frequency (Hz)')
    grid on;
end

end