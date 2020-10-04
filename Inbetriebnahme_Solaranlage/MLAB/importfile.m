function InbetriebnahmeSolaranlagen08 = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  INBETRIEBNAHMESOLARANLAGEN08 = IMPORTFILE(FILENAME) reads data from
%  text file FILENAME for the default selection.  Returns the data as a
%  table.
%
%  INBETRIEBNAHMESOLARANLAGEN08 = IMPORTFILE(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  InbetriebnahmeSolaranlagen08 = importfile("C:\Users\Philipp\Documents\Solarthermie_PT\Inbetriebnahme_Solaranlage\InbetriebnahmeSolaranlagen08.09.2020 15_09_52 1.csv", [26, 879]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 04-Oct-2020 14:27:48

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [26, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 19, "Encoding", "UTF16-LE");

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Scan", "Zeit", "Abgelaufen", "T_RL_KollC", "T_VL_KollC", "T_RL_SpeiC", "T_VL_SpeiC", "Vpkt_Vortex", "T_RL_Koll_drainC", "T_VL_Koll_drainC", "T_RL_Spei_drainC", "T_VL_Spei_drainC", "Vpkt_drain_MIDinlpromin", "p_draininmbar", "T_U_DachC", "T_Spei_obenC", "T_Spei_mitteC", "T_Spei_untenC", "I_KollinWprom2"];
opts.VariableTypes = ["double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Zeit", "Abgelaufen"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Zeit", "Abgelaufen"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["Scan", "T_RL_KollC", "T_VL_KollC", "T_RL_SpeiC", "T_VL_SpeiC", "Vpkt_Vortex", "T_RL_Koll_drainC", "T_VL_Koll_drainC", "T_RL_Spei_drainC", "T_VL_Spei_drainC", "Vpkt_drain_MIDinlpromin", "p_draininmbar", "T_U_DachC", "T_Spei_obenC", "T_Spei_mitteC", "T_Spei_untenC", "I_KollinWprom2"], "DecimalSeparator", ",");

% Import the data
InbetriebnahmeSolaranlagen08 = readtable(filename, opts);

end