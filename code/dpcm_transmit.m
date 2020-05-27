%Javier Salazar Andrew Bouasry
%DPCM INTRAFRAME TRANSMISSION
% Output error signal, line scanned video signal X
% and predictor model x_hat given input video
function [errorSignal, FY1,FY2,FY3, samples, X] = dpcm_transmit(movie, bits)
info = size(movie); % get dimensions
%-----------scan line method---------------------
X = zeros(info(1)*info(2),info(3),'uint8'); % preallocate line scan signal
% preallocate predictor coefficient info
for i = 1:info(3) % go through all frames
    if (mod(i,2)==1)
        for k=2:2:info(1) % go through all even rows and flip them left right
            movie(k,:,i) = flip(movie(k,:,i));
        end
        newFrame = transpose(movie(:,:,i)); % transpose video such that
        X(:,i) = newFrame(:); % save to X Signal
    else
        temp = transpose(flipud(movie(:,:,i)));
        for k=1:2:info(1) % go through all odd columns and flip them up down
            temp(:,k+1) = flip(temp(:,k+1));
        end
        X(:,i) = temp(:); % save to X Signal
    end
end
X = X(:);
%-----------------predictors----------------------------
X_noquant = X;
%X = quantizeUniform(X, bits);
X_mean = mean(X.^2); % get mean squared value of signal
Y1 = circshift(X,1); % perform shift to get left pixel along all images
Y2 = circshift(X,info(2)); % shift to top pixel along images
Y3 = circshift(X, info(2)+1); % shift to top left pixel along iamges
Y12 = mean(times(Y1, Y2)); % get mean values of all 3 predictors
Y13 = mean(times(Y1, Y3));
Y23 = mean(times(Y2, Y3));
XY1 = mean(times(X, Y1)); % get mean of predictor and true signal
XY2 = mean(times(X, Y2));
XY3 = mean(times(X, Y3));
detM = det([X_mean Y12 Y13; Y12 X_mean Y23; Y13 Y23 X_mean]); % derived matrix discriminant value
detA=det([XY1 Y12 Y13; XY2 X_mean Y23; XY3 Y23 X_mean]); % disc. for Y1 constant
detB=det([X_mean XY1 Y13; Y12 XY2 Y23; Y13 XY3 X_mean]); % disc. for Y2 constant
detC= det([X_mean Y12 XY1; Y12 X_mean XY2; Y13 Y23 XY3]); % disc. for Y3 constant
FY1 = detA./detM; FY2 = detB./detM;FY3=detC./detM; % get final coefficients
clear Y12 Y13 Y23 XY1 XY2 XY3 X_mean detA detB detC detM newFrame temp i k
X_hat = times(double(Y1), FY1) + times(double(Y2), FY2) + times(double(Y3), FY3);% % create X_hat array from derived values
clear Y1 Y2 Y3
%X_hat_quant = quantizeUniform(X_hat, bits);
errorSignal = cast(double(X_noquant)-X_hat,'double'); % create error signal
%errorSignal = cast(errorSignal, 'int16');
%errorSignal = quantizeUniform(errorSignal, bits);
samples = X_noquant(end-info(2):end);
end

