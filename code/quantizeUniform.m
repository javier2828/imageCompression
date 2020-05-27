%Javier Salazar Andrew Bouasry
%Uniform Quantizer given X bits
function quantizeSignal = quantizeUniform(signal, bits)
%type = class(signal);
signal = double(signal);
maxValue = 2^(bits-1) -1;% max(signal);
minValue = -2^(bits-1);% min(signal);
stepSize = (maxValue-minValue)/(2^bits);
q_level = minValue+stepSize/2:stepSize:maxValue-stepSize/2;
sigp = (signal-minValue)/stepSize+1/2;
qindex = round(sigp);
qindex = min(qindex, 2^bits);
quantizeSignal = q_level(qindex);
quantizeSignal = transpose(quantizeSignal);
%quantizeSignal = cast(quantizeSignal, type);
end