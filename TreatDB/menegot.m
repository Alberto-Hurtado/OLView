function [Sig,Eps1,LoSign,SigIn,EpsIn,R]=menegot(Eps,Eps1,LoSign,SigIn,EpsIn,R,...
                                              Es,Emu,Sigo,Ro,A1,A2)
%MENEGOT
%           [Sig,Eps1,LoSign,SigIn,EpsIn,R]=MENEGOT(Eps,Eps1,LoSign,SigIn,EpsIn,R,...
%                                               Es,Emu,Sigo,Ro,A1,A2)
%           For a given strain history Eps, last previous strain Eps1,
%           loading Sign LoSign (+1 or -1) since the
%           last previous loading inversion point (SigIn,EpsIn) and last
%           previous R exponent, gives the resulting history of stress Sig
%           and the new current values of those state variables following
%           a Menegotto and Pinto model characterized by the parameters:
%              Es:      Tangent initial modulus
%              Emu:     Tangent asymptotic modulus
%              Sigo:    Stress at the intersection between the asymptotic
%                       positve line of slope Emu and the initial tangent
%                       stiffnes line of slope Es.
%              Ro:      Exponent for the initial monotonic loading curve
%              A1,A2:   Parameters of the formula for the definition of the 
%                       exponent R for subsequent loading branchs
%
%  Example:     Es=2e11;Emu=Es/10;Sigo=500e6;Ro=3;A1=0;A2=1;
%               Eps=1e-3*[0 3 9 12 8 6 7 9 12 15 13 7 4 2 -1];
%               Eps1=0;LoSign=+1;SigIn=0;EpsIn=0;R=Ro;
%
%   [Sig,Eps1,LoSign,SigIn,EpsIn,R]=menegot(Eps,Eps1,LoSign,SigIn,EpsIn,R,...
%                                              Es,Emu,Sigo,Ro,A1,A2)
%
%  28/1/97  J. Molina

Eps=Eps(:);
nt=length(Eps);
Sig=zeros(nt,1);
b=Emu/Es;
EpspIn=EpsIn-SigIn/Es;
SigKn=LoSign*Sigo+Emu/(1-b)*EpspIn;
EpsKn=EpspIn+SigKn/Es;
Eps1_=(Eps1-EpsIn)/(EpsKn-EpsIn);
Sig1=SigIn+(SigKn-SigIn)*((1-b)/(1+Eps1_^R)^(1/R)+b)*Eps1_;
for it=1:nt;
  if (Eps(it)-Eps1)*LoSign<0;
    LoSign=-LoSign;
    Epsp1=Eps1-Sig1/Es;
    Xin=abs(Epsp1-EpspIn)/(Sigo/Es);
    if Xin>0.001; R=Ro-A1*Xin/(A2+Xin); end;   
%    disp([Eps1 Sig1 LoSign Xin R]);
    EpsIn=Eps1;
    SigIn=Sig1;
    EpspIn=EpsIn-SigIn/Es;
    SigKn=LoSign*Sigo+Emu/(1-b)*EpspIn;
    EpsKn=EpspIn+SigKn/Es;
  end;
  Eps1=Eps(it);
  Eps1_=(Eps1-EpsIn)/(EpsKn-EpsIn);
  Sig1=SigIn+(SigKn-SigIn)*((1-b)/(1+Eps1_^R)^(1/R)+b)*Eps1_;
  Sig(it)=Sig1;
end;


