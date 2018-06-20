function this = divideClasses(this)

this = adjustCycles(this);

triggerArray = this.propertyVector('triggerTime');
aux = 1:length(this.Waves);
this.spIndexes = aux(triggerArray < this.timePE);
this.peIndexes = aux(triggerArray >= this.timePE & triggerArray < this.timePI);
this.piIndexes = aux(triggerArray >= this.timePI);
 
target = zeros(3,length(this.Waves));
target(1,this.spIndexes) = 1;
target(2,this.peIndexes) = 1;
target(3,this.piIndexes) = 1;

this.StreamingModel.target = target;
end