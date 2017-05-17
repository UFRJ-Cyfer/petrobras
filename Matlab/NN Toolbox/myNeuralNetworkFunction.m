test_perform_neuron = zeros(3,10)
for neuron_size = 10:10
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 29-Apr-2017 20:56:19
%
% This script assumes these variables are defined:
%
%   E_entry - input data.
%   output_classes - target data.


x = E_entry';
t = (y)';

% x = E_entry';
% t = (output_classes)';

% E_Entry = [E_entry; E_entry(1450:end,:)];
% output_C = [output_classes; output_classes(1450:end,:)];

% x = E_Entry';
% t = (output_C)';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = neuron_size;
net = patternnet(hiddenLayerSize);
% net.layers{2}.transferFcn = 'tansig';
net.trainFcn = trainFcn;

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
% net.input.processFcns = {'removeconstantrows','mapminmax'};
% net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 10/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

net.trainParam.min_grad = 1e-16;
net.trainParam.max_fail = 50;
net.trainParam.lr = 0.1;

% Train the Network
[net,tr] = train(net,x,t);

x_ = E_entry';
t_ = (output_classes)';

% Test the Network
y = net(x);
y_ = net(x_);
figure;
plot(y_,'r.');
% hold on;
% plot(t);
% plot(zeros(size(t)),'k--')
e = gsubtract(t,y);
performance = perform(net,t,y)
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};

aux = tr.testMask{1};
testTargets_ = t_.*aux(1,1:size(t_,2));
testOutputs = y_ .*aux(1,1:size(y_,2));
 
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

test_perform_neuron(1,neuron_size) = testPerformance;
test_perform_neuron(2,neuron_size) = testPerformance;
test_perform_neuron(3,neuron_size) = testPerformance;

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
figure, plotconfusion(testTargets,testOutputs)
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',14)
% set(findobj(gca,'type','text'),'fontsize',16)
%figure, plotroc(t,y)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end
end
