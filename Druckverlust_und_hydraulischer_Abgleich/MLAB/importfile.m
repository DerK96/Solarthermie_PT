function Volumenstrom600lh07 = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  VOLUMENSTROM600LH07 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  VOLUMENSTROM600LH07 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  Volumenstrom600lh07 = importfile("C:\Users\Philipp\Desktop\Lena_Solarthermie\Praktika Solarthermie und thermische Messtechnik\Praktika Solarthermie und thermische Messtechnik\Druckverlust_hydraulischer abgleich\DATA\Volumenstrom600l-h_07.09.2020 09_36_04.csv", [17, 85]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 01-Oct-2020 16:01:55

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [17, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 16, "Encoding", "UTF16-LE");

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Scan", "Zeit", "Relativdruck", "Alarm114", "TemperatureC", "Alarm116", "V_Strang_1", "Alarm118", "V_Strang_2", "Alarm119", "V_Strang_3", "Alarm120", "Vpkt_MIDinlproh", "Alarm121", "Differenzdruckinmbar", "Alarm122"];
opts.VariableTypes = ["double", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Zeit", "InputFormat", "dd.MM.yyyy HH:mm:ss");
opts = setvaropts(opts, ["Scan", "Relativdruck", "Alarm114", "TemperatureC", "Alarm116", "V_Strang_1", "Alarm118", "V_Strang_2", "Alarm119", "V_Strang_3", "Alarm120", "Vpkt_MIDinlproh", "Alarm121", "Differenzdruckinmbar", "Alarm122"], "DecimalSeparator", ",");

% Import the data
Volumenstrom600lh07 = readtable(filename, opts);

end