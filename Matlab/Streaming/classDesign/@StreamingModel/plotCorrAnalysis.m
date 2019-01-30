function this = plotCorrAnalysis(this)

fieldNames = fieldnames(this.corrStruct);
f = this.frequencyArray;
corr_limit = 1.96/sqrt(size(this.target,2));
maxes = zeros(1,3);
for variableIndex = 1:length(fieldNames)

    
    var_ = fieldNames{variableIndex};
    titleVar = [upper(var_(1)) var_(2:end)];
    maxes(1) = max(this.corrStruct.(var_).SP);
    maxes(2) = max(this.corrStruct.(var_).PE);
    maxes(3) = max(this.corrStruct.(var_).PI);
    max_max = max(maxes);
    titleVar = (regexprep(titleVar, '([A-Z])', ' $1'));
    titleVar(1) = [];
    
    %this.figHandles(variableIndex) = figure(100+variableIndex);
    this.figHandles(variableIndex) = figure('name',titleVar);
    subplot(3,1,1)
    hold off;
    plot(f,this.corrStruct.(var_).SP,'.'); hold on;    
    plot(f(find(sign(this.corrStruct.(var_).SPPE) == -1)),...
        this.corrStruct.(var_).SP(sign(this.corrStruct.(var_).SPPE) == -1),'g.');
    
    plot(f,ones(size(this.corrStruct.(var_).SP))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var_).SP))*corr_limit*-1,'r--')
    ylim([-max_max max_max])

    
    %title(titleVar)
    ylabel('NP x SP'); % SP x PE
    grid on;
    xlim([0 400e3])
    
    % Second Subplot
    subplot(3,1,2)
    hold off;
    plot(f,this.corrStruct.(var_).PE,'.');
    hold on;    
    plot(f(sign(this.corrStruct.(var_).PEPI) == -1),...
        this.corrStruct.(var_).PE(sign(this.corrStruct.(var_).PEPI) == -1),'g.');
    
    plot(f,ones(size(this.corrStruct.(var_).PE))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var_).PE))*corr_limit*-1,'r--')
    ylim([-max_max max_max])

    ylabel('SP x UP'); %PE x PI
    grid on;
    xlim([0 400e3])
    
    % Third Subplot
    subplot(3,1,3)
    hold off;
    plot(f,this.corrStruct.(var_).PI,'.');
    hold on;
    
    plot(f(find(sign(this.corrStruct.(var_).PISP) == -1)),...
        this.corrStruct.(var_).PI(sign(this.corrStruct.(var_).PISP) == -1),'g.');
    
    plot(f,ones(size(this.corrStruct.(var_).PI))*corr_limit,'r--')
    plot(f,ones(size(this.corrStruct.(var_).PI))*corr_limit*-1,'r--')
    ylim([-max_max max_max])

    ylabel('UP x NP'); % PI x SP
    xlabel('Frequency (Hz)')
    grid on;
    xlim([0 400e3])
    
end

end