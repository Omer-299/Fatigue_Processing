% V5 - Removes the mean from the temperature segments in the TSA.
clc; clear all; set(groot, 'defaultAxesGridColor', [0.0 0.0 0.0]); set(groot, 'defaultAxesGridAlpha', 0.7); set(groot, 'defaultAxesLineWidth', 1); set(groot, 'defaultAxesBox', 'on');
close all;
%% Input parameters
% Averaging window size
windowTSA = 5;
windowDissipation = windowTSA;  BW = 1; % bandwidth [Hz]
movmeanFactor = 1;    % theta = movmean(theta, movmeanFactor);

%%
% Force
LF = 20; SF_F = 2000; % Loading an loading sampling frequency in Hz
Force_idxS = 33474; %4197; %3900; %33407; %33451; %33481; %33491; %33447; %33428; %33462; % 33474; %33158; %9486; %17788; %10290; %10290;%9486; %31456; %17788; %16018; %19580; % %33954;  % value to be adjusted after reviewing 'Clean' force vs Index. Start point of proper loading - count the selected Fhigh (peak) from the start of the cyclic loading, and select the T0D trough accordingly.
Force_idxE = 719219; %226076; %224923; %177368; %177666; %385341; %385043; %719259; %719643; %719471; %719219; %726407; %719219; %374480; %374398; %154639; %726265; %154639; %374480; %726393; %374398; %726265;%726290; % %726975; % of Clean force % End index for force (last peak point) - To be found through force plot of 'clean force'. Clean force is the one which is plotted after removing the 'time' vector's duplicate values.
minFthresh = 0.02;
% For Force through linear fitting
dFmax_programmed = 0;

% theta
SF = 353; % Sampling frequency for thermal data (should be Verfied from the time_diff)

% Start index from T_noOffset (select the low peak in accordance to the count of Fhigh selected in Force_idxS) - To be found through T_noOffset plot.
temp_idxS = 8760; %5777; %4605; %7784; %10849; %7489; %7656; %7589; %25346; %7479; %8760; %19315; %30631; %10159; %18175; %18175; %18191;%30631; %9612; %10159; %8661;%13675+2; % %19156;%%5932 ; %8763; 

% End index from T_noOffset (last low peak) - To be found through T_noOffset plot.
temp_idxE = 129796; %84101; %82627; %33192; %36299; %69592; %69706; %128631; %146463; %128561; %129796; %140550; %94822; %72905; %43350;%43350; %94822; %131826; %72905; %133533;%137981; % %141019;% %129796; 

BeforeLoad_IdxEnd = 3562; % For spectral analysis of IR data (temperature data) in the no-load region of the test
% noLoad_IdxEnd = This index from the raw experimental temperature data before the cold-working step

% Ti indices: Stabilized T_noOffset used to calculate the specimen temperature before the loading starts.
Ti_idxS = 8388;         Ti_idxE = 8530;  %Ti = mean(T_noOffset(Ti_idxS : Ti_idxE));

%% SS316L 2026 tests
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1415_VIRG_Test-1_Take-1\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1431_VIRG_Test-1_Take-2\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1535_VALIR_PT_Test-1_Take-1\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1557_VALIR_PT_Test-1_Take-2\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1622_VALIR_PT_Test-2_Take-1\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1634_VALIR_PT_Test-2_Take-2\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260116\SS316L_260116_1035_VALIR_PT_Test-3_Take-1\Test1';

%% SS304 2026
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20260112\SS304L_20260112_1607_Virgin1_VLAIR_Test-1_take-0\Test1'; % Thermal data is not correct
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20260114\SS304L_20260114_1157_VIRG_VLAIR_Test-1_take-1\Test1';

%% SS304 2025 tests
     % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-3_Take-3\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-3_Take-2\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-14\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-13\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-12\Test1';
        folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-11\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-10\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-9\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-8\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-7\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-5\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-4\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-3\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-2\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251117\20251117 SS304-Test-1-Take-3\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251117\20251117 SS304-Test-1-Take-2\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_BL_Test-2_Take-1\Test1'; 
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_BL_Test-1_Take-2\Test1';
        % folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_BL_Test-1_Take-1\Test1';

% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-3_Take-3\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-3_Take-2\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-14\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-13\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-12\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\2025\20251118\20251118_SS304_Test-2_Take-11\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-10\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-9\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-8\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-7\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-5\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-4\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-3\Test1';
% folderPath = ['C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-2\Test1'];
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_BL_Test-2_Take-1\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_BL_Test-1_Take-2\Test1';
% folderPath = ['C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_BL_Test-1_Take-1\Test1'];
% folderPath = ['C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251117\20251117 SS304-Test-1-Take-3\Test1'];
% folderPath = ['C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251117\20251117 SS304-Test-1-Take-2\Test1'];
% folderPath = ['C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-3_Take-3\Test1'];

%%
cd(folderPath);
source_dir = pwd;
%% Material properties
% ###################
% -- SS304
% ###################
% % Gage zone dimensions SS304L and SS316L
thick_my = 1/1000;     width_my = 15/1000;    % Thickness 1mm for SS304 specimen    % Width 15mm for SS304 specimen

% rho = 8000;     C = 500;    alpha = 17.3e-6;    tau = 72; %(68+76)/2; for SS304L
% rho = 8000;     C = 500;    tau = 82.5; %(90+75)/2; for SS316L - material properties are almos same as SS304L

% % SS304: Density (kg/m^3): 8000; Specific heat (J/kg-K): 500; Linear Coefficient of Thermal Expansion (1/K): 17.3e-6 1/K;
% % Reference: https://www.matweb.com/search/DataSheet.aspx?MatGUID=edb229c36fc849628289705c796c4d89
% % Thermal time constant in seconds - see the graphs of Tau estimation: SS304\A_TAU_MEASUREMENT\Return_to_ambiant_1 and Return_to_ambiant_2, with 68 and 76 seconds respectively.
% Km = alpha / (rho * C);
xarea = thick_my * width_my; % Cross-sectional area in m^2

% -------- Material identification from folder name --------
folderName = lower(folderPath);   % case-insensitive comparison

% -------- Material-specific assignment --------
if contains(folderName, 'ss304','IgnoreCase', true)
    % SS 304L
    materialStr = 'SS304L';
    % Load tau(theta) lookup table
    % load('C:/Users/mo170/OneDrive - The University of Waikato/PhD/Experiments/PostProcessing/Fatigue_Processing/tau_table_SS316.mat');      % contains tau_table
    tau = 72;          % s  (mean of 68–76 s)

    rho   = 8000;          % kg/m^3
    C     = 500;           % J/(kg·K)
    alpha = 17.3e-6;       % 1/K (austenitic stainless steel)

elseif contains(folderName, 'ss316','IgnoreCase', true)
    % SS 316L
    materialStr = 'SS316L';
    % load('C:/Users/mo170/OneDrive - The University of Waikato/PhD/Experiments/PostProcessing/Fatigue_Processing/tau_table_SS316.mat');      % contains tau_table
    % tau = 79;        % s  (mean of 75–90 s)
    % tau = 60;
    rho   = 8000;          % kg/m^3 % Same as SS304L
    C     = 500;           % J/(kg·K) % Same as SS304L
    alpha = 16.5e-6;       % 1/K (austenitic stainless steel) % Same as SS304L

else
    error('Material grade not recognised in folderPath: SS304 or SS316 not found.');
end


%% Test name extraction with data
% ---- Extract date (yyyymmdd) ----
dateTok = regexp(folderPath, '(20\d{6})', 'tokens');  % find 8-digit year-first date

if ~isempty(dateTok)
    dateStr = dateTok{1}{1};    % first date found
else
    dateStr = 'UnknownDate';
end

% ---- Extract Test and Take ----
tokens = regexp(folderPath, '(Test[-_ ]?\d+).*?(Take[-_ ]?\d+)', ...
    'tokens', 'ignorecase');

if ~isempty(tokens)
    parts = tokens{1};

    % Remove '-', '_', and ' ' → produce e.g. "Test1" and "Take2"
    cleanTest = regexprep(parts{1}, '[-_ ]', '');
    cleanTake = regexprep(parts{2}, '[-_ ]', '');

    % ---- Final testName (NO underscores) ----
    test_details = sprintf('%s %s %s %s', materialStr , dateStr, cleanTest, cleanTake);

else
    test_details = sprintf('%s UnknownTest', dateStr);
end


%% Load mechanical data
fileName = 'Test1.steps.tracking.csv';
fileWithPath = fullfile(folderPath, fileName);  % Combines path and filename safely

data = readmatrix(fileWithPath);
data = round(data,9);
tF = data(1:end,1);
tF = tF(:);
force = data(1:end,8)*1000; % Convert load from kN to N
force = force(:);


% for the Frane experimental data
% load F1F2.mat;
% load tF1F2.mat;
% Force_idxS = 1;
% Force_idxE = length(F1F2);
%
% force = F1F2;
% tF = tF1F2;
%


fprintf('\nFirst time in mechanical data: %0.5fs. This time is subtracted to start from zero\n', tF(1));

tF = tF - tF(1); % Start time at zero

% Force vs index (raw force data)
figure('Name', 'Raw data: Force vs. Index');
plot(force,'-k');
title(['Raw data: Force vs. Index - ', test_details]);
legend('raw force data','Location', 'northwest');
xlabel('Index'); ylabel('Force (N)')
grid on


% Force vs time (raw force data)
figure('Name', 'Raw data: Force vs. Time');
plot(tF,force,'-k');
title(['Raw data: Force vs. Time - ', test_details]);
legend('raw force data','Location', 'northwest');
xlabel('Time (s)'); ylabel('Force (N)')
grid on

% Position plot
% position = data(1:end,7); %
% position = position  - position(1);
%
% % Separating high and low peaks
% pos_minProminence = 0.00005 * max(position); % Minimum peak prominence
% [pos_highs, pos_locs_highs] = findpeaks(position, 'MinPeakProminence', pos_minProminence);
% pos_Time_highs = tF(pos_locs_highs);
%
% [pos_lows, pos_locs_lows] = findpeaks(-position, 'MinPeakProminence', pos_minProminence);
% pos_Time_lows = tF(pos_locs_lows);
% pos_lows = -pos_lows;
%
%
% figure('Name', 'Raw data: Position vs. Force');
% plot(force, position);
% title(['Raw data: Position vs. Force - ', test_details]);
% legend('raw force data','Location', 'northwest');
% xlabel('Force (N)'); ylabel('Position (mm)');
% grid on
%
% % --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));
%
% % plot Fhighs and Flows
% figure('Name', 'Raw data: Position vs. Time');
% plot(pos_Time_highs,pos_highs, '.r',MarkerSize=10);
% title(['Raw data: Position vs. Time - ', test_details]);
% hold on
% plot(pos_Time_lows, pos_lows, '.b',MarkerSize=10)
% plot(tF,position,'-k', LineWidth=0.5)
% grid on
% legend ('Pos-max','Pos-min', 'location','northwest')
% xlabel('Time (s)')
% ylabel('Position (mm)')

% --- Checking for any issues with time data
tF_diff = [nan;round(diff(tF),9)];

% Determining the sampling frequency of force data by fatigue testing machine (Instron)
mode_tF_diff =  mode(tF_diff);
SF_Fx = round(1/mode_tF_diff, 9); % Sampling Frequency of Force data
% Check sampling frequency consistency
tol = 1e-3;  % 0.001 Hz

if abs(SF_Fx - SF_F) > tol
    error('SamplingFrequencyMismatch:InconsistentValues', ...
          ['Sampling frequencies do not match within tolerance.\n' ...
           '   SF_Fx (Experiment) = %.4f Hz\n' ...
           '   SF_F  (Record)     = %.4f Hz\n' ...
           '   Difference         = %.4f Hz (Tolerance = %.3f Hz)'], ...
           SF_Fx, SF_F, abs(SF_Fx - SF_F), tol);
end

%% --------- Cleaning time vector of force
% Removing time values which are repeated consecutively
% Logical index of consecutive repeats
repIdx = (diff(tF) == 0);

% Convert to indices of the repeated elements (second of each pair)
removeIdx = find(repIdx) + 1;

% Remove the repeated entries
tF_clean = tF;
tF_clean(removeIdx) = [];
force_clean = force;
force_clean(removeIdx) = [];

% Display results
figure('Name', 'diff(tF clean)');
plot(diff(tF),'--r');
title('diff(tF clean)',test_details)
hold on; plot(diff(tF_clean),'.b');
xlabel('Index'); ylabel('diff (force time) (s)');
grid on
legend('diff(tF)', 'diff(tF clean)')

figure('Name', 'tF orginal vs tF clean');
plot(tF, '-k')
title('tF orginal vs tF clean')
hold on;
plot(tF_clean,'.b')
legend ('tF','tF clean','Location','best')
grid on

% Clean Force vs index
figure('Name', 'Clean force vs Index');
plot(force_clean,'-k');
title(sprintf('Clean force vs Index - %s',test_details))
legend('Clean force data','Location', 'northwest');
xlabel('Index'); ylabel('Force (N)')
grid on
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% % Clean Force vs clean time
figure('Name', 'Clean force vs Time');
plot(tF_clean,force_clean,'-k');
title(sprintf('Clean force vs Time - %s',test_details))
legend('Clean force data','Location', 'northwest');
xlabel('Time (s)'); ylabel('Force (N)')
grid on
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

tF = tF_clean;
force = force_clean;

%% ----- Extracting fatigue loading period and Loading frequency calculation from experimental data
F_fatigue = force(Force_idxS:Force_idxE); % Only selecting the force data relevant to fatigue loading, excluding the hardening loading
tF_fatigue = tF(Force_idxS:Force_idxE); % Only selecting the force data relevant to fatigue loading, excluding the hardening period
% tF_fatigue = tF_fatigue - tF_fatigue(1); % Starting time from zero

figure('Name', 'Fatigue force vs time')
plot(tF_fatigue,F_fatigue)
title(sprintf('Fatigue force vs Time - %s',test_details))
xlabel('Time (s)'); ylabel('Force (N)')
grid on
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% Separating high and low peaks
minProminence = minFthresh * max(F_fatigue); % Minimum peak prominence
[Fpk, locs_highs] = findpeaks(F_fatigue, 'MinPeakProminence', minProminence);
time_Fhighs = tF_fatigue(locs_highs);

LF_exp = 1 / mode(round(diff(time_Fhighs),9));
disp(['Loading Frequency as per experimental data: ', num2str(LF_exp),'Hz']);

checkLF = 0.7;
if abs(LF_exp - LF) > checkLF
    disp(['|FS-force-data - (FL)| > ', num2str(checkLF)]);  % Display mod of cycles before error
    error('Please check Loading Frequency input value');
    % else
    %     LF = round(LF_exp,6); % Fixed time step for mechanical data
end


%% ------ Loading frequency analysis from the force data

Loading = F_fatigue; %(Force_idxS:Force_idxE);
N_Loading = length(Loading);

N_LoadingTrunc = N_Loading; % Finding the maximum length of force data which has integer number of cycles
while mod(N_LoadingTrunc, SF_F/LF) >= 1e-9
    N_LoadingTrunc = N_LoadingTrunc -1;
end

Ndiff = N_Loading - N_LoadingTrunc;
LoadingIdx = (Ndiff + 1):N_Loading;

Loading = Loading(LoadingIdx);

fLoading = (0:floor(N_LoadingTrunc/2)) * (SF_F / N_LoadingTrunc);

% FFT computation
P1Loading = abs(fft(Loading)) * (2/N_LoadingTrunc);
P1Loading = P1Loading(1 : floor(N_LoadingTrunc/2)+1);
P1Loading(1) = NaN; % Remove DC component

figure('Name', 'Force Amplitude Spectrum');
% plot(fLoading, log(P1Loading), '.r', 'MarkerSize', 5, DisplayName='Loading'); hold on;
plot(fLoading, log(P1Loading), '.r', 'MarkerSize', 5, DisplayName='Loading'); hold on;
title(sprintf('Loading Amplitude Spectrum - %s', test_details)); % (DC Removed)
xlabel('Frequency (Hz)');
xticks (0:LF:max(fLoading))
ylabel('Log Amplitude (N)');
grid on;
legend

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% Load thermal data
load THERMAL_data.mat;
IRtime = IRtime(:);

%
fprintf('\nFirst time in thermal data: %0.5fs. This time is subtracted to start from zero\n', IRtime(1));

% figure('Name', 'Raw T0D vs Raw IR time');
% plot(IRtime,T0D,'-k')
% title('Raw T0D vs Raw IR time')
% hold on; plot(IRtime,T0D,'.r', MarkerSize=5)
% grid on
% xlabel('Time(s)')
% ylabel('Temperature (K)')

IRtime = IRtime - IRtime(1); % Start time at zero

T0D = T_0D(:);
T_ref_up = T_ref_up(:);
T_ref_bottom = T_ref_bottom(:);

% === CALCULATE TEMPORAL NOISE ===
mean_T = mean(T0D(1:1000));
std_T = std(T0D(1:1000));  % Standard deviation with N-1 normalization

% === OUTPUT ===
% fprintf('Mean Temperature = %.4f C\n', mean_T);
% fprintf('Temporal Noise (STD) = %.4f C\n', std_T);


SF_exp = 1 / mode(round(diff(IRtime),9));
disp(['IR camera Sampling Frequency as per experimental data: ', num2str(SF_exp),'Hz']);

checkSF = 0.108;
if abs(SF_exp - SF) > checkSF
    disp(['|SF Experimental - SF| > ', num2str(checkSF)]);  % Display mod of cycles before error
    abs(SF_exp - SF)
    error('Please check Sampling Frequency input value');
    % else
    %     SF = SF_exp;
end

%% --- Repair IR Time vector segment-wise  ---
% This is not a proper repair. There are instances of dropped frames or
% multiple erratic values consecutively, these kind of errors are not
% addressed by this repair.
% close all
N = length(IRtime);
IRtime_ok = IRtime;          % start with a copy

if N < 2
    return;
end

% Find where the sequence decreases or stays the same
diffs = diff(IRtime);
% bad = (diffs <= 0);
bad = (diffs <= 0) | (diffs > 1.01 * 1/SF);

% Find start and end indices of every bad segment
% Padding with false at both ends to make edge detection easy
bad_padded = [false; bad; false];
starts = find(diff(bad_padded) == 1)+1; % - 1;   % first bad index in each run
ends = find(diff(bad_padded) == -1)-1; % + 1; % last bad index in each run

for k = 1:length(starts)
    seg_start = starts(k);      % index where decrease begins (1-based)
    seg_end = ends(k);        % last bad index in this run

    % The segment that needs fixing is from seg_start to seg_end (inclusive)
    % We interpolate using the last good point before seg_start
    % and the first good point after seg_end

    left_idx = seg_start - 1;                 % last good point before problem
    right_idx = seg_end + 1;                   % first good point after problem

    % --- Edge cases ---
    if left_idx < 1
        % Problem starts at the very beginning - forward extrapolate
        first_good_diff = diffs(find(~bad,1,'first'));
        t0 = IRtime(right_idx);
        IRtime_ok(1:right_idx) = t0 - first_good_diff*(right_idx:-1:0)';
        continue;
    end

    if right_idx > N
        % Problem goes to the very end - backward extrapolate
        last_good_diff = diffs(find(~bad,1,'last'));
        t0 = IRtime(left_idx);
        IRtime_ok(left_idx:end) = t0 + last_good_diff*(1:(N-left_idx+1))';
        continue;
    end

    % --- Normal case: interpolate between left_idx and right_idx ---
    t_left = IRtime_ok(left_idx);
    t_right = IRtime_ok(right_idx);

    % Number of points from left_idx to right_idx inclusive
    n_points = right_idx - left_idx + 1;
    % n_points = round(abs(t_right - t_left)*SF);
    new_times = linspace(t_left, t_right, n_points);

    IRtime_ok(left_idx:right_idx) = new_times';
end

% IR time plots
figure('Name', 'IR time');
plot(IRtime, '-k', LineWidth=0.5);
title('IR time',test_details)
hold on; plot(IRtime, '.k', markersize=5);
hold on; plot(IRtime_ok, 'or', markersize=05);
legend('IRtime original','' ,'IRtime corrected','Location', 'northwest');
xlabel('Index'); ylabel('Time (s)')
grid on


figure('Name', 'diff (tTemp)');
plot(diff(IRtime), '-k', LineWidth=2);
title('diff (tTemp)',test_details)
hold on;
plot(diff(IRtime), '.k', markersize=5);
plot(diff(IRtime_ok), 'or', LineWidth=0.5);
legend('diff (IRtime)','','diff (IRtime corrected)','Location', 'northwest');
xlabel('Index'); ylabel('diff (tTemp)  (s)')
grid on

%% Temperature offset removal

T_ref = 0.5 * (T_ref_up + T_ref_bottom); % Average reference temperature
T_noOffset = T0D - T_ref; % Remove reference temperature offset

% === CALCULATE TEMPORAL NOISE ===
mean_TnoOffset = mean(T_noOffset(1:1000));
std_TnoOffset = std(T_noOffset(1:1000));  % Standard deviation with N-1 normalization

% === OUTPUT ===
% fprintf('Mean Temperature (T no offset) = %.4f K\n', mean_TnoOffset);
% fprintf('Temporal Noise (STD) (T no offset) = %.4f K\n', std_TnoOffset);


% thermal display --- Experimental temperature vs Index
figure('Name','Experimental Temperature Data vs Index');
plot(T0D, '-r');
title(sprintf('Experimental Temperature Data vs Index - %s',test_details))
hold on
plot(T_ref_up,'-b');
plot(T_ref_bottom,'-g');
xlabel('Index');
ylabel('Temperature (K)')
legend('T0D','Tref up', 'Tref bottom', 'Location', 'northwest');
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ------------Experimental temperature data vs time
figure('Name','Experimental Temperature Data vs Time');
plot(IRtime_ok,T0D,'-r');
title(sprintf('Experimental Temperature Data vs Time - %s',test_details))
hold on
plot(IRtime_ok,T_ref_up,'-b');
plot(IRtime_ok,T_ref_bottom,'-g');
xlabel('Time (s)');
ylabel('Temperature (K)')
legend('T0D','Tref up', 'Tref bottom', 'Location', 'northwest');
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ----------- Plotting without offset
figure('Name','T without offset vs Index');
title('T without offset',test_details)
plot(T_noOffset,'-k');
xlabel('Index');
ylabel('Temperature (K)')
legend('T no offset', 'Location', 'northwest');
grid on

figure('Name','T without offset vs time');
title('T without offset',test_details)
plot(IRtime_ok, T_noOffset,'-k');
xlabel('Time (s)');
ylabel('Temperature (K)')
legend('T no offset', 'Location', 'northwest');
grid on


%% T_noOffset_fatigue
% Selecting the temperature data relevant for the fatigue loading. Start
% and End Index to found by observing the raw temperature (T0D) and force
% plots

tTheta = IRtime_ok(temp_idxS:temp_idxE);

dt = tTheta(1) - tF_fatigue(1);
if dt > 0
    tF_fatigue = tF_fatigue + dt;
elseif dt < 0
    tTheta = tTheta - dt;
end

% tTheta = tTheta - tTheta(1); % starting time from 0.

figure('Name','IR and Force time vectors during fatigue loading');
plot(tTheta,'-r');
title('IR and Force time vectors during fatigue loading',test_details)
hold on; plot(tF_fatigue, '--b')
grid on
legend ('IR time','Force time')

T_noOffset_fatigue = T_noOffset(temp_idxS:temp_idxE);
T0D_fatigue = T0D(temp_idxS:temp_idxE);
T_ref_up_fatigue = T_ref_up(temp_idxS:temp_idxE);
T_ref_bottom_fatigue = T_ref_bottom(temp_idxS:temp_idxE);

%% Basic correction of T_noOffset_fatigue
% In this correction only those instances are corrected which have a single
% erratic value in betwrrn two proper values. This correction does not
% address the dropped frames and multiple consecutive erratic values.
% --- Initialisation ---
X = T_noOffset_fatigue(:);     % ensure column vector
X_clean = X;

% --- First difference ---
DiffTheta = diff(X);
N = numel(DiffTheta);

% --- Expected linear envelopes ---
UpLine  = linspace( 0.007,  0.12, N)';
BotLine = linspace(-0.007, -0.12, N)';

% --- Visualisation ---
figure('Name','Diff TnoOffset Fatigue')
plot(DiffTheta,'k'); hold on; grid on
plot(UpLine,'r','LineWidth',2)
plot(BotLine,'r','LineWidth',2)
title('Diff TnoOffset fatigue - without correction')
xlabel('Index'); ylabel('[K]')

% --- Residuals ---
gama1 = DiffTheta - UpLine;
gama2 = DiffTheta - BotLine;

threshold = 0.01;

% --- Candidate spikes ---
candidate1 = gama1 >  threshold;
candidate2 = gama2 < -threshold;

% --- Keep only isolated exceedances ---
isolated1 = candidate1 & ...
           ~[false; candidate1(1:end-1)] & ...
           ~[candidate1(2:end); false];

isolated2 = candidate2 & ...
           ~[false; candidate2(1:end-1)] & ...
           ~[candidate2(2:end); false];

idxY1 = find(isolated1);
idxY2 = find(isolated2);

% --- Remove idxY2 within ±1 of idxY1 ---
if ~isempty(idxY1) && ~isempty(idxY2)
    D = abs(idxY2 - idxY1');
    idxY2 = idxY2(~any(D <= 1,2));
end

% --- Combine all spike indices ---
idxY = sort([idxY1; idxY2]);

% --- Map diff index → original index ---
idxX = idxY;    % initialise

for n = 1:numel(idxY)

    i = idxY(n);

    % Boundary protection
    if i <= 1
        idxX(n) = i + 1;
        continue
    elseif i >= N
        idxX(n) = i;
        continue
    end

    % Compare forward/backward residual magnitude
    forward_mag = abs(DiffTheta(i+1) - DiffTheta(i));
    backward_mag = abs(DiffTheta(i) - DiffTheta(i-1));

    if forward_mag > backward_mag
        idxX(n) = i + 1;
    else
        idxX(n) = i;
    end
end

% --- Remove duplicates (important) ---
idxX = unique(idxX);

% --- Replace corrupted samples ---
validMask = idxX > 1 & idxX < numel(X);
idxX = idxX(validMask);

X_clean(idxX) = 0.5 * (X(idxX-1) + X(idxX+1));

% --- Final plots ---
figure('Name','Cleaned T-no-offset')
plot(X,'k'); hold on; grid on
plot(X_clean,'--r')
title('Cleaned T-no-offset')
legend('Original','Cleaned')


figure('Name','Difference: Original - Cleaned')
plot(X - X_clean); grid on
title('T-noOffset - T-noOffset-clean')


%%
T_noOffset_fatigue = X_clean;

%% Calculatin of theta and plotting
% T0D_fatigue = T0D (temp_idxS:temp_idxE);
% % Experimental temperature data (fatigue period) vs time
% figure
% plot(tTheta,T0D_fatigue,'-k');
% title('Experimental Temperature Data',test_details)
% xlabel('Time (s)');
% ylabel('Temperature (K)')
% hold on
% yyaxis right
% plot(tTheta,T_noOffset_fatigue,'-g');
% ylabel('Temperature (K)')
% legend('T0D','T no Offset','Location', 'northwest');
% grid on

% ##############################
% ##############################
Ti = mean(T_noOffset(Ti_idxS : Ti_idxE));
theta = T_noOffset_fatigue - Ti;
theta = theta(:);

% === CALCULATE TEMPORAL NOISE ===
% mean_theta = mean(theta(1:500));
% std_theta = std(theta(1:500));  % Standard deviation with N-1 normalization

% === OUTPUT ===
% fprintf('Mean theta = %.4f K\n', mean_theta);
% fprintf('Temporal Noise (STD)(theta) = %.4f K\n', std_theta);

% theta display --- theta vs index
figure('Name','theta vs index')
plot(theta)
title(sprintf('theta %s',test_details))
xlabel('Index');
ylabel('\theta (K)')
legend('\theta','Location', 'northwest');
grid on
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% theta display --- theta vs time
% theta(1) = NaN;
% theta(2) = 0;
figure('Name','theta vs time')
plot(tTheta, theta,'r',LineWidth=2)
% hold on; xline(24.8, '--r',LineWidth=4)
title(sprintf('theta %s',test_details))
xlabel('Time (s)');
ylabel('\theta (K)')
% legend('\theta','Location', 'northwest');
grid on
set(gcf,'MenuBar','figure','ToolBar','figure');
set(gcf,'Position',[600 200 580 450])


% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%%
% ############### Segmentation of time vector based on violation of
% delta(time) from 1/SF +/- tolerance
% This part address the dropped frames errors in the time vector
% ###################################

% tTheta = IRtime(temp_idxS:temp_idxE);
% fprintf('Total fatigue duration from IRtime (not corrected): %.6f s\n', tTheta(end) - tTheta(1));
% tTheta = tTheta(:);
% tTheta = tTheta - tTheta(1);
% % N = length(tTheta);
%
% dt0 = 1/353;
% tol = 0.0011 * dt0;
%
% dT = diff(tTheta);
%
% % Valid step logical mask
% valid_step = abs(dT - dt0) <= tol;
%
% % Preallocate large NaN matrices
% maxRows = 1e6;      % adjust if needed
% maxSegs = 500;      % maximum expected number of segments
%
% TimeMat  = NaN(maxRows, maxSegs);
% IndexMat = NaN(maxRows, maxSegs);
%
% seg_count = 0;
% i = 1;
%
% while i <= length(valid_step)
%
%     if valid_step(i)
%
%         seg_count = seg_count + 1;
%         row_count = 1;
%
%         start_idx = i;
%
%         % First point of segment
%         TimeMat(row_count, seg_count)  = tTheta(start_idx);
%         IndexMat(row_count, seg_count) = start_idx;
%
%         % Extend segment
%         while i <= length(valid_step) && valid_step(i)
%
%             row_count = row_count + 1;
%
%             TimeMat(row_count, seg_count)  = tTheta(i+1);
%             IndexMat(row_count, seg_count) = i+1;
%
%             i = i + 1;
%         end
%
%     else
%         i = i + 1;
%     end
%
% end
%
% % Trim unused rows and columns
% TimeMat  = TimeMat(~all(isnan(TimeMat),2),  1:seg_count);
% IndexMat = IndexMat(~all(isnan(IndexMat),2),1:seg_count);
%
%
% figure ('Name','Constant delta(t) Segments')
% hold on
% grid on
%
% nSeg = size(TimeMat,2);
%
% for k = 1:nSeg
%
%     idx = ~isnan(TimeMat(:,k));
%
%     plot(IndexMat(idx,k), ...
%         TimeMat(idx,k), ...
%         'LineWidth', 1.2)
% end
%
% xlabel('Original Index')
% ylabel('Time (s)')
% title('Constant \Deltat Segments (1/353 s)')
%
%
% % ##########################
% % Filling up the erratic and missing time stamps with correct values
% % ##########################
%
% % segLengths = sum(~isnan(TimeMat));
% nSeg = size(TimeMat,2);
%
% ThetaTime_corrected = [];
% InsertedIndices_global = [];
%
% for k = 1:nSeg
%
%     % Extract valid rows of current segment
%     idx_valid = ~isnan(TimeMat(:,k));
%     t_seg     = TimeMat(idx_valid,k);
%     idx_seg   = IndexMat(idx_valid,k);
%
%     % Append current segment
%     ThetaTime_corrected = [ThetaTime_corrected; t_seg];
%
%     % If not last segment → reconstruct gap
%     if k < nSeg
%
%         t_end   = t_seg(end);
%         idx_end = idx_seg(end);
%
%         t_start  = TimeMat(1,k+1);
%
%         % -------------------------------
%         % Monotonicity Check
%         % -------------------------------
%         if t_start <= t_end
%             error(['Time reversal detected between segment %d and %d.\n' ...
%                 'Segment %d end time = %.12f\n' ...
%                 'Segment %d start time = %.12f'], ...
%                 k, k+1, k, t_end, k+1, t_start);
%         end
%
%
%         gap = t_start - t_end;
%
%         Nideal = gap * SF;
%         Nadd   = round(Nideal) - 1;
%
%         if Nadd > 0
%
%             dt_rec = gap / (Nadd + 1);
%
%             if abs(dt_rec - dt0) <= tol
%
%                 newTime = t_end + dt_rec*(1:Nadd)';
%
%                 ThetaTime_corrected = ...
%                     [ThetaTime_corrected; newTime];
%
%                 newInserted = ( ...
%                     length(ThetaTime_corrected)-Nadd+1 : ...
%                     length(ThetaTime_corrected) )';
%
%                 InsertedIndices_global = ...
%                     [InsertedIndices_global; newInserted];
%             else
%                 warning('Gap between segment %d and %d exceeds tolerance.',k,k+1)
%             end
%         end
%     end
% end
%
% fprintf('Total duration with corrected time = %.4f s\n', (ThetaTime_corrected(end) - ThetaTime_corrected(1)))
%
% figure('Name','t-Theta Corrected')
% plot(ThetaTime_corrected)
% grid on
% xlabel('Corrected Sample Index')
% ylabel('Time (s)')
% title('Globally Corrected ThetaTime')
%
% dT_corr = diff(ThetaTime_corrected);
%
% figure ('Name','diff t-Theta-corrected');
% plot(dT_corr); grid
% title('diff time-theta-corrected');
% ylabel('\Delta t (s)')
% xlabel('Index')
%
% fprintf('Mean dt  = %.12f\n', mean(dT_corr))
% fprintf('Std dt   = %.12e\n', std(dT_corr))
% fprintf('Max dev  = %.12e\n', max(abs(dT_corr - dt0)))
%
% tTheta = ThetaTime_corrected;

%%
% ########### Correction of the theta - This correction addresses the
% dropped frames issue. It is dependent on the dropped frames correction of
% time vector.

% Segmentation of theta - Expansion of theta - Linearised filling of missing values

% (1) Remove theta values corresponding to eliminated time indices,
% (2) Insert new indices introduced during time vector correction,
% (3) Assign NaN values at those inserted positions to preserve alignment,
% (4) Replace the NaN entries using interpolation to reconstruct the
%     missing cyclic temperature data while maintaining temporal continuity.
% #########################

% nSeg = size(IndexMat,2);
%
% % Preallocate matrix (same size as TimeMat)
% ThetaMat = NaN(size(IndexMat));
%
% for k = 1:nSeg
%
%     idx = IndexMat(:,k);
%     valid = ~isnan(idx);
%
%     ThetaMat(valid,k) = theta(idx(valid));
%     % ThetaMat contains only the valid (physically consistent) theta samples,
%     % with all erratic or corrupted indices removed. In other words, theta has
%     % been segmented according to the validated time indices, preserving only
%     % the reliable portions of the signal.
%
% end
%
% figure ('Name','Segmented theta plot')
% hold on
% grid on
%
% for k = 1:nSeg
%
%     idx = ~isnan(ThetaMat(:,k));
%
%     plot(IndexMat(idx,k), ...
%         ThetaMat(idx,k), ...
%         'LineWidth', 1.2)
% end
%
% xlabel('Original Index')
% ylabel('\theta')
% title('\theta Segments Corresponding to Valid Time Blocks')
%
%
% % ----- Insertion of new indices with NaN as value
% thetaClean = ThetaMat(:);        % Column-wise stacking
% thetaClean = thetaClean(~isnan(thetaClean));
% N_thetaClean = length(thetaClean);
% % Norig = nnz(~isnan(ThetaMat)); %nnz = Number of nonzero matrix elements
%
% InsertedIndices_global = InsertedIndices_global(:);
% Nins  = length(InsertedIndices_global);
%
% Ncorr = N_thetaClean + Nins;
%
% % Preallocate expanded theta
% theta_NaN = NaN(Ncorr,1);
%
% % Logical mask of inserted positions
% insertMask = false(Ncorr,1);
% insertMask(InsertedIndices_global) = true;
%
% % Positions corresponding to original samples
% origPositions = find(~insertMask);
%
% % Sanity check
% if length(origPositions) ~= N_thetaClean
%     error('Dimension mismatch during theta expansion.')
% end
%
% % Insert original values
% theta_NaN(origPositions) = thetaClean;
%
% % Diagnostics
% fprintf('Original samples : %d\n', N_thetaClean)
% fprintf('Inserted NaNs    : %d\n', Nins)
% fprintf('Final length     : %d\n', Ncorr)
%
% figure('Name','Theta NaN');
% plot(theta_NaN); grid;
% title('Theta expanded')
%
% % filling the NaN values with linear interpolation
% theta_filled = fillmissing(theta_NaN, ...
%                                   'linear', ...
%                                   'SamplePoints', ...
%                                   ThetaTime_corrected);
%
% % ---------------------------------------------
% % STEP 3: Validation
% % ---------------------------------------------
%
% assert(~any(isnan(theta_filled)), ...
%     'Interpolation failed: NaNs remain.')
%
% assert(length(theta_filled) == Ncorr, ...
%     'Length mismatch after interpolation.')
%
% % ---------------------------------------------
% % STEP 4: Diagnostics
% % ---------------------------------------------
%
% fprintf('Original samples   : %d\n', N_thetaClean)
% fprintf('Inserted samples   : %d\n', Nins)
% fprintf('Final sample count : %d\n', Ncorr)

%% Check for time duration match/mismatch

theta_time_duration = tTheta(end) - tTheta(1)
Force_time_duration = tF_fatigue(end) - tF_fatigue(1)
time_diff = abs(Force_time_duration - theta_time_duration)

checkTimeDuration = 0.01;
% if time_diff > checkTimeDuration
%     error('Time mismatch: %.6g s > %.6g s.', time_diff, checkTimeDuration);
% end

figure('Name','Fatigue load and theta in one plot')
plot(tF_fatigue, F_fatigue)
ylabel('Force (N)')
hold on
yyaxis right
plot(tTheta, theta)
ylabel('\theta (K)')
xlabel('Time (s)')
title('Fatigue loading and theta in one plot')
grid on

%% Calculating slope of high and low forces for the Stress amplitude calculation
% Robust linear regression
minProminence = minFthresh * max(F_fatigue); % Minimum peak prominence

[Fpk, Fpk_loc] = findpeaks(F_fatigue,'MinPeakProminence', minProminence);         % local maxima
[Ftr_raw, Ftr_loc] = findpeaks(-F_fatigue,'MinPeakProminence', minProminence);    % raw minima (troughs)
Ftr = -Ftr_raw;

Time_highs = tF_fatigue(Fpk_loc); %
Time_lows = tF_fatigue(Ftr_loc); %

n = min(numel(Fpk), numel(Ftr));
Fpk = Fpk(1:n);
Ftr = Ftr(1:n);
Time_highs = Time_highs(1:n);
Time_lows  = Time_lows(1:n);

[bH, statsH] = robustfit(Time_highs(:), Fpk(:));
[bL, statsL] = robustfit(Time_lows(:),  Ftr(:));

% Extract slope/intercept to cleaner variables
aH = bH(1);        % intercept
mH = bH(2);        % slope

aL = bL(1);
mL = bL(2);

% 2. Extract residuals
resH = statsH.resid;
resL = statsL.resid;

% 3. Compute RMSE for overall discrepancy
RMSE_H = round(sqrt(mean(resH.^2)),2);
RMSE_L = round(sqrt(mean(resL.^2)),2);

fprintf('RMSE (Highs): \xB1%.2f N\n', RMSE_H);
fprintf('RMSE (Lows) : \xB1%.2f N\n', RMSE_L);

% 4. Plot original data and fitted lines
Fhigh_fit = mH * tF_fatigue + aH; % y = mx +b; linear equation
Flow_fit = mL * tF_fatigue + aL;

% Compute R² for both fits
% Highs
yH_fit = aH + mH * Time_highs;

SS_res_H = sum((Fpk - yH_fit).^2);
SS_tot_H = sum((Fpk - mean(Fpk)).^2);
R2_H = 1 - SS_res_H / SS_tot_H;

% Lows
yL_fit = aL + mL * Time_lows;

SS_res_L = sum((Ftr - yL_fit).^2);
SS_tot_L = sum((Ftr - mean(Ftr)).^2);

R2_L = 1 - SS_res_L / SS_tot_L;

figure('Name','Linear Fits for Fhigh and Flow')
hold on; grid on;

% Plot data
scatter(Time_highs, Fpk, 40, 'r', 'filled');
scatter(Time_lows,  Ftr,  40, 'b', 'filled');

% Plot fits
plot(tF_fatigue, Fhigh_fit, '-g', 'LineWidth', 2);
plot(tF_fatigue, Flow_fit,  '-m', 'LineWidth', 2);

xlabel('Time (s)');
ylabel('Force (N)');
title(sprintf('Robust Linear Fits for F_{high} and F_{low} - %s', test_details));

legend('Fhighs data','Flows data','High fit','Low fit','Location', 'northwest');

% Get axes limits
ax = gca;
xMin = ax.XLim(1);
xMax = ax.XLim(2);
yMin = ax.YLim(1);
yMax = ax.YLim(2);

% Offset for text slightly below the top
yOffset = 0.25*(yMax - yMin);

% Display fit equations below the legend box (northwest)
text(xMin + 0.02*(xMax-xMin), yMax - yOffset, ...
    sprintf('Fhighs = %.3f + %.3f*t   \n(R^2 = %.3f)', aH, mH, R2_H), ...
    'Color','g','FontSize',12,'VerticalAlignment','top');

text(xMin + 0.02*(xMax-xMin), yMax - 1.5*yOffset, ...
    sprintf('Flows = %.3f + %.3f*t   \n(R^2 = %.3f)', aL, mL, R2_L), ...
    'Color','m','FontSize',12,'VerticalAlignment','top');

hold off;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --- Compute Force Amplitude ---
Famp_fit = (Fhigh_fit - Flow_fit)/2;

% --- Compute Stress Amplitude ---
Samp = Famp_fit / xarea / 1e6;  % in MPa


% ----------- Fmax Increment/cycle: Experimental vs Programmed
cycleNum = (1:length(Fpk))';

% Linear regression of Fhighs vs. cycle number
p = polyfit(cycleNum, Fpk, 1);
dFmax_exp = p(1);

% Deviation between experimental and theoretical slope
deviation = abs(dFmax_exp - dFmax_programmed) / dFmax_programmed * 100;

fprintf('Programmed Fmax Increment:   %.3f N/cycle\n', dFmax_programmed);
fprintf('Experimental Fmax Increment: %.3f N/cycle\n', dFmax_exp);
fprintf('Deviation:          %.2f %%\n', deviation);

% --- Plot Fmax increment comparison ---
figure('Name','dFmax/cycle');
plot(cycleNum, Fpk, '.k', 'DisplayName', 'Measured F_{max}');
hold on;
plot(cycleNum, polyval(p, cycleNum), '-r', 'LineWidth', 1.5, 'DisplayName', sprintf('Fit (%.2f N/cycle)', dFmax_exp));
plot(cycleNum, dFmax_programmed*cycleNum + Fpk(1), '--b', 'LineWidth', 1.5, 'DisplayName', sprintf('Programmed (%.2f N/cycle)', dFmax_programmed));
xlabel('Cycle number');
ylabel('F_{max} (N)');
title(sprintf('F_{max} increment per cycle: Experimental vs Programmed - %s', test_details));
legend('Location', 'northwest');
grid on;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


% --- Plot Force Amplitude ---
figure('Name','Force and Stress Amplitude vs Time');
plot(tF_fatigue, Famp_fit, 'b', 'LineWidth', 2);
title(sprintf('Force and Stress Amplitude vs Time - %s', test_details));
xlabel('Time (s)'); ylabel('Force Amplitude (N)');
grid on;

yyaxis right
plot(tF_fatigue, Samp, 'r', 'LineWidth', 2); grid on;
ylabel('Stress Amplitude (MPa)');
legend('Famp','Samp')

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%--- Plot Fit Forces ---
figure('Name','Fit plots: Fhighs, Flows, Famp vs Time'); 
hold on; grid on;
plot(tF_fatigue, Fhigh_fit, '-r', 'LineWidth', 2);
plot(tF_fatigue, Flow_fit,  '-b', 'LineWidth', 2);
plot(tF_fatigue, Famp_fit, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Force (N)');
title('Fit plots: Fhighs, Flows, Famp vs Time', test_details);
legend('Fhigh fit','Flow fit','Famp fit','Location','northwest');
hold off;

% --- Plot Stress -----
figure('Name','Stress vs Time'); 
hold on; grid on;
plot(tF_fatigue, Fhigh_fit/xarea/1e6, '-r', 'LineWidth', 2);
plot(tF_fatigue, Flow_fit/xarea/1e6,  '-b', 'LineWidth', 2);
plot(tF_fatigue, Samp, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Stress (MPa)');
title('Stress vs Time', test_details);
legend('Shighs','Slows','Samp','Location','northwest');
hold off;

% --- Plot theta and Stress -----
figure('Name','Theta and Stress vs Time'); 
plot(tTheta, theta, '-b'); grid on; 
hold on;
xlabel('Time (s)'); ylabel('\theta (K)');
yyaxis right
plot(tF_fatigue, Samp, '-r', 'LineWidth', 2);          % amplitude fit
ylabel('Stress (MPa)');
title(sprintf('theta and Stress vs Time - %s', test_details));
legend('\theta','Samp','Location','northwest');
hold off;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% -------  T0D: Calculate mechanical dissipation

SFnewDissipation = round(windowDissipation * SF, 9);
if mod(SFnewDissipation,2) == 0
    SFnewDissipation = SFnewDissipation + 1; % Ensure odd number for convolution
end

movmean_theta = movmean(theta, SFnewDissipation, 'endpoints','fill');

% ------------------------------ tau(theta)

% Check if tau_table exists and is not empty
if exist('tau_table','var') && ~isempty(tau_table)

    % Sort tau table
    [tauThetaSorted, idx] = sort(tau_table.Theta);
    tauSorted = tau_table.Tau(idx);

    % Initialise tau array
    tau_exp = NaN(size(movmean_theta));

    % Identify theta bounds
    theta_min = tauThetaSorted(1);
    theta_max = tauThetaSorted(end);

    % Case 1: theta below minimum -> use minimum tau
    idx_low = movmean_theta <= theta_min;
    tau_exp(idx_low) = tauSorted(1);

    % Case 2: theta above maximum -> use maximum tau
    idx_high = movmean_theta >= theta_max;
    tau_exp(idx_high) = tauSorted(end);

    % Case 3: theta within bounds -> interpolate
    idx_mid = ~(idx_low | idx_high);
    tau_exp(idx_mid) = interp1( ...
        tauThetaSorted, ...
        tauSorted, ...
        movmean_theta(idx_mid), ...
        'linear' );

    figure('Name','tau vs movmean Theta and tau Theta');
    plot(movmean_theta, tau_exp, '-r','DisplayName','tau vs \theta_{mean}');
    grid on
    title('\tau vs \theta')
    hold on
    plot(tau_table.Theta,tau_table.Tau, '.b', 'DisplayName','tau table');
    legend

else
    % ---- Use constant tau value ----
    tau_exp = tau * ones(size(movmean_theta));
end


% --------------------------- d1
d1 = nan(size(theta));
kd = (SFnewDissipation-1)/2;

for k = SFnewDissipation : length(theta) - (SFnewDissipation - 1)
    d1(k) = rho * C * ( ...
        (movmean_theta(k+kd) - movmean_theta(k-kd)) / ...
        (tTheta(k+kd) - tTheta(k-kd)) + ...
        movmean_theta(k) / tau_exp(k) );
end

d1 = d1/1000; % Converting units into kilo
% if mean(theta) > 0
% Z1 = d1(~isnan(d1));
% d1 = d1 - (Z1(1));
% end

figure('Name','d1, Theta, and Avg.Theta vs Time')
plot(tTheta, theta); grid on;
hold on;
plot(tTheta, movmean_theta, '-r', LineWidth=1.5)
title(sprintf('d1, \theta and Avg.\theta vs Time (%.0fs window) %s)', windowDissipation, test_details))
grid on
ylabel('\theta (K)');
yyaxis right
plot(tTheta, d1, '-b',LineWidth=3)
ax = gca;
ax.YAxis(2).Color = 'b';
xlabel('Time (s)')
ylabel('d1 (kW/m³)')
legend('\theta','Avg.\theta','d1','Location', 'northwest');


D1 = d1 / LF; % Normalize by loading frequency

% Interpolate stress amplitude to theta time vector
SampInterp = interp1(tF_fatigue, Samp, tTheta, 'linear');


figure('Name','Checking Samp interpolation')
plot(tF_fatigue, Samp, LineWidth=2);
title('Checking Samp interpolation', test_details)
hold on;
plot(tTheta,SampInterp, '--r',LineWidth=2);
legend ('SampLoading-fit','Samp interpolated','Location', 'northwest');
ylabel('Stess Amplitude (MPa)')
xlabel('Time (s)')
grid on


%% ------------  Plotting section

% --- d1 & stress amplitude vs Time
figure('Name','d1 and Samp vs Time')
plot(tTheta, d1, '.b', 'LineWidth', 1.5); % in kW/m3
title(sprintf('d1 and Samp vs Time\n(%0.0fs window) %s', windowDissipation, test_details));
xlabel('Time (s)');
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
yyaxis right;
plot(tTheta, SampInterp, '-.r', LineWidth=2)
ylabel('Stress Amplitude (MPa)');
legend('d1', '\sigma_{amp}','Location', 'northwest');
grid on;

% ---- d1 and Avg. Theta vs stress amplitude
figure('Name','d1 and Avg. Theta vs stress amplitude');
plot(SampInterp, d1, '.b');
title(sprintf('Sum of Heat Sources vs Samp\n(%0.0fs window) %s', windowDissipation, test_details));
xlabel('\sigma_{amp} (MPa)');
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
yyaxis right
plot(SampInterp, movmean_theta,'r', LineWidth=2)
ylabel('\theta (K)')
legend('d1', 'Avg.\theta','Location','northwest')
grid on;

% ---- D1 vs stress amplitude
figure('Name','D1 and Avg. Theta vs stress amplitude');
plot(SampInterp, D1, '.b');
title(sprintf('Sum of Heat Sources / Cycle (D1) & Avg.theta vs Samp (%.0fs window) %s', windowDissipation, test_details));
xlabel('\sigma_{amp} (MPa)');
ylabel('D1 - Sum of Heat Sources / Cycle (kJ·m^{-3}/cycle)');
yyaxis right
plot(SampInterp, movmean_theta,'r', LineWidth=2)
ylabel('\theta (K)')
legend('D1', 'Avg.\theta','Location','northwest')
grid on;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ---- D1 and diff(Avg.Theta) vs stress amplitude
figure('Name','D1 and diff(Avg.Theta) vs stress amplitude');
plot((SampInterp(2:end)), diff(movmean_theta),'-r', LineWidth=1)
ylabel('diff (Avg.\theta)  (K)')
title(sprintf('Sum of Heat Sources / Cycle (D1) & theta vs Samp\n(%.0fs window) %s', windowDissipation, test_details));
xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampInterp, D1, '.b');
ax = gca;
ax.YAxis(2).Color = 'b';
ylabel('D1 - Sum of Heat Sources / Cycle (kJ/m^3/cycle)');
legend('diff (Avg.\theta)','D1','Location','northwest')
grid on;

%% ----------  d1 calculated from detrended OR Self Heating part of theta

% theta_ThermoElastic = detrend(theta,6);
% theta_SelfHeating = theta - theta_ThermoElastic; % theta_d1 = theta from only mechanical dissipation (d1)
%
% figure('Name','Theta, Thermoelastic, and Self Heating vs Samp');
% plot(SampInterp,theta,'-k', LineWidth=1.5); grid on
% hold on;
% plot(SampInterp,theta_SelfHeating,'-r', LineWidth=1.5);
% plot(SampInterp,theta_ThermoElastic,'-b', LineWidth=1);
% title(sprintf(['\\theta_{ThermoElastic} = detrend (\\theta, 6)\n' ...
%                '\\theta_{SelfHeating} = \\theta - \\theta_{ThermoElastic}\n' ...
%                '(Window Size: %.2f s) - %s'], window, testName_withDate));
% ylabel('\theta (K)')
% xlabel('Stess Amplitude (MPa)')
% grid on
% legend('\theta', '\theta_{SelfHeating}', '\theta_{ThermoElastic}', Location='northwest')
%
%
% d1_SelfHeating = nan(size(theta));
% kd = (SFnew-1)/2;
%
% for k = (SFnew):length(theta)-(SFnew-1)
%     d1_SelfHeating  (k) = rho * C * (((theta_SelfHeating(k+kd) - theta_SelfHeating(k-kd)) / (tTheta_sync(k+kd) - tTheta_sync(k-kd))) + theta_SelfHeating(k)/tau);
% end
%
% d1_SelfHeating = d1_SelfHeating/1000; % Converting into kilo
% % if mean(theta) > 0
% Z2 = d1_SelfHeating(~isnan(d1_SelfHeating));
% rangeZ2 = round(length(Z2)*1/100);
% d1_SelfHeating = d1_SelfHeating - mean(Z2(1:rangeZ2));
% % end
%
% D1_SelfHeating = d1_SelfHeating   / LF; % Normalize by loading frequency

% % ---- d1-SelfHeating and Theta vs Samp
% figure('Name','d1-SelfHeating and Theta vs Samp')
% plot(SampInterp, theta)
% hold on; grid on
% plot(SampInterp, theta_SelfHeating, '-r', LineWidth=1.5)
% title('d1-SelfHeating  , \theta and \theta_{SelfHeating} vs Samp', testName_withDate)
% ylabel('\theta (K)');
% yyaxis right
% plot(SampInterp, d1_SelfHeating  , '-b',LineWidth=1.5)
% ax = gca;
% ax.YAxis(2).Color = 'b';
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d1-SelfHeating (kW/m³)')
% legend('\theta','\theta_{SelfHeating}','d1_{SelfHeating}  ','Location', 'northwest');


% % ----- D1-SelfHeating and Theta vs Samp
% figure('Name','D1-SelfHeating and Theta vs Samp')
% plot(SampInterp, theta)
% hold on;
% plot(SampInterp, theta_SelfHeating, '-r', LineWidth=1.5)
% title('D1-SelfHeating, \theta and \theta_{SelfHeating} vs Samp', testName_withDate)
% grid on
% ylabel('\theta (K)');
% yyaxis right
% plot(SampInterp, D1_SelfHeating  , '-b',LineWidth=1.5)
% ax = gca;
% ax.YAxis(2).Color = 'b';
% xlabel('\sigma_{amp} (MPa)')
% ylabel('D1-SelfHeating   (kJ/m^3/cycle)')
% legend('\theta','\theta_{SelfHeating}','D1_{SelfHeating}  ','Location', 'northwest');

% figure('Name','d1 vs d1-theta-selfheating')
% plot(SampInterp,d1,'-b', LineWidth=1.5)
% hold on
% plot(SampInterp,d1_theta_SelfHeating,'--r', LineWidth=2)
% grid on
% title('d1 and d1-self-heating vs Samp')
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d1 (kW/m³)')
% legend ('d1','d1_{SelfHeating}')


%% ----------- T0D: Spectral Analysis of Whole IR Data
% Gage zone, Top and Bottom legs
% close all
N_IR = length(IRtime);

N_IRTrunc = N_IR; % Finding the maximum length of data which has integer number of cycles

while mod(N_IRTrunc, SF/LF) >= 1e-9
    N_IRTrunc = N_IRTrunc -1;
end

% --- Ensure column vectors
T0D = T0D(:);
T_ref_up = T_ref_up(:);
T_ref_bottom = T_ref_bottom(:);

% --- Truncate to consistent length
T0D = T0D(1:N_IRTrunc);
T_ref_up = T_ref_up(1:N_IRTrunc);
T_ref_bottom = T_ref_bottom(1:N_IRTrunc);

% --- Hann window
applyHANN = hann(N_IRTrunc);
applyHANN = applyHANN(:);
CG = mean(applyHANN);

% --- Frequency vector
f_whole = (0:floor(N_IRTrunc/2)) * (SF / N_IRTrunc);
f_whole = f_whole(:);

% --------- FFT computation T0D
T0D_HANN = T0D .* applyHANN;
P1T0D = abs(fft(T0D_HANN, N_IRTrunc)) * (2/(N_IRTrunc * CG));
P1T0D = P1T0D(1 : floor(N_IRTrunc/2)+1);
P1T0D(1) = NaN;

% --------- FFT computation T_ref_up
T_ref_up_HANN = T_ref_up .* applyHANN;
P1Up = abs(fft(T_ref_up_HANN, N_IRTrunc)) * (2/(N_IRTrunc * CG));
P1Up = P1Up(1 : floor(N_IRTrunc/2)+1);
P1Up(1) = NaN;

% ----------- FFT computation T_ref_bottom
T_ref_bottom_HANN = T_ref_bottom .* applyHANN;
P1bot = abs(fft(T_ref_bottom_HANN, N_IRTrunc)) * (2/(N_IRTrunc * CG));
P1bot = P1bot(1 : floor(N_IRTrunc/2)+1);
P1bot(1) = NaN;

figure('Name', 'Frequency analysis whole IR data');
title('Frequency analysis whole IR data')
hold on;

% Harmonic markers
xline(20,'--k','1f','FontSize',22);
xline(40,'--k','2f','FontSize',22);
xline(60,'--k','3f','FontSize',22);

h = plot(f_whole, movmean(P1T0D,3), 'or', 'MarkerSize', 2, 'DisplayName','T_{GZ}');
set(h, 'MarkerFaceColor', h.Color);
h = plot(f_whole, movmean(P1bot,3), 'og', 'MarkerSize', 2, 'DisplayName','T_{RefLow}');
set(h, 'MarkerFaceColor', h.Color);
h = plot(f_whole, movmean(P1Up,3),  'ob', 'MarkerSize', 2, 'DisplayName','T_{RefUp}');
set(h, 'MarkerFaceColor', h.Color);


xlabel('Frequency (Hz)');
ylabel('Amplitude');

xlim([0 70])
xticks(0:10:70)

set(gca, 'YScale', 'log');
ylim([1e-6 1e-1])
yticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1])
yticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}'})

% Grid
grid on;
ax = gca;
ax.YMinorGrid = 'on';
ax.GridAlpha = 0.5;
ax.MinorGridAlpha = 0.3;
set(gca, 'FontSize', 20)          % Axes tick labels
    xlabel('Frequency (Hz)', 'FontSize', 20)
    ylabel('Amplitude', 'FontSize', 20)
pos = [300   300   657   480];  %[left  bottom  width  height]
set(gcf, 'Position', pos);
box on
ax = gca;
ax.GridAlpha = 0.8;
legend

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% ------------- T0D: Spectral Analysis During Fatigue

N_IRfatigue = length(theta);

N_IRfatigueTrunc = N_IRfatigue; % Finding the maximum length of data which has integer number of cycles

while abs(mod(N_IRfatigueTrunc, SF / LF)) > 1e-6
    N_IRfatigueTrunc = N_IRfatigueTrunc -1;
end

% --------- Frequency vector
f_fatigue = (0:floor(N_IRfatigueTrunc/2)) * (SF / N_IRfatigueTrunc);
f_fatigue = f_fatigue(:);

TrefUp_fatigueTrunc = T_ref_up_fatigue(1:N_IRfatigueTrunc); 
TrefUp_fatigueTrunc = TrefUp_fatigueTrunc(:);

TrefBot_fatigueTrunc = T_ref_bottom_fatigue(1:N_IRfatigueTrunc); 
TrefBot_fatigueTrunc = TrefBot_fatigueTrunc(:);

T0D_fatigueTrunc = T0D_fatigue(1:N_IRfatigueTrunc); 
T0D_fatigueTrunc = T0D_fatigueTrunc(:);

thetaTrunc = theta(1:N_IRfatigueTrunc); 
thetaTrunc = thetaTrunc(:);

% --------- Apply Hann window
applyHANN_fatigue = hann(N_IRfatigueTrunc);
applyHANN_fatigue = applyHANN_fatigue(:);

CG_fatigue = mean(applyHANN_fatigue); % Coherent gain

TrefUp_fatigueHANN = TrefUp_fatigueTrunc.* applyHANN_fatigue;
TrefBot_fatigueHANN = TrefBot_fatigueTrunc.* applyHANN_fatigue;
T0DC_fatigueHANN = T0D_fatigueTrunc.* applyHANN_fatigue;
thetaC_HANN = thetaTrunc.* applyHANN_fatigue;


% --------- FFT computation TrefUp_fatigue
P1TrefUp_fatigue = abs(fft(TrefUp_fatigueHANN, N_IRfatigueTrunc)) * (2/(N_IRfatigueTrunc * CG_fatigue));
P1TrefUp_fatigue = P1TrefUp_fatigue(1 : floor(N_IRfatigueTrunc/2)+1);
P1TrefUp_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation TrefBot_fatigue
P1TrefBot_fatigue = abs(fft(TrefBot_fatigueHANN, N_IRfatigueTrunc)) * (2/(N_IRfatigueTrunc * CG_fatigue));
P1TrefBot_fatigue = P1TrefBot_fatigue(1 : floor(N_IRfatigueTrunc/2)+1);
P1TrefBot_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation T0DC
P1T0DC_fatigue = abs(fft(T0DC_fatigueHANN, N_IRfatigueTrunc)) * (2/(N_IRfatigueTrunc * CG_fatigue));
P1T0DC_fatigue = P1T0DC_fatigue(1 : floor(N_IRfatigueTrunc/2)+1);
P1T0DC_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation thetaC
P1thetaC = abs(fft(thetaC_HANN, N_IRfatigueTrunc)) * (2/(N_IRfatigueTrunc * CG_fatigue));
P1thetaC = P1thetaC(1 : floor(N_IRfatigueTrunc/2)+1);
P1thetaC(1) = NaN; % Remove DC component

figure('Name', 'Frequency analysis IR data FATIGUE (log scale)'); hold on
title(sprintf('Frequency analysis IR data FATIGUE (log scale) - %s', test_details));

% Harmonic markers
xline(20,'--k','1f','FontSize',22);
xline(40,'--k','2f','FontSize',22);
xline(60,'--k','3f','FontSize',22);

h = plot(f_fatigue, movmean(P1TrefUp_fatigue,3),'o', 'Color', 'b', 'MarkerSize', 3); 
set(h, 'MarkerFaceColor', h.Color);

h = plot(f_fatigue, movmean(P1TrefBot_fatigue,3),'o', 'Color', 'g', 'MarkerSize', 3);
set(h, 'MarkerFaceColor', h.Color);

h = plot(f_fatigue, movmean(P1T0DC_fatigue,3),'o', 'Color', 'r', 'MarkerSize', 3);
set(h, 'MarkerFaceColor', h.Color);

h = plot(f_fatigue, movmean(P1thetaC,3),'o', 'Color', 'k', 'MarkerSize', 3);
set(h, 'MarkerFaceColor', h.Color);    

xlabel('Frequency (Hz)', 'FontSize', 20)
ylabel('Amplitude', 'FontSize', 20)

set(gca, 'YScale', 'log');
ylim([1e-6 1e-0])
yticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e0])
yticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}'})

xlim([0 70])
xticks(0:10:ceil(SF/2/100)*100)

grid on;
ax = gca;
ax.YMinorGrid = 'on';
ax.GridAlpha = 0.5;
ax.MinorGridAlpha = 0.3;

set(gcf, 'Position', [688 535 657 400])
set(gca, 'FontSize', 20)

% legend

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



%% -------- T0D: FFT BEFORE pre-training tension and before fatigue loading
% close all

% Although the index length correction is not necessary for the BEFORE
% data, however, I am still performing it for the purpose of concistency.
% Since, I will be subtracting the BEFORE amplitudes from the Fatigue
% amplitudes, therefore, I think it is safe to have index length which
% satisfies the integer number of cycles criteria even for the BEFORE data.

N_IRBefore = length(1:BeforeLoad_IdxEnd);

N_IRBeforeTrunc = N_IRBefore; % Finding the maximum length of data which has integer number of cycles

while mod(N_IRBeforeTrunc, SF/LF) >= 1e-6
    N_IRBeforeTrunc = N_IRBeforeTrunc -1;
end

applyHANN = hann(N_IRBeforeTrunc);
applyHANN = applyHANN(:);
CG_BEFORE = mean(applyHANN); % --- Coherent gain correction

T0D_BeforeHANN = T0D(1:N_IRBeforeTrunc).* applyHANN;
T_ref_up_BeforeHANN = T_ref_up(1:N_IRBeforeTrunc).* applyHANN;
T_ref_bot_BeforeHANN = T_ref_bottom(1:N_IRBeforeTrunc).* applyHANN;

T_ref_Before = 0.5 * (T_ref_up_BeforeHANN + T_ref_bot_BeforeHANN);
TnoOffset_Before = T0D_BeforeHANN - T_ref_Before;
Ti_Before = mean(TnoOffset_Before(1 : SF*2)); % data of initial 2 seconds
theta_Before = TnoOffset_Before - Ti_Before;
theta_Before = theta_Before(:);
theta_BeforeHANN = theta_Before; % already HANN windowed implicitly

f_Before = (0:floor(N_IRBeforeTrunc/2)) * (SF / N_IRBeforeTrunc);
f_Before = f_Before(:);

% --------- FFT computation T0D
P1T0D_Before = abs(fft(T0D_BeforeHANN, N_IRBeforeTrunc)) * (2/(N_IRBeforeTrunc * CG_BEFORE));
P1T0D_Before = P1T0D_Before(1 : floor(N_IRBeforeTrunc/2)+1);
P1T0D_Before(1) = NaN; % Remove DC component

% --------- FFT computation T_ref_up
P1UpBefore = abs(fft(T_ref_up_BeforeHANN, N_IRBeforeTrunc)) * (2/(N_IRBeforeTrunc * CG_BEFORE));
P1UpBefore = P1UpBefore(1 : floor(N_IRBeforeTrunc/2)+1);
P1UpBefore(1) = NaN; % Remove DC component

% ----------- FFT computation T_ref_bottom
P1botBefore = abs(fft(T_ref_bot_BeforeHANN, N_IRBeforeTrunc)) * (2/(N_IRBeforeTrunc * CG_BEFORE));
P1botBefore = P1botBefore(1 : floor(N_IRBeforeTrunc/2)+1);
P1botBefore(1) = NaN; % Remove DC component

% ----------- FFT computation theta_Before
P1thetaBefore = abs(fft(theta_BeforeHANN, N_IRBeforeTrunc)) * (2/(N_IRBeforeTrunc * CG_BEFORE));
P1thetaBefore = P1thetaBefore(1 : floor(N_IRBeforeTrunc/2)+1);
P1thetaBefore(1) = NaN; % Remove DC component

% ------------ Plot (log scale)
figure('Name', 'Frequency analysis IR data BEFORE fatigue (log scale)'); hold on
title(sprintf('Frequency analysis IR data BEFORE fatigue (log scale)- %s', test_details));
% Harmonic markers
xline(20,'--k','1f','FontSize',22);
xline(40,'--k','2f','FontSize',22);
xline(60,'--k','3f','FontSize',22);

plot(f_Before, movmean(P1UpBefore,3), 'o', 'Color', 'b', 'MarkerSize', 3, ...
    'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'DisplayName', 'T_{RefUp}');

plot(f_Before, movmean(P1botBefore,3), 'o', 'Color', 'g', 'MarkerSize', 3, ...
    'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'DisplayName', 'T_{RefLow}');

plot(f_Before, movmean(P1T0D_Before,3),'o', 'Color', 'r', 'MarkerSize', 3, ...
    'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'DisplayName', 'T_{GZ}');

% plot(f_Before, movmean(P1thetaBefore,3),'o', 'Color', 'k', 'MarkerSize', 3, ...
%     'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'DisplayName', '\theta');

xlabel('Frequency (Hz)');
ylabel('Amplitude');
xticks(0:10:ceil(SF/2/100)*100)
xlim([0 70])

set(gca, 'YScale', 'log');
ylim([1e-5 1e-0])
yticks([1e-5 1e-4 1e-3 1e-2 1e-1 1e0])
yticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}'})

grid on;
ax = gca;
ax.YMinorGrid = 'on';
ax.GridAlpha = 0.8;
ax.MinorGridAlpha = 0.3;
pos = [300   300   657   480];  %[left  bottom  width  height]
set(gcf, 'Position', pos);
set(gca, 'FontSize', 20)          % Axes tick labels
    xlabel('Frequency (Hz)', 'FontSize', 20)
    ylabel('Amplitude', 'FontSize', 20)

box on


% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscore
saveas(gcf, fullfile(folderPath, [figureName '.fig']));




%% -------------- T0D: Spectral Analysis AFTER Fatigue
% close all
offset = 500;

T0D_After = T0D(temp_idxE+offset:end);
T_ref_bottom_After = T_ref_bottom(temp_idxE+offset:end);
T_ref_up_After = T_ref_up(temp_idxE+offset:end);

T0D_After = T0D_After(:);
T_ref_bottom_After = T_ref_bottom_After(:);
T_ref_up_After = T_ref_up_After(:);

N_IR_After = length(T0D_After);

N_IR_AfterTrunc = N_IR_After; % Finding the maximum length of data which has integer number of cycles

while mod(N_IR_AfterTrunc, SF/LF) >= 1e-6
    N_IR_AfterTrunc = N_IR_AfterTrunc -1;
end

applyHANN_After = hann(N_IR_AfterTrunc);
applyHANN_After = applyHANN_After(:);

CG_After = mean(applyHANN_After); % --- Coherent gain correction

f_After = (0:floor(N_IR_AfterTrunc/2)) * (SF / N_IR_AfterTrunc);
f_After = f_After(:);

% --------- Apply Hann window (time-domain)
T0D_AfterHANN = T0D_After(1:N_IR_AfterTrunc) .* applyHANN_After;
T_ref_up_AfterHANN = T_ref_up_After(1:N_IR_AfterTrunc) .* applyHANN_After;
T_ref_bottom_AfterHANN = T_ref_bottom_After(1:N_IR_AfterTrunc) .* applyHANN_After;

% --------- FFT computation T0D
P1T0D_After = abs(fft(T0D_AfterHANN, N_IR_AfterTrunc)) * (2/(N_IR_AfterTrunc * CG_After));
P1T0D_After = P1T0D_After(1 : floor(N_IR_AfterTrunc/2)+1);
P1T0D_After(1) = NaN; % Remove DC component

% --------- FFT computation T_ref_up
P1UpAfter = abs(fft(T_ref_up_AfterHANN, N_IR_AfterTrunc)) * (2/(N_IR_AfterTrunc * CG_After));
P1UpAfter = P1UpAfter(1 : floor(N_IR_AfterTrunc/2)+1);
P1UpAfter(1) = NaN; % Remove DC component

% ----------- FFT computation T_ref_bottom
P1botAfter = abs(fft(T_ref_bottom_AfterHANN, N_IR_AfterTrunc)) * (2/(N_IR_AfterTrunc * CG_After));
P1botAfter = P1botAfter(1 : floor(N_IR_AfterTrunc/2)+1);
P1botAfter(1) = NaN; % Remove DC component

% ------- Theta for AFTER
T_ref_After = 0.5 * (T_ref_up_AfterHANN + T_ref_bottom_AfterHANN);
TnoOffset_After = T0D_AfterHANN - T_ref_After;

Ti_After = mean(TnoOffset_After(1:min(SF*2, length(TnoOffset_After))));
theta_After = TnoOffset_After - Ti_After;
theta_After = theta_After(:);

P1thetaAfter = abs(fft(theta_After, N_IR_AfterTrunc)) * (2/(N_IR_AfterTrunc * CG_After));
P1thetaAfter = P1thetaAfter(1 : floor(N_IR_AfterTrunc/2)+1);
P1thetaAfter(1) = NaN;


% ------------ Plot After Fatigue loading (log scale)
figure('Name', 'Frequency analysis IR data AFTER fatigue (log scale)'); hold on
title(sprintf('Frequency analysis IR data AFTER fatigue (log scale) - %s', test_details));

% Harmonic markers
xline(20,'--k','1f','FontSize',22);
xline(40,'--k','2f','FontSize',22);
xline(60,'--k','3f','FontSize',22);

h = plot(f_After, movmean(P1UpAfter,3), 'o', 'Color', 'b', 'MarkerSize', 2);
set(h, 'MarkerFaceColor', h.Color);

h = plot(f_After, movmean(P1botAfter,3), 'o', 'Color', 'g', 'MarkerSize', 2);
set(h, 'MarkerFaceColor', h.Color);

h = plot(f_After, movmean(P1T0D_After,3),'o', 'Color', 'r', 'MarkerSize', 2);
set(h, 'MarkerFaceColor', h.Color);

% h = plot(f_After, movmean(P1thetaAfter,3),'o', 'Color', 'k', 'MarkerSize', 2);
% set(h, 'MarkerFaceColor', h.Color);



xticks(0:10:ceil(SF/2/100)*100)
xlim([0 70])

set(gca, 'YScale', 'log');
ylim([1e-5 1e-0])
yticks([1e-5 1e-4 1e-3 1e-2 1e-1 1e0])
yticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}'})

grid on;
ax = gca;
ax.YMinorGrid = 'on';
ax.GridAlpha = 0.8;
ax.MinorGridAlpha = 0.3;
pos = [300   300   657   480];  %[left  bottom  width  height]
set(gcf, 'Position', pos);
set(gca, 'FontSize', 20)          % Axes tick labels
    xlabel('Frequency (Hz)', 'FontSize', 20)
    ylabel('Amplitude', 'FontSize', 20)
box on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.svg']));

%% FFT on sliding windows

N_theta = length(theta);
SFnewTSA = round(SF * windowTSA);

if mod(SFnewTSA, SF/LF) >= 1e-9
    error('window size is not producing integer number of cycles!!!')
end

LF2 = 2*LF;                % 2nd harmonic [Hz]
LF3 = 3*LF;                % 3rd harmonic [Hz]

% Aliasing check
if LF3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], LF3, SF/2);
end

% --- Arbitrary frequencies ---
fA = LF - 3;
fB = LF + 2;
fC = LF + LF/2; %FL - 5;
fD = LF*2 - 7 ; %FL + 5;
fE = LF*2 + 2; %FL*2 - 5;
fF = LF*2 + 13; %FL*2 + 5;
arbitraryFreqs = [fA, fB, fC, fD, fE, fF];

% --- FFT frequency axis ---
f = (0:SFnewTSA-1) * (SF/SFnewTSA);
nWinTheta = N_theta - SFnewTSA + 1; % # of windows in the whole theta vector

% --- Preallocate ---
maxAmpH1 = nan(nWinTheta,1); maxFreqH1 = nan(nWinTheta,1); ampAtH1 = nan(nWinTheta,1);
maxAmpH2 = nan(nWinTheta,1); maxFreqH2 = nan(nWinTheta,1); ampAtH2 = nan(nWinTheta,1);
maxAmpH3 = nan(nWinTheta,1); maxFreqH3 = nan(nWinTheta,1); ampAtH3 = nan(nWinTheta,1);
ampAtArbit = nan(nWinTheta, length(arbitraryFreqs));


%% --- Sliding window --- FFT method

for k = 1:nWinTheta

    end_idx = k+SFnewTSA-1;
    segmentTheta = detrend(theta(k : end_idx), 6);
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta(k : end_idx);
    beta = abs(fft(segmentTheta)) * (2/SFnewTSA);

    idx1 = find(f >= (LF-BW) & f <= (LF+BW));
    [maxAmpH1(k), j1] = max(beta(idx1)); maxFreqH1(k) = f(idx1(j1));
    [~, i1] = min(abs(f - LF)); ampAtH1(k) = beta(i1);

    idx2 = find(f >= (LF2-BW) & f <= (LF2+BW));
    [maxAmpH2(k), j2] = max(beta(idx2)); maxFreqH2(k) = f(idx2(j2));
    [~, i2] = min(abs(f - LF2)); ampAtH2(k) = beta(i2);

    if LF3<SF/2
        idx3 = find(f >= (LF3-BW) & f <= (LF3+BW));
        [maxAmpH3(k), j3] = max(beta(idx3)); maxFreqH3(k) = f(idx3(j3));
        [~, i3] = min(abs(f - LF3)); ampAtH3(k) = beta(i3);
    end

    for j = 1:length(arbitraryFreqs)
        [~, idx] = min(abs(f - arbitraryFreqs(j)));
        ampAtArbit(k, j) = beta(idx);
    end

end

% --- Construct central time reference for overlaying theta ---
winCentreIdx = (1:nWinTheta) + floor(SFnewTSA/2);

%% --- Amplitude Plotting FFT method (with theta on yyaxis right) ---
nn = 3;
if LF3>SF/2
    nn = 2;
end

figure('Name','Harmonic Amplitudes with Theta');%);%,'NumberTitle','off');
% Define time vector for x-axis

tplot = tTheta(1:nWinTheta);

% loading window
loading_start = tTheta(1);%(idx_Theta_sync(1));
loading_end = tTheta(end); %(temp_idxE - SF*window);
loading_window = find(tplot >= loading_start & tplot <= loading_end);

subplot(nn,2,1);
yyaxis left
plot(tplot, ampAtH1, 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,2);
yyaxis left
plot(tplot, maxAmpH1, 'b', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Avg. \theta','Location', 'northwest');


subplot(nn,2,3);
yyaxis left
plot(tplot, ampAtH2, 'g', 'LineWidth', 2);
hold on;
plot(tplot, movmean(ampAtH2, SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF2)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,4);
yyaxis left
plot(tplot, maxAmpH2, 'm', 'LineWidth', 2);
hold on; plot(tplot, movmean(maxAmpH2, SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if LF3<SF/2
    subplot(nn,2,5);
    yyaxis left
    plot(tplot, ampAtH3, 'y', 'LineWidth', 2);
    hold on; plot(tplot, movmean(ampAtH3, SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF3)); grid on;
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('Time (s)')
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');



    subplot(nn,2,6);
    yyaxis left
    plot(tplot, maxAmpH3, 'c', 'LineWidth', 2);
    hold on; plot(tplot, movmean(maxAmpH3, SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('Time (s)')
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sg = sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n(mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



% ------------------------ Harmonic Amplitudes vs Stress amplitude
SampInterp_x = SampInterp(1:nWinTheta);

figure('Name','Harmonic Amplitudes vs Stress Amp');%);%,'NumberTitle','off');

subplot(nn,2,1);
yyaxis left
plot(SampInterp_x, ampAtH1(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,2);
yyaxis left
plot(SampInterp_x, maxAmpH1(loading_window), 'b', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Avg. \theta','Location', 'northwest');


subplot(nn,2,3);
yyaxis left
plot(SampInterp_x, ampAtH2(loading_window), 'g', 'LineWidth', 2);
hold on;
plot(SampInterp_x, movmean(ampAtH2(loading_window), SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF2)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,4);
yyaxis left
plot(SampInterp_x, maxAmpH2(loading_window), 'm', 'LineWidth', 2);
hold on; plot(SampInterp_x, movmean(maxAmpH2(loading_window), SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if LF3<SF/2
    subplot(nn,2,5);
    yyaxis left
    plot(SampInterp_x, ampAtH3(loading_window), 'y', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(ampAtH3(loading_window), SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF3 )); grid on;
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');



    subplot(nn,2,6);
    yyaxis left
    plot(SampInterp_x, maxAmpH3(loading_window), 'c', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(maxAmpH3(loading_window), SFnewDissipation, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sg = sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n(mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% --- Arbitrary Frequencies with Theta Overlay ---
figure('Name','All Arbitrary Frequency Amplitudes with Theta');%);%,'NumberTitle','off');
nCols = 2; nRows = ceil(length(arbitraryFreqs) / nCols);
for j = 1:length(arbitraryFreqs)
    subplot(nRows, nCols, j);
    yyaxis left
    plot(tplot, ampAtArbit(:, j), '--', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.2f Hz', arbitraryFreqs(j))); grid on;

    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
    ylabel('\theta (K)'); xlabel('Time (s)')
    legend('Amp','Avg. \theta','Location', 'northwest');
end
% sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', windowTSA,test_details));


% -- Arbitrary Frequencies' Amp vs Stress Amp
figure('Name','Arbitrary Freq Amps vs Stres Amp');%);%,'NumberTitle','off');
nCols = 2; nRows = ceil(length(arbitraryFreqs) / nCols);
for j = 1:length(arbitraryFreqs)
    subplot(nRows, nCols, j);
    yyaxis left
    plot(SampInterp_x, ampAtArbit(loading_window, j), '--', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.2f Hz', arbitraryFreqs(j))); grid on;

    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window), SFnewDissipation, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
    ylabel('\theta (K)'); xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Avg. \theta','Location', 'northwest');

end
% sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', windowTSA,test_details));


%% --- Frequency Peak Tracking Only ---
figure('Name','Harmonic Peak Frequencies');%);%,'NumberTitle','off');

subplot(nn,1,1);
plot(tplot, maxFreqH1,'b','LineWidth',1.2);
title(sprintf('Peak Freq in %.f\\pm%.1f Hz', LF, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

subplot(nn,1,2);
plot(tplot, maxFreqH2,'m','LineWidth',1.2);
title(sprintf('Peak Freq in %.f\\pm%.1f Hz', LF2, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

if LF3<SF/2
    subplot(nn,1,3);
    plot(tplot, maxFreqH3,'c','LineWidth',1.2);
    title(sprintf('Peak Freq in %.f\\pm%.1f Hz', LF3, BW));
    ylabel('Freq (Hz)');
    xlabel('Time (s)'); grid on;
end

sgtitle(sprintf('%.1fs Sliding-Window - Peak Frequency Tracking vs. Time\n (mean \\theta removed) - %s', windowTSA,test_details));

% % --- Frequencies vs Stress Amplitude
% maxFreqH1_loading = maxFreqH1(loading_window);
% maxFreqH2_loading = maxFreqH2(loading_window);
% maxFreqH3_loading = maxFreqH3(loading_window);
%
% figure('Name','Harmonic Peak Frequencies vs Stress Amp');%);%,'NumberTitle','off');
%
% subplot(nn,1,1);
% plot(SampInterp, maxFreqH1_loading,'b','LineWidth',1.2);
% title(sprintf('Peak Freq in %.f\\pm%.1f Hz', FL, BW));
% ylabel('Freq (Hz)');
% xlabel('\sigma_{amp} (MPa)'); grid on;
%
% subplot(nn,1,2);
% plot(SampInterp, maxFreqH2_loading,'m','LineWidth',1.2);
% title(sprintf('Peak Freq in %.f\\pm%.1f Hz', FL2, BW));
% ylabel('Freq (Hz)');
% xlabel('\sigma_{amp} (MPa)'); grid on;
%
% if FL3<FS/2
%     subplot(nn,1,3);
%     plot(SampInterp, maxFreqH3_loading,'c','LineWidth',1.2);
%     title(sprintf('Peak Freq in %.f\\pm%.1f Hz', FL3, BW));
%     ylabel('Freq (Hz)');
%     xlabel('\sigma_{amp} (MPa)'); grid on;
% end
%
% sgtitle(sprintf('%.1fs Sliding-Window - Peak Frequency Tracking vs. Stress Amp\n (mean \\theta removed)', window));
%
%



%% Traditional method
% Generate reference signals
tref_signal = (0:N_theta-1) / SF;
X1 = cos(2 * pi * LF * tref_signal)'; %FL_analysed
Y1 = sin(2 * pi * LF * tref_signal)';

X2 = cos(2 * pi * 2*LF * tref_signal)';
Y2 = sin(2 * pi * 2*LF * tref_signal)';

X3 = cos(2 * pi * 3*LF * tref_signal)';
Y3 = sin(2 * pi * 3*LF * tref_signal)';

for k = 1:nWinTheta

    end_idx = k+SFnewTSA-1;

    if end_idx > N_theta
        break;
    end

    segmentC = detrend(theta(k : end_idx), 6); % - mean(theta(start_idx : end_idx)); Detrend removed the mean of theta
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta(k : end_idx);


    H1_cos(k) = sum(segmentC .* X1(k : end_idx)) / ((SFnewTSA)/2);
    H1_sin(k) = sum(segmentC .* Y1(k : end_idx)) / ((SFnewTSA)/2);

    H2_cos(k) = sum(segmentC .* X2(k : end_idx)) / ((SFnewTSA)/2);
    H2_sin(k) = sum(segmentC .* Y2(k : end_idx)) / ((SFnewTSA)/2);

    H3_cos(k) = sum(segmentC .* X3(k : end_idx)) / ((SFnewTSA)/2);
    H3_sin(k) = sum(segmentC .* Y3(k : end_idx)) / ((SFnewTSA)/2);

    % T_mean(k) = mean(T0D_segment);
    AmpH1_window(k) = sqrt(H1_sin(k)^2 + H1_cos(k)^2);
    AmpH2_window(k) = sqrt(H2_sin(k)^2 + H2_cos(k)^2);
    AmpH3_window(k) = sqrt(H3_sin(k)^2 + H3_cos(k)^2);
end

% --- plots

% tplot = tTheta_sync(winCentreIdx);
tplot = tTheta(1:nWinTheta);
% Combined figure with three subplots for H1, H2, H3 amplitudes
figure('Name','Harmonic Amplitudes');%);%,'NumberTitle','off');

subplot(nn,1,1);
plot(tplot, AmpH1_window, LineWidth=2); grid on; title(sprintf('H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(tplot, movmean(AmpH1_window, smoothing, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('Amp','Avg. \theta','Location', 'northwest');

subplot(nn,1,2);
plot(tplot, AmpH2_window); grid on; title(sprintf('H2 Amplitude at %.f Hz', LF2));
hold on;
plot(tplot, movmean(AmpH2_window, SFnewDissipation, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if LF3<SF/2
    subplot(nn,1,3);
    plot(tplot, AmpH3_window); grid on; 
    title(sprintf('H3 Amplitude at %.f Hz', LF3));
    hold on;
    plot(tplot, movmean(AmpH3_window, SFnewDissipation, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('Time (s)');
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    ylabel('\theta (K)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sg = sgtitle(sprintf('%.1fs Sliding-Window Harmonic Analysis using Reference Signals\n(mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


% ------------------------------------- Harmonics vs stress amplitude

% loading period in temperatue and tTemp: idx_Theta_sync(1):theta_idxE
% so the time should statrt when time is => than the time value at
% idx_Theta_sync(1) and ends at when the time value is =< theta_idxE.

AmpH1_loading = AmpH1_window(loading_window);
AmpH2_loading = AmpH2_window(loading_window);
AmpH3_loading = AmpH3_window(loading_window);


figure('Name','Harmonic Amp vs Stress Amp');%);%,'NumberTitle','off');
subplot(nn,1,1);
plot(SampInterp_x, AmpH1_loading, LineWidth=2); grid on; title(sprintf('H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(SampInterp, movmean(AmpH1_loading, smoothing, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,1,2);
plot(SampInterp_x, AmpH2_loading); grid on; title(sprintf('H2 Amplitude at %.f Hz', LF2));
hold on;
plot(SampInterp_x, movmean(AmpH2_loading, SFnewDissipation, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if LF3<SF/2
    subplot(nn,1,3);
    plot(SampInterp_x, AmpH3_loading); grid on; title(sprintf('H3 Amplitude at %.f Hz', LF3));
    hold on;
    plot(SampInterp_x, movmean(AmpH3_loading, SFnewDissipation, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window),SFnewDissipation,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    ylabel('\theta (K)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sg = sgtitle(sprintf('%.1fs Sliding-Window Harmonic Analysis using Reference Signals\n(mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% T0D: Least Square Method
clc
tref_signal = tTheta(:);
% tref_signal = (0:N_theta-1) / SF;

% --------- Precompute Hann window (for weighted LS)
applyHANN = hann(SFnewTSA);
applyHANN = applyHANN(:);
pOrder = 4;
nWinTheta = N_theta - SFnewTSA + 1;

for k = 1:nWinTheta

    end_idx = k + SFnewTSA - 1;

    if end_idx > N_theta
        break;
    end

    kIndices = k:end_idx;
    kIndices = kIndices(:);

    % --------- Signal segment
    segment = detrend(theta(kIndices), pOrder);
    % segment = theta(kIndices);
    segment = segment(:);

    t_seg = tref_signal(kIndices);

    A = [ ...
        cos(2*pi*LF*t_seg),  sin(2*pi*LF*t_seg), ...
        cos(2*pi*2*LF*t_seg),sin(2*pi*2*LF*t_seg), ...
        cos(2*pi*3*LF*t_seg),sin(2*pi*3*LF*t_seg) ...
        ];

    Aw = A .* applyHANN;
    yw = segment .* applyHANN;

    % --------- Least squares solution
    coeff = Aw \ yw;

    % --------- Extract coefficients
    a1 = coeff(1); b1 = coeff(2);
    a2 = coeff(3); b2 = coeff(4);
    a3 = coeff(5); b3 = coeff(6);

    % --------- Amplitudes
    AmpH1_LS(k) = sqrt(a1^2 + b1^2);
    AmpH2_LS(k) = sqrt(a2^2 + b2^2);
    AmpH3_LS(k) = sqrt(a3^2 + b3^2);

    % --------- Phase (optional, very useful)
    PhaseH1_LS(k) = atan2(b1, a1);
    PhaseH2_LS(k) = atan2(b2, a2);
    PhaseH3_LS(k) = atan2(b3, a3);

end

% --------- Time reference
winCentreIdx = (1:nWinTheta) + floor(SFnewTSA/2);

% -------------- Paper Figure
figure('Name','LS H1 Amplitude vs Stress'); hold on; grid on
title('LS H1 Amplitude')

h = plot(SampInterp_x, AmpH1_LS, 'ok','MarkerSize',4,'DisplayName','H1 Raw');
set(h, 'MarkerFaceColor', h.Color);

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (K)')

xlim([0 210])
xticks(0:20:220)
xtickangle(0)

ylim([0 0.4])
yticks(0:0.1:0.4)
set(gcf, 'Position', [688 535 657 400])
set(gca, 'FontSize', 18)
box on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


figure('Name','T0D: LS H2 & H3 Amplitudes vs Stress'); hold on; grid on
title(sprintf('T0D: LS H2 and H3 Harmonic Amplitudes - porder = %0.0f', pOrder))

h = plot(SampInterp_x, AmpH2_LS*1e3, 'og','MarkerSize',4,'DisplayName','H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampInterp_x, AmpH3_LS*1e3, 'ob','MarkerSize',4,'DisplayName','H3 Raw');
set(h, 'MarkerFaceColor', h.Color);

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (mK)')

xlim([0 210])
xticks(0:20:220)
xtickangle(0)

ylim([0 4])
yticks(0:1:4)
set(gcf, 'Position', [688 535 657 400])
set(gca, 'FontSize', 12)
box on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% T0D: Frequency Adaptive Least Square Method
% clc
tref_signal = tTheta(:);
% tref_signal = (0:N_theta-1) / SF;
nWinTheta = N_theta - SFnewTSA + 1;
applyHANN = hann(SFnewTSA);
applyHANN = applyHANN(:);

fSearch = linspace(LF-BW, LF+BW, 15);   % frequency search grid

for k = 1:nWinTheta

    end_idx = k + SFnewTSA - 1;

    if end_idx > N_theta
        break;
    end

    kIndices = (k:end_idx)';
    segment = detrend(theta(kIndices), 6);
    % segment = theta(kIndices);
    segment = segment(:);
    t_seg = tref_signal(kIndices);

    bestErr = inf;

    % --------- Frequency search
    for ftest = fSearch

        A = [ ...
            cos(2*pi*ftest*t_seg),   sin(2*pi*ftest*t_seg), ...
            cos(2*pi*2*ftest*t_seg),sin(2*pi*2*ftest*t_seg), ...
            cos(2*pi*3*ftest*t_seg),sin(2*pi*3*ftest*t_seg) ...
            ];

        % Weighted LS (efficient form)
        Aw = A .* applyHANN;
        yw = segment .* applyHANN;

        coeff = Aw \ yw;

        residual = norm(yw - Aw*coeff);

        if residual < bestErr
            bestErr = residual;
            bestCoeff = coeff;
            bestFreq(k) = ftest;
        end
    end

    % --------- Extract coefficients
    a1 = bestCoeff(1); b1 = bestCoeff(2);
    a2 = bestCoeff(3); b2 = bestCoeff(4);
    a3 = bestCoeff(5); b3 = bestCoeff(6);

    % --------- Amplitudes
    AmpH1_LSFA(k) = sqrt(a1^2 + b1^2); % FA = Frequency Addaptive
    AmpH2_LSFA(k) = sqrt(a2^2 + b2^2);
    AmpH3_LSFA(k) = sqrt(a3^2 + b3^2);

    % --------- Phases
    PhaseH1_LSFA(k) = atan2(b1, a1);
    PhaseH2_LSFA(k) = atan2(b2, a2);
    PhaseH3_LSFA(k) = atan2(b3, a3);

end

winCentreIdx = (1:nWinTheta) + floor(SFnewTSA/2);

%% --- T0D: Frequency-Adaptive Least Square Method Peak Tracking Only ---
% ------------- Best Frequency Track

bestFreq_H1 = bestFreq;        % 1f
bestFreq_H2 = 2 * bestFreq;    % 2f
bestFreq_H3 = 3 * bestFreq;    % 3f
figure('Name','T0D: Adaptive Frequency vs Stress Amplitude');

tiledlayout(3,1)

% ===================== H1 =====================
nexttile; hold on

plot(SampInterp_x, bestFreq_H1, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','b', 'MarkerEdgeColor','b', ...
    'DisplayName','Raw');

plot(SampInterp_x, movmean(bestFreq_H1,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
title(sprintf('H1 Frequency Evolution (~%d Hz)', LF))
grid on
legend('Location','best')

% ===================== H2 =====================
nexttile; hold on

plot(SampInterp_x, bestFreq_H2, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','r', 'MarkerEdgeColor','r', ...
    'DisplayName','Raw');

plot(SampInterp_x, movmean(bestFreq_H2,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
title(sprintf('H2 Frequency Evolution (~%d Hz)', 2*LF))
grid on
legend('Location','best')

% ===================== H3 =====================
nexttile; hold on

plot(SampInterp_x, bestFreq_H3, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','g', 'MarkerEdgeColor','g', ...
    'DisplayName','Raw');

plot(SampInterp_x, movmean(bestFreq_H3,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
xlabel('\sigma_{amp} (MPa)')
title(sprintf('H3 Frequency Evolution (~%d Hz)', 3*LF))
grid on
legend('Location','best')

% --------- Formatting
set(gcf, 'Position', [650 200 650 700])
set(findall(gcf,'-property','FontSize'),'FontSize',12)

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% T0D: Plots of Frequency-Adaptive LS Harmonic Amplitudes

theta_plot = theta(winCentreIdx);

figure('Name','T0D: Adaptive LS Harmonics (Amplitude)');
tiledlayout(3,1)

% ---------- H1
nexttile; hold on
yyaxis left
plot(SampInterp_x, theta_plot, 'b', 'LineWidth', 2)
ylabel('\theta (K)')

yyaxis right
plot(SampInterp_x, AmpH1_LSFA, 'r')
plot(SampInterp_x, movmean(AmpH1_LSFA,5),'k','LineWidth',2)
ylabel('Amp (K)')
% title(sprintf('H1 @ ~%.2f Hz', LF))
title(sprintf('T0D: Frequency Adaptive LS Max Amp %.f\\pm%.1f Hz', LF, BW));
grid on

% ---------- H2
nexttile; hold on
yyaxis left
plot(SampInterp_x, theta_plot, 'b', 'LineWidth', 2)

yyaxis right
plot(SampInterp_x, AmpH2_LSFA, 'r')
plot(SampInterp_x, movmean(AmpH2_LSFA,5),'k','LineWidth',2)
% set(gca,'YScale','log')
% title(sprintf('H2 @ ~%.2f Hz', 2*LF))
title(sprintf('T0D: Frequency Adaptive LS Max Amp %.f\\pm%.1f Hz', LF*2, BW));
grid on

% ---------- H3
nexttile; hold on
yyaxis left
plot(SampInterp_x, theta_plot, 'b', 'LineWidth', 2)

yyaxis right
plot(SampInterp_x, AmpH3_LSFA, 'r')
plot(SampInterp_x, movmean(AmpH3_LSFA,5),'k','LineWidth',2)
% set(gca,'YScale','log')
% title(sprintf('H3 @ ~%.2f Hz', 3*LF))
title(sprintf('T0D: Frequency Adaptive LS Max Amp %.f\\pm%.1f Hz', LF*3, BW));
xlabel('\sigma_{amp} (MPa)')
grid on

set(gcf,'Position',[600 200 700 800])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% ############   Force and Theta Segmentation  ################
% **************************************************************
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

% ------------------- Segmentation of theta
% [peakVals, peakIdx] = findpeaks(theta);
% [troughVals_neg, troughIdx] = findpeaks(-theta);
theta_MinPeakProminence = 0.03;
[peakVals, peakIdx] = findpeaks(theta,'MinPeakProminence',theta_MinPeakProminence);
[troughVals_neg, troughIdx] = findpeaks(-theta,'MinPeakProminence',theta_MinPeakProminence);
troughVals = -troughVals_neg;   % restore original sign

figure('Name','Segments: Theta Peaks and Troughs');
plot(theta, 'k', 'LineWidth', 1.2); hold on;
title(sprintf('Segments: Theta Peaks and Troughs %s',test_details))
plot(peakIdx, peakVals, 'ro', 'MarkerFaceColor', 'r');
plot(troughIdx, troughVals, 'bo', 'MarkerFaceColor', 'b');
xlabel('Frame Index');
ylabel('\theta (K)');
legend('\theta', 'Peaks', 'Troughs','Location', 'best');
grid on;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


switch test_details

    case {
            'SS304L 20251118 Test1 Take1',...
            'SS304L 20251118 Test1 Take2',...
            'SS304L 20251118 Test2 Take7',...
            'SS304L 20251118 Test2 Take8',...
            'SS304L 20251118 Test2 Take9',...
            'SS304L 20251118 Test2 Take10',...
            'SS304L 20251118 Test2 Take11',...
            'SS304L 20251118 Test2 Take12',...
            'SS304L 20251118 Test2 Take13',...
            'SS304L 20251118 Test2 Take14',...
            }
        % Only why test is test2_take13
        DiffTroughIdx= diff(troughIdx);
        MeanDiffTroughIdx = mean(DiffTroughIdx);
        segThresh = 2 * MeanDiffTroughIdx;
        segTroughIdxEnd = find(DiffTroughIdx > segThresh);
        segTroughIdxStart = segTroughIdxEnd + 1;


        % Map back to theta index space
        theta_segIdxE = troughIdx(segTroughIdxEnd);
        % theta_segIdxE = troughIdx(segTroughIdxEnd);

        % Remove closely spaced jumps
        theta_segIdxE = theta_segIdxE([true; diff(theta_segIdxE) > 20]);

        % Segment boundaries
        theta_segIdxE = [theta_segIdxE; numel(theta)];

        % Map back to theta index space
        theta_segIdxS = troughIdx(segTroughIdxStart); %

    otherwise

        % ------------------------------ theta: Finding segment End indices
        DD_troughVals = diff(detrend(troughVals,6)); % In between each file jump diff(theta trough values) increases significantly (DD = Detrend and Diff)
        figure('Name','Segments: Theta troughs segments'); plot(DD_troughVals); grid; title('diff(detrend(troughVals,6))')
        ThreshTroughTheta = abs(mean(DD_troughVals))*1000;

        idxE = find(DD_troughVals > ThreshTroughTheta);
        valE = DD_troughVals(idxE);

        troughIdxE = false(size(valE));
        troughIdxE(1) = true;       % always keep first value

        currentValE = valE(1);

        for k = 2:length(valE)
            if valE(k) > currentValE
                troughIdxE(k) = true;
                currentValE = valE(k);   % update reference
            end
        end

        val_segE = valE(troughIdxE);

        segIdxE_filtered = idxE(troughIdxE);

        % Map back to theta index space
        theta_segIdxE = troughIdx(segIdxE_filtered);

        % Remove closely spaced jumps
        theta_segIdxE = theta_segIdxE([true; diff(theta_segIdxE) > 20]);

        % Segment boundaries
        theta_segIdxE = [theta_segIdxE; numel(theta)];

        % ---------------------------------- theta: Finding segment start indices
        idxS = find(DD_troughVals < -ThreshTroughTheta);
        valS = DD_troughVals(idxS);
        troughIdxS = false(size(valS));
        troughIdxS(1) = true;        % always keep first value

        currentValS = valS(1);

        for k = 2:length(valS)
            if valS(k) < currentValS
                troughIdxS(k) = true;
                currentValS = valS(k);   % update reference
            end
        end

        troughIdxS = idxS(troughIdxS) + 1;

        % Map back to theta index space
        theta_segIdxS = troughIdx(troughIdxS + 1); % I tried to start the segment
        % after some cycles when a new file starts, however, the change in
        % temperature is significant as compare the the last cycle of the last file,
        % which creats steps in theta, and not good results achieved.
end

% Remove closely spaced jumps
theta_segIdxS = theta_segIdxS([true; diff(theta_segIdxS) > 20]);

% Segment boundaries
theta_segIdxS = [1; theta_segIdxS];

% Calculate segment lengths
segLength = theta_segIdxE - theta_segIdxS + 1;

% Logical mask for valid segments
SegLengthCheck = segLength >= 50;

% Keep only valid segments
theta_segIdxS = theta_segIdxS(SegLengthCheck);
theta_segIdxE = theta_segIdxE(SegLengthCheck);

N_segTheta = numel(theta_segIdxE);
% 
maxNthetaSeg = max(theta_segIdxE - theta_segIdxS + 1); % to find the length of the longest segment
indices = nan(maxNthetaSeg, N_segTheta);
thetaSegs = nan(maxNthetaSeg, N_segTheta);
tThetaSegs = nan(maxNthetaSeg, N_segTheta);

for s = 1:N_segTheta
    idx = theta_segIdxS(s):theta_segIdxE(s);
    n = numel(idx);
    indices(1:n, s) = idx;    
    thetaSegs(1:n, s) = theta(idx);    
    tThetaSegs(1:n, s) = tTheta(idx);    
end

indices = indices(~isnan(indices));

thetaC = theta(indices); % Continuous Theta thetaC
tThetaSegsVector = tTheta(indices);
thetaSegsVector = theta(indices); % Only for saving purpose; otherwise it is same as thetaC

T_noOffsetC_fatigue = T_noOffset_fatigue(indices);
TrefUpC_fatigue = T_ref_up(indices);
TrefBotC_fatigue = T_ref_bottom(indices);
T0DC_fatigue = T0D_fatigue(indices);

%% =============================================
% ==============================================
% ---- Calculating and Plotting Theta Amplitude
% ==============================================
theta_MinPeakProminence = 0.03;

% --- Peak detection ---
[peakVals, peakIdx] = findpeaks(thetaC, ...
    'MinPeakProminence', theta_MinPeakProminence);

% --- Trough detection ---
[troughVals_neg, troughIdx] = findpeaks(-thetaC, ...
    'MinPeakProminence', theta_MinPeakProminence);

troughVals = -troughVals_neg;

% --- Plot raw signal with extrema ---
figure('Name','Segments: ThetaC Peaks and Troughs');
plot(thetaC, 'k', 'LineWidth', 1.2); hold on;
title(sprintf('Segments: ThetaC Peaks and Troughs %s', test_details))

plot(peakIdx, peakVals, 'ro', 'MarkerFaceColor', 'r');
plot(troughIdx, troughVals, 'bo', 'MarkerFaceColor', 'b');

xlabel('Frame Index');
ylabel('\theta (K)');
legend('\theta', 'Peaks', 'Troughs','Location', 'northwest');
grid on;
set(gcf,'Position',[600 200 580 450])

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');
figureName = strrep(figureName, ' ', '_');
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% =========================================================
% --- TRUNCATION
% =========================================================

mylength = min(numel(peakVals), numel(troughVals));

peakVals_trim   = peakVals(1:mylength);
troughVals_trim = troughVals(1:mylength);

% =========================================================
% --- AMPLITUDE COMPUTATION ---
% =========================================================

thetaAmplitude = (peakVals_trim - troughVals_trim) / 2;

% =========================================================
% --- PLOT RESULTS ---
% =========================================================

figure('Name','ThetaC Amplitude');
plot(thetaAmplitude, 'm', 'LineWidth', 1.5);

title(sprintf('ThetaC and ThetaC Amplitude %s', test_details));
xlabel('Cycle Index');
ylabel('Temperature / Amplitude (K)');
legend('\theta_a','Location', 'northwest');
grid on;
set(gcf,'Position',[600 200 580 450])

%
peakIdx_trim    = peakIdx(1:mylength);
thetaAmplitudeFull = NaN(size(thetaC));
thetaAmplitudeFull(peakIdx_trim) = thetaAmplitude;

figure('Name','ThetaC with Cycle-wise Amplitude');
yyaxis left
plot(thetaC, 'k', 'LineWidth', 1.2);
ylabel('\theta (K)');

yyaxis right
plot(thetaAmplitudeFull, 'mo', ...
    'LineWidth', 1.5, ...
    'MarkerFaceColor', 'm');
ylabel('Cycle Temperature Amplitude (K)');

title(sprintf('ThetaC and Cycle-wise Amplitude %s', test_details));
xlabel('Frame Index');
grid on;

legend('\theta', '\theta Amplitude', 'Location', 'northwest');
set(gcf,'Position',[600 200 580 450])

%% ------------------- Segmentation of force

% minProminence = 150;        % force prominence Newoton
minSegGap = 300;           % minimum gap in samples 

F_fatigue = F_fatigue(:);

% --- Detect force peaks ---
[Fpk, Fpk_loc] = findpeaks(F_fatigue, ...
    'MinPeakProminence', minProminence);

% --- Ensure boundaries included ---
if Fpk_loc(1) ~= 1
    Fpk = [F_fatigue(1); Fpk];
    Fpk_loc = [1; Fpk_loc];
end

if Fpk_loc(end) ~= numel(F_fatigue)
    Fpk = [Fpk; F_fatigue(end)];
    Fpk_loc = [Fpk_loc; numel(F_fatigue)];
end

% --- Detect large gaps between peaks ---
d_Fpk_loc = diff(Fpk_loc);

Fpk_segIdxE = find(d_Fpk_loc > minSegGap);
Fpk_segIdxS = Fpk_segIdxE + 1;

% --- Segment boundaries in force index space ---
F_segS_Idx = [1; Fpk_loc(Fpk_segIdxS)];
F_segE_Idx = [Fpk_loc(Fpk_segIdxE); numel(F_fatigue)];

F_fatigue = F_fatigue(:);

figure('Name','Segments: Force Segments Start End');
plot(F_fatigue, 'k', 'LineWidth', 1.2);
hold on;

% --- Plot Segment Start Indices ---
plot(F_segS_Idx, F_fatigue(F_segS_Idx), ...
    'go', 'MarkerFaceColor', 'g', 'MarkerSize', 6);

% --- Plot Segment End Indices ---
plot(F_segE_Idx, F_fatigue(F_segE_Idx), ...
    'mo', 'MarkerFaceColor', 'm', 'MarkerSize', 6);

xlabel('Frame Index');
ylabel('F_{fatigue}');
legend('F_{fatigue}', 'Segment Start', 'Segment End', 'Location','best');
grid on;

N_segF = numel(F_segE_Idx);

if N_segF ~= N_segTheta
    error('Number of segments in theta and force are not equal.')
end

maxN = max(F_segE_Idx - F_segS_Idx + 1);

ForceSegs = nan(maxN, N_segF);
tFSegs = nan(maxN, N_segF);

for s = 1:N_segF
    idx = F_segS_Idx(s):F_segE_Idx(s);

    ForceSegs(1:numel(idx), s) = F_fatigue(idx);
    tFSegs(1:numel(idx), s) = tF_fatigue(idx);
end

tF_Seg_Vector = tFSegs(~isnan(tFSegs));
ForceC = ForceSegs(~isnan(ForceSegs));



%% $$$$$$$$$$$$$$$$$$$$          Continuous             $$$$$$$$$$$$$$$$$$$$$$
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%----------- Continuous Force and Theta
% figure('Name','Continuous Force and Theta')
% plot(tF_Seg_Vector,ForceSegsVector); grid
% title(sprintf('Continuous Force and Theta - %s', test_details))
% ylabel('Force (N)')
% hold on
% yyaxis right
% tTheta_Seg_VectorX = tTheta_Seg_Vector - tTheta_Seg_Vector(1); % to synchronize with force time
% plot(tTheta_Seg_VectorX,thetaSegsVector)
% ylabel('\theta (K)')
% xlabel('Time (s)')
% legend('Force','\theta')


% --------------- Building new time vectors for force and theta

tFC = (0:1/SF_F:(numel(ForceC)-1)/SF_F) + tF_fatigue(1); %tTheta(1);
tFC = tFC(:);
% tThetaC = 0:1/SF:(numel(thetaC)-1)/SF;
% tThetaC = (0:1/SF:(numel(thetaC)-1)/SF) + tTheta(1); % to synch with the experimental temperature time
tThetaC = linspace(tTheta(1), tFC(end), numel(thetaC));
tThetaC = tThetaC(:);

% ----------- Continuous Force and Theta
figure('Name','Continuous Force and Theta')
plot(tFC,ForceC); grid
title(sprintf('Continuous Force and Theta - %s', test_details))
ylabel('Force (N)')
hold on
yyaxis right
tTheta_CX = tThetaC ;%- tThetaC(1); % to synchronize with force time
plot(tTheta_CX,thetaC)
ylabel('\theta (K)')
xlabel('Time (s)')
legend('Force','\theta')

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --------------- Continuous: Stress Amplitude from Continuous Force

[FpkC, locs_FpkC] = findpeaks(ForceC, 'MinPeakProminence', minProminence);
t_FpkC = tFC(locs_FpkC);


[FtrC, locs_FtrC] = findpeaks(-ForceC, 'MinPeakProminence', minProminence);
FtrC = -FtrC;
t_FtrC = tFC(locs_FtrC);

n = min(numel(FpkC), numel(FtrC));
FpkC = FpkC(1:n);
FtrC = FtrC(1:n);
t_FpkC = t_FpkC(1:n);
t_FtrC  = t_FtrC(1:n);

% ================================================================================
% Calculating slope of high and low forces for the Stress amplitude calculation

% Robust linear regression
[bH, statsH] = robustfit(t_FpkC(:), FpkC(:));
[bL, statsL] = robustfit(t_FtrC(:), FtrC(:));

% Extract slope/intercept
aH_C = bH(1);
mH_C = bH(2);

aL_C = bL(1);
mL_C = bL(2);

% Residuals
resH = statsH.resid;
resL = statsL.resid;

% RMSE
RMSE_H = round(sqrt(mean(resH.^2)),2);
RMSE_L = round(sqrt(mean(resL.^2)),2);

fprintf('RMSE (Highs): %.2f N\n', RMSE_H);
fprintf('RMSE (Lows) : %.2f N\n', RMSE_L);

% Fitted lines
Fhigh_fitC = mH_C * tFC + aH_C;
Flow_fitC  = mL_C * tFC + aL_C;

% R² calculation
SS_res_H = sum((FpkC - (aH_C + mH_C*t_FpkC)).^2);
SS_tot_H = sum((FpkC - mean(FpkC)).^2);
R2_H = 1 - SS_res_H/SS_tot_H;

SS_res_L = sum((FtrC - (aL_C + mL_C*t_FtrC)).^2);
SS_tot_L = sum((FtrC - mean(FtrC)).^2);
R2_L = 1 - SS_res_L/SS_tot_L;

figure('Name', 'Continuous: Robust Linear Force Fits');
hold on; grid on;

% Plot data
scatter(t_FpkC, FpkC, 40, 'r', 'filled');
scatter(t_FtrC,  FtrC,  40, 'b', 'filled');

% Plot fits
plot(tFC, Fhigh_fitC, '-g', 'LineWidth', 2);
plot(tFC, Flow_fitC,  '-m', 'LineWidth', 2);

xlabel('Time');
ylabel('Force');
title(sprintf('Continuous: Robust Linear Fits for F_{high} and F_{low} - %s', test_details));

legend('Fhighs data','Flows data','High fit','Low fit','Location', 'northwest');

% Get axes limits
ax = gca;
xMin = ax.XLim(1);
xMax = ax.XLim(2);
yMin = ax.YLim(1);
yMax = ax.YLim(2);

% Offset for text slightly below the top
yOffset = 0.25*(yMax - yMin);

% Display fit equations below the legend box (northwest)
text(xMin + 0.02*(xMax-xMin), yMax - yOffset, ...
    sprintf('Fhighs = %.3f + %.3f*t   \n(R^2 = %.3f)', aH_C, mH_C, R2_H), ...
    'Color','g','FontSize',12,'VerticalAlignment','top');

text(xMin + 0.02*(xMax-xMin), yMax - 1.5*yOffset, ...
    sprintf('Flows = %.3f + %.3f*t   \n(R^2 = %.3f)', aL_C, mL_C, R2_L), ...
    'Color','m','FontSize',12,'VerticalAlignment','top');

hold off;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --- Compute Force Amplitude ---
Famp_fitC = (Fhigh_fitC - Flow_fitC)/2;

% --- Compute Stress Amplitude ---
SampC = Famp_fitC / xarea / 1e6;  % in MPa

%--- Plot Fit Forces ---
figure('Name','Continuous: Force vs Time');
hold on; grid on;
plot(tFC, Fhigh_fitC, '-r', 'LineWidth', 2);
plot(tFC, Flow_fitC,  '-b', 'LineWidth', 2);
plot(tFC, Famp_fitC, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Force (N)');
title(sprintf('Continuous: Fhighs, Flows, Famp vs Time - %s', test_details));
legend('Fhigh fit','Flow fit','Famp fit','Location','northwest');
hold off;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --- Plot Stress -----
figure('Name','Continuous: Stress vs Time');
hold on; grid on;
plot(tFC, Fhigh_fitC/xarea/1e6, '-r', 'LineWidth', 2);
plot(tFC, Flow_fitC/xarea/1e6,  '-b', 'LineWidth', 2);
plot(tFC, SampC, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Stress (MPa)');
title(sprintf('Continuous: Stress vs Time - %s', test_details));
legend('Shighs','Slows','Samp','Location','northwest');
hold off;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



% Interpolate stress amplitude to theta time vector
SampCinterp = interp1(tFC, SampC, tThetaC, 'linear');
SampCinterp = SampCinterp(:);

dSamp = SampInterp(1) - SampCinterp(1);

if dSamp > 0
    SampCinterp = SampCinterp + dSamp;
elseif dSamp < 0
    SampInterp = SampInterp + abs(dSamp);
end

figure('Name','Checking Samp interpolation')
plot(tFC, SampC, LineWidth=2);
title('Checking Continuous Samp Interpolation', test_details)
hold on;
plot(tThetaC,SampCinterp, '--r',LineWidth=2);
legend ('SampC','SampC interpolated','Location', 'northwest');
ylabel('Stess Amplitude (MPa)')
xlabel('Time (s)')
grid on
hold off;


%% Continuous: mechanical dissipation d1 calculation using continuous theta
THSxx = nan(length(thetaC),3);
d1Cxx = nan(length(thetaC),3);
D1Cxx = nan(length(thetaC),3);
meanThetaC = nan(length(thetaC),3);
count = 0;
for myWindowSize = 1:4:9     % Window size in sec
    count = count + 1;
SFnewDissipationC = round(myWindowSize * SF, 9);

movmean_thetaC = movmean(thetaC, SFnewDissipationC, 'endpoints','fill');
meanThetaC(:,count) = movmean_thetaC;


% Continuous: Calculation of averaged Thermoelastic heat source S_TE
% Formula: STE = rho * C * ( d(movmean_thetaC_initial)/dt + (movmean_thetaC_initial)/tau )

% -------------------- Time derivative --------------------
d_movmean_thetaC = gradient(movmean_thetaC, tThetaC);

% % -------------------- INPUTS --------------------
% t_limitS = 30.6;   % corresponding to 30 MPa
% t_limitE = 66.775;   % corresponding to 57.465 MPa
% 
% % -------------------- STEP 3: Limit to thermoelastic region --------------------
% idx_limit = (tThetaC >= t_limitS) & (tThetaC <= t_limitE);


% -------------------- INPUTS --------------------
Samp_limitS = min(SampCinterp);   % MPa % start of test
Samp_limitE = 35;                 % MPa % This is the stress amplitude point (~35 MPa) where specimen thermoelastic cooling stopped and temperature stablised. See the theta and Averaged-theta vs Samp plot

% -------------------- STEP 3: Limit to thermoelastic region --------------------
idx_limit = (SampCinterp >= Samp_limitS) & ...
            (SampCinterp <= Samp_limitE);

% -------------------- STEP 4: Remove NaNs --------------------
valid = idx_limit & ~isnan(movmean_thetaC) & ~isnan(d_movmean_thetaC);

theta_valid = movmean_thetaC(valid);
dtheta_valid = d_movmean_thetaC(valid);

% -------------------- STEP 5: Instantaneous STE --------------------
STE_inst = rho * C * ( dtheta_valid + theta_valid ./ tau );

% -------------------- STEP 6: Average STE (HSR estimate) --------------------
STE_HSR(1,count) = mean(STE_inst, 'omitnan');

% STE_HSR = median(STE_inst);

% -------------------- OUTPUT --------------------
fprintf('STE_HSR (up to 36 MPa) = %.4f W/m^3\n', STE_HSR);

% % ---------- STE calculation from TSA formula
% % STE = - alpha * Tinit * d(Samp)/dt

% -------------------- STEP 2: Stress derivative --------------------
Samp_Pa = SampCinterp * 1e6;
dSamp_dt = gradient(Samp_Pa, tThetaC);

% -------------------- STEP 3: Valid region --------------------
valid = idx_limit & ~isnan(dSamp_dt);

% -------------------- STEP 4: Instantaneous STE (vector) --------------------
Tinit = mean(T0D(Ti_idxS : Ti_idxE));
STE_TSA_inst = nan(size(tThetaC));
STE_TSA_inst(valid) = - alpha * Tinit .* dSamp_dt(valid);
STE_TSA(1,count) = mean(STE_TSA_inst(valid), 'omitnan');
fprintf('STE_TSA (up to 36 MPa) = %.4f W/m^3\n', STE_TSA);

% % --------- Symmetric percentage difference
den = (STE_TSA(count) + STE_HSR(count)) / 2;
valid = den ~= 0;
perc_diff_sym = nan(size(STE_TSA));
perc_diff_sym(valid) = (STE_TSA(valid) - STE_HSR(valid)) ./ den(valid) * 100


% ------------------------------ tau(theta)  [Continuous Case]
% Check if tau_table exists and is not empty
% if exist('tau_table','var') && ~isempty(tau_table)
% 
%     % Sort tau table
%     [tauThetaSorted, idx] = sort(tau_table.Theta);
%     tauSorted = tau_table.Tau(idx);
% 
%     % Initialise tau array
%     tau_exp = NaN(size(movmean_thetaC));
% 
%     % Identify theta bounds
%     theta_min = tauThetaSorted(1);
%     theta_max = tauThetaSorted(end);
% 
%     % Case 1: theta below minimum -> use minimum tau
%     idx_low = movmean_thetaC <= theta_min;
%     tau_exp(idx_low) = tauSorted(1);
% 
%     % Case 2: theta above maximum -> use maximum tau
%     idx_high = movmean_thetaC >= theta_max;
%     tau_exp(idx_high) = tauSorted(end);
% 
%     % Case 3: theta within bounds -> interpolate
%     idx_mid = ~(idx_low | idx_high);
%     tau_exp(idx_mid) = interp1( ...
%         tauThetaSorted, ...
%         tauSorted, ...
%         movmean_thetaC(idx_mid), ...
%         'linear' );
% 
%     figure('Name','tau vs movmean ThetaC and tau Theta');
%     plot(movmean_thetaC, tau_exp, '-r','DisplayName','\tau vs \theta_{mean,C}');
%     grid on
%     title('\tau vs \thetaC')
%     hold on
%     plot(tau_table.Theta,tau_table.Tau, '.b', 'DisplayName','tau table');
%     legend
% 
% else
    % ---- for constant tau value ----
    % tau_exp = tau * ones(size(movmean_thetaC));
% end

tau_exp = tau * ones(size(movmean_thetaC));

% --------------------------------------- d1C
% d1C = nan(size(thetaC));
% kd = (SFnewDissipation - 1) / 2;
% 
% for k = SFnewDissipation : length(thetaC) - (SFnewDissipation - 1)
%     d1C(k) = rho * C * ( ...
%         (movmean_thetaC(k+kd) - movmean_thetaC(k-kd)) / ...
%         (tThetaC(k+kd) - tThetaC(k-kd)) + ...
%         movmean_thetaC(k) / tau_exp(k) );
% end
% % DD = d1C/1000;
% d1C = d1C - STE_HSR; 

THS = nan(size(thetaC)); % THS = Total Heat Sources
kd = (SFnewDissipationC - 1) / 2;

for k = SFnewDissipationC : length(thetaC) - (SFnewDissipationC - 1)
    THS(k) = rho * C * ( ...
        (movmean_thetaC(k+kd) - movmean_thetaC(k-kd)) / ...
        (tThetaC(k+kd) - tThetaC(k-kd)) + ...
        movmean_thetaC(k) / tau_exp(k) );
end

THSxx(:,count) = THS/1000; % Converting units into kilo

d1C = THS - STE_HSR(1,count); 
d1C = d1C/1000; % Converting units into kilo
d1Cxx(:,count) = d1C;

D1C = d1C / LF; % Normalize by loading frequency
D1Cxx(:,count) = D1C;
end


%%        Continuous: Dissipatin Plots
% ----------- SampC, ThetaC vs Time -----
figure('Name','Continuous: SampC and ThetaC vs Time'); 
plot(tThetaC, SampCinterp, '-k', LineWidth=3); hold on; % amplitude fit
ylabel('\sigma_{amp} (MPa)');
title(sprintf('Continuous: Samp, theta, Avg.Theta vs Time - %s', test_details));
yyaxis right
plot(tThetaC, thetaC, '-r', LineWidth=3); grid on; 
plot(tThetaC, meanThetaC(:,1),'-r', linewidth= 2); 
plot(tThetaC, meanThetaC(:,2),'g-',linewidth= 2); 
plot(tThetaC, meanThetaC(:,3),'-b',linewidth= 2); 
xlabel('Time (s)'); ylabel('\theta (K)');
legend('\sigma_{amp}','\theta','\theta_{avg-1s}','\theta_{avg-5s}','\theta_{avg-9s}','Location','northwest');
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ------------------ thetaC, Avg.ThetaC vs SampC
figure('Name', 'Continuous: theta, Avg.Theta vs SampC');
plot(SampCinterp, thetaC, '-r', LineWidth=5); hold on; %
plot(SampCinterp, meanThetaC(:,1),'-k', linewidth= 2); grid
plot(SampCinterp, meanThetaC(:,2),'g-',linewidth= 2); 
plot(SampCinterp, meanThetaC(:,3),'-b',linewidth= 2); 
xlabel('\sigma_{amp} (MPa)');
ylabel('(\theta) (K)');
title(sprintf('Continuous: Theta, Averged theta vs Stress Amplitude - %s', test_details));
legend('\theta','\theta_{avg-1s}','\theta_{avg-5s}','\theta_{avg-9s}','Location','northwest');
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ------------------ THS & stress amplitude vs Time
figure('Name','Continuous: THS and SampC vs Time')
plot(tThetaC, THSxx(:,1),'-r', linewidth= 5); grid
hold on
plot(tThetaC, THSxx(:,2),'g-',linewidth= 2); 
plot(tThetaC, THSxx(:,3),'-b',linewidth= 2); 
title(char(sprintf('Continuous: THS, and Samp vs Time - %s', test_details)));
ylabel('Total Heat Source ⟨s⟩ (kW·m^{-3})');
xlabel('Time (s)')
yyaxis right;
plot(tFC, SampC, '-.m', LineWidth=2)
ylabel('\sigma_{amp} (MPa)');
ax = gca;
ax.YAxis(2).Color = 'm';
legend('THS_{1s}','THS_{5s}','THS_{9s}', '\sigma_{amp}','Location', 'northwest');
grid on;
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ---------------- THS vs SampC
figure('Name', 'Continuous: THS vs Samp');
plot(SampCinterp, THSxx(:,1),'-k', linewidth= 2); grid
hold on
plot(SampCinterp, THSxx(:,2),'g-',linewidth= 2); 
plot(SampCinterp, THSxx(:,3),'-b',linewidth= 2); 
xlabel('\sigma_{amp} (MPa)');
ylabel('Total Heat Source ⟨s⟩ (kW·m^{-3})');
title(sprintf('Total Heat Source vs Stress Amplitude - %s', test_details));
legend('THS_{1s}','THS_{5s}','THS_{9s}', 'Location', 'northwest');
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ---------------- d1C vs SampC
figure('Name', 'Continuous: d1C vs SampC');
plot(SampCinterp, d1Cxx(:,1),'-r', linewidth= 2); grid
hold on
plot(SampCinterp, d1Cxx(:,2),'g-',linewidth= 2); 
plot(SampCinterp, d1Cxx(:,3),'-b',linewidth= 2); 
xlabel('\sigma_{amp} (MPa)');
ylabel('Mechanical Dissipation ⟨d_1⟩ (kW·m^{-3})');
title(sprintf('Continuous: d_1 vs Stress Amplitude - %s', test_details));
legend('d_1_{-1s}','d_1_{-5s}','d_1_{-9s}', 'Location', 'northwest');
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ---------------- D1C vs SampC
figure('Name', 'Continuous: D1C vs Samp');
plot(SampCinterp, D1Cxx(:,1),'.r', linewidth= 2); grid
hold on
plot(SampCinterp, D1Cxx(:,2),'.g',linewidth= 2); 
plot(SampCinterp, D1Cxx(:,3),'.b',linewidth= 2); 
xlabel('\sigma_{amp} (MPa)');
ylabel('Mechanical Dissipation per Cycle ⟨D_1⟩ (kJ·m^{-3}/cycle)');
title(sprintf('Continuous: D_1 vs Stress Amplitude - %s', test_details));
legend('D_1_{-1s}','D_1_{-5s}','D_1_{-9s}', 'Location', 'northwest');
set(gcf, 'Position', [688 535 580 450])
% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ylabel('Heat Density per Cycle ⟨{\its}_{c}⟩ (kJ·m^{-3}/cycle)', 'Interpreter', 'tex')
%% Continuous: d1 and D1 Plotting section

% --- d1 & stress amplitude vs Time
figure('Name','Continuous: d1C and SampC vs Time')
plot(tThetaC, d1C, '.b', 'LineWidth', 1.5); % in kW/m3
title(char(sprintf('Continuous: d1, and Samp vs Time (%0.0fs Window) %s', ...
    windowDissipation, test_details)));
ylabel('d1 - Mechanical Dissipation (kW/m^3)');
xlabel('Time (s)')
yyaxis right;
plot(tFC, SampC, '-.m', LineWidth=2)
ylabel('Stress Amplitude (MPa)');
ax = gca;
ax.YAxis(2).Color = 'm';
legend('d1', '\sigma_{amp}','Location', 'northwest');
grid on;

% --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));


% ---- d1, Theta, and Avg.Theta vs stress amplitude
figure('Name','Continuous: d1C, Theta, and Avg.Theta  vs SampC')
plot(SampCinterp, thetaC,'-r');%, linewidth = 2)
hold on
plot(SampCinterp, movmean_thetaC, '-g', linewidth = 1.5)
ylabel('\theta (K)')
xlabel('\sigma_{amp} (MPa)');

yyaxis right
plot(SampCinterp, d1C, '.b');
title(char(sprintf('Continuous: d1C, theta, and Avg. theta vs Samp (%0.0fs Window) %s', windowDissipation, test_details)));
ylabel('d1 - Mechanical Dissipation (kW/m^3)');
ax = gca;
ax.YAxis(2).Color = 'b';
legend('\theta','Avg. \theta','d1','Location','northwest')
% legend('d1', '\theta','Location','northwest')
grid on;

% --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% % ---- d1 and diff(Avg. Theta) vs stress amplitude
figure('Name','Continuous: d1C and diff(Avg.Theta) vs SampC');
plot(SampCinterp(2:end), diff(movmean_thetaC), '-r', linewidth = 1)
ylabel('diff (Avg.\theta)  (K)')
title(sprintf('Continuous: d1 and diff (Avg.theta) vs Samp (%0.0fs Window) %s', windowDissipation, test_details));
xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampCinterp, d1C, '.b');
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
ax = gca;
ax.YAxis(2).Color = 'b';
legend('diff (Avg.\theta)','d1', 'Location','northwest')
grid on;
% --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ---- D1, Theta, and Avg.Theta vs stress amplitude
figure('Name','Continuous: D1C, Theta, and Avg.Theta  vs SampC')
plot(SampCinterp, thetaC,'-r');%, linewidth = 2)
hold on
plot(SampCinterp, movmean_thetaC, '-g', linewidth = 1.5)
ylabel('\theta (K)')
xlabel('\sigma_{amp} (MPa)');

yyaxis right
plot(SampCinterp, D1C, '.b');
title(sprintf('Continuous: D1C, theta, and Avg.theta vs Samp (%0.0fs Window) %s', windowDissipation, test_details));
ylabel('Mechanical Dissipation - D1 (kJ·m^{-3}/cycle)');
ax = gca;
ax.YAxis(2).Color = 'b';
legend('\theta','Avg. \theta','D1C','Location','northwest')
% legend('d1', '\theta','Location','northwest')
grid on;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% ----- d1, d1C
% figure('Name','d1, d1C vs Samp')
% plot(SampInterp,d1,'-b', LineWidth=2)
% hold on;
% plot(SampCinterp,d1C,'-k', LineWidth=1.5)
% grid on
% title(sprintf('d1, d1C vs \sigma_{amp} (%0.0fs Window) %s', windowDissipation, test_details));
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d1 (kW/m³)')
% legend ('d1','d1C',Location='northwest')

% ----- D1, D1C
figure('Name','D1, D1C vs Samp')
plot(SampInterp,D1,'-b', LineWidth=2)
hold on;
plot(SampCinterp,D1C,'-k', LineWidth=1.5)
grid on
title(sprintf('D1, D1C vs \\sigma_{amp} (%0.0fs Window) %s', windowDissipation, test_details));
xlabel('\sigma_{amp} (MPa)')
ylabel('D1 (kJ·m^{-3}/cycle)')
legend ('D1','D1C',Location='northwest')

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Continuous: Frequency Analysis of Theta of Loading Period
N_IRfatigueC = length(thetaC);

N_IRfatigueCTrunc = N_IRfatigueC; % Finding the maximum length of data which has integer number of cycles

while abs(mod(N_IRfatigueCTrunc, SF / LF)) > 1e-6
    N_IRfatigueCTrunc = N_IRfatigueCTrunc -1;
end

% --------- Frequency vector
f_fatigueC = (0:floor(N_IRfatigueCTrunc/2)) * (SF / N_IRfatigueCTrunc);
f_fatigueC = f_fatigueC(:);

TrefUpC_fatigueTrunc = TrefUpC_fatigue(1:N_IRfatigueCTrunc);
TrefBotC_fatigueTrunc = TrefBotC_fatigue(1:N_IRfatigueCTrunc); 
T0DC_fatigueTrunc = T0DC_fatigue(1:N_IRfatigueCTrunc); 
thetaCtrunc = thetaC(1:N_IRfatigueCTrunc); 

% --------- Apply Hann window
applyHANN_fatigueC = hann(N_IRfatigueCTrunc);
applyHANN_fatigueC = applyHANN_fatigueC(:);

CG_fatigueC = mean(applyHANN_fatigueC); % Coherent gain

TrefUpC_fatigueHANN = TrefUpC_fatigueTrunc.* applyHANN_fatigueC;
TrefBotC_fatigueHANN = TrefBotC_fatigueTrunc.* applyHANN_fatigueC;
T0DC_fatigueHANN = T0DC_fatigueTrunc.* applyHANN_fatigueC;
thetaC_HANN = thetaCtrunc.* applyHANN_fatigueC;



% --------- FFT computation TrefUp_fatigue
P1TrefUpC_fatigue = abs(fft(TrefUpC_fatigueHANN, N_IRfatigueCTrunc)) * (2/(N_IRfatigueCTrunc * CG_fatigueC));
P1TrefUpC_fatigue = P1TrefUpC_fatigue(1 : floor(N_IRfatigueCTrunc/2)+1);
P1TrefUpC_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation TrefBot_fatigue
P1TrefBotC_fatigue = abs(fft(TrefBotC_fatigueHANN, N_IRfatigueCTrunc)) * (2/(N_IRfatigueCTrunc * CG_fatigueC));
P1TrefBotC_fatigue = P1TrefBotC_fatigue(1 : floor(N_IRfatigueCTrunc/2)+1);
P1TrefBotC_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation T0DC
P1T0DC_fatigue = abs(fft(T0DC_fatigueHANN, N_IRfatigueCTrunc)) * (2/(N_IRfatigueCTrunc * CG_fatigueC));
P1T0DC_fatigue = P1T0DC_fatigue(1 : floor(N_IRfatigueCTrunc/2)+1);
P1T0DC_fatigue(1) = NaN; % Remove DC component

% --------- FFT computation thetaC
P1thetaC = abs(fft(thetaC_HANN, N_IRfatigueCTrunc)) * (2/(N_IRfatigueCTrunc * CG_fatigueC));
P1thetaC = P1thetaC(1 : floor(N_IRfatigueCTrunc/2)+1);
P1thetaC(1) = NaN; % Remove DC component

figure('Name', 'Continuous: Frequency analysis IR data FATIGUE'); hold on
title(sprintf('Continuous: Frequency analysis IR data FATIGUE (110 Hz) - %s', test_details));


% Harmonic markers
xline(20,'--k','1f','FontSize',22);
xline(40,'--k','2f','FontSize',22);
xline(60,'--k','3f','FontSize',22);
xline(80,'--k','4f','FontSize',22);
xline(100,'--k','5f','FontSize',22);

plot(f_fatigueC, movmean(P1T0DC_fatigue,3),'o', 'Color', 'r', 'MarkerSize', 2, ...
    'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'DisplayName', 'T_{GZ}');

plot(f_fatigueC, movmean(P1TrefBotC_fatigue,3),'o', 'Color', 'g', 'MarkerSize', 2, ...
    'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'DisplayName', 'T_{RefLow}');

plot(f_fatigueC, movmean(P1TrefUpC_fatigue,3),'o', 'Color', 'b', 'MarkerSize', 2, ...
    'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'DisplayName', 'T_{RefUp}');


% plot(f_fatigueC, movmean(P1thetaC,3),'o', 'Color', 'k', 'MarkerSize', 3, ...
%     'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'DisplayName', '\theta');

xlabel('Frequency (Hz)', 'FontSize', 20)
ylabel('Amplitude', 'FontSize', 20)

set(gca, 'YScale', 'log');
ylim([1e-6 1e-1])
yticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1])
yticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}'})

xlim([0 110])
xticks(0:10:ceil(SF/2/100)*100)

grid on;
ax = gca;
ax.YMinorGrid = 'on';
ax.GridAlpha = 0.5;
ax.MinorGridAlpha = 0.3;

set(gcf, 'Position', [688 535 657 480])
set(gca, 'FontSize', 20)
set(gcf,'MenuBar','figure','ToolBar','figure');

% legend

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% 3D plot - Continuous: Fatigue 3D
% close all;

% Create grid: frequency repeated for each variable
nFreqFatigueC = length(f_fatigueC);
X = repmat(f_fatigueC(:), 1, 3);           % X = frequency
Y = repmat(1:3, nFreqFatigueC, 1);                % Y = variable index (1 to 4)
Z = [P1TrefUpC_fatigue(:), P1TrefBotC_fatigue(:), P1T0DC_fatigue(:)]; % Z = amplitudes

figure('Name', 'Continuous: Frequency Analysis Fatigue Region');

myMarkerSize = 2.5;

% Plot 3D stems with different colors
stem3(X(:,1), Y(:,1), Z(:,1), 'bo', 'filled', ...
      'MarkerSize', myMarkerSize, 'LineStyle', 'none'); hold on;
stem3(X(:,2), Y(:,2), Z(:,2), 'go', 'filled', ...
      'MarkerSize', myMarkerSize, 'LineStyle', 'none');
stem3(X(:,3), Y(:,3), Z(:,3), 'ro', 'filled', ...
      'MarkerSize', myMarkerSize, 'LineStyle', 'none');

title(sprintf('Continuous: Frequency Analysis Fatigue Region - %s', test_details));
xlabel('Frequency (Hz)');

zlabel('Amplitude');
set(gca, 'ZScale', 'log');
zlim([1e-6 1e-1])

% Nice axis labels
yticks(1:3);
yticklabels({'T_{RefUp}', 'T_{RefLow}', 'T_{GZ}'});

xlim([0 110]);
xticks(0:10:110)
% zlim([0 2.5]);
grid on;

view(45, 35);           % Good default 3D angle (change to taste: e.g. 30,40 or -40,30)
legend('Location', 'bestoutside');

set(gca, 'FontSize', 20);

zticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1])
zticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}','10^{-1}'})
set(gcf,'MenuBar','figure','ToolBar','figure');

% ------------------- Save Figure
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Continuous: FFT on sliding windows

N_thetaC = length(thetaC);

% Aliasing check
if LF3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], LF3, SF/2);
end

% --- Arbitrary frequencies ---
fA = LF - 3;
fB = LF + 2;
fC = LF + LF/2; %FL - 5;
fD = LF*2 - 2 ; %FL + 5;
fE = LF*2 + 2; %FL*2 - 5;
fF = LF*2 + 13; %FL*2 + 5;
arbitraryFreqs = [fA, fB, fC, fD, fE, fF];

% --- FFT frequency axis ---
f = (0:SFnewTSA-1) * (SF/SFnewTSA);
nWinThetaC = N_thetaC - SFnewTSA + 1; % # of windows in the whole theta vector
tplot = tThetaC(1:nWinThetaC);
tplot = tplot(:);
% loading window
loading_start = tThetaC(1);%(idx_Theta_sync(1));
loading_end = tThetaC(end); %(temp_idxE - SF*window);
loading_window = find(tplot >= loading_start & tplot <= loading_end);

% ###########################
% ###########################
SampCinterp_x = SampCinterp(1:nWinThetaC);
SampCinterp_x = SampCinterp_x(:);

% ###########################
% ###########################

% --- Preallocate ---
maxAmpH1C = nan(nWinThetaC,1); maxFreqH1C = nan(nWinThetaC,1); ampAtH1C = nan(nWinThetaC,1); % ampAtH1C = Amplitude At H1 Continuous theta data
maxAmpH2C = nan(nWinThetaC,1); maxFreqH2C = nan(nWinThetaC,1); ampAtH2C = nan(nWinThetaC,1);
maxAmpH3C = nan(nWinThetaC,1); maxFreqH3C = nan(nWinThetaC,1); ampAtH3C = nan(nWinThetaC,1);
ampAtArbitC = nan(nWinThetaC, length(arbitraryFreqs));


% --- Sliding window ---
%% --- Continuous: SHTSA FFT method

% --------- Precompute Hann window and coherent gain
applyHANN = hann(SFnewTSA);
applyHANN = applyHANN(:);
CG = mean(applyHANN);

for k = 1:nWinThetaC

    end_idx = k+SFnewTSA-1;

    segmentC = detrend(thetaC(k : end_idx), 6);
    % segment = detrend(theta(k : end_idx), 1);
    % segment = thetaC(k : end_idx);

    segmentC = segmentC(:);

    % --------- Apply Hann window
    segmentHANN = segmentC .* applyHANN;

    % --------- FFT with amplitude correction
    beta = abs(fft(segmentHANN)) * (2/(SFnewTSA * CG));

    % --------- First harmonic (1f)
    idx1 = find(f >= (LF-BW) & f <= (LF+BW));
    [maxAmpH1C(k), j1] = max(beta(idx1)); maxFreqH1C(k) = f(idx1(j1));
    [~, i1] = min(abs(f - LF)); ampAtH1C(k) = beta(i1);

    % --------- Second harmonic (2f)
    idx2 = find(f >= (LF2-BW) & f <= (LF2+BW));
    [maxAmpH2C(k), j2] = max(beta(idx2)); maxFreqH2C(k) = f(idx2(j2));
    [~, i2] = min(abs(f - LF2)); ampAtH2C(k) = beta(i2);

    % --------- Third harmonic (3f)
    if LF3 < SF/2
        idx3 = find(f >= (LF3-BW) & f <= (LF3+BW));
        [maxAmpH3C(k), j3] = max(beta(idx3)); maxFreqH3C(k) = f(idx3(j3));
        [~, i3] = min(abs(f - LF3)); ampAtH3C(k) = beta(i3);
    end

    % --------- Arbitrary frequencies
    for j = 1:length(arbitraryFreqs)
        [~, idx] = min(abs(f - arbitraryFreqs(j)));
        ampAtArbitC(k, j) = beta(idx);
    end

end

% --- Construct central time reference for overlaying theta ---
winCentreIdx = (1:nWinThetaC) + floor(SFnewTSA/2);

%% --- Continuous: Plots of Amplitudes from FFT method ---

% --------- Continuous: Harmonic Amplitudes and Theta vs TIME
figure('Name','Continuous: Harmonic Amplitudes and Theta vs Time'); %,'NumberTitle','off');

nn = 3;
if LF3>SF/2
    nn = 2;
end

subplot(nn,2,1); % ---- in this subplot no average of amplitude as the amplitud is not very noisy
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx), '-b');
ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, ampAtH1C, 'k', 'LineWidth', 3); grid on;
ylabel('Amp (K)');
% title(sprintf('Continuous: Amp @ %.f Hz', LF)); grid on;
title(sprintf('Continuous: Amp @ %0.0f Hz',LF));
xlabel('Time (s)')
legend('\theta','Amp', 'Location', 'northwest');
% legend('Amp', 'Avg. \theta','Location', 'northwest');

subplot(nn,2,2); % ---- in this subplot no average of amplitude as the amplitud is not very noisy
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx), '-b');
ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, maxAmpH1C, 'k', 'LineWidth', 3); grid on
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz',LF, BW));
xlabel('Time (s)')
legend('\theta','Amp', 'Location', 'northwest');

subplot(nn,2,3);
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, ampAtH2C, 'g', 'LineWidth', 2);
hold on;
plot(tplot, movmean(ampAtH2C, SFnewTSA, 'Endpoints', 'fill'), 'm-', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', LF2)); 
grid on;
xlabel('Time (s)')
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


subplot(nn,2,4);
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, maxAmpH2C, 'm', 'LineWidth', 2);
hold on; plot(tplot, movmean(maxAmpH2C, SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
xlabel('Time (s)')
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if LF3<SF/2
    subplot(nn,2,5);
    yyaxis left
    % plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, thetaC(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(tplot, ampAtH3C, 'y', 'LineWidth', 2);
    hold on; plot(tplot, movmean(ampAtH3C, SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Amp @ %.f Hz', LF3)); grid on;
    xlabel('Time (s)')
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


    subplot(nn,2,6);
    yyaxis left
    % plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, thetaC(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(tplot, maxAmpH3C, 'c', 'LineWidth', 2);
    hold on; plot(tplot, movmean(maxAmpH3C, SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    xlabel('Time (s)')
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sg = sgtitle(sprintf('Continuous: %.1fs Sliding-Window FFT Harmonic Analysis\n(mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special characters
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


% --------- Continuous: Harmonic Amplitudes and Theta vs Stress amplitude
figure('Name','Continuous: Harmonic Amplitudes and Theta vs Stress Amp'); %);%,'NumberTitle','off');

subplot(nn,2,1);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, ampAtH1C(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp', 'Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,2,2);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, maxAmpH1C(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,2,3);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, ampAtH2C(loading_window), 'g', 'LineWidth', 2);
hold on;
plot(SampCinterp_x, movmean(ampAtH2C(loading_window), SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', LF2)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

subplot(nn,2,4);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, maxAmpH2C(loading_window), 'm', 'LineWidth', 2);
hold on; plot(SampCinterp_x, movmean(maxAmpH2C(loading_window), SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if LF3<SF/2
    subplot(nn,2,5);
    yyaxis left
    % plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(SampCinterp_x, ampAtH3C(loading_window), 'y', 'LineWidth', 2);
    hold on; plot(SampCinterp_x, movmean(ampAtH3C(loading_window), SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Amp @ %.f Hz', LF3 )); grid on;
    xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


    subplot(nn,2,6);
    yyaxis left
    % plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(SampCinterp_x, maxAmpH3C(loading_window), 'c', 'LineWidth', 2);
    hold on; plot(SampCinterp_x, movmean(maxAmpH3C(loading_window), SFnewTSA, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sgtitle(sprintf('Continuous: %.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', windowTSA,test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special characters
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



%% --- Continuous: Traditional method
tref_signal = (0:N_thetaC-1) / SF; %(0:dt:(length(F_continuous)-1)*dt);

X1C = cos(2 * pi * LF * tref_signal)';
Y1C = sin(2 * pi * LF * tref_signal)';

X2C = cos(2 * pi * 2*LF * tref_signal)';
Y2C = sin(2 * pi * 2*LF * tref_signal)';

X3C = cos(2 * pi * 3*LF * tref_signal)';
Y3C = sin(2 * pi * 3*LF * tref_signal)';

for k = 1:nWinThetaC

    end_idx = k+SFnewTSA-1;

    if end_idx > N_thetaC
        break;
    end

    kIndices = k : end_idx;
    kIndices = kIndices(:);

    segmentC = detrend(thetaC(kIndices), 6); 
    % segmentC = segmentC(:);

    H1_cosC(k) = sum(segmentC .* X1C(kIndices)) / (SFnewTSA/2);
    H1_sinC(k) = sum(segmentC .* Y1C(kIndices)) / (SFnewTSA/2);

    H2_cosC(k) = sum(segmentC .* X2C(kIndices)) / (SFnewTSA/2);
    H2_sinC(k) = sum(segmentC .* Y2C(kIndices)) / (SFnewTSA/2);

    H3_cosC(k) = sum(segmentC .* X3C(kIndices)) / (SFnewTSA/2);
    H3_sinC(k) = sum(segmentC .* Y3C(kIndices)) / (SFnewTSA/2);

    % --------- Amplitudes
    AmpH1_windowC(k) = sqrt(H1_sinC(k)^2 + H1_cosC(k)^2);
    AmpH2_windowC(k) = sqrt(H2_sinC(k)^2 + H2_cosC(k)^2);
    AmpH3_windowC(k) = sqrt(H3_sinC(k)^2 + H3_cosC(k)^2);

end


% ------------------------- plots
% Combined figure with three subplots for H1, H2, H3 amplitudes
figure('Name','Continuous: Harmonic Amplitudes and Theta vs time'); %,'NumberTitle','off');
subplot(nn,1,1);
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, AmpH1_windowC, LineWidth=2); grid on; 
title(sprintf('Continuous: H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(tplot, movmean(AmpH1_windowC, smoothing, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
% legend('Amp','Avg. \theta','Location', 'northwest');
% legend('Amp','\theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,1,2);
yyaxis left
% plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, thetaC(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, AmpH2_windowC); grid on; 
title(sprintf('Continuous: H2 Amplitude at %.f Hz', LF2));
hold on;
plot(tplot, movmean(AmpH2_windowC, SFnewTSA, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if LF3<SF/2
    subplot(nn,1,3);
    yyaxis left
    % plot(tplot, movmean(thetaC(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, thetaC(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(tplot, AmpH3_windowC); grid on; 
    title(sprintf('Continuous: H3 Amplitude at %.f Hz', LF3));
    hold on;
    plot(tplot, movmean(AmpH3_windowC, SFnewTSA, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('Time (s)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sg = sgtitle(sprintf('Continuous: %.1fs Sliding-Window Harmonic Analysis using Reference Signals (mean \\theta removed) - %s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



% ---------------------- Harmonic Amp. and Theta vs Stress Amp

% loading period in temperatue and tTemp: idx_Theta_sync(1):theta_idxE
% so the time should statrt when time is => than the time value at
% idx_Theta_sync(1) and ends at when the time value is =< theta_idxE.
AmpH1_loading = AmpH1_windowC(loading_window);
AmpH2_loading = AmpH2_windowC(loading_window);
AmpH3_loading = AmpH3_windowC(loading_window);


figure('Name','Continuous: Harmonic Amp. and Theta vs Stress Amp'); %);%,'NumberTitle','off');
subplot(nn,1,1);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, AmpH1_loading, LineWidth=2); grid on; title(sprintf('Continuous: H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(SampInterp, movmean(AmpH1_loading, smoothing, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');


subplot(nn,1,2);
yyaxis left
% plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampCinterp_x, AmpH2_loading); grid on; title(sprintf('Continuous: H2 Amplitude at %.f Hz', LF2));
hold on;
plot(SampCinterp_x, movmean(AmpH2_loading, SFnewTSA, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


if LF3<SF/2
    subplot(nn,1,3);
    yyaxis left
    % plot(SampInterp, movmean(thetaC(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampCinterp_x, thetaC(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    title(sprintf('Continuous: H3 Amplitude at %.f Hz', LF3));
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(SampCinterp_x, AmpH3_loading, linewidth = 1.2); grid on;
    hold on;
    plot(SampCinterp_x, movmean(AmpH3_loading, SFnewTSA, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sg = sgtitle(sprintf('Continuous: %.1fs Sliding-Window Harmonic Analysis using Reference Signals\n(mean \\theta removed - %s)', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Continuous: Least Square Method Harmonics Vs SampC
% clc
N_thetaC = length(thetaC);
tref_signal = (0:N_thetaC-1) / SF;
tref_signal = tref_signal(:);

applyHANN = hann(SFnewTSA);
applyHANN = applyHANN(:);

CG = mean(applyHANN);   % --------- ADD THIS

pOrder = 4;

for k = 1:nWinThetaC

    end_idx = k + SFnewTSA - 1;
    if end_idx > N_thetaC
        break;
    end

    kIndices = k:end_idx;
    kIndices = kIndices(:);

    segmentC = detrend(thetaC(kIndices), pOrder);
    % segmentC = thetaC(kIndices);
    segmentC = segmentC(:);

    t_seg = tref_signal(kIndices);

    A = [ ...
        cos(2*pi*1*LF*t_seg),sin(2*pi*1*LF*t_seg), ...
        cos(2*pi*2*LF*t_seg),sin(2*pi*2*LF*t_seg), ...
        cos(2*pi*3*LF*t_seg),sin(2*pi*3*LF*t_seg) ...
        cos(2*pi*4*LF*t_seg),sin(2*pi*4*LF*t_seg) ...
        ];

    Aw = A .* applyHANN;
    yw = segmentC .* applyHANN;

    coeff = Aw \ yw;

    a1 = coeff(1); b1 = coeff(2);
    a2 = coeff(3); b2 = coeff(4);
    a3 = coeff(5); b3 = coeff(6);
    a4 = coeff(7); b4 = coeff(8);

    AmpH1C_LS(k) = sqrt(a1^2 + b1^2); % / CG;
    AmpH2C_LS(k) = sqrt(a2^2 + b2^2); % / CG;
    AmpH3C_LS(k) = sqrt(a3^2 + b3^2); % / CG;
    AmpH4C_LS(k) = sqrt(a4^2 + b4^2); % / CG;

    PhaseH1C_LS(k) = atan2(b1, a1);
    PhaseH2C_LS(k) = atan2(b2, a2);
    PhaseH3C_LS(k) = atan2(b3, a3);

end
AmpH1C_LS = AmpH1C_LS(:);
AmpH2C_LS = AmpH2C_LS(:);
AmpH3C_LS = AmpH3C_LS(:);
AmpH4C_LS = AmpH4C_LS(:);

% --------- Time reference
winCentreIdx = (1:nWinThetaC) + floor(SFnewTSA/2);

%% Reconstruction of theta from the harmonic amplitudes
% Estimate a smooth trend of the original signal
trend = movmean(thetaC, SFnewTSA);   % or smoothdata, or polyfit, etc.

% Reconstruct the harmonics
recon_osc = zeros(size(thetaC));
weight    = zeros(size(thetaC));

for k = 1:nWinThetaC
    end_idx = k + SFnewTSA - 1;
    if end_idx > N_thetaC, break; end
    idx   = k:end_idx;
    t_seg = tref_signal(idx);

    osc = AmpH1C_LS(k) * cos(2*pi*LF  *t_seg - PhaseH1C_LS(k)) ...
        + AmpH2C_LS(k) * cos(2*pi*2*LF*t_seg - PhaseH2C_LS(k)) ...
        + AmpH3C_LS(k) * cos(2*pi*3*LF*t_seg - PhaseH3C_LS(k));

    recon_osc(idx) = recon_osc(idx) + osc;
    weight(idx)    = weight(idx) + 1;
end
recon_osc(weight>0) = recon_osc(weight>0) ./ weight(weight>0);

%% Final reconstruction
recon_theta = trend + recon_osc;
%
figure;
plot(tref_signal, thetaC, 'k', 'LineWidth', 1.5);
hold on;
plot(tref_signal, recon_theta, 'r--', 'LineWidth', 1.5);

grid on;
box on;

xlabel('Time (s)');
ylabel('\theta');

legend('\theta Original', '\theta Reconstructed', 'Location', 'best');

title('Comparison of Original and Reconstructed \theta');

%% ----------- Continuous: Combined D1, H2 and H3 Paper Figure
figure('Name','Continuous: D1, H2 & H3 vs Stress');
grid on
hold on
box on

title(sprintf('Continuous: D_1, H2 and H3 vs Stress - porder = %0.0f', pOrder))

% ================= LEFT Y-AXIS =================
yyaxis left

plot(SampCinterp, D1Cxx(:,2), '-g', 'LineWidth', 2, ...
    'DisplayName', 'D_1_{-5s}');

ylabel('Mechanical Dissipation per Cycle ⟨\itD\rm_1⟩ (kJ·m^{-3}/cycle)')

ylim([0 100])
yticks(0:25:100)

set(gca, ...
    'FontSize', 20, ...
    'XColor', 'k', ...
    'YColor', 'k')

% ================= RIGHT Y-AXIS =================
yyaxis right

h = plot(SampCinterp_x, AmpH3C_LS*1e3, 'ob', ...
    'MarkerSize', 2, ...
    'DisplayName', 'H3 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampCinterp_x, AmpH2C_LS*1e3, 'or', ...
    'MarkerSize', 2, ...
    'DisplayName', 'H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

ylabel('Amplitude (mK)')

ylim([0 4])
yticks(0:1:4)
set(gca, ...
    'FontSize', 20, ...
    'XColor', 'k', ...
    'YColor', 'k')
% ================= COMMON AXIS SETTINGS =================
xlabel('\sigma_{amp} (MPa)')

xlim([0 210])
xticks(0:20:220)
xtickangle(90)

set(gcf, 'Position', [688 535 657 480])
set(gca, 'FontSize', 20)

legend('Location', 'northwest')

box on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');
figureName = strrep(figureName, ' ', '_');

saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% -----------Continuous: LS Amplitude Paper Figure
% close all
figure('Name','Continuous: LS H1 Amplitude vs Stress'); hold on; grid on
title(sprintf('Continuous: LS H1 Amplitude - porder = %0.0f', pOrder))

h = plot(SampCinterp_x, AmpH1C_LS, 'ok','MarkerSize',2,'DisplayName','H1 Raw');
set(h, 'MarkerFaceColor', h.Color);

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (K)')

xlim([0 210])
xticks(0:30:210)
xtickangle(90)

ylim([0 0.4])
yticks(0:0.1:0.4)
set(gcf, 'Position', [688 535 657 480])
set(gca, 'FontSize', 20)
box on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%%
figure('Name','Continuous: LS H2 & H3 Amplitudes vs Stress'); hold on; grid on
title(sprintf('Continuous: LS H2 and H3 Amplitudes - porder = %0.0f', pOrder))

h = plot(SampCinterp_x, AmpH3C_LS*1e3, 'ob','MarkerSize',2,'DisplayName','H3 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampCinterp_x, AmpH2C_LS*1e3, 'or','MarkerSize',2,'DisplayName','H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampCinterp_x, AmpH4C_LS*1e3, 'ok','MarkerSize',2,'DisplayName','H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (mK)')
legend

xlim([0 210])
xticks(0:30:210)
xtickangle(90)

ylim([0 4])
yticks(0:1:4)
set(gcf, 'Position', [688 535 657 480])
set(gca, 'FontSize', 20)
set(gcf,'MenuBar','figure','ToolBar','figure');
box on

%% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% Continuous: Least Square Amplitude Plots

% --------- Prepare x-axis (stress amplitude) and theta
theta_plot = thetaC(winCentreIdx);       % Corresponding theta

% --------- Optional smoothing (for visual clarity)
AmpH1_LS_smooth = movmean(AmpH1C_LS,5);
AmpH2_LS_smooth = movmean(AmpH2C_LS,5);
AmpH3_LS_smooth = movmean(AmpH3C_LS,5);

% --------- Figure
figure('Name','Continuous: LS Sliding-Window Harmonic Analysis'); 

tiledlayout(3,1)

% ===================== H1 =====================
nexttile; hold on

yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2, 'DisplayName', '\theta');
ylabel('\theta (K)')

yyaxis right
plot(SampCinterp_x, AmpH1C_LS, '-', 'Color', [0.85 0.33 0.1], 'LineWidth', 1, 'DisplayName', 'Amp');
plot(SampCinterp_x, AmpH1_LS_smooth, 'k', 'LineWidth', 2, 'DisplayName', 'Mean Amp');
ylabel('Amp (K)')

title(sprintf('Continuous: LS H1 Amplitude @ %d Hz', LF))
xlabel('\sigma_{amp} (MPa)')
grid on
legend('Location','northwest')

% ===================== H2 =====================
nexttile; hold on

yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2, 'DisplayName', '\theta');
ylabel('\theta (K)')

yyaxis right
plot(SampCinterp_x, AmpH2C_LS, '-', 'Color', [0.93 0.69 0.13], 'LineWidth', 1, 'DisplayName', 'Amp');
plot(SampCinterp_x, AmpH2_LS_smooth, 'k', 'LineWidth', 2, 'DisplayName', 'Mean Amp');
ylabel('Amp (K)')
% set(gca,'YScale','log')


title(sprintf('Continuous: LS H2 Amplitude @ %d Hz', 2*LF))
xlabel('\sigma_{amp} (MPa)')
grid on
legend('Location','northwest')

% ===================== H3 =====================
nexttile; hold on

yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2, 'DisplayName', '\theta');
ylabel('\theta (K)')

yyaxis right
plot(SampCinterp_x, AmpH3C_LS, '-', 'Color', [0 0.75 0.75], 'LineWidth', 1, 'DisplayName', 'Amp');
plot(SampCinterp_x, AmpH3_LS_smooth, 'k', 'LineWidth', 2, 'DisplayName', 'Mean Amp');
ylabel('Amp (K)')
% set(gca,'YScale','log')

title(sprintf('Continuous: LS H3 Amplitude @ %d Hz', 3*LF))
xlabel('\sigma_{amp} (MPa)')
grid on
legend('Location','northwest')

% --------- Formatting
set(gcf, 'Position', [600 200 700 700])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% --------- Continuous: LS Unwrap phase
PhaseH1_unwrap = unwrap(PhaseH1C_LS);
PhaseH2_unwrap = unwrap(PhaseH2C_LS);
PhaseH3_unwrap = unwrap(PhaseH3C_LS);

% --------- Optional smoothing (recommended for H2, H3)
PhaseH1_smooth = movmean(PhaseH1_unwrap,5);
PhaseH2_smooth = movmean(PhaseH2_unwrap,5);
PhaseH3_smooth = movmean(PhaseH3_unwrap,5);

% --------- Plot
figure('Name','LS Harmonic Phase Evolution');

tiledlayout(3,1)

% ===================== H1 =====================
nexttile; hold on

plot(SampCinterp_x, PhaseH1_unwrap, '-', 'Color', [0.6 0.6 0.6], ...
    'DisplayName','Raw Phase');

plot(SampCinterp_x, PhaseH1_smooth, 'k', 'LineWidth', 2, ...
    'DisplayName','Smoothed Phase');

ylabel('\phi_{1f} (rad)')
title(sprintf('Phase Evolution H1 @ %d Hz', LF))
grid on
legend('Location','best')

% ===================== H2 =====================
nexttile; hold on

plot(SampCinterp_x, PhaseH2_unwrap, '-', 'Color', [0.6 0.6 0.6], ...
    'DisplayName','Raw Phase');

plot(SampCinterp_x, PhaseH2_smooth, 'k', 'LineWidth', 2, ...
    'DisplayName','Smoothed Phase');

ylabel('\phi_{2f} (rad)')
title(sprintf('Phase Evolution H2 @ %d Hz', 2*LF))
grid on
legend('Location','best')

% ===================== H3 =====================
nexttile; hold on

plot(SampCinterp_x, PhaseH3_unwrap, '-', 'Color', [0.6 0.6 0.6], ...
    'DisplayName','Raw Phase');

plot(SampCinterp_x, PhaseH3_smooth, 'k', 'LineWidth', 2, ...
    'DisplayName','Smoothed Phase');

ylabel('\phi_{3f} (rad)')
xlabel('\sigma_{amp} (MPa)')
title(sprintf('Phase Evolution H3 @ %d Hz', 3*LF))
grid on
legend('Location','best')

% --------- Formatting
set(gcf, 'Position', [700 200 650 700])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



%% Continuous: Frequency Adaptive Least Square Method

tref_signal = (0:N_thetaC-1) / SF;
tref_signal = tref_signal(:);

applyHANN = hann(SFnewTSA);
applyHANN = applyHANN(:);

fSearch = linspace(LF-BW, LF+BW, 15);   % frequency search grid

for k = 1:nWinThetaC

    end_idx = k + SFnewTSA - 1;

    if end_idx > N_thetaC
        break;
    end

    kIndices = (k:end_idx)';

    segmentC = detrend(thetaC(kIndices), pOrder);
    segmentC = segmentC(:);

    t_seg = tref_signal(kIndices);

    bestErr = inf;

    % --------- Frequency search
    for ftest = fSearch

        A = [ ...
            cos(2*pi*ftest*t_seg),   sin(2*pi*ftest*t_seg), ...
            cos(2*pi*2*ftest*t_seg),sin(2*pi*2*ftest*t_seg), ...
            cos(2*pi*3*ftest*t_seg),sin(2*pi*3*ftest*t_seg) ...
            ];

        % Weighted LS (efficient form)
        Aw = A .* applyHANN;
        yw = segmentC .* applyHANN;

        coeff = Aw \ yw;

        residual = norm(yw - Aw*coeff);

        if residual < bestErr
            bestErr = residual;
            bestCoeff = coeff;
            bestFreqC(k) = ftest;
        end
    end

    % --------- Extract coefficients
    a1 = bestCoeff(1); b1 = bestCoeff(2);
    a2 = bestCoeff(3); b2 = bestCoeff(4);
    a3 = bestCoeff(5); b3 = bestCoeff(6);

    % --------- Amplitudes
    AmpH1C_LSFA(k) = sqrt(a1^2 + b1^2); % FA = Frequency Addaptive
    AmpH2C_LSFA(k) = sqrt(a2^2 + b2^2);
    AmpH3C_LSFA(k) = sqrt(a3^2 + b3^2);

    % --------- Phases
    PhaseH1C_LSFA(k) = atan2(b1, a1);
    PhaseH2C_LSFA(k) = atan2(b2, a2);
    PhaseH3C_LSFA(k) = atan2(b3, a3);

end

winCentreIdx = (1:nWinThetaC) + floor(SFnewTSA/2);

%% ---Continuous: Frequency-Adaptive Least Square Method Peak Tracking Only ---
% ------------- Best Frequency Track

bestFreq_H1C = bestFreqC;        % 1f
bestFreq_H2C = 2 * bestFreqC;    % 2f
bestFreq_H3C = 3 * bestFreqC;    % 3f
figure('Name','Adaptive Frequency vs Stress Amplitude');

tiledlayout(3,1)

% ===================== H1 =====================
nexttile; hold on

plot(SampCinterp_x, bestFreq_H1C, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','b', 'MarkerEdgeColor','b', ...
    'DisplayName','Raw');

plot(SampCinterp_x, movmean(bestFreq_H1C,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
title(sprintf('H1 Frequency Evolution (~%d Hz)', LF))
grid on
legend('Location','best')

% ===================== H2 =====================
nexttile; hold on

plot(SampCinterp_x, bestFreq_H2C, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','r', 'MarkerEdgeColor','r', ...
    'DisplayName','Raw');

plot(SampCinterp_x, movmean(bestFreq_H2C,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
title(sprintf('H2 Frequency Evolution (~%d Hz)', 2*LF))
grid on
legend('Location','best')

% ===================== H3 =====================
nexttile; hold on

plot(SampCinterp_x, bestFreq_H3C, 'o', ...
    'MarkerSize',4, 'MarkerFaceColor','g', 'MarkerEdgeColor','g', ...
    'DisplayName','Raw');

plot(SampCinterp_x, movmean(bestFreq_H3C,5), 'k', 'LineWidth',2, ...
    'DisplayName','Smoothed');

ylabel('Frequency (Hz)')
xlabel('\sigma_{amp} (MPa)')
title(sprintf('H3 Frequency Evolution (~%d Hz)', 3*LF))
grid on
legend('Location','best')

% --------- Formatting
set(gcf, 'Position', [650 200 650 700])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Continuous: Amplitude Plots of Frequency-Adaptive LS

theta_plot = thetaC(winCentreIdx);

figure('Name','Continuous: Adaptive LS Harmonics (Amplitude)');
tiledlayout(3,1)

% ---------- H1
nexttile; hold on
yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2)
ylabel('\theta (K)')

yyaxis right
plot(SampCinterp_x, AmpH1C_LSFA, 'r')
plot(SampCinterp_x, movmean(AmpH1C_LSFA,5),'k','LineWidth',2)
ylabel('Amp (K)')
% title(sprintf('H1 @ ~%.2f Hz', LF))
title(sprintf('Continuous: LS Max Amp %.f\\pm%.1f Hz', LF, BW));
grid on

% ---------- H2
nexttile; hold on
yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2)

yyaxis right
plot(SampCinterp_x, AmpH2C_LSFA, 'r')
plot(SampCinterp_x, movmean(AmpH2C_LSFA,5),'k','LineWidth',2)
% set(gca,'YScale','log')
% title(sprintf('H2 @ ~%.2f Hz', 2*LF))
title(sprintf('Continuous: LS Max Amp %.f\\pm%.1f Hz', LF*2, BW));
grid on

% ---------- H3
nexttile; hold on
yyaxis left
plot(SampCinterp_x, theta_plot, 'b', 'LineWidth', 2)

yyaxis right
plot(SampCinterp_x, AmpH3C_LSFA, 'r')
plot(SampCinterp_x, movmean(AmpH3C_LSFA,5),'k','LineWidth',2)
% set(gca,'YScale','log')
% title(sprintf('H3 @ ~%.2f Hz', 3*LF))
title(sprintf('Continuous: LS Max Amp %.f\\pm%.1f Hz', LF*3, BW));
xlabel('\sigma_{amp} (MPa)')
grid on

set(gcf,'Position',[600 200 700 800])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% ------------------- Continuous: Phase Plot Frequency-Adaptive LS

figure('Name','Adaptive LS Harmonics (Phase)');
tiledlayout(3,1)

nexttile
plot(SampCinterp_x, PhaseH1C_LSFA,'LineWidth',1.5)
title('Phase H1')
ylabel('\phi (rad)')
grid on

nexttile
plot(SampCinterp_x, PhaseH2C_LSFA,'LineWidth',1.5)
title('Phase H2')
ylabel('\phi (rad)')
grid on

nexttile
plot(SampCinterp_x, PhaseH3C_LSFA,'LineWidth',1.5)
title('Phase H3')
ylabel('\phi (rad)')
xlabel('\sigma_{amp} (MPa)')
grid on

set(gcf,'Position',[700 200 600 800])
set(findall(gcf,'-property','FontSize'),'FontSize',16)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));




%% Continuous: Leaset Square Method as per paper Krapez yr. 2000.
% --------- Preallocate
T0_LS = zeros(nWinThetaC,1);
dT_LS = zeros(nWinThetaC,1);

AmpH1_LS_K = zeros(nWinThetaC,1); % K for Krapez
AmpH2_LS_K = zeros(nWinThetaC,1);
AmpH3_LS_K = zeros(nWinThetaC,1);

PhaseH1_LS_K = zeros(nWinThetaC,1);
PhaseH2_LS_K = zeros(nWinThetaC,1);
PhaseH3_LS_K = zeros(nWinThetaC,1);

% --------- Loop
for k = 1:nWinThetaC

    end_idx = k + SFnewTSA - 1;
    if end_idx > N_thetaC
        break;
    end

    kIndices = (k:end_idx)';
    % t_seg = detrend(tThetaC(kIndices),6);
    t_seg = tThetaC(kIndices);
    segmentC = thetaC(kIndices);

    % --------- Angular frequency
    omega = 2*pi*LF;

    % --------- Design matrix (paper-consistent model)
    A = [ ...
        ones(size(t_seg)), ...                     % T0
        LF * t_seg, ...                           % ΔT f t
        sin(omega*t_seg), cos(omega*t_seg), ...   % 1f
        sin(2*omega*t_seg), cos(2*omega*t_seg), ... % 2f
        sin(3*omega*t_seg), cos(3*omega*t_seg) ...  % 3f
        ];

    % --------- Least squares solution
    coeff = A \ segmentC;

    % --------- Extract coefficients
    T0_LS(k) = coeff(1);
    dT_LS(k) = coeff(2);

    a1 = coeff(3); b1 = coeff(4);
    a2 = coeff(5); b2 = coeff(6);
    a3 = coeff(7); b3 = coeff(8);

    % --------- Convert to amplitude & phase
    AmpH1_LS_K(k) = sqrt(a1^2 + b1^2);
    AmpH2_LS_K(k) = sqrt(a2^2 + b2^2);
    AmpH3_LS_K(k) = sqrt(a3^2 + b3^2);

    PhaseH1_LS_K(k) = atan2(b1, a1);
    PhaseH2_LS_K(k) = atan2(b2, a2);
    PhaseH3_LS_K(k) = atan2(b3, a3);

end

% --------- Window centre alignment
winCentreIdx = (1:nWinThetaC) + floor(SFnewTSA/2);


% ###################################################
% ---------- Plots

% ------ H1
figure('Name','Harmonic Amplitudes (Paper Model)'); hold on

plot(SampCinterp_x, AmpH1_LS_K, 'b', 'DisplayName','H1');

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (K)')
title('Harmonic Amplitudes vs Stress (LS - Paper Model)')
grid on

set(gcf, 'Position', [688 535 657 400])
set(gca, 'FontSize', 20)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


% ---------- H2 and H3
figure('Name','Harmonic Amplitudes (Paper Model)'); hold on
plot(SampCinterp_x, AmpH2_LS_K, 'r', 'DisplayName','H2');
plot(SampCinterp_x, AmpH3_LS_K, 'g', 'DisplayName','H3');

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (K)')
title('Harmonic Amplitudes vs Stress (LS - Paper Model)')
legend('Location','best')
grid on

set(gcf, 'Position', [688 535 657 400])
set(gca, 'FontSize', 20)

% ---------------- Save 
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% ############ Segment: Stress mplitude for each segment   ################
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%(((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))))

ForceAmpSegs = nan(maxN, N_segF);   % amplitude vs time inside segment
SampSegs = nan(maxN, N_segF);   % stress amplitude vs time
R_seg_values = nan(N_segF,1);   % preallocate before loop

for s = 1:N_segF

    % --- Remove NaNs safely ---
    validINDX = ~isnan(ForceSegs(:,s));
    Fseg  = ForceSegs(validINDX, s);
    time_seg  = tFSegs(validINDX, s);

    if numel(Fseg) < 3
        continue
    end

    % -------- Peak Detection --------
    [Fpk, locs_Fhighs] = findpeaks(Fseg, ...
        'MinPeakProminence', minProminence);

    [Flows_raw, locs_Flows] = findpeaks(-Fseg, ...
        'MinPeakProminence', minProminence);
    Ftr = -Flows_raw;

    % Manual boundary checks (safer form)
    if Fseg(1) > Fseg(min(2,end))
        Fpk = [Fseg(1); Fpk];
        locs_Fhighs = [1; locs_Fhighs];
    end

    if Fseg(end) > Fseg(max(end-1,1))
        Fpk = [Fpk; Fseg(end)];
        locs_Fhighs = [locs_Fhighs; numel(Fseg)];
    end

    if numel(Fpk) < 2 || numel(Ftr) < 2
        continue
    end

    time_Fhighs = time_seg(locs_Fhighs);
    time_Flows  = time_seg(locs_Flows);

    % -------- Robust Linear Fit (Envelope Drift Removal) --------

    bH = robustfit(time_Fhighs, Fpk);
    bL = robustfit(time_Flows,  Ftr);

    aH = bH(1);  mH = bH(2);
    aL = bL(1);  mL = bL(2);

    R_seg = mL / mH;
    R_seg_values(s) = R_seg;
    Fhigh_fit = mH * time_seg + aH;
    Flow_fit  = mL * time_seg + aL;

    % -------- Goodness of Fit --------

    Fhigh_pred = aH + mH*time_Fhighs;
    Flow_pred  = aL + mL*time_Flows;

    SS_res_H = sum((Fpk - Fhigh_pred).^2);
    SS_tot_H = sum((Fpk - mean(Fpk)).^2);
    R2_H = 1 - SS_res_H/SS_tot_H;

    SS_res_L = sum((Ftr - Flow_pred).^2);
    SS_tot_L = sum((Ftr - mean(Ftr)).^2);
    R2_L = 1 - SS_res_L/SS_tot_L;

    RMSE_H = sqrt(mean((Fpk - Fhigh_pred).^2));
    RMSE_L = sqrt(mean((Ftr  - Flow_pred).^2));

    fprintf('Segment %d\n', s);
    fprintf('RMSE Highs: %.2f N | R^2: %.4f\n', RMSE_H, R2_H);
    fprintf('RMSE Lows : %.2f N | R^2: %.4f\n', RMSE_L, R2_L);
    fprintf('Force Ratio R (slope-based): %.4f\n\n', R_seg);

    % -------- Force Amplitude (Drift-Corrected) --------
    Famp_fit = (Fhigh_fit - Flow_fit) / 2;
    ForceAmpSegs(1:numel(Famp_fit), s) = Famp_fit;

    % -------- Stress Amplitude --------
    % xarea must be in mm^2 → stress in MPa
    SampSegs(1:numel(Famp_fit), s) = Famp_fit ./ xarea / 1e6;
end

Samp_Seg_Vector = SampSegs(~isnan(SampSegs));
SampSegsMeans = mean(SampSegs,1,'omitnan');
SampSegsMeans = SampSegsMeans(:);


figure('Name','Segments: Stress Amplitude per Segment')
hold on;

for s = 1:N_segF

    validINDX = ~isnan(SampSegs(:,s));

    time_seg = tFSegs(validINDX, s);
    Samp_seg = SampSegs(validINDX, s);

    if isempty(Samp_seg)
        continue
    end

    % --- Plot stress amplitude ---
    plot(time_seg, Samp_seg, 'LineWidth', 1.5);

    % --- Position for R label (above segment) ---
    x_mid = mean(time_seg);
    y_top = max(Samp_seg);

    text(x_mid, y_top*1.05, ...
        sprintf('R = %.3f', R_seg_values(s)), ...
        'HorizontalAlignment','center', ...
        'FontWeight','bold');
end

xlabel('Time (s)');
ylabel('\sigma_a (MPa)');
title(sprintf('Segments: Stress Amplitude and Ratio per Segment - %s', test_details));
grid on;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% Segments: Loading frequency analysis for each bloc

Freq = cell(N_segF,1);
Amp = cell(N_segF,1);

for s = 1:N_segF

    % ---- extract valid force data ----
    F = ForceSegs(:,s);
    F = F(~isnan(F));

    if numel(F) < 10
        continue   % skip empty / too short segment
    end


    % ---- FFT ----
    N = length(F);
    Y = fft(F);
    Y(1) = NaN;

    P2 = abs(Y)/N;
    P1 = P2(1:floor(N/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = SF_F*(0:floor(N/2))/N; % SF_F mechanical data sampling frquency, not the IR camera sampling frequency.

    % ---- store ----
    Freq{s} = f;
    Amp{s} = P1;

end

% ----------------- Y-axis: Amplitude (N)
figure('Name','Segment: LF Analysis'); hold on; grid on;
legTxt = cell(N_segF,1);
for s = 1:N_segF
    if isempty(Freq{s}), continue; end
    plot(Freq{s}, (Amp{s}), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('Segment %d', s))
    legTxt{s} = sprintf('Loading Segment %d', s);
end

xlabel('Frequency (Hz)')
xticks (0:LF:round(SF_F)/2)
ylabel('Amplitude (N)')

title(sprintf('Segments: Force Single-Sided Amplitude Spectrum per Segment (DC Removed) - %s', test_details));
legend(legTxt, 'Location','best');
grid on;

% % --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --------------------- Y-axis: Log scale
figure('Name','Segment: LF Analysis (log scale)'); hold on; grid on;
legTxt = cell(N_segF,1);
for s = 1:N_segF
    if isempty(Freq{s}), continue; end
    plot(Freq{s}, log(Amp{s}), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('Segment %d', s))
    legTxt{s} = sprintf('Loading Segment %d', s);
end

xlabel('Frequency (Hz)')
xticks (0:LF:round(SF_F)/2)
ylabel('Log Amplitude (N)')

title(sprintf('Segments: Force Single-Sided Amplitude Spectrum per Segment (DC Removed) %s', test_details));
legend(legTxt, 'Location','best');
grid on;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% Segments: Mechanical dissipation calculation d1

d1Segs = nan(maxNthetaSeg, N_segTheta);

% Ensure window length is odd for centred differentiation
% SFnewDissipation = round(windowDissipation * SF, 9);
% if mod(SFnewDissipation,2) == 0
%     SFnewDissipation = SFnewDissipation + 1; % Ensure odd number for convolution
% end

kd = (SFnewDissipation - 1)/2;

for s = 1:N_segTheta

    % --- Consistent NaN removal ---
    validINDX = ~isnan(thetaSegs(:,s));

    theta_s = thetaSegs(validINDX, s);
    t_theta_s = tThetaSegs(validINDX, s);

    % Reset time origin for numerical stability
    t_theta_s = t_theta_s - t_theta_s(1);

    % Moving mean smoothing
    movmean_theta_s = movmean(theta_s, SFnewDissipation, ...
        'endpoints','fill');

    d1_s = nan(size(theta_s));

    % --- Centred time derivative + convection term ---
    for k = 1+kd : length(theta_s)-kd

        dt = t_theta_s(k+kd) - t_theta_s(k-kd);

        if dt == 0
            continue
        end

        dtheta_dt = (movmean_theta_s(k+kd) - ...
            movmean_theta_s(k-kd)) / dt;

        d1_s(k) = rho * C * ...
            ( dtheta_dt + movmean_theta_s(k)/tau );
    end

    % Convert W/m^3 → kW/m^3
    d1_s = d1_s / 1000;

    d1Segs(1:length(d1_s), s) = d1_s;

end

d1_Segs_Vector = d1Segs(~isnan(d1Segs));
D1SegsVector = d1_Segs_Vector / LF;

d1SegsMeans = mean(d1Segs,1,'omitnan');
d1SegsMeans = d1SegsMeans(:);

D1Segs = d1Segs / LF;
D1SegsMeans = d1SegsMeans / LF;

%%
% -------------------------------
% Plot 1: d1SegsMeans vs SampSegsMeans
% -------------------------------
figure('Name','d1SegsMeans vs SampSegsMeans')
title('Segments: mean d1 vs mean Stress Amplitude ', test_details);
plot(SampSegsMeans, d1SegsMeans, 'b-o','MarkerSize',6)
grid on
xlabel('\sigma_{amp} (MPa)')
ylabel('d1 (kW/m^3)')

% --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% -------------------------------
% Plot 2: D1SegsMeans vs SampSegsMeans
% -------------------------------
figure('Name','D1SegsMeans vs SampSegsMeans')
plot(SampSegsMeans, D1SegsMeans, 'b-o','MarkerSize',6)
grid on
xlabel('\sigma_{amp} (MPa)')
ylabel('D1 (kJ·m^{-3}/cycle)')
title(sprintf('Segments: mean D1 vs mean Stress Amplitude - %s',test_details));

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

SampInterpSegs_d1 = nan(maxNthetaSeg, N_segTheta);

figure('Name','Segments: D1 vs Stress Amplitude')
hold on;

for s = 1:N_segTheta

    % --- Extract valid theta data ---
    validIndx = ~isnan(D1Segs(:,s));
    D1_seg = D1Segs(validIndx, s);
    t_theta = tThetaSegs(validIndx, s);

    % --- Extract valid stress data ---
    validStress = ~isnan(SampSegs(:,s));
    Samp_seg = SampSegs(validStress, s);
    tFSeg = tFSegs(validStress, s);

    if isempty(D1_seg) || isempty(Samp_seg)
        continue
    end

    % --- Interpolate stress amplitude to theta time base ---
    Samp_interp_seg_d1 = interp1(tFSeg, Samp_seg, ...
        t_theta, 'linear', 'extrap');
    SampInterpSegs_d1(1:length(Samp_interp_seg_d1),s) = Samp_interp_seg_d1;
    % --- Plot ---
    plot(Samp_interp_seg_d1, D1_seg, '-b', LineWidth=2); %, 25, 'filled');

end

xlabel('\sigma_{amp} (MPa)');
ylabel('D1 (kJ/m^3/cycle)');
title(sprintf('Segments: D1 vs Stress Amplitude (%.0f s window) %s',windowDissipation, test_details));
grid on;

SampInterpSegsVector_d1 = SampInterpSegs_d1(~isnan(SampInterpSegs_d1));
SampInterpSegsMean = mean(SampInterpSegs_d1,1,'omitnan');
SampInterpSegsMean = SampInterpSegsMean(:);

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Segment: Frequency Analysis From theta data

thetaX = cell(N_segTheta,1);
Amp = cell(N_segTheta,1);

for s = 1:N_segTheta

    % ---- extract valid force data ----
    theta_seg = thetaSegs(:,s);
    theta_seg = theta_seg(~isnan(theta_seg));

    if numel(theta_seg) < 10
        continue   % skip empty / too short segment
    end


    % ---- FFT ----
    N = length(theta_seg);
    Y = fft(theta_seg);
    Y(1) = NaN;

    P2 = abs(Y)/N;
    P1 = P2(1:floor(N/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = SF*(0:floor(N/2))/N; % SF_F mechanical data sampling frquency, not the IR camera sampling frequency.

    % ---- store ----
    thetaX{s} = f;
    Amp{s} = P1;

end

% ----------------- Y-axis: Amplitude (N)
figure('Name','Segment: Theta SF Analysis'); hold on; grid on;
legTxt = cell(N_segTheta,1);
for s = 1:N_segTheta
    if isempty(thetaX{s}), continue; end
    plot(thetaX{s}, (Amp{s}), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('Segment %d', s))
    legTxt{s} = sprintf('Loading Segment %d', s);
end

xlabel('Frequency (Hz)')
xticks (0:LF:round(SF)/2)
ylabel('Amplitude (K)')

title('Segments: Theta Single-Sided Amplitude Spectrum per Segment (DC Removed)', test_details);
legend(legTxt, 'Location','best');
grid on;

% --- Save figure ---
% figTitle = get(get(gca, 'Title'), 'String');
% figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
% figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
% saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% --------------------- Y-axis: Log scale
figure('Name','Segment: Theta SF Analysis (log scale)'); hold on; grid on;
legTxt = cell(N_segTheta,1);
for s = 1:N_segTheta
    if isempty(thetaX{s}), continue; end
    plot(thetaX{s}, log(Amp{s}), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('Segment %d', s))
    legTxt{s} = sprintf('Loading Segment %d', s);
end

xlabel('Frequency (Hz)')
xticks (0:LF:round(SF)/2)
ylabel('Log Amplitude (K)')

title(sprintf('Segments: Theta Single-Sided Amplitude Spectrum per Segment (DC Removed) %s', test_details));
legend(legTxt, 'Location','best');
grid on;

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Segment: SHTSA of Theta per Segment (FFT method)

% Aliasing check
if LF3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], LF3, SF/2);
end

[H1Segs, H2Segs, H3Segs, H1maxSegs, H2maxSegs, H3maxSegs] = deal(nan(maxNthetaSeg,N_segTheta));
% [H1SegsMeans, H2SegsMeans, H3SegsMeans, H1maxSegsMeans, H2maxSegsMeans, H3maxSegsMeans] = deal(nan(N_segTheta,1));

for s = 1:N_segTheta
    theta_s = thetaSegs(~isnan(thetaSegs(:,s)),s);
    N_thetaSeg_s = length(theta_s);

    if N_thetaSeg_s < SFnewTSA
        continue
    end

    t_theta_s = (0:numel(theta_s)-1)'/SF;
    t_theta_s = t_theta_s(:);


    % --- FFT frequency axis ---
    f = (0:SFnewTSA-1) * (SF/SFnewTSA);
    nWinSeg = N_thetaSeg_s - SFnewTSA + 1; % # of windows in the whole theta vector
    tplot = t_theta_s(1:nWinSeg);
    % loading window
    loading_start = t_theta_s(1);%(idx_Theta_sync(1));
    loading_end = t_theta_s(end); %(temp_idxE - SF*window);
    loading_window = find(tplot >= loading_start & tplot <= loading_end);

    % --- Preallocate ---
    maxAmpH1seg = nan(nWinSeg,1); maxFreqH1seg = nan(nWinSeg,1); ampAtH1seg = nan(nWinSeg,1); % ampAtH1C = Amplitude At H1 Continuous theta data
    maxAmpH2seg = nan(nWinSeg,1); maxFreqH2seg = nan(nWinSeg,1); ampAtH2seg = nan(nWinSeg,1);
    maxAmpH3seg = nan(nWinSeg,1); maxFreqH3seg = nan(nWinSeg,1); ampAtH3seg = nan(nWinSeg,1);

    % --- FFT method
    for k = 1:nWinSeg

        end_idx = k+SFnewTSA-1;
        segmentC = detrend(theta_s(k : end_idx), 6);
        % segment = detrend(theta(k : end_idx), 1);
        % segment = thetaC(k : end_idx);

        beta = abs(fft(segmentC)) * (2/SFnewTSA);
        idx1 = find(f >= (LF-BW) & f <= (LF+BW));
        [maxAmpH1seg(k), j1] = max(beta(idx1)); maxFreqH1seg(k) = f(idx1(j1));
        [~, i1] = min(abs(f - LF)); ampAtH1seg(k) = beta(i1);

        idx2 = find(f >= (LF2-BW) & f <= (LF2+BW));
        [maxAmpH2seg(k), j2] = max(beta(idx2)); maxFreqH2seg(k) = f(idx2(j2));
        [~, i2] = min(abs(f - LF2)); ampAtH2seg(k) = beta(i2);

        if LF3<SF/2
            idx3 = find(f >= (LF3-BW) & f <= (LF3+BW));
            [maxAmpH3seg(k), j3] = max(beta(idx3)); maxFreqH3seg(k) = f(idx3(j3));
            [~, i3] = min(abs(f - LF3)); ampAtH3seg(k) = beta(i3);
        end

    end
    H1Segs(1:numel(ampAtH1seg), s) = ampAtH1seg;
    H2Segs(1:numel(ampAtH2seg), s) = ampAtH2seg;
    H3Segs(1:numel(ampAtH3seg), s) = ampAtH3seg;

    H1maxSegs(1:numel(maxAmpH1seg), s) = maxAmpH1seg;
    H2maxSegs(1:numel(maxAmpH2seg), s) = maxAmpH2seg;
    H3maxSegs(1:numel(maxAmpH3seg), s) = maxAmpH3seg;

end

    H1SegsVector = H1Segs(~isnan(H1Segs));
    H2SegsVector = H2Segs(~isnan(H2Segs));
    H3SegsVector = H3Segs(~isnan(H3Segs));

    H1maxSegsVector = H1maxSegs(~isnan(H1maxSegs));
    H2maxSegsVector = H2maxSegs(~isnan(H2maxSegs));
    H3maxSegsVector = H3maxSegs(~isnan(H3maxSegs));

    H1SegsMeans = mean(H1Segs,1,"omitnan");
    H1SegsMeans = H1SegsMeans(:);

    H2SegsMeans = mean(H2Segs,1,"omitnan");
    H2SegsMeans = H2SegsMeans(:);

    H3SegsMeans = mean(H3Segs,1,"omitnan");
    H3SegsMeans = H3SegsMeans(:);

    H1maxSegsMeans = mean(H1maxSegs,1,"omitnan");
    H1maxSegsMeans = H1maxSegsMeans(:);

    H2maxSegsMeans = mean(H2maxSegs,1,"omitnan");
    H2maxSegsMeans = H2maxSegsMeans(:);

    H3maxSegsMeans = mean(H3maxSegs,1,"omitnan");
    H3maxSegsMeans = H3maxSegsMeans(:);

%% --- Segment's Harmonic MEANs vs MEAN stress amplitude 
nn = 3;
if LF3>SF/2
    nn = 2;
end
% -- Segment Harmonic Amplitudes vs Stress amplitude
figure('Name', 'Segment: Harmonic Amplitudes vs StressAmp');

subplot(nn,2,1);
plot(SampSegsMeans, H1SegsMeans, 'k-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Location', 'best');

subplot(nn,2,2);
plot(SampSegsMeans, H1maxSegsMeans, 'b-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Location', 'best');


subplot(nn,2,3);
plot(SampSegsMeans, H2SegsMeans, 'g-o', 'LineWidth', 2, markersize=5);
hold on;
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF2)); grid on;
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Location', 'best');

subplot(nn,2,4);
plot(SampSegsMeans, H2maxSegsMeans, 'm-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
hold on;
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Location', 'best');

if LF3<SF/2
    subplot(nn,2,5);
    plot(SampSegsMeans, H3SegsMeans, 'r-o', 'LineWidth', 2, markersize=5);
    hold on;
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF3)); grid on;
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp', 'Location', 'best');

    subplot(nn,2,6);
    plot(SampSegsMeans, H3maxSegsMeans, 'c-o', 'LineWidth', 2, markersize=5);
    hold on;
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%. 1f Hz', LF3, BW)); grid on;
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp', 'Location', 'best');
end

sg = sgtitle(sprintf('Segment: Mean Harmonic Amps. vs. Mean Stress Amp. \n%s', test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% --- Segment wise Harmonic Amplitudes vs stress amplitude 

figure('Name','Harmonics vs Stress Amplitude (All Segments)');

nn = 3;
if LF3 > SF/2
    nn = 2;
end

for s = 1:N_segTheta

    % -------------------------------------------------
    % Extract harmonic data (theta domain)
    % -------------------------------------------------
    validH = ~isnan(H1Segs(:,s));
    if ~any(validH)
        continue
    end

    H1_s     = H1Segs(validH,s);
    H2_s     = H2Segs(validH,s);
    H3_s     = H3Segs(validH,s);
    H1max_s  = H1maxSegs(validH,s);
    H2max_s  = H2maxSegs(validH,s);
    H3max_s  = H3maxSegs(validH,s);

    N_H = length(H1_s);
    t_H = (0:N_H-1)'/SF;   % theta sampling frequency


    % -------------------------------------------------
    % Extract stress amplitude (force domain)
    % -------------------------------------------------
    validS = ~isnan(SampSegs(:,s));
    if ~any(validS)
        continue
    end

    Samp_s = SampSegs(validS,s);
    N_S = length(Samp_s);
    t_S = (0:N_S-1)'/SF_F;   % force sampling frequency


    % -------------------------------------------------
    % Interpolate stress amplitude
    % -------------------------------------------------
    Samp_interp = interp1(t_S, Samp_s, t_H, 'linear', 'extrap');


    % =================================================
    % ================== PLOTTING =====================
    % =================================================

    subplot(nn,2,1); hold on;
    plot(Samp_interp, H1_s, 'k-');
    xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF)); grid on;

    subplot(nn,2,2); hold on;
    plot(Samp_interp, H1max_s, 'b-');
    xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;

    subplot(nn,2,3); hold on;
    plot(Samp_interp, H2_s, 'g-');
    xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF2)); grid on;

    subplot(nn,2,4); hold on;
    plot(Samp_interp, H2max_s, 'm-');
    xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;

    if LF3 < SF/2
        subplot(nn,2,5); hold on;
        plot(Samp_interp, H3_s, 'r-');
        xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
        title(sprintf('Amp @ %.f Hz', LF3)); grid on;

        subplot(nn,2,6); hold on;
        plot(Samp_interp, H3max_s, 'c-');
        xlabel('\sigma_{amp} (MPa)'); ylabel('Amp (K)');
        title(sprintf('Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    end

end

% sgtitle('Sliding-Window Harmonic Amplitudes vs Stress Amplitude');
sg = sgtitle(sprintf('Segment: %.1fs Sliding-Window - Harmonic Amps. vs Stress Amp.\n%s', windowTSA, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Saving Variables
% Lahore = Karachi;
% ***************************************************
% ***************************************************
% ***************************************************
% ***************************************************
if windowDissipation ~= 5 || BW ~= 1
    error('Window size is not 3 seconds or Bandwidth is not 1.');
end

ampAtH2mean = movmean(ampAtH2, SFnewTSA);
ampAtH3mean = movmean(ampAtH3, SFnewTSA);

ampAtH2Cmean = movmean(ampAtH2C, SFnewTSA);
ampAtH3Cmean = movmean(ampAtH3C, SFnewTSA);

ampAtH1 = ampAtH1(loading_window);
maxAmpH1 = maxAmpH1(loading_window);
ampAtH2 = ampAtH2(loading_window);
maxAmpH2 = maxAmpH2(loading_window);

% List of variables to save
saveVars = {'LF','SF','Force_idxS','Force_idxE','temp_idxS','temp_idxE','Ti_idxS','Ti_idxE','BeforeLoad_IdxEnd',...
    'SampInterp','theta', 'd1','D1', 'ampAtH1', 'maxAmpH1','ampAtH2','ampAtH2mean','maxAmpH2',... %'d1_SelfHeating', 'D1_SelfHeating',
    'SampC','thetaC', 'd1C','D1C', 'ampAtH1C', 'maxAmpH1C','ampAtH2C','ampAtH2Cmean', 'maxAmpH2C',...
    'SampInterpSegsVector_d1','thetaSegsVector','d1_Segs_Vector','D1SegsVector','H1SegsVector','H2SegsVector',... % From segment wise analysis
    'SampSegsMeans', 'd1SegsMeans','D1SegsMeans', 'H1SegsMeans', 'H2SegsMeans'};

% Add H3 variables only when needed
if LF3 < SF/2
    ampAtH3 = ampAtH3(loading_window);
    maxAmpH3 = maxAmpH3(loading_window);

    saveVars = [saveVars, ...
        {'ampAtH3','ampAtH3mean','maxAmpH3',...
         'ampAtH3C','ampAtH3Cmean','maxAmpH3C',...
         'H3SegsVector','H3SegsMeans'}];
end

safeTestName = strrep(test_details, '-', '_');
safeTestName = regexprep(safeTestName, '[^a-zA-Z0-9_]', '_');

matFileName = fullfile(folderPath, ['SH_d1_' num2str(windowTSA) 's_' safeTestName '.mat']);

SegEndLocs = struct();

for i = 1:numel(saveVars)

    varName = saveVars{i};
    newName = [varName '_' safeTestName];

    if exist(varName, 'var')
        SegEndLocs.(newName) = eval(varName);
    else
        warning('Variable "%s" does not exist and will not be saved.', varName);
    end

end

save(matFileName, '-struct', 'SegEndLocs');

%%
saveFolder = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\My Paper\Figures\Combined Results';

TestData.TestName     = test_details;
TestData.SampCinterp  = SampCinterp;
TestData.MeanThetaC5s = meanThetaC(:,2);
TestData.thetaC       = thetaC;
TestData.D1C5s = D1Cxx(:,2);

TestData.SampCHarmonic = SampCinterp_x;
TestData.H1C5s = AmpH1C_LS;
TestData.H2C5s = AmpH2C_LS;
TestData.H3C5s = AmpH3C_LS;

save(fullfile(saveFolder,[test_details,'.mat']), 'TestData');

%%
Fs = 44100;
t = 0:1/Fs:0.3;
y = sin(2*pi*1000*t);
sound(y, Fs)
%% Check: Is it BL test or not
% Check if folder path contains 'BL'
if ~contains(folderPath, 'BL')
    error('Terminating: folder path does not contain "BL".');
end


%% ############   Block Loading   ################
% ################################################
% ################################################
% ################################################

% Ensure column vectors
% F_fatigue = F_fatigue(:);
% 
% % --- Find peaks ---
% [Fpk, Fpk_loc] = findpeaks(F_fatigue,'MinPeakProminence',minProminence);
% 
% % --- Detect block transitions using peak jumps ---
% diffPk = diff(Fpk);
% 
% jumpThresh = 100 * mean((diffPk));
% idx_jump = find(diffPk > jumpThresh);
% 
% idx_jump = [idx_jump([true; diff(idx_jump) > 20])];
% 
% % --- Segment boundaries (in peak index space) ---
% segPeakStartIdx = [1; idx_jump + 10 + 1];
% segPeakEndIdx = [idx_jump - 10; numel(Fpk)];
% 
% N_segments = numel(segPeakStartIdx);
% 
% segment_starts = zeros(N_segments,1);
% segment_ends = zeros(N_segments,1);
% 
% for s = 1:N_segments
% 
%     % Segment start
%     if s == 1
%         segment_starts(s) = 1;                 % first segment starts at beginning
%     else
%         segment_starts(s) = Fpk_loc(segPeakStartIdx(s));% + 1;
%     end
% 
%     % Segment end = last peak before jump
%     segment_ends(s) = Fpk_loc(segPeakEndIdx(s));
% 
% end
% 
% % ==============================================================
% maxN = max(segment_ends - segment_starts +1);
% 
% ForceBL = nan(maxN, N_segments);
% thetaBL = nan(maxN, N_segments);
% t_BL = nan(maxN, N_segments);
% 
% Force_BL_X = [];
% theta_BL_X = [];
% t_BL_X = [];
% 
% for s = 1:N_segments
%     idx = segment_starts(s) : segment_ends(s);
%     N_Rows = length(idx);
% 
%     ForceBL(1:N_Rows,s) = F_fatigue(idx);
%     thetaBL(1:N_Rows,s) = theta(idx);
%     t_BL(1:N_Rows,s) = tTheta(idx);
% 
%     Force_BL_X = [Force_BL_X; F_fatigue(idx)];
%     theta_BL_X = [theta_BL_X; theta(idx)];
% end
% 
% % ==============================================================
% % NEW TIME VECTOR STARTING AT 0
% 
% dt = mode(diff(tTheta));
% t_X = (0:dt:(length(theta_BL_X)-1)*dt).'; % both Force_BL_X and theta_BL_X have same length


Force_BL_X = ForceC;
tF_X = tFC;
theta_BL_X = thetaC;
tTheta_X = tThetaC;

thetaBL = thetaSegs;


% ============================= PLOT
figure('Name','BL Segment Assembly')
plot(tF_X, Force_BL_X, 'k')
ylabel('Force (N)')
hold on
yyaxis right
plot(tTheta_X, theta_BL_X, 'r')
ylabel('\theta (K)')
xlabel('Time (s)')
title(sprintf('BL Segments: Force and theta - %s', test_details))
legend ('F continuous','\theta continuous', 'location','northwest')
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Block Loading: Stress Amplitude calculation
nRows = size(ForceSegs,1);

% triming the edgest of the force blocks to eliminate the transitional periods
startIdx = floor(0.05*nRows) + 1;
endIdx   = ceil(0.95*nRows);

ForceBL = ForceSegs(startIdx:endIdx,:);

N_segments = size(ForceBL,2);
ForceAmpBL = nan(N_segments,1);

for s = 1:N_segments

    % --- extract valid force data for this block ---
    Fblk = ForceBL(:,s);
    Fblk = Fblk(~isnan(Fblk));

    if numel(Fblk) < 10
        continue
    end

    % --- find peaks and troughs ---
    [Fpk,  ~] = findpeaks(Fblk);
    [Ftr0, ~] = findpeaks(-Fblk);
    Ftr = -Ftr0;

    % ensure equal number of cycles
    Ncyc = min(numel(Fpk), numel(Ftr));
    Fpk = Fpk(1:Ncyc);
    Ftr = Ftr(1:Ncyc);

    cyc = (1:Ncyc).';

    % --- linear fits ---
    p_pk = polyfit(cyc, Fpk, 1);
    p_tr = polyfit(cyc, Ftr, 1);

    % --- force amplitude
    ForceAmpBL(s) = (p_pk(2) - p_tr(2))/2;

end

% ---------- Stress Amp
ForceAmpBL = ForceAmpBL(:);
SampBL = ForceAmpBL./ xarea / 1e6; % unit: MPa

%% Block Loading: Mechanical dissipation calculation d1

THS_BL = nan(maxN,N_segments); % THS = Total Heat Source

for s = 1:N_segments

    % thetaBL_s = thetaBL(~isnan(thetaBL(:,s)),s);
    thetaBL_s = thetaSegs(~isnan(thetaSegs(:,s)),s);
    movmean_thetaBL_s = movmean(thetaBL_s, SFnewDissipation, 'endpoints','fill');
    % tThetaSegs = tThetaSegs
    tBL_s = tThetaSegs(~isnan(tThetaSegs(:,s)), s);
    tBL_s = tBL_s - tBL_s(1);

    THS_BL_s = nan(size(thetaBL_s));
    kd = (SFnewDissipation-1)/2;

    for k = (SFnewDissipation):length(thetaBL_s)-(SFnewDissipation-1)
        THS_BL_s(k) = rho * C * (((movmean_thetaBL_s(k+kd) - movmean_thetaBL_s(k-kd)) / (tBL_s(k+kd) - tBL_s(k-kd))) + movmean_thetaBL_s(k)/tau);
    end

    THS_BL_s = THS_BL_s/1000; % Converting units into kilo

    THS_BL(1:length(THS_BL_s),s) = THS_BL_s;
end

d1BL_mean = mean(THS_BL,"omitnan") - STE_HSR(1,2)/1e3; % STE_HSR(1,2) is the one calculated with window size of 5s
d1BL_mean = d1BL_mean(:);
D1BL_mean = d1BL_mean / LF;

%% ----- Plot D1, D1C, D1BL
figure('Name','D1, D1C, D1BL vs Samp')
plot(SampInterp,D1,'-b', LineWidth=2)
hold on;
plot(SampCinterp,D1C,'-k', LineWidth=1.5)
plot(SampBL,D1BL_mean,'-o', markersize=5, LineWidth=2)
grid on
title(sprintf('D1, D1C, D1BL vs \sigma_{amp} - %s', test_details))
xlabel('\sigma_{amp} (MPa)')
ylabel('D1 (kJ·m^{-3}/cycle)')
legend ('D1','D1C', 'D1BL',Location='northwest')

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Block Loading: Loading frequency analysis for each bloc

% Separating force blocks from the F_fatigue

% Ensure column vectors
F_fatigue = F_fatigue(:);

% --- Find peaks ---
[Fpk, Fpk_loc] = findpeaks(F_fatigue,'MinPeakProminence',minProminence);

% --- Detect block transitions using peak jumps ---
diffPk = diff(Fpk);

jumpThresh = 100 * mean((diffPk));
idx_jump = find(diffPk > jumpThresh);

idx_jump = [idx_jump([true; diff(idx_jump) > 20])];

% --- Segment boundaries (in peak index space) ---
segPeakStartIdx = [1; idx_jump + 10 + 1];
segPeakEndIdx = [idx_jump - 10; numel(Fpk)];

N_segments = numel(segPeakStartIdx);

segment_starts = zeros(N_segments,1);
segment_ends = zeros(N_segments,1);

for s = 1:N_segments

    % Segment start
    if s == 1
        segment_starts(s) = 1;                 % first segment starts at beginning
    else
        segment_starts(s) = Fpk_loc(segPeakStartIdx(s));% + 1;
    end

    % Segment end = last peak before jump
    segment_ends(s) = Fpk_loc(segPeakEndIdx(s));

end

maxN =  max(segment_ends - segment_starts +1);

Fatigue_BL = nan(maxN, N_segments);
Fatigue_BL_X = [];

for s = 1:N_segments
    idx = segment_starts(s) : segment_ends(s);
    N_Rows = length(idx);
    Fatigue_BL(1:N_Rows,s) = F_fatigue(idx);
    Fatigue_BL_X = [Fatigue_BL_X; F_fatigue(idx)];
end


Freq = cell(N_segments,1);
Amp = cell(N_segments,1);

for s = 1:N_segments

    % ---- extract valid force data ----
    F = Fatigue_BL(:,s);
    F = F(~isnan(F));
    % F = Fatigue_BL_X;

    if numel(F) < 10
        continue   % skip empty / too short blocks
    end

    % ---- detrend (important for block loading) ----
    F = detrend(F); % detrend best linear fit

    % ---- FFT ----
    N = length(F);
    Y = fft(F);
    Y(1) = NaN;

    P2 = abs(Y)/N;
    P1 = P2(1:floor(N/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = SF_F*(0:floor(N/2))/N; % SF_F mechanical data sampling frquency, not the IR camera sampling frequency.

    % ---- store ----
    Freq{s} = f;
    Amp{s} = P1;

end

figure('Name','BL: Loading Frequency Analysis'); hold on; grid on;
legTxt = cell(N_segments,1);
for s = 1:N_segments
    if isempty(Freq{s}), continue; end
    plot(Freq{s}, log(Amp{s}), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('Block %d', s))
    legTxt{s} = sprintf('Loading Block %d', s);
end

xlabel('Frequency (Hz)')
xticks (0:LF:round(SF_F)/2)
ylabel('Log Amplitude (N)')

title(sprintf('BL: Force Single-Sided Amplitude Spectrum per Segment (DC Removed) - %s', test_details));
legend(legTxt, 'Location','best');
grid on;

figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));



%% Block Loading: Frequency Analysis From theta data
N = length(theta);

dtheta    = diff(theta);
dthetaAbs = abs(dtheta);
% thr = 0.0039; %
zz = findpeaks(dthetaAbs);
thr = .008;%min(zz(1:600)); % dtermined this value after plotting Z, where Z = findpeaks(dthetaAbs);
[pkVals, pkLocs] = findpeaks(dthetaAbs, 'MinPeakProminence', thr); %0.0039);

% Peak-to-peak distance
dPk = diff(pkLocs);

% A new segment starts when gap > 100 samples
segBreakIdx = find(dPk > 400);
segBreakIdx = segBreakIdx([true; diff(segBreakIdx) > 500]);

% Segment start indices (in theta)
segStart = [1; pkLocs(segBreakIdx+1)];
segStart = segStart + 100;
% Segment end indices (in theta)
segEnd = [pkLocs(segBreakIdx); N];
segEnd = segEnd - 100;
ZZ = [segStart,segEnd]

numSeg = numel(segStart);

fprintf('Detected %d theta segments.\n', numSeg);

segLengths = segEnd - segStart + 2;
maxLen     = max(segLengths);

thetaSeg = NaN(maxLen, numSeg);

for k = 1:numSeg
    idx = segStart(k):segEnd(k);
    thetaSeg(1:numel(idx), k) = theta(idx);
end

figure('Name','BL: Theta segments')
plot(thetaSeg(:,1:numSeg))
xlabel ('Idx')
ylabel ('Temperature (K)')

freqCell = cell(numSeg,1);
ampCell  = cell(numSeg,1);
domFreq  = NaN(numSeg,1);

for k = 1:numSeg
    x = thetaSeg(:,k);
    x = x(~isnan(x));        % remove NaN padding
    x = detrend(x);          % detrend best linear fit
    L = length(x);

    % FFT parameters
    NFFT = 2^nextpow2(L);

    % FFT
    X = fft(x, NFFT);

    % Single-sided amplitude spectrum
    P2 = abs(X / NFFT);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2 * P1(2:end-1);

    % Frequency vector
    f = SF * (0:(NFFT/2)) / NFFT;

    % Store spectra
    freqCell{k} = f;
    ampCell{k}  = P1;

    % Dominant frequency (exclude DC)
    [~, idxMax] = max(P1(2:end));
    domFreq(k) = f(idxMax + 1);

end

disp('Dominant frequency of each theta segment [Hz]:');
disp(domFreq);

figure('Name','BL: Theta Frequency Analysis'); hold on; box on;
legTxt = cell(numSeg,1);

for k = 1:numSeg
    myWindowSize = freqCell{k};
    yy = ampCell{k};
    yy(1) = NaN;
    % plot(freqCell{k}, log(ampCell{k}), 'LineWidth', 1);
    plot(myWindowSize, (yy), 'LineWidth', 1);
    legTxt{k} = sprintf('Seg %d', k);
end

xlabel('Frequency (Hz)', 'Interpreter','latex');
ylabel('Amplitude', 'Interpreter','latex');
% title('Frequency Content of All $\theta$ Segments', 'Interpreter','latex');
title(sprintf('BL: theta Single-Sided Amplitude Spectrum per Segment (DC Removed) - %s', test_details));
legend(legTxt, 'Location','best');
grid on;

%--------- sacing plot
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Block Loading: SHTSA of BL Theta (FFT method)

% Aliasing check
if LF3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], LF3, SF/2);
end

[H1BL, H2BL, H3BL, H1maxBL, H2maxBL, H3maxBL] = deal(nan(N_segments,1));

for s = 1:N_segments
    thetaBL_s = thetaBL(~isnan(thetaBL(:,s)),s);
    N_thetaBL_s = length(thetaBL_s);

    tBL_s = tThetaSegs(~isnan(tThetaSegs(:,s)), s);
    tBL_s = tBL_s - tBL_s(1);


    % --- FFT frequency axis ---
    f = (0:SFnewTSA-1) * (SF/SFnewTSA);
    nWinBL = N_thetaBL_s - SFnewTSA + 1; % # of windows in the whole theta vector
    tplot = tBL_s(1:nWinBL);
    % loading window
    loading_start = tBL_s(1);%(idx_Theta_sync(1));
    loading_end = tBL_s(end); %(temp_idxE - SF*window);
    loading_window = find(tplot >= loading_start & tplot <= loading_end);

    % --- Preallocate ---
    maxAmpH1C = nan(nWinBL,1); maxFreqH1C = nan(nWinBL,1); ampAtH1C = nan(nWinBL,1); % ampAtH1C = Amplitude At H1 Continuous theta data
    maxAmpH2C = nan(nWinBL,1); maxFreqH2C = nan(nWinBL,1); ampAtH2C = nan(nWinBL,1);
    maxAmpH3C = nan(nWinBL,1); maxFreqH3C = nan(nWinBL,1); ampAtH3C = nan(nWinBL,1);

    % --- FFT method
    for k = 1:nWinBL

        end_idx = k+SFnewTSA-1;
        segmentC = detrend(thetaBL_s(k : end_idx), 6);
        % segment = detrend(theta(k : end_idx), 1);
        % segment = thetaC(k : end_idx);

        beta = abs(fft(segmentC)) * (2/SFnewTSA);
        idx1 = find(f >= (LF-BW) & f <= (LF+BW));
        [maxAmpH1C(k), j1] = max(beta(idx1)); maxFreqH1C(k) = f(idx1(j1));
        [~, i1] = min(abs(f - LF)); ampAtH1C(k) = beta(i1);

        idx2 = find(f >= (LF2-BW) & f <= (LF2+BW));
        [maxAmpH2C(k), j2] = max(beta(idx2)); maxFreqH2C(k) = f(idx2(j2));
        [~, i2] = min(abs(f - LF2)); ampAtH2C(k) = beta(i2);

        if LF3<SF/2
            idx3 = find(f >= (LF3-BW) & f <= (LF3+BW));
            [maxAmpH3C(k), j3] = max(beta(idx3)); maxFreqH3C(k) = f(idx3(j3));
            [~, i3] = min(abs(f - LF3)); ampAtH3C(k) = beta(i3);
        end

    end
    H1BL(s,1) = mean(ampAtH1C,"omitnan");
    H2BL(s,1) = mean(ampAtH2C,"omitnan");
    H3BL(s,1) = mean(ampAtH3C,"omitnan");

    H1maxBL(s,1) = mean(maxAmpH1C,"omitnan");
    H2maxBL(s,1) = mean(maxAmpH2C,"omitnan");
    H3maxBL(s,1) = mean(maxAmpH3C,"omitnan");
end


%% ---BL: TSA Plots of Amplitudes from FFT method ---
nn = 3;
if LF3>SF/2
    nn = 2;
end

% -- BL Harmonic Amplitudes vs Stress amplitude
figure('Name','BL: Harmonic Amplitudes vs Stress Amp');%);%,'NumberTitle','off');

subplot(nn,2,1);
% yyaxis left
plot(SampBL, H1BL,'k-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


subplot(nn,2,2);
% yyaxis left
plot(SampBL, H1maxBL, 'b-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


subplot(nn,2,3);
% yyaxis left
plot(SampBL, H2BL, 'g-o', 'LineWidth', 2, markersize=5);
hold on;
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF2)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


subplot(nn,2,4);
% yyaxis left
plot(SampBL, H2maxBL, 'm-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
hold on;
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF2, BW)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


if LF3<SF/2
    subplot(nn,2,5);
    % yyaxis left
    plot(SampBL, H3BL, 'r-o', 'LineWidth', 2, markersize=5);
    hold on;
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', LF3 )); grid on;
    % yyaxis right
    % plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Location', 'best');

    subplot(nn,2,6);
    % yyaxis left
    plot(SampBL, H3maxBL, 'c-o', 'LineWidth', 2, markersize=5);
    hold on;
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', LF3, BW)); grid on;
    % yyaxis right
    % plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Location', 'best');

end

sg = sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n(mean \\theta removed) - %s', windowDissipation, test_details));

% --- Save figure ---
figTitle = sg.String;
if iscell(figTitle)
    figTitle = strjoin(figTitle,' ');
end
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars
figureName = strrep(figureName, ' ', '_');        % replace spaces with underscores
figureName = strrep(figureName, newline, '_');    % remove newline characters
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%% ============    BL: Least Square Method Harmonic Amplitudes  =================

% Aliasing check
if LF3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], LF3, SF/2);
end

[H1BL_LS,H2BL_LS,H3BL_LS] = deal(nan(N_segments,1));

for s = 1:N_segments

    thetaBL_s = thetaBL(~isnan(thetaBL(:,s)),s);
    tBL_s     = tThetaSegs(~isnan(tThetaSegs(:,s)),s);

    tBL_s = tBL_s - tBL_s(1);

    N_thetaBL_s = length(thetaBL_s);

    nWinBL = N_thetaBL_s - SFnewTSA + 1;

    % --- Preallocate ---
    H1_win = nan(nWinBL,1);
    H2_win = nan(nWinBL,1);
    H3_win = nan(nWinBL,1);

    for k = 1:nWinBL

        end_idx = k + SFnewTSA - 1;

        % Windowed segment
        y = thetaBL_s(k:end_idx);

        % Optional detrending
        y = detrend(y,6);

        % Time vector
        t = tBL_s(k:end_idx);
        t = t - t(1);

        % Fundamental angular frequency
        w1 = 2*pi*LF;

        % =========================================================
        % Least Squares Harmonic Matrix
        % =========================================================

        A = [ ...
            ones(length(t),1), ...
            sin(w1*t), cos(w1*t), ...
            sin(2*w1*t), cos(2*w1*t), ...
            sin(3*w1*t), cos(3*w1*t)];

        % Least squares solution
        x = A \ y;

        % =========================================================
        % Harmonic amplitudes
        % =========================================================

        % First harmonic
        a1 = x(2);
        b1 = x(3);

        % Second harmonic
        a2 = x(4);
        b2 = x(5);

        % Third harmonic
        a3 = x(6);
        b3 = x(7);

        H1_win(k) = sqrt(a1^2 + b1^2);
        H2_win(k) = sqrt(a2^2 + b2^2);
        H3_win(k) = sqrt(a3^2 + b3^2);

    end

    % Mean harmonic amplitudes over windows
    H1BL_LS(s,1) = mean(H1_win,"omitnan");
    H2BL_LS(s,1) = mean(H2_win,"omitnan");
    H3BL_LS(s,1) = mean(H3_win,"omitnan");

end

%% ========================= BL: Plot Harmonic Amplitudes =========================
% First Harmonic
% ==========================

figure('Name', 'BL: First Harmonic Amplitude'); hold on; grid on; box on;

plot(SampBL, H1BL_LS, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);

xlabel('SampBL');
ylabel('1st Harmonic Amplitude');

title('First Harmonic vs SampBL');

legend('1st Harmonic', 'Location', 'best');


% =========================
% Second and Third Harmonics
% ==========================

figure('Name', 'BL: Second Third Harmonic Amplitudes');
hold on;
grid on;
box on;

plot(SampBL, H2BL_LS, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);

plot(SampBL, H3BL_LS, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);

xlabel('SampBL');
ylabel('Harmonic Amplitude');

title('Higher Harmonics vs SampBL');

legend('2nd Harmonic', '3rd Harmonic', 'Location', 'best');

%%
saveFolder = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\My Paper\Figures\Combined Results';

TestData.TestName     = test_details;
TestData.SampCinterp  = SampCinterp;
TestData.thetaC       = thetaC;
TestData.MeanThetaC5s = meanThetaC(:,2);

TestData.SampBL = SampBL;
TestData.meanD1BL = D1BL_mean;
TestData.meanH1BL = H1BL_LS;
TestData.meanH2BL = H2BL_LS;
TestData.meanH3BL = H3BL_LS;

save(fullfile(saveFolder,[test_details,'.mat']), 'TestData');

%% Block Loading: Saving Variables
if windowDissipation ~= 5 || BW ~= 1
    error('Window size is not 3 seconds or Bandwidth is not 1.');
end

SampC = SampBL;
d1C = d1BL_mean;
D1C = D1BL_mean;

ampAtH1C = H1BL_LS;
ampAtH2C = H2BL_LS;
ampAtH2Cmean = H2BL_LS;

maxAmpH1C = H1maxBL;
maxAmpH2C = H2maxBL;

% List of variables to save
saveVars = {'LF','SF','Force_idxS','Force_idxE','temp_idxS','temp_idxE','Ti_idxS','Ti_idxE','BeforeLoad_IdxEnd',...
    'SampInterp','theta', 'd1','D1', 'ampAtH1', 'maxAmpH1','ampAtH2','ampAtH2mean','maxAmpH2',... %'d1_SelfHeating', 'D1_SelfHeating',
    'SampC','thetaC', 'd1C','D1C', 'ampAtH1C', 'maxAmpH1C','ampAtH2C','ampAtH2Cmean', 'maxAmpH2C'};

% Add H3 variables only when needed
if LF3 < SF/2
    % ampAtH3 = ampAtH3(loading_window);
    % maxAmpH3 = maxAmpH3(loading_window);
    ampAtH3C = H3BL_LS;
    ampAtH3Cmean = H3BL_LS;
    maxAmpH3C = H3maxBL;
    saveVars = [saveVars, {'ampAtH3', 'ampAtH3mean','maxAmpH3','ampAtH3C', 'ampAtH3Cmean','maxAmpH3C'}];
end

safeTestName = strrep(test_details, '-', '_');
safeTestName = regexprep(safeTestName, '[^a-zA-Z0-9_]', '_');

% Construct MAT file path
matFileName = fullfile(folderPath, ['SH_d1_' test_details '.mat']);

% Save variables with suffixed names
SegEndLocs = struct();       % temporary structure

for i = 1:numel(saveVars)
    varName = saveVars{i};                % e.g. 'SampInterp'
    newName = [varName '_' safeTestName]; % e.g. 'SampInterp_Test3_Take3'

    if evalin('base', sprintf('exist(''%s'',''var'')', varName))
        SegEndLocs.(newName) = evalin('base', varName);
    else
        warning('Variable "%s" does not exist and will not be saved.', varName);
    end
end


% Save the structure to MAT file
save(matFileName, '-struct', 'SegEndLocs');

fprintf('\nSaved variables to:\n%s\n', matFileName);

%% End of Scrip Sound
Fs = 44100;
t = 0:1/Fs:0.3;
y = sin(2*pi*1000*t);
sound(y, Fs)

%%
% 3-Mar-2026
% Trying to process SS304 2026 data. However, there is an issue of frames
% dropped. Need to lookinto the issue.



%%
figure('Name','Continuous: First Harmonic Amplitude vs SampC'); 
plot(SampCinterp_x, ampAtH1C(loading_window), 'k', 'LineWidth', 2);
ylabel('Amplitude (K)');
title(sprintf('Continuous: First Harmonic Amplitude vs SampC @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


figure('Name','Continuous: Second Harmonic Amplitude vs SampC'); 
plot(SampCinterp_x, movmean(ampAtH2C(loading_window)*1e3, SF*5, 'Endpoints', 'fill'), '-g', 'LineWidth', 2);
ylabel('Amplitude (mK)');
title(sprintf('Continuous: Second Harmonic Amplitude vs SampC @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

figure('Name','Continuous: Third Harmonic Amplitude vs SampC'); 
plot(SampCinterp_x, movmean(ampAtH3C(loading_window)*1e3, SF*5, 'Endpoints', 'fill'), '-g', 'LineWidth', 2);
ylabel('Amplitude (mK)');
title(sprintf('Continuous: Third Harmonic Amplitude vs SampC @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%%
figure('Name','Continuous: 2nd 3rd Harmonic Amplitude vs SampC'); 
plot(SampCinterp_x, movmean(ampAtH2C(loading_window)*1e3, SF*5, 'Endpoints', 'fill'), '-g', 'LineWidth', 2);
hold on
plot(SampCinterp_x, movmean(ampAtH3C(loading_window)*1e3, SF*5, 'Endpoints', 'fill'), '-b', 'LineWidth', 2);
ylabel('Amplitude (mK)');
title(sprintf('Continuous: 2nd and 3rd Harmonic Amplitude vs SampC @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));


%%
%% Continuous: Frequency Analysis of Theta of Loading Period
% T0DC_fatigue = T0DC_fatigue;

N_thetaCLoading = length(T0DC_fatigue);
f = (0:floor(N_thetaCLoading/2)) * (SF / N_thetaCLoading);

% FFT computation
P1 = abs(fft(T0DC_fatigue,N_thetaCLoading)) * (2/N_thetaCLoading);
P1 = P1(1 : floor(N_thetaCLoading/2)+1);
P1(1) = NaN; % Remove DC component

figure('Name', 'Continuous: Amplitude Spectrum');
plot(f, log(P1), '.r', 'MarkerSize', 5, DisplayName='theta-loading'); hold on;
title('Continuous: T0D (loading) Frequency Analysis', test_details);
xlabel('Frequency (Hz)');
xticks(0:LF:ceil(SF/2/100)*100)
ylabel('Amplitude (log)');
grid on;
legend

N_thetaCLoadingTrunc = N_thetaCLoading;
while mod(N_thetaCLoadingTrunc, SF/LF) >= 1e-9
    N_thetaCLoadingTrunc = N_thetaCLoadingTrunc -1;
end


% T_total = N_thetaCLoading / SF;
% k = floor(T_total * LF);   % integer number of cycles
% T_trunc = k / LF;
% N_thetaCLoadingTruncX = floor(T_trunc * SF);


Ndiff = N_thetaCLoading - N_thetaCLoadingTrunc;
thetaCTruncIdx = Ndiff+1:N_thetaCLoading;

thetaTrunc = T0DC_fatigue(thetaCTruncIdx);

fTrunc = (0:floor(N_thetaCLoadingTrunc/2)) * (SF / N_thetaCLoadingTrunc);

% FFT computation
P1TruncX = abs(fft(thetaTrunc,N_thetaCLoadingTrunc)) * (2/N_thetaCLoadingTrunc);
P1TruncX = P1TruncX(1 : floor(N_thetaCLoadingTrunc/2)+1);
P1TruncX(1) = NaN; % Remove DC component

hold on
plot(fTrunc, log(P1TruncX), '.b', 'MarkerSize', 5, DisplayName='theta-loading truncated');


%%
saveFolder = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\My Paper\Figures\Combined_Theta';

TestData.TestName     = test_details;
TestData.SampCinterp  = SampCinterp;
TestData.MeanThetaC5s = meanThetaC(:,2);
TestData.thetaC       = thetaC;
TestData.D1C5s = D1Cxx(:,2);

TestData.SampCHarmonic = SampCinterp_x;
TestData.H1C5s = AmpH1C_LS;
TestData.H2C5s = AmpH2C_LS;
TestData.H3C5s = AmpH3C_LS;

save(fullfile(saveFolder,[test_details,'.mat']), 'TestData');



%%
files = dir(fullfile(saveFolder,'*.mat'));

for k = 1:length(files)

    load(fullfile(saveFolder,files(k).name));

    theta  = TestData.thetaC;
    stress = TestData.SampCinterp;

    plot(stress, theta)
    hold on

end






%% Rough work
% Min-max normalization of all series
thetaC_n      = (thetaC - min(thetaC)) / (max(thetaC) - min(thetaC));
meanThetaC_n  = movmean(thetaC_n,SFnewTSA,'Endpoints','fill'); %(meanThetaC(:,2) - min(meanThetaC(:,2))) / (max(meanThetaC(:,2)) - min(meanThetaC(:,2)));

AmpH3_mov = movmean(AmpH3C_LS*1e3, SFnewTSA, 'Endpoints','fill');
AmpH2_mov = movmean(AmpH2C_LS*1e3, SFnewTSA, 'Endpoints','fill');


AmpH3_n = (AmpH3_mov - min(AmpH3_mov)) / (max(AmpH3_mov) - min(AmpH3_mov));
AmpH2_n = (AmpH2_mov - min(AmpH2_mov)) / (max(AmpH2_mov) - min(AmpH2_mov));

% Single plot (all normalized to [0 1])
figure;
plot(SampCinterp,   thetaC_n,     '-r', 'LineWidth', 1.5); hold on;
plot(SampCinterp,   meanThetaC_n, '-g', 'LineWidth', 2);
ylabel('\theta Normalized amplitude (min-max)');

yyaxis right
plot(SampCinterp_x, AmpH3_n,      '-k', 'LineWidth', 2.5);
plot(SampCinterp_x, AmpH2_n,      '-b', 'LineWidth', 2.5);
ylabel('Harmonics Normalized amplitude (min-max)');

ylim([0 1]);
xlim([0 210]);
xticks(0:30:210);

grid on; box on;
xlabel('Sample / Time');

legend('\theta_C', 'mean\Theta_C(:,2)', 'AmpH3_{LS} (movmean)', 'AmpH2_{LS} (movmean)', ...
       'Location', 'best');
title('Min-max normalized comparison');
set(gcf,'MenuBar','figure','ToolBar','figure');

xlim([14 60])
yyaxis left
ylim([0 0.008])
yyaxis right
ylim([.0 .5])

%%
close all
figure;
yyaxis left
plot(SampCinterp, thetaC, '-r', 'LineWidth', 1.5); hold on;
plot(SampCinterp, meanThetaC(:,2), '-g', 'LineWidth', 2);
ylabel('K');
ylim([-1 24]);          % your left-axis range

yyaxis right
plot(SampCinterp_x, movmean(AmpH3C_LS*1e3, SFnewTSA, 'Endpoints','fill'), '-k', 'LineWidth', 2.5);
plot(SampCinterp_x, movmean(AmpH2C_LS*1e3, SFnewTSA, 'Endpoints','fill'), '-b', 'LineWidth', 2.5);
ylabel('mK');

% ---- Align zeros ----
% Left axis currently goes from -2 to 24  →  total span = 26
% Zero is located at 2/26 ≈ 0.077 of the way up from the bottom.

leftMin = -1;
leftMax = 24;
fracZero = -leftMin / (leftMax - leftMin);   % fraction from bottom where zero sits

% Right axis data goes 0 → 4. We keep the same fraction for zero.
rightDataMax = 4;
rightMin = -rightDataMax * fracZero / (1 - fracZero);
rightMax = rightDataMax;

ylim([rightMin rightMax]);
% ylim([-0.5 4])

xlim([0 210])
xticks(0:30:210)

grid on; box on;
xlabel('Sample / Time');
% legend('\theta_C', 'mean\Theta_C(:,2)', 'AmpH2C_{LS} \times 10^3', 'Location', 'best');
title('Comparison of \theta_C, mean\Theta_C and AmpH2');
set(gcf,'MenuBar','figure','ToolBar','figure');

xlim([14 80])
yyaxis left
ylim([-.15 0.02])
yyaxis right
ylim([.02 0.5])

%% Saving variable to Excel Spreadsheet
AmpH3_mov = movmean(AmpH3C_LS*1e3, SFnewTSA, 'Endpoints','fill');
AmpH2_mov = movmean(AmpH2C_LS*1e3, SFnewTSA, 'Endpoints','fill');

n1 = length(SampCinterp);
n2 = length(SampCinterp_x);
N  = max(n1, n2);

% Pad shorter vectors with NaN
SampCinterp_p   = [SampCinterp(:); NaN(N-n1,1)];
thetaC_p        = [thetaC(:);      NaN(N-n1,1)];
meanThetaC_p    = [meanThetaC(:,2); NaN(N-n1,1)];
D1C_p             = [D1Cxx(:,2);   NaN(N-n1,1)];

SampCinterp_x_p = [SampCinterp_x(:); NaN(N-n2,1)];
AmpH3_p         = [AmpH3_mov(:);   NaN(N-n2,1)];
AmpH2_p         = [AmpH2_mov(:);   NaN(N-n2,1)];


T = table(SampCinterp_p, thetaC_p, meanThetaC_p, D1C_p,...
          SampCinterp_x_p, AmpH3_p, AmpH2_p, ...
    'VariableNames', {'SampCinterp','thetaC','meanThetaC', 'D1C',...
                      'SampCinterp_x','AmpH3_movmean_mK','AmpH2_movmean_mK'});

writetable(T, 'theta_and_amplitudes.xlsx');
%%
figure('Name','Continuous: LS H2 & H3 Amplitudes vs Stress'); hold on; grid on
title(sprintf('Continuous: LS H2 and H3 Amplitudes - porder = %0.0f', pOrder))

h = plot(SampCinterp_x, AmpH3C_LS*1e3, 'ob','MarkerSize',2,'DisplayName','H3 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampCinterp_x, AmpH2C_LS*1e3, 'or','MarkerSize',2,'DisplayName','H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

h = plot(SampCinterp_x, AmpH4C_LS*1e3, 'ok','MarkerSize',2,'DisplayName','H2 Raw');
set(h, 'MarkerFaceColor', h.Color);

xlabel('\sigma_{amp} (MPa)')
ylabel('Amplitude (mK)')
legend

xlim([0 210])
xticks(0:30:210)
xtickangle(90)

ylim([0 4])
yticks(0:1:4)
set(gcf, 'Position', [688 535 657 480])
set(gca, 'FontSize', 20)
set(gcf,'MenuBar','figure','ToolBar','figure');
box on

figure('Name', 'Continuous: theta, Avg.Theta vs SampC');
plot(SampCinterp, thetaC, '-r', LineWidth=5); hold on; %
plot(SampCinterp, meanThetaC(:,1),'-k', linewidth= 2); grid
plot(SampCinterp, meanThetaC(:,2),'g-',linewidth= 2); 
plot(SampCinterp, meanThetaC(:,3),'-b',linewidth= 2); 
xlabel('\sigma_{amp} (MPa)');
ylabel('(\theta) (K)');
title(sprintf('Continuous: Theta, Averged theta vs Stress Amplitude - %s', test_details));
legend('\theta','\theta_{avg-1s}','\theta_{avg-5s}','\theta_{avg-9s}','Location','northwest');