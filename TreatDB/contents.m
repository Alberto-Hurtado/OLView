% TreatDB: Treatment of signals for the ELSA Data Base 
% This a list of some of the available functions (Dec-2006):
%
% For manipulation of structures in general:
%
%    sst         gst    gm       Sets or gets a field value.
%    cell2mat                    Transforms cell to matrix.
%    selst                       Selects structures according to a field value.
%    common      complem         Extracts common or complementary elements 
%                                            between cells.
%
% For manipulation of ELSA DB signal structures:
%
%    getsig      putpp           Reads or writes signals in a DB postprocessing.
%    putdocu                     Introduces documents or files in DB.
%    put_treat                   Introduces signals and files in DB.
%    repsig                      Types a report of the properties of signals.
%    rformst                     Remakes the format (time increment) of a signal
%    physic                      Transforms Volts to physical units.
%    psast                       Response spectrum.
%    fftst                       Fast Fourier Transform.
%    psdfst                      Power spectral density function.
%    frfst                       Frequency response function.
%
% For generation of graphics from signal structures:
%
%    gra                         Multiple-trace graph of signals.
%    mgra                        Matrix of graphs.
%    plotdb                      Interactive graph with direct copy from DB browser
%
% For numeric treatment on MATLAB matrices:
%
%    dericen       Central-Difference derivative.
%    work          Absorbed energy.
%    rmodes        Real modes and poles.
%    cmodes        Complex modes and poles for symmetric matrices.
%    amodes        Complex modes and poles for asymmetric matrices.
%    eqkz          Equivalent linear stiffness and damping to a cycle shape.
%    eqkzhilb      Equivalent linear stiffness and damping by Hilbert's rtransform.
%    sdf4          Cross spectral denssity functions.
%    fhilbt        Fast Hilbert-transform.
%    sdofresp      Single-degree-of-freedom system response to an accelerogram.
%    smooth        Smooths (filters) an evolution with a convolution window.
%    timepole      Poles of a linear system form the time domain response.
%    trigger       Trigger function based on history.
%
% For interfacing with '.si' files (old ELSA format):
%
%    si2st         Reads a '.si' file into a SI structure.
%    st2si         Writes a SI structure into a '.si' file.
%    sist2db       Converts  a SI structure into a Data Base structure.
%


