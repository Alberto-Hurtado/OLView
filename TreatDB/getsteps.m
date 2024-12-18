function [steps,sig2]=getsteps(sig,Tol,Intervalmin,Intervalborder)
%Gets the averaged value of the step intervals of a signal
% Tol=0.5; %kN tolerance within the step
% Intervalmin=30; %Minimum number of points of a step interval
% Intervalborder=5;  %Points to be removed at every side of the step interval

steps=[];
in_step=0;
sig2=0*sig;
for ip=2:length(sig)
    if in_step
        if abs(sig(ip)-sig(ip-1))<Tol && ip<length(sig)
            npstep=npstep+1;
        else
            if npstep>Intervalmin
                steps=[steps; mean(sig(ip-1-npstep+Intervalborder:ip-1-Intervalborder))];
                sig2(ip-1-npstep+1+Intervalborder:ip-1-Intervalborder)= ...
                    steps(length(steps))*ones(npstep-2*Intervalborder,1);
            end
            in_step=0;
        end
    else
        if abs(sig(ip)-sig(ip-1))<Tol
            in_step=1;
            npstep=1;
        end
    end
end

    