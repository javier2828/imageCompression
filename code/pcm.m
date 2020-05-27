%Javier Salazar Andrew Bouasry
%Uniform Quantizer given X bits
function quantizeSignal = pcm(signal, bits)
%type = class(signal);
signal = double(signal);
maxValue =  max(signal);
minValue = min(signal);
stepSize = (maxValue-minValue)/(2^bits);
q_level = minValue+stepSize/2:stepSize:maxValue-stepSize/2;
sigp = (signal-minValue)/stepSize+1/2;
qindex = round(sigp);
qindex = min(qindex, 2^bits);
quantizeSignal = q_level(qindex);
quantizeSignal = transpose(quantizeSignal);
%quantizeSignal = cast(quantizeSignal, type);
end