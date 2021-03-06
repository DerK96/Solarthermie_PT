function MeteoMessTeilABSolarstrahlung = importfile1(workbookFile, sheetName, dataLines)
%IMPORTFILE1 Import data from a spreadsheet
%  METEOMESSTEILABSOLARSTRAHLUNG = IMPORTFILE1(FILE) reads data from the
%  first worksheet in the Microsoft Excel spreadsheet file named FILE.
%  Returns the data as a table.
%
%  METEOMESSTEILABSOLARSTRAHLUNG = IMPORTFILE1(FILE, SHEET) reads from
%  the specified worksheet.
%
%  METEOMESSTEILABSOLARSTRAHLUNG = IMPORTFILE1(FILE, SHEET, DATALINES)
%  reads from the specified worksheet for the specified row interval(s).
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  MeteoMessTeilABSolarstrahlung = importfile1("C:\Users\Marvin\Desktop\MM\200909_MeteoMess_Teil A+B_Solarstrahlung.xlsx", "Strahlung01", [20, 660]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 03-Oct-2020 12:51:20

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [20, 660];
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":V" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Scan", "Zeit", "Windgeschwindigkeitinmpros", "Alarm101", "WindrichtunginGrad", "Alarm102", "RelativeFeuchteinV", "Alarm103", "TemperatureC", "Alarm104", "TAGBS", "Alarm107", "ENNOSSSR81", "Alarm109", "CM3", "Alarm111", "CM11", "Alarm112", "CM11Schattenring", "Alarm113", "Niederschlag", "Alarm203"];
opts.SelectedVariableNames = ["Scan", "Zeit", "Windgeschwindigkeitinmpros", "Alarm101", "WindrichtunginGrad", "Alarm102", "RelativeFeuchteinV", "Alarm103", "TemperatureC", "Alarm104", "TAGBS", "Alarm107", "ENNOSSSR81", "Alarm109", "CM3", "Alarm111", "CM11", "Alarm112", "CM11Schattenring", "Alarm113", "Niederschlag", "Alarm203"];
opts.VariableTypes = ["double", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 2, "InputFormat", "");

% Import the data
MeteoMessTeilABSolarstrahlung = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":V" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    MeteoMessTeilABSolarstrahlung = [MeteoMessTeilABSolarstrahlung; tb]; %#ok<AGROW>
end

end