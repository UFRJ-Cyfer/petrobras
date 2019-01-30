function this = divideClasses(this)
%
%   Divides the 3 classes based on this.timePE and this.timePI. Also creates the arrays that hold the wave indexes for each class and the target to be used on the model.
%

this = adjustCycles(this);

triggerArray = this.propertyVector('triggerTime');
aux = 1:length(this.Waves);
this.spIndexes = aux(triggerArray < this.timePE);
this.peIndexes = aux(triggerArray >= this.timePE & triggerArray < this.timePI);
this.piIndexes = aux(triggerArray >= this.timePI);
 
this.spIndexes = [this.spIndexes this.peIndexes(1:225)];
this.peIndexes(1:225) = [];

target = zeros(3,length(this.Waves));
target(1,this.spIndexes) = 1;
target(2,this.peIndexes) = 1;
target(3,this.piIndexes) = 1;

this.StreamingModel.target = target;
end