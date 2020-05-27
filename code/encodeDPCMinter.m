function [errorSignal, FY1, FY2, FY3, FY4, FY5, FY6] = encodeDPCMinter(movie, bits)
% Send bits referenced to left pixel, top pixel, top-left pixel, behind
% pixel, left of behind pixel, and top of behind pixel
firstFrame = movie(:,:,1);
secondFrame = movie(:,:,2);
info = size(movie);
% for k=2:2:info(1) % go through all even rows and flip them left right
%     firstFrame(k,:) = flip(firstFrame(k,:));
% end
X = transpose(firstFrame); % transpose video such that
X = X(:); % save to X Signal
T = transpose(secondFrame);
T = T(:);

M = zeros(1,info(1)*info(2)+info(1)+1); % Size of vector including first and second frame samples
for i=1:info(1)*info(2)
    M(i) = X(i);
end
for i=1:info(2)+1
    M(i+info(1)*info(2)) = T(i);     
end
%Z = T(1,(1:info(2)+1));
%M = cat(2, X, Z);
M = cast(M,'double'); % To perform calculations later on, must be double type and not integer 8bit
Y1 = circshift(M,1);% Left pixel
Y2 = circshift(M,info(2));% Top pixel
Y3 = circshift(M,info(2)+1);% Top left pixel
Y4 = circshift(M,1+info(1)*info(2));% Left pixel previous frame
Y5 = circshift(M,info(2)+info(1)*info(2));% Top pixel previous frame
Y6 = circshift(M,info(1)*info(2));%Pixel in previous frame
detM=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*Y3) mean(Y1.*Y4) mean(Y1.*Y5) mean(Y1.*Y6); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*Y3) mean(Y2.*Y4) mean(Y2.*Y5) mean(Y2.*Y6); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.^2) mean(Y3.*Y4) mean(Y3.*Y5) mean(Y3.*Y6); mean(Y4.*Y1) mean(Y4.*Y2) mean(Y4.*Y3) mean(Y4.^2) mean(Y4.*Y5) mean(Y4.*Y6); mean(Y5.*Y1) mean(Y5.*Y2) mean(Y5.*Y3) mean(Y5.*Y4) mean(Y5.^2) mean(Y5.*Y6); mean(Y6.*Y1) mean(Y6.*Y2) mean(Y6.*Y3) mean(Y6.*Y4) mean(Y6.*Y5) mean(Y6.^2)]); % derived matrix discriminant value
detA=det([mean(M.*Y1) mean(Y1.*Y2) mean(Y1.*Y3) mean(Y1.*Y4) mean(Y1.*Y5) mean(Y1.*Y6); mean(M.*Y2) mean(Y2.^2) mean(Y2.*Y3) mean(Y2.*Y4) mean(Y2.*Y5) mean(Y2.*Y6); mean(M.*Y3) mean(Y2.*Y3) mean(Y3.^2) mean(Y3.*Y4) mean(Y3.*Y5) mean(Y3.*Y6); mean(M.*Y4) mean(Y4.*Y2) mean(Y4.*Y3) mean(Y4.^2) mean(Y4.*Y5) mean(Y4.*Y6); mean(M.*Y5) mean(Y5.*Y2) mean(Y5.*Y3) mean(Y5.*Y4) mean(Y5.^2) mean(Y5.*Y6); mean(M.*Y6) mean(Y6.*Y2) mean(Y6.*Y3) mean(Y6.*Y4) mean(Y6.*Y5) mean(Y6.^2)]); % disc. for Y1 constant
detB=det([mean(Y1.^2) mean(Y1.*M) mean(Y1.*Y3) mean(Y1.*Y4) mean(Y1.*Y5) mean(Y1.*Y6); mean(Y1.*Y2) mean(M.*Y2) mean(Y2.*Y3) mean(Y2.*Y4) mean(Y2.*Y5) mean(Y2.*Y6); mean(Y1.*Y3) mean(M.*Y3) mean(Y3.^2) mean(Y3.*Y4) mean(Y3.*Y5) mean(Y3.*Y6); mean(Y4.*Y1) mean(Y4.*M) mean(Y4.*Y3) mean(Y4.^2) mean(Y4.*Y5) mean(Y4.*Y6); mean(Y5.*Y1) mean(Y5.*M) mean(Y5.*Y3) mean(Y5.*Y4) mean(Y5.^2) mean(Y5.*Y6); mean(Y6.*Y1) mean(Y6.*M) mean(Y6.*Y3) mean(Y6.*Y4) mean(Y6.*Y5) mean(Y6.^2)]); % disc. for Y2 constant  
detC=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*M) mean(Y1.*Y4) mean(Y1.*Y5) mean(Y1.*Y6); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*M) mean(Y2.*Y4) mean(Y2.*Y5) mean(Y2.*Y6); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.*M) mean(Y3.*Y4) mean(Y3.*Y5) mean(Y3.*Y6); mean(Y4.*Y1) mean(Y4.*Y2) mean(Y4.*M) mean(Y4.^2) mean(Y4.*Y5) mean(Y4.*Y6); mean(Y5.*Y1) mean(Y5.*Y2) mean(Y5.*M) mean(Y5.*Y4) mean(Y5.^2) mean(Y5.*Y6); mean(Y6.*Y1) mean(Y6.*Y2) mean(Y6.*M) mean(Y6.*Y4) mean(Y6.*Y5) mean(Y6.^2)]); % disc. for Y3 constant
detD=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*Y3) mean(Y1.*M) mean(Y1.*Y5) mean(Y1.*Y6); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*Y3) mean(Y2.*M) mean(Y2.*Y5) mean(Y2.*Y6); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.^2) mean(Y3.*M) mean(Y3.*Y5) mean(Y3.*Y6); mean(Y4.*Y1) mean(Y4.*Y2) mean(Y4.*Y3) mean(Y4.*M) mean(Y4.*Y5) mean(Y4.*Y6); mean(Y5.*Y1) mean(Y5.*Y2) mean(Y5.*Y3) mean(Y5.*M) mean(Y5.^2) mean(Y5.*Y6); mean(Y6.*Y1) mean(Y6.*Y2) mean(Y6.*Y3) mean(Y6.*M) mean(Y6.*Y5) mean(Y6.^2)]); % disc. for Y4 constant
detE=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*Y3) mean(Y1.*Y4) mean(Y1.*M) mean(Y1.*Y6); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*Y3) mean(Y2.*Y4) mean(Y2.*M) mean(Y2.*Y6); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.^2) mean(Y3.*Y4) mean(Y3.*M) mean(Y3.*Y6); mean(Y4.*Y1) mean(Y4.*Y2) mean(Y4.*Y3) mean(Y4.^2) mean(Y4.*M) mean(Y4.*Y6); mean(Y5.*Y1) mean(Y5.*Y2) mean(Y5.*Y3) mean(Y5.*Y4) mean(Y5.*M) mean(Y5.*Y6); mean(Y6.*Y1) mean(Y6.*Y2) mean(Y6.*Y3) mean(Y6.*Y4) mean(Y6.*M) mean(Y6.^2)]); % disc. for Y5 constant
detF=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*Y3) mean(Y1.*Y4) mean(Y1.*Y5) mean(Y1.*M); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*Y3) mean(Y2.*Y4) mean(Y2.*Y5) mean(Y2.*M); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.^2) mean(Y3.*Y4) mean(Y3.*Y5) mean(Y3.*M); mean(Y4.*Y1) mean(Y4.*Y2) mean(Y4.*Y3) mean(Y4.^2) mean(Y4.*Y5) mean(Y4.*M); mean(Y5.*Y1) mean(Y5.*Y2) mean(Y5.*Y3) mean(Y5.*Y4) mean(Y5.^2) mean(Y5.*M); mean(Y6.*Y1) mean(Y6.*Y2) mean(Y6.*Y3) mean(Y6.*Y4) mean(Y6.*Y5) mean(Y6.*M)]); % disc. for Y6 constant
FY1 = detA/detM; FY2=detB/detM; FY3=detC/detM; FY4 = detD/detM; FY5 = detE/detM; FY6 = detF/detM;
clear X M Y1 Y2 Y3 Y4 Y5 Y6 detA detB detC detD detE detF detM
% X_hat = (detA/detM).*Y1+(detB/detM).*Y2+(detC/detM).*Y3; % create X_hat array from derived formulas
% errorSig = X-X_hat; % create error signal
% figure;histogram(errorSig, 128);
movie = cast(movie, 'double');
X_hat = zeros(info); errorSignal=X_hat;
for frameLoc = 2:info(3)
    for rowLoc=1:info(1)
        for colLoc=1:info(2)
            if rowLoc==1
                if colLoc==1
                    X_pred = 0;
                else
                    X_pred = FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
                end
            elseif colLoc==1
                if rowLoc == 1
                    X_pred = 0;
                else
                    X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) + FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
                end
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1,frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1,frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1)+  FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            end
            error_pixel = movie(rowLoc,colLoc, frameLoc) - X_pred;
            errorSignal(rowLoc,colLoc, frameLoc) = signedQuantizer(error_pixel, bits);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorSignal(rowLoc,colLoc, frameLoc);
        end
        for colLoc=(colLoc+1):info(2)
            if rowLoc==1
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) + FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1, frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1)+  FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            end
            error_pixel = movie(rowLoc,colLoc, frameLoc) - X_pred;
            errorSignal(rowLoc,colLoc, frameLoc) = signedQuantizer(error_pixel, bits);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorSignal(rowLoc,colLoc, frameLoc);
        end
    end
end
errorSignal = errorSignal(:);
end