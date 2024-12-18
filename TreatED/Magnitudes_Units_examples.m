




display('List of existing magnitudes in ELSADATA:')
mags=getAllSignalMagnitudes(data);
magTypes=cell(size(mags));
for iMag=1:size(mags)
    unit=mags(iMag).unit.name;
    display(sprintf('  iMag=%2d  Type=%25s  Unit=%15s    Descr.=%s', ...
        iMag, mags(iMag).type.name,mags(iMag).unit.name,mags(iMag).unit.description))
end

% List of existing magnitudes in ELSADATA:
%   iMag= 1  Type=              Accelerance  Unit=           kg?¹    Descr.=1 / Kilogram
%   iMag= 2  Type=             Acceleration  Unit=           m/s²    Descr.=Metre per square second
%   iMag= 3  Type=                    Angle  Unit=            rad    Descr.=Radian
%   iMag= 4  Type=                  Counter  Unit=  Dimensionless    Descr.=Dimensionless
%   iMag= 5  Type=                  Current  Unit=              A    Descr.=Ampere
%   iMag= 6  Type=                    Cycle  Unit=  Dimensionless    Descr.=Dimensionless
%   iMag= 7  Type=                  Damping  Unit=           Ns/m    Descr.=Newton second per metre
%   iMag= 8  Type=             Displacement  Unit=              m    Descr.=Metre
%   iMag= 9  Type=                   Energy  Unit=              J    Descr.=Joule
%   iMag=10  Type=                    Force  Unit=              N    Descr.=Newton
%   iMag=11  Type=                Frequency  Unit=             Hz    Descr.=Hertz
%   iMag=12  Type=            JRC undefined  Unit=  Dimensionless    Descr.=Dimensionless
%   iMag=13  Type=                     Mass  Unit=             kg    Descr.=Kilogram
%   iMag=14  Type=                   Moment  Unit=             Nm    Descr.=Newton metre
%   iMag=15  Type=                   Number  Unit=  Dimensionless    Descr.=Dimensionless
%   iMag=16  Type=                   Period  Unit=              s    Descr.=Second
%   iMag=17  Type=                    Phase  Unit=            rad    Descr.=Radian
%   iMag=18  Type=                 Pressure  Unit=             Pa    Descr.=Pascal
%   iMag=19  Type=                    Ratio  Unit=  Dimensionless    Descr.=Dimensionless
%   iMag=20  Type=                 Rotation  Unit=            rad    Descr.=Radian
%   iMag=21  Type=    Rotation acceleration  Unit=         rad/s²    Descr.=Radian per square second
%   iMag=22  Type=        Rotation velocity  Unit=          rad/s    Descr.=Radian per second
%   iMag=23  Type=                Stiffness  Unit=            N/m    Descr.=Newton per metre
%   iMag=24  Type=                   Strain  Unit=              ?    Descr.=Strain
%   iMag=25  Type=                   Stress  Unit=             Pa    Descr.=Pascal
%   iMag=26  Type=              Temperature  Unit=             ºC    Descr.=Celsius
%   iMag=27  Type=                     Time  Unit=              s    Descr.=Second
%   iMag=28  Type=                 Velocity  Unit=            m/s    Descr.=Metre per second
%   iMag=29  Type=                  Voltage  Unit=              V    Descr.=Volt

