function this = adjustCycles(this)

if ~isempty(this.cycleDividers) && ~this.adjusted

    for k=1:length(this.cycleDividers)
        T = this.Waves(this.cycleDividers(k)-1).triggerTime;
        for m=this.cycleDividers(k):length(this.Waves)
           this.Waves(m).triggerTime = this.Waves(m).triggerTime+T;
        end
    end
end
this.adjusted = 1;
end