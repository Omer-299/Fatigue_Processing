% V5 - Removes the mean from the temperature segments in the TSA.
clc; clear all; set(groot, 'defaultAxesGridColor', [0.5 0.5 0.5]); set(groot, 'defaultAxesGridAlpha', 0.8); set(groot, 'defaultAxesLineWidth', 1);
close all; 
%% Input parameters
% Averaging window size
window = 3;  BW = 1; % bandwidth [Hz]
movmeanFactor = 3;    % theta = movmean(theta, movmeanFactor);

%%
% Force
LF = 20; % Loading frequency in Hz
Force_idxS = 1; %16018; %19580; % %33954;  % value to be adjusted after reviewing 'Clean' force vs Index. Start point of proper loading - count the selected Fhigh (peak) from the start of the cyclic loading, and select the T_0D trough accordingly.
Force_idxE = 9726265; %726265;%726290; % %726975; % of Clean force % End index for force (last peak point) - To be found through force plot of 'clean force'. Clean force is the one which is plotted after removing the 'time' vector's duplicate values.
minFthresh = 0.05;

% theta
SF = 353; % Sampling frequency for thermal data (should be Verfied from the time_diff)
temp_idxS = 1; %8662-1;%13675+2; % %19156;%%5932 ; %8763; % Start index for theta (low peak in accordance to the count of Fhigh selected in Force_idxS) - To be found through temperature plot.
temp_idxE = 9133533; %133533;%137981; % %141019;% %129796; % End index for theta (last low peak) - To be found through temperature plot.

% For Force through linear fitting
% maxF = 3000; % Maximum force in N
% maxF_increment_per_cycle = 1; % This is the desired f max increment per cycle fromt the machine.

%% SS316L
folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1634_VALIR_PT_Test-2_Take-2\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1535_VALIR_PT_Test-1_Take-1\Test1';

% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1431_VIRG_Test-1_Take-2\Test1'; cd(folderPath);
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS316_VAL\20260115\SS316L_20260115_1415_VIRG_Test-1_Take-1\Test1'; cd(folderPath);

%% SS304

% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-3_Take-3\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-3_Take-2\Test1';

% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-14\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-13\Test1';  
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-12\Test1';
% folderPath = 'C:\Users\mo170\OneDrive - The University of Waikato\PhD\Experiments\SS304_VAL\20251118\20251118_SS304_Test-2_Take-11\Test1';
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
thick = 1/1000;     width = 15/1000;    % Thickness 1mm for SS304 specimen    % Width 15mm for SS304 specimen

% rho = 8000;     C = 500;    alpha = 17.3e-6;    tau = 72; %(68+76)/2; for SS304L
% rho = 8000;     C = 500;    tau = 82.5; %(90+75)/2; for SS316L - material properties are almos same as SS304L

% % SS304: Density (kg/m^3): 8000; Specific heat (J/kg-K): 500; Linear Coefficient of Thermal Expansion (1/K): 17.3e-6 1/K;
% % Reference: https://www.matweb.com/search/DataSheet.aspx?MatGUID=edb229c36fc849628289705c796c4d89
% % Thermal time constant in seconds - see the graphs of Tau estimation: SS304\A_TAU_MEASUREMENT\Return_to_ambiant_1 and Return_to_ambiant_2, with 68 and 76 seconds respectively.
% Km = alpha / (rho * C);
xarea = thick * width; % Cross-sectional area in m^2

% -------- Material identification from folder name --------
folderName = lower(folderPath);   % case-insensitive comparison

% -------- Default (fail-safe) values --------
rho   = 8000;          % kg/m^3
C     = 500;           % J/(kg·K)
alpha = 17.3e-6;       % 1/K (austenitic stainless steel)
tau   = NaN;           % s (must be set explicitly)

% -------- Material-specific assignment --------
if contains(folderName, 'ss304')
    % SS 304L
    materialStr = 'SS304L';
    tau = 72;          % s  (mean of 68–76 s)

elseif contains(folderName, 'ss316')
    % SS 316L
    materialStr = 'SS316L';
    tau = 82.5;        % s  (mean of 75–90 s)

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
    testName = sprintf('%s %s %s %s', materialStr , dateStr, cleanTest, cleanTake);

else
    testName = sprintf('%s UnknownTest', dateStr);
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

fprintf('\nFirst time in mechanical data: %0.5fs. This time is subtracted to start from zero\n', tF(1));

tF = tF - tF(1); % Start time at zero

% Force vs index (raw force data)
figure('Name', 'Raw data: Force vs. Index');
plot(force,'-k');
title(['Raw data: Force vs. Index - ', testName]);
legend('raw force data','Location', 'northwest');
xlabel('Index'); ylabel('Force (N)')
grid on


% Force vs time (raw force data)
figure('Name', 'Raw data: Force vs. Time');
plot(tF,force,'-k');
title(['Raw data: Force vs. Time - ', testName]);
legend('raw force data','Location', 'northwest');
xlabel('Time (s)'); ylabel('Force (N)')
grid on

% Position plot
position = data(1:end,7); %
position = position  - position(1);

% Separating high and low peaks
pos_minProminence = 0.00005 * max(position); % Minimum peak prominence
[pos_highs, pos_locs_highs] = findpeaks(position, 'MinPeakProminence', pos_minProminence);
pos_Time_highs = tF(pos_locs_highs);

[pos_lows, pos_locs_lows] = findpeaks(-position, 'MinPeakProminence', pos_minProminence);
pos_Time_lows = tF(pos_locs_lows);
pos_lows = -pos_lows;


figure('Name', 'Raw data: Position vs. Force');
plot(force, position);
title(['Raw data: Position vs. Force - ', testName]);
legend('raw force data','Location', 'northwest');
xlabel('Force (N)'); ylabel('Position (mm)'); 
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% plot Fhighs and Flows
figure('Name', 'Raw data: Position vs. Time');
plot(pos_Time_highs,pos_highs, '.r',MarkerSize=10);
title(['Raw data: Position vs. Time - ', testName]);
hold on
plot(pos_Time_lows, pos_lows, '.b',MarkerSize=10)
plot(tF,position,'-k', LineWidth=0.5)
grid on
legend ('Pos-max','Pos-min', 'location','northwest')
xlabel('Time (s)')
ylabel('Position (mm)')

% --- Checking for any issues with time data
tF_diff = [nan;round(diff(tF),9)];

% Determining the sampling frequency of force data by fatigue testing machine (Instron)
mode_tF_diff =  mode(tF_diff);
SF_F = round(1/mode_tF_diff, 9); % Sampling Frequency of Force data
disp(['Sampling frequency of force data (SF-force) as per experimental data: ', num2str(SF_F), 'Hz']);  %

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
title('diff(tF clean)',testName)
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
title('Clean force vs Index',testName)
legend('Clean force data','Location', 'northwest');
xlabel('Index'); ylabel('Force (N)')
grid on

% % Clean Force vs clean time
figure('Name', 'Clean force vs Time');
plot(tF_clean,force_clean,'-k');
title('Clean force vs Time',testName)
legend('Clean force data','Location', 'northwest');
xlabel('Time (s)'); ylabel('Force (N)')
grid on

tF = tF_clean;
force = force_clean;

%% ----- Extracting fatigue loading period and Loading frequency calculation from experimental data
F_fatigue = force(Force_idxS:Force_idxE); % Only selecting the force data relevant to fatigue loading, excluding the hardening loading
tF_fatigue = tF(Force_idxS:Force_idxE); % Only selecting the force data relevant to fatigue loading, excluding the hardening period
tF_fatigue = tF_fatigue - tF_fatigue(1); % Starting time from zero

figure('Name', 'Fatigue force vs time')
plot(tF_fatigue,F_fatigue)
title('Fatigue force vs Time',testName)
xlabel('Time (s)'); ylabel('Force (N)')
grid on

% Separating high and low peaks
minProminence = minFthresh * max(F_fatigue); % Minimum peak prominence
[Fhighs, locs_highs] = findpeaks(F_fatigue, 'MinPeakProminence', minProminence);
time_Fhighs = tF_fatigue(locs_highs);

LF_exp = 1 / mode(round(diff(time_Fhighs),9));
disp(['Loading Frequency as per experimental data: ', num2str(LF_exp),'Hz']);

checkLF = 0.35;
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
while mod(N_LoadingTrunc, LF) >= 1e-9
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
title('Loading Single-Sided Amplitude Spectrum (DC Removed)', testName);
xlabel('Frequency (Hz)');
xticks (0:LF:max(fLoading))
ylabel('Log Amplitude (N)');
grid on;
legend


%% Load thermal data
load THERMAL_data.mat;
fprintf('\nFirst time in thermal data: %0.5fs. This time is subtracted to start from zero\n', IRtime(1));
IRtime = IRtime(:);

% figure('Name', 'Raw T0D vs Raw IR time');
% plot(IRtime,T_0D,'-k')
% title('Raw T0D vs Raw IR time')
% hold on; plot(IRtime,T_0D,'.r', MarkerSize=5)
% grid on
% xlabel('Time(s)')
% ylabel('Temperature (K)')

IRtime = IRtime - IRtime(1); % Start time at zero

T_0D = T_0D(:);
T_ref_up = T_ref_up(:);
T_ref_bottom = T_ref_bottom(:);

% === CALCULATE TEMPORAL NOISE ===
mean_T = mean(T_0D(1:1000));
std_T = std(T_0D(1:1000));  % Standard deviation with N-1 normalization

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

%% --- Repair IR time vector segment-wise  ---
N = length(IRtime);
IRtime_ok = IRtime;          % start with a copy

if N < 2
    return;
end

% Find where the sequence decreases or stays the same
diffs = diff(IRtime);
bad = (diffs <= 0);

% Find start and end indices of every bad segment
% Padding with false at both ends to make edge detection easy
bad_padded = [false; bad; false];
starts = find(diff(bad_padded) == 1) - 1;   % first bad index in each run
ends = find(diff(bad_padded) == -1) + 1; % last bad index in each run

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
    new_times = linspace(t_left, t_right, n_points);

    IRtime_ok(left_idx:right_idx) = new_times';
end

% IR time plots
figure('Name', 'IR time');
plot(IRtime, '-k', LineWidth=0.5);
title('IR time',testName)
hold on; plot(IRtime, '.k', markersize=5);
hold on; plot(IRtime_ok, '.r', markersize=5);
legend('IRtime original','' ,'IRtime corrected','Location', 'northwest');
xlabel('Index'); ylabel('Time (s)')
grid on


figure('Name', 'diff (tTemp)');
plot(diff(IRtime), '-k', LineWidth=2);
title('diff (tTemp)',testName)
hold on; 
plot(diff(IRtime), '.k', markersize=5);
plot(diff(IRtime_ok), '.r', LineWidth=5);
legend('diff (IRtime)','','diff (IRtime corrected)','Location', 'northwest');
xlabel('Index'); ylabel('diff (tTemp)  (s)')
grid on

%% Temperature offset removal

T_ref = 0.5 * T_ref_up + 0.5 * T_ref_bottom; % Average reference temperature
T_noOffset = T_0D - T_ref; % Remove reference temperature offset

% === CALCULATE TEMPORAL NOISE ===
mean_TnoOffset = mean(T_noOffset(1:1000));
std_TnoOffset = std(T_noOffset(1:1000));  % Standard deviation with N-1 normalization

% === OUTPUT ===
% fprintf('Mean Temperature (T no offset) = %.4f K\n', mean_TnoOffset);
% fprintf('Temporal Noise (STD) (T no offset) = %.4f K\n', std_TnoOffset);


% thermal display --- Experimental temperature vs Index
figure('Name','Experimental Temperature Data vs Index');
plot(T_0D, '-k');
title('Experimental Temperature Data',testName)
hold on
plot(T_ref_up,'-r');
plot(T_ref_bottom,'-b');
xlabel('Index');
ylabel('Temperature (K)')
legend('T0D','Tref up', 'Tref bottom', 'Location', 'northwest');
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

% Experimental temperature data vs time
figure('Name','Experimental Temperature Data vs Time');
plot(IRtime_ok,T_0D,'-k');
title('Experimental Temperature Data',testName)
hold on
plot(IRtime_ok,T_ref_up,'-r');
plot(IRtime_ok,T_ref_bottom,'-b');
xlabel('Time (s)');
ylabel('Temperature (K)')
legend('T0D','Tref up', 'Tref bottom', 'Location', 'northwest');
grid on

% --- Save figure ---
figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));
%% Theta calculation
% Selecting the temperature data relevant for the fatigue loading. Start
% and End Index to found by observing the raw temperature (T_0D) and force
% plots

T_0D_fatigue = T_0D (temp_idxS:temp_idxE);
tTheta = IRtime_ok (temp_idxS:temp_idxE);
tTheta = tTheta - tTheta(1); % starting time from 0.

figure('Name','IR and Force time vectors during fatigue loading');
plot(tTheta,'-r');
title('IR and Force time vectors during fatigue loading',testName)
hold on; plot(tF_fatigue, '--b')
grid on
legend ('IR time','Force time')

T_noOffset_fatigue = T_noOffset(temp_idxS:temp_idxE);

% Experimental temperature data (fatigue period) vs time
figure
plot(tTheta,T_0D_fatigue,'-k');
title('Experimental Temperature Data',testName)
xlabel('Time (s)');
ylabel('Temperature (K)')
hold on
yyaxis right
plot(tTheta,T_noOffset_fatigue,'-g');
ylabel('Temperature (K)')
legend('T0D','T no Offset','Location', 'northwest');
grid on

% ##############################
% ##############################
theta = T_noOffset_fatigue - mean(T_noOffset_fatigue(1:50));
theta = movmean(theta, movmeanFactor);

% === CALCULATE TEMPORAL NOISE ===
% mean_theta = mean(theta(1:500));
std_theta = std(theta(1:500));  % Standard deviation with N-1 normalization

% === OUTPUT ===
% fprintf('Mean theta = %.4f K\n', mean_theta);
% fprintf('Temporal Noise (STD)(theta) = %.4f K\n', std_theta);

% theta display --- theta vs index
figure('Name','theta vs index')
plot(theta)
title('\theta',testName)
xlabel('Index');
ylabel('\theta (K)')
legend('\theta','Location', 'northwest');
grid on

% theta display --- theta vs time
figure('Name','theta vs time')
plot(tTheta, theta)
title('\theta', testName)
xlabel('Time (s)');
ylabel('\theta (K)')
legend('\theta','Location', 'northwest');
grid on

%% Normalize force and theta for visualization (0.5 seconds)
time_duration = 0.5; % Time window in seconds
samples_force = round(time_duration * SF_F); % Number of force samples
samples_theta = round(time_duration * SF); % Number of theta samples
idx_start_force = length(F_fatigue) - samples_force + 1; % Start index for force
idx_start_theta = length(theta) - samples_theta + 1; % Start index for theta

% Calculate mean for normalization
mean_force = abs(mean(F_fatigue(idx_start_force:end))); % Mean absolute force
mean_theta = abs(mean(theta(idx_start_theta:end))); % Mean absolute theta

% Normalize force and theta using original experimental data
norm_force = F_fatigue(idx_start_force:end) / mean_force; % Normalized force
norm_theta = theta(idx_start_theta:end) / mean_theta; % Normalized theta

% Create time vectors for normalized data
t_force = time_duration:-1/SF_F:0; % Reverse time vector for force
t_force = flip(t_force(1:length(norm_force))); % Flip and trim to match norm_force
t_theta = time_duration:-1/SF:0; % Reverse time vector for theta
t_theta = flip(t_theta(1:length(norm_theta))); % Flip and trim to match norm_theta

% --- Normalized force and theta
figure;
plot(t_force, norm_force, 'b.-', 'MarkerSize', 10);
title('Normalized Force and Theta (Last 0.5s of Loading)', testName);
ylabel('Force [N] (normalized)');
hold on;
yyaxis right;
plot(t_theta, norm_theta, 'r.--', 'MarkerSize', 6);
xlabel('Time (s)');
ylabel('\theta (K) (normalized)');
xlim([0 0.52]);
grid on;
legend('Force', '\theta','Location', 'northwest');

%% Synchronize force and theta
tTheta_sync = tTheta;
tF_sync = tF_fatigue;

tForce_rel = tF_sync - tF_sync(end);
tTheta_rel = tTheta_sync - tTheta_sync(end);
t_common_start = max(tForce_rel(1), tTheta_rel(1));
idx_f_sync = find(tForce_rel >= t_common_start);
idx_Theta_sync = find(tTheta_rel >= t_common_start);

if idx_Theta_sync(1) > idx_f_sync(1) % if IR recording started earlier than the loading, which is true in most of the cases.
    tF_sync = tF_sync + tTheta_sync(idx_Theta_sync(1));
    t_sync = tF_sync;
else
    tTheta_sync = tTheta_sync + tF_sync(idx_f_sync(1));
    t_sync = tTheta_sync;
end

figure; 
plot(tF_sync,'-r', LineWidth=3);
hold on; 
plot(tF_sync,'.k');
plot(tTheta_sync,'-b', LineWidth=3)
plot(tTheta_sync,'.g')
title('Sync times')
legend ('tFsync','','tTheta sync')
grid on

%% ######################### Another method of synchronization
dt_theta = mode(diff(tTheta));

tTheta(end)
tF_fatigue(end)
tEnd_maxA = max(tTheta(end), tF_fatigue(end))
t_diff = tTheta(end) - tF_fatigue(end)
t_sync = (0:dt_theta:tEnd_maxA);
t_sync = t_sync(:);

% shape-preserving interpolation
% I am preferring shape-preserving spline interpolation 'pchip'
% interpolation over the linear interpolation, as the 'pchip' provides better 
% match the original Force profile
% F_fatigue_flip = fliplr(F_fatigue);
% theta_flip = fliplr(theta);

F_sync_interp = interp1(tF_fatigue, F_fatigue, t_sync, 'pchip');
theta_sync_interp = interp1(tTheta, theta, t_sync, 'pchip');

% F_sync_interp = fliplr(F_sync_interp);
% theta_sync_interp = fliplr(theta_sync_interp);

% ---------
figure('Name','MY Interpolated Sychronized F & theta')
plot(t_sync,F_sync_interp,'-k')
title('MY Interpolated Synchronisation: Force and \theta', testName)
hold on;
plot(t_sync,F_sync_interp,'.b')
xlabel('Time (s)');
ylabel('Force [N]')
yyaxis right
plot(t_sync, theta_sync_interp,'-m')
plot(t_sync, theta_sync_interp,'.g')
ylabel('\theta (K)');
legend('F-interpolated','\theta-interpolated','Location', 'northwest');
grid on

% ==============================================================

[FhighsA, locs_FhighsA] = findpeaks(F_sync_interp, 'MinPeakProminence', minProminence);
N = numel(F_sync_interp);

% --- Manual test for first point ---
if F_sync_interp(1) > F_sync_interp(2)
    FhighsA = [F_sync_interp(1); FhighsA];
    locs_FhighsA = [1; locs_FhighsA];
end
% --- Manual test for last point ---
if F_sync_interp(N) > F_sync_interp(N-1)
    FhighsA = [FhighsA; F_sync_interp(N)];
    locs_FhighsA = [locs_FhighsA; N];
end
time_FhighsA = t_sync(locs_FhighsA);


[FlowsA, locs_FlowsA] = findpeaks(-F_sync_interp, 'MinPeakProminence', minProminence);
FlowsA = -FlowsA;
time_FlowsA = t_sync(locs_FlowsA);


% ---------
figure('Name','MY Force and Theta Synchronisation')
plot(t_sync,F_sync_interp,'-k')
title('MY Force and \theta Synchronisation', testName)
hold on;
plot(time_FhighsA,FhighsA,'.r')
plot(time_FlowsA,FlowsA,'.b')
xlabel('Time (s)');
ylabel('Force [N]')
yyaxis right
plot(t_sync, theta_sync_interp)
ylabel('\theta (K)');
legend('F-filtered','highs','lows','\theta','Location', 'northwest');
grid on


%% Process force data: clean cyclic portion of the force data
% % Separating high and low peaks
% % minProminence = 0.05 * max(F_sync); % Minimum peak prominence
% 
% % --- Find internal peaks ---
% [Fhighs, locs_highs] = findpeaks(F_fatigue, 'MinPeakProminence', minProminence);
% N = numel(F_fatigue);
% 
% % --- Manual test for first point ---
% if F_fatigue(1) > F_fatigue(2)
%     Fhighs = [F_fatigue(1); Fhighs];
%     locs_highs = [1; locs_highs];
% end
% 
% % --- Manual test for last point ---
% if F_fatigue(N) > F_fatigue(N-1)
%     Fhighs = [Fhighs; F_fatigue(N)];
%     locs_highs = [locs_highs; N];
% end
% Time_highs = tF_sync(locs_highs);
% 
% 
% [Flows, locs_lows] = findpeaks(-F_fatigue, 'MinPeakProminence', minProminence);
% Flows = -Flows;
% Time_lows = tF_sync(locs_lows);
% 
% % Combine and sort extrema
% all_locs = [locs_highs; locs_lows]; %; 1; length(F_sync)];
% % all_vals = [Fhighs; Flows]; %; F_sync(1); F_sync(end)];
% sort_idx = sort(all_locs);
% 
% F_filtered = F_fatigue(sort_idx);
% tF_filtered = tF_sync(sort_idx);
% 
% % ---------
% figure
% plot(F_filtered,'-k')
% title('F-filtered vs Index', testName_withDate)
% hold on; plot(F_filtered,'.r')
% xlabel('Index');
% ylabel('Force [N]')
% grid on
% 
% % ---------
% figure('Name','Force and Theta Synchronisation')
% plot(tF_filtered,F_filtered,'-k')
% title('Force and \theta Synchronisation', testName_withDate)
% hold on;
% plot(Time_highs,Fhighs,'.r')
% plot(Time_lows,Flows,'.b')
% xlabel('Time (s)');
% ylabel('Force [N]')
% yyaxis right
% plot(tTheta_sync, theta)
% ylabel('\theta (K)');
% legend('F-filtered','highs','lows','\theta','Location', 'northwest');
% grid on
% 
% %  ---Diff(F_filtered)
% figure
% plot(diff(F_filtered),'Color', [0.8 0.8 0.8])
% title('diff(F filtered)', testName_withDate)
% hold on
% plot(diff(F_filtered),'.r',MarkerSize=20 ) % It is important to plot the '.' after plotting the lines
% xlabel('Index');
% ylabel('Force [N]')
% grid on

%% Calculating slope of high and low forces for the Stress amplitude calculation
% Robust linear regression

Time_highs = time_FhighsA;
Fhighs = FhighsA;

Time_lows = time_FlowsA;
Flows = FlowsA;

[bH, statsH] = robustfit(Time_highs(:), Fhighs(:));
[bL, statsL] = robustfit(Time_lows(:),  Flows(:));

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
Fhigh_fit = mH * t_sync + aH; % y = mx +b; linear equation
Flow_fit = mL * t_sync + aL;

% Compute R² for both fits
SS_res_H = sum((Fhighs - (aH + mH*Time_highs)));
SS_tot_H = sum((Fhighs - mean(Fhighs)));
R2_H = 1 - SS_res_H/SS_tot_H;

SS_res_L = sum((Flows - (aL + mL*Time_lows)));
SS_tot_L = sum((Flows - mean(Flows)));
R2_L = 1 - SS_res_L/SS_tot_L;

figure; hold on; grid on;

% Plot data
scatter(Time_highs, Fhighs, 40, 'r', 'filled');
scatter(Time_lows,  Flows,  40, 'b', 'filled');

% Plot fits
plot(t_sync, Fhigh_fit, '-g', 'LineWidth', 2);
plot(t_sync, Flow_fit,  '-m', 'LineWidth', 2);

xlabel('Time');
ylabel('Force');
title('Robust Linear Fits for F_{high} and F_{low}', testName);

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

% --- Compute Force Amplitude ---
Famp_fit = (Fhigh_fit - Flow_fit)/2;

% --- Compute Stress Amplitude ---
Samp = Famp_fit / xarea / 1e6;  % in MPa

% --- Plot Force Amplitude ---
figure;
plot(t_sync, Famp_fit, 'b', 'LineWidth', 2);
title('Amplitude vs Time', testName);
xlabel('Time (s)'); ylabel('Force Amplitude (N)');
grid on;

yyaxis right
plot(t_sync, Samp, 'r', 'LineWidth', 2); grid on;
ylabel('Stress Amplitude (MPa)');
legend('Famp','Samp')

%--- Plot Fit Forces ---
figure; hold on; grid on;
plot(t_sync, Fhigh_fit, '-r', 'LineWidth', 2);
plot(t_sync, Flow_fit,  '-b', 'LineWidth', 2);
plot(t_sync, Famp_fit, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Force (N)');
title('Fit plots: Fhighs, Flows, Famp vs Time', testName);
legend('Fhigh fit','Flow fit','Famp fit','Location','northwest');
hold off;

% --- Plot Stress -----
figure; hold on; grid on;
plot(t_sync, Fhigh_fit/xarea/1e6, '-r', 'LineWidth', 2);
plot(t_sync, Flow_fit/xarea/1e6,  '-b', 'LineWidth', 2);
plot(t_sync, Samp, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Stress (MPa)');
title('Stress vs Time', testName);
legend('Shighs','Slows','Samp','Location','northwest');
hold off;


%% Calculate mechanical dissipation
theta = theta_sync_interp;

SFnew = round(window * SF, 9);
if mod(SFnew,2) == 0
    SFnew = SFnew + 1; % Ensure odd number for convolution
end

movmean_theta = movmean(theta, SFnew, 'endpoints','fill');

d1 = nan(size(theta));
kd = (SFnew-1)/2;
% kd = (FSnew)/2;
for k = (SFnew):length(theta)-(SFnew-1)
    d1(k) = rho * C * (((movmean_theta(k+kd) - movmean_theta(k-kd)) / (t_sync(k+kd) - t_sync(k-kd))) + movmean_theta(k)/tau);
end

d1 = d1/1000; % Converting units into kilo
% if mean(theta) > 0
% Z1 = d1(~isnan(d1)); 
% d1 = d1 - (Z1(1));
% end

figure('Name','d1, Theta, and Avg.Theta vs Time')
plot(t_sync, theta)
hold on;
plot(t_sync, movmean_theta, '-r', LineWidth=1.5)
title('d1, \theta and Avg.\theta vs Time', testName)
grid on
ylabel('\theta (K)');
yyaxis right
plot(t_sync, d1, '-b',LineWidth=3)
ax = gca;
ax.YAxis(2).Color = 'b';
xlabel('Time (s)')
ylabel('d1 (kW/m³)')
legend('\theta','Avg.\theta','d1','Location', 'northwest');


D1 = d1 / LF; % Normalize by loading frequency

% Interpolate stress amplitude to theta time vector
SampInterp = interp1(t_sync, Samp, t_sync, 'linear');


figure('Name','Checking Samp interpolation')
plot(t_sync, Samp, LineWidth=2);
title('Checking Samp interpolation', testName)
hold on;
plot(t_sync,SampInterp, '--r',LineWidth=2);
legend ('SampLoading-fit','Samp interpolated','Location', 'northwest');
ylabel('Stess Amplitude (MPa)')
xlabel('Time (s)')
grid on


%% Plotting section

% --- d1 & stress amplitude vs Time
figure('Name','d1 and Samp vs Time')
plot(t_sync, d1, '.b', 'LineWidth', 1.5); % in kW/m3
title(sprintf('d1 and \\sigma_{amp} vs Time\n(Window Size: %0.2fs - %s)', window, testName));
xlabel('Time (s)');
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
yyaxis right;
plot(t_sync, SampInterp, '-.r', LineWidth=2)
ylabel('Stress Amplitude (MPa)');
legend('d1', '\sigma_{amp}','Location', 'northwest');
grid on;

% ---- d1 and Avg. Theta vs stress amplitude
figure('Name','d1 and Avg. Theta vs stress amplitude');
plot(SampInterp, d1, '.b');
title(sprintf('Sum of Heat Sources vs \\sigma_{amp}\n(Window Size: %0.2fs - %s)', window, testName));
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
title(sprintf('Sum of Heat Sources / Cycle (D1) & Avg.\\theta vs \\sigma_{amp}\n(Window Size: %0.2fs) - %s', window, testName));
xlabel('\sigma_{amp} (MPa)');
ylabel('D1 - Sum of Heat Sources / Cycle (kJ/m³)');
yyaxis right
plot(SampInterp, movmean_theta,'r', LineWidth=2)
ylabel('\theta (K)')
legend('D1', 'Avg.\theta','Location','northwest')
grid on;

% ---- D1 and diff(Avg.Theta) vs stress amplitude
figure('Name','D1 and diff(Avg.Theta) vs stress amplitude');
plot((SampInterp(2:end)), diff(movmean_theta),'-r', LineWidth=1)
ylabel('diff (Avg.\theta)  (K)')
title(sprintf('Sum of Heat Sources / Cycle (D1) & \\theta vs \\sigma_{amp}\n(Window Size: %0.2fs) - %s', window, testName));
xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampInterp, D1, '.b');
ax = gca;
ax.YAxis(2).Color = 'b';
ylabel('D1 - Sum of Heat Sources / Cycle (kJ/m³)');
legend('diff (Avg.\theta)','D1','Location','northwest')
grid on;

%% d1 calculated from detrended OR Self Heating part of theta

% theta_ThermoElastic = detrend(theta,5);
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
% ylabel('D1-SelfHeating   (kJ/m³)')
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

%% Frequency Analysis of Theta of Loading Period
N_thetaLoading = length(theta);
f = (0:floor(N_thetaLoading/2)) * (SF / N_thetaLoading);

% FFT computation
P1 = abs(fft(theta,N_thetaLoading)) * (2/N_thetaLoading);
P1 = P1(1 : floor(N_thetaLoading/2)+1);
P1(1) = NaN; % Remove DC component

figure('Name', 'Amplitude Spectrum');
plot(f, log(P1), '.r', 'MarkerSize', 5, DisplayName='theta-loading'); hold on;
title('\theta (loading) Single-Sided Amplitude Spectrum (DC Removed)', testName);
xlabel('Frequency (Hz)');
xticks(0:LF:ceil(SF/2/100)*100)
ylabel('Amplitude (log)');
grid on;
legend

N_thetaLoadingTrunc = N_thetaLoading;
while mod(N_thetaLoadingTrunc, SF/LF) >= 1e-9
    N_thetaLoadingTrunc = N_thetaLoadingTrunc -1;
end

Ndiff = N_thetaLoading - N_thetaLoadingTrunc;
thetaTruncIdx = flip(N_thetaLoading:-1:Ndiff-1);

thetaTrunc = theta(thetaTruncIdx);

fTrunc = (0:floor(N_thetaLoadingTrunc/2)) * (SF / N_thetaLoadingTrunc);

% FFT computation
P1Trunc = abs(fft(thetaTrunc,N_thetaLoadingTrunc)) * (2/N_thetaLoadingTrunc);
P1Trunc = P1Trunc(1 : floor(N_thetaLoadingTrunc/2)+1);
P1Trunc(1) = NaN; % Remove DC component

hold on
plot(fTrunc, log(P1Trunc), '.b', 'MarkerSize', 5, DisplayName='theta-loading truncated');

%% FFT on sliding windows

N_theta = length(theta);
elements_in_window = SFnew; %round(SF*window);      % window length in samples

if mod(elements_in_window, SF/LF) >= 1e-9
    error('window size is not producing integer number of cycles!!!')
end

FL2 = 2*LF;                % 2nd harmonic [Hz]
FL3 = 3*LF;                % 3rd harmonic [Hz]

% Aliasing check
if FL3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], FL3, SF/2);
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
f = (0:elements_in_window-1) * (SF/elements_in_window);
nWin = N_theta - elements_in_window + 1; % # of windows in the whole theta vector

% --- Preallocate ---
maxAmpH1 = nan(nWin,1); maxFreqH1 = nan(nWin,1); ampAtH1 = nan(nWin,1);
maxAmpH2 = nan(nWin,1); maxFreqH2 = nan(nWin,1); ampAtH2 = nan(nWin,1);
maxAmpH3 = nan(nWin,1); maxFreqH3 = nan(nWin,1); ampAtH3 = nan(nWin,1);
ampAtArbit = nan(nWin, length(arbitraryFreqs));


%% --- Sliding window --- FFT method

for k = 1:nWin

    end_idx = k+elements_in_window-1;
    segment = detrend(theta(k : end_idx), 4);
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta(k : end_idx);
    A = abs(fft(segment)) * (2/elements_in_window);

    idx1 = find(f >= (LF-BW) & f <= (LF+BW));
    [maxAmpH1(k), j1] = max(A(idx1)); maxFreqH1(k) = f(idx1(j1));
    [~, i1] = min(abs(f - LF)); ampAtH1(k) = A(i1);

    idx2 = find(f >= (FL2-BW) & f <= (FL2+BW));
    [maxAmpH2(k), j2] = max(A(idx2)); maxFreqH2(k) = f(idx2(j2));
    [~, i2] = min(abs(f - FL2)); ampAtH2(k) = A(i2);

    if FL3<SF/2
        idx3 = find(f >= (FL3-BW) & f <= (FL3+BW));
        [maxAmpH3(k), j3] = max(A(idx3)); maxFreqH3(k) = f(idx3(j3));
        [~, i3] = min(abs(f - FL3)); ampAtH3(k) = A(i3);
    end

    for j = 1:length(arbitraryFreqs)
        [~, idx] = min(abs(f - arbitraryFreqs(j)));
        ampAtArbit(k, j) = A(idx);
    end

end

% --- Construct central time reference for overlaying theta ---
winCentreIdx = (1:nWin) + floor(elements_in_window/2);

%% --- Amplitude Plotting FFT method (with theta on yyaxis right) ---
nn = 3;
if FL3>SF/2
    nn = 2;
end

figure('Name','Harmonic Amplitudes with Theta');%);%,'NumberTitle','off');
% Define time vector for x-axis

tplot = t_sync(1:nWin);

% loading window
loading_start = t_sync(1);%(idx_Theta_sync(1));
loading_end = t_sync(end); %(temp_idxE - SF*window);
loading_window = find(tplot >= loading_start & tplot <= loading_end);

subplot(nn,2,1);
yyaxis left
plot(tplot, ampAtH1, 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,2);
yyaxis left
plot(tplot, maxAmpH1, 'b', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Avg. \theta','Location', 'northwest');


subplot(nn,2,3);
yyaxis left
plot(tplot, ampAtH2, 'g', 'LineWidth', 2);
hold on;
plot(tplot, movmean(ampAtH2, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', FL2)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,4);
yyaxis left
plot(tplot, maxAmpH2, 'm', 'LineWidth', 2);
hold on; plot(tplot, movmean(maxAmpH2, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', FL2, BW)); grid on;
yyaxis right
plot(tplot, movmean(theta(winCentreIdx), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('Time (s)')
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if FL3<SF/2
    subplot(nn,2,5);
    yyaxis left
    plot(tplot, ampAtH3, 'y', 'LineWidth', 2);
    hold on; plot(tplot, movmean(ampAtH3, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', FL3)); grid on;
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('Time (s)')
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');



    subplot(nn,2,6);
    yyaxis left
    plot(tplot, maxAmpH3, 'c', 'LineWidth', 2);
    hold on; plot(tplot, movmean(maxAmpH3, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', FL3, BW)); grid on;
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('Time (s)')
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', window,testName));


% -- Harmonic Amplitudes vs Stress amplitude
SampInterp_x = SampInterp(1:nWin);

figure('Name','Harmonic Amplitudes vs Stress Amp');%);%,'NumberTitle','off');

subplot(nn,2,1);
yyaxis left
plot(SampInterp_x, ampAtH1(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', LF)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,2);
yyaxis left
plot(SampInterp_x, maxAmpH1(loading_window), 'b', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Avg. \theta','Location', 'northwest');


subplot(nn,2,3);
yyaxis left
plot(SampInterp_x, ampAtH2(loading_window), 'g', 'LineWidth', 2);
hold on;
plot(SampInterp_x, movmean(ampAtH2(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Amp @ %.f Hz', FL2)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,2,4);
yyaxis left
plot(SampInterp_x, maxAmpH2(loading_window), 'm', 'LineWidth', 2);
hold on; plot(SampInterp_x, movmean(maxAmpH2(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Max Amp %.f\\pm%.1f Hz', FL2, BW)); grid on;
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if FL3<SF/2
    subplot(nn,2,5);
    yyaxis left
    plot(SampInterp_x, ampAtH3(loading_window), 'y', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(ampAtH3(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', FL3 )); grid on;
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');



    subplot(nn,2,6);
    yyaxis left
    plot(SampInterp_x, maxAmpH3(loading_window), 'c', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(maxAmpH3(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', FL3, BW)); grid on;
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', window,testName));

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
    plot(tplot, movmean(theta(winCentreIdx), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
    ylabel('\theta (K)'); xlabel('Time (s)')
    legend('Amp','Avg. \theta','Location', 'northwest');
end
% sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', window,testName));


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
    plot(SampInterp_x, movmean(theta(loading_window), SFnew, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
    ylabel('\theta (K)'); xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Avg. \theta','Location', 'northwest');

end
% sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', window,testName));


%% --- Frequency Peak Tracking Only ---
figure('Name','Harmonic Peak Frequencies');%);%,'NumberTitle','off');

subplot(nn,1,1);
plot(tplot, maxFreqH1,'b','LineWidth',1.2);
title(sprintf('Peak Freq in %.f\\pm%.1f Hz', LF, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

subplot(nn,1,2);
plot(tplot, maxFreqH2,'m','LineWidth',1.2);
title(sprintf('Peak Freq in %.f\\pm%.1f Hz', FL2, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

if FL3<SF/2
    subplot(nn,1,3);
    plot(tplot, maxFreqH3,'c','LineWidth',1.2);
    title(sprintf('Peak Freq in %.f\\pm%.1f Hz', FL3, BW));
    ylabel('Freq (Hz)');
    xlabel('Time (s)'); grid on;
end

sgtitle(sprintf('%.1fs Sliding-Window - Peak Frequency Tracking vs. Time\n (mean \\theta removed) - %s', window,testName));

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

for k = 1:nWin

    end_idx = k+elements_in_window-1;

    if end_idx > N_theta
        break;
    end

    segment = detrend(theta(k : end_idx), 4); % - mean(theta(start_idx : end_idx)); Detrend removed the mean of theta
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta(k : end_idx);
    

    H1_cos(k) = sum(segment .* X1(k : end_idx)) / ((elements_in_window)/2);
    H1_sin(k) = sum(segment .* Y1(k : end_idx)) / ((elements_in_window)/2);

    H2_cos(k) = sum(segment .* X2(k : end_idx)) / ((elements_in_window)/2);
    H2_sin(k) = sum(segment .* Y2(k : end_idx)) / ((elements_in_window)/2);

    H3_cos(k) = sum(segment .* X3(k : end_idx)) / ((elements_in_window)/2);
    H3_sin(k) = sum(segment .* Y3(k : end_idx)) / ((elements_in_window)/2);

    % T_mean(k) = mean(T_0D_segment);
    AmpH1_window(k) = sqrt(H1_sin(k)^2 + H1_cos(k)^2);
    AmpH2_window(k) = sqrt(H2_sin(k)^2 + H2_cos(k)^2);
    AmpH3_window(k) = sqrt(H3_sin(k)^2 + H3_cos(k)^2);
end

% --- plots

% tplot = tTheta_sync(winCentreIdx);
tplot = t_sync(1:nWin);
% Combined figure with three subplots for H1, H2, H3 amplitudes
figure('Name','Harmonic Amplitudes');%);%,'NumberTitle','off');

subplot(nn,1,1);
plot(tplot, AmpH1_window, LineWidth=2); grid on; title(sprintf('H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(tplot, movmean(AmpH1_window, smoothing, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('Amp','Avg. \theta','Location', 'northwest');

subplot(nn,1,2);
plot(tplot, AmpH2_window); grid on; title(sprintf('H2 Amplitude at %.f Hz', FL2));
hold on;
plot(tplot, movmean(AmpH2_window, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
yyaxis right
plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if FL3<SF/2
    subplot(nn,1,3);
    plot(tplot, AmpH3_window); grid on; title(sprintf('H3 Amplitude at %.f Hz', FL3));
    hold on;
    plot(tplot, movmean(AmpH3_window, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('Time (s)');
    yyaxis right
    plot(tplot, movmean(theta(winCentreIdx),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    ylabel('\theta (K)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sgtitle(sprintf('%.1fs Sliding-Window Harmonic Analysis using Reference Signals\n(mean \\theta removed) - %s', window, testName));


% -- Harmonics vs stress amplitude
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
plot(SampInterp_x, movmean(theta(loading_window),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
legend('Amp', 'Avg. \theta','Location', 'northwest');


subplot(nn,1,2);
plot(SampInterp_x, AmpH2_loading); grid on; title(sprintf('H2 Amplitude at %.f Hz', FL2));
hold on;
plot(SampInterp_x, movmean(AmpH2_loading, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampInterp_x, movmean(theta(loading_window),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
ylabel('\theta (K)');
legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');


if FL3<SF/2
    subplot(nn,1,3);
    plot(SampInterp_x, AmpH3_loading); grid on; title(sprintf('H3 Amplitude at %.f Hz', FL3));
    hold on;
    plot(SampInterp_x, movmean(AmpH3_loading, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
    yyaxis right
    plot(SampInterp_x, movmean(theta(loading_window),SFnew,"Endpoints","fill"), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    ylabel('\theta (K)');
    legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');

end

sgtitle(sprintf('%.1fs Sliding-Window Harmonic Analysis using Reference Signals\n (mean \\theta removed - %s)', window,testName));

%% Continuous: Eliminating transient periods from Force and Theta
% ##############################################################
% ##############################################################
% ##############################################################
% ==============================================================
% DETECT SEGMENT BOUNDARIES FROM LARGE DROPS IN TROUGHS

F_sync_interp = F_sync_interp(:);
theta_sync_interp = theta_sync_interp(:);

[Fpk, Fpk_loc] = findpeaks(F_sync_interp,'MinPeakProminence', minProminence);         % local maxima
[Ftr_raw, Ftr_loc] = findpeaks(-F_sync_interp);    % raw minima (troughs)
Ftr = -Ftr_raw;

diffTroughs = abs(diff(Ftr));
thresh = 0.3 * mean(abs(Ftr));     % you can tune this threshold

% indices within trough list
idx_bad = find(diffTroughs > thresh);
idx_bad = [idx_bad([true; diff(idx_bad) > 20])];
idx_bad = idx_bad + 1;
% convert to indices in F
SegEndLocs = Ftr_loc(idx_bad);   
SegEndLocs = SegEndLocs(:);

% last segment ends at final time
SegEndLocs = [SegEndLocs; length(F_sync_interp)];

N_segments = length(SegEndLocs);

% ==============================================================
% BUILD FORCE SEGMENTS:
%    - segment end = last peak before the trough drop
%    - segment start = next peak closest in amplitude to last peak
% ==============================================================

segment_starts = zeros(N_segments,1);
segment_ends = zeros(N_segments,1);

peakPtr = 1;   % pointer inside Fpk
X = [];
for s = 1:N_segments

    % --------- END OF SEGMENT ----------
    endIdx = SegEndLocs(s);

    % peaks up to this end
    peaks_before_end = Fpk_loc(Fpk_loc <= endIdx);
    if isempty(peaks_before_end)
        lastPeakIdx = endIdx;
        lastPeakVal = F_sync_interp(endIdx);
    else
        lastPeakIdx = peaks_before_end(end);
        lastPeakVal = F_sync_interp(lastPeakIdx);
    end
    segment_ends(s) = lastPeakIdx;

    % --------- START OF NEXT SEGMENT ----------
    if s == 1
        segment_starts(s) = 1;  % first segment starts at the beginning
    else
        % candidate next 15 peaks (tune value if needed)
        searchRange = peakPtr : min(peakPtr+0, length(Fpk_loc)); 

        % why I am taking 0 in 'peakPtr+0'. The reason is when the force in each new segment 
        % is selected to be closest to the peak of the previous segment, the resulting force 
        % history becomes cleaner, as overshoots and undershoots are effectively removed. 
        % However, under this processing, the temperature signal exhibits a distinct step 
        % increase at the transition between segments. This behaviour is likely due to the 
        % fact that, during the original test, the step change in force and the associated 
        % over- and undershoots had already influenced the specimen’s thermal response. 
        % Consequently, when these force transients are removed from the force history but the 
        % corresponding temperature data are retained, the temperature signal reveals a clear 
        % step increase between segments. The temperature level in each new segment is higher 
        % than that of the preceding segment, with a distinct step separating them. In contrast, 
        % when only the transient period between segments is removed, while retaining the fatigue 
        % loading from the very start of a segment including the over- and undershoots in the 
        % force data, the temperature signal remains smoothly increasing, with no noticeable step 
        % change between segments.

        candidates = Fpk(searchRange);

        % select the peak whose amplitude is closest to previous last peak
        % [~, idxMin] = min(abs(candidates - lastPeakVal));
        [~, idxMin] = min(abs(candidates - X));
        newStartPeak = searchRange(idxMin);

        % start at one sample before that peak
        % segment_starts(s) = max(Fpk_loc(newStartPeak) - 1, 1);
        segment_starts(s) = Fpk_loc(newStartPeak + 0) + 1; 
        % Adding 1, or 2, or 3, so that the next point is not a peak, but a point going towards the trough. 
        % I see from Fsync_interp that it usually takes 1 or 2 or 3 data points after peak to match the normal force profile.
        % 1 gives the best result

        % peakPtr = newStartPeak;
    end

    % update pointer to locate peaks for next segment
    peakPtr = find(Fpk_loc == lastPeakIdx, 1) + 1;

    % segment_starts(s)
    % segment_ends(s)
    X = lastPeakVal;

end

% ==============================================================
% BUILD FORCE + THETA SEGMENTS INTO ONE CONTINUOUS VECTOR

Force_C = [];
% theta_C = nan(2635,N_segments);
theta_C = [];
% my_theta_continuous = [];

for s = 1:N_segments
    idx = segment_starts(s) : segment_ends(s);
    Force_C = [Force_C;      F_sync_interp(idx)];
    theta_C = [theta_C;  theta_sync_interp(idx)];
    % theta_C(1:length(idx),s) = theta_sync_interp(idx);
    % my_theta_continuous = [my_theta_continuous;  movmean(theta_sync_interp(idx),SFnew,'Endpoints','fill')];
 end

theta_C = movmean(theta_C, movmeanFactor);

% ==============================================================
% NEW TIME VECTOR STARTING AT 0

dt = mode(diff(t_sync));
t_C = (0:dt:(length(theta_C)-1)*dt).'; % both Force_C and theta_C have same length

% ==============================================================
% PLOT

figure('Name','Continuous Segment Assembly')
plot(t_C, Force_C, 'k')
ylabel('Force (N)')
hold on
yyaxis right
plot(t_C, theta_C, 'r')
ylabel('\theta (K)')
xlabel('Time (s)')
title('Continuous Segments: Force–\theta')
legend ('F continusou','\theta continuous', 'location','northwest')
grid on

%% Continuous: Determining Force Peaks and Troughs for evaluating their slopes and finally calculating Force and Stress Amplitudes

[FhighsC, locs_FhighsC] = findpeaks(Force_C, 'MinPeakProminence', minProminence);
N = numel(Force_C);

% --- Manual test for first point ---
if Force_C(1) > Force_C(2)
    FhighsC = [Force_C(1); FhighsC];
    locs_FhighsC = [1; locs_FhighsC];
end
% --- Manual test for last point ---
if Force_C(N) > Force_C(N-1)
    FhighsC = [FhighsC; Force_C(N)];
    locs_FhighsC = [locs_FhighsC; N];
end
time_FhighsC = t_C(locs_FhighsC);


[FlowsC, locs_FlowsC] = findpeaks(-Force_C, 'MinPeakProminence', minProminence);
FlowsC = -FlowsC;
time_FlowsC = t_C(locs_FlowsC);

% ---------
figure('Name','Continuous: Force and Theta Synchronisation')
plot(t_C,Force_C,'-k')
title('Continuous: Force and \theta Synchronisation', testName)
hold on;
plot(time_FhighsC,FhighsC,'.r')
plot(time_FlowsC,FlowsC,'.b')
xlabel('Time (s)');
ylabel('Force [N]')
yyaxis right
plot(t_C, theta_C)
ylabel('\theta (K)');
legend('F-filtered','highs','lows','\theta','Location', 'northwest');
grid on

% ================================================================================
% Calculating slope of high and low forces for the Stress amplitude calculation

% Robust linear regression
[bH, statsH] = robustfit(time_FhighsC(:), FhighsC(:));
[bL, statsL] = robustfit(time_FlowsC(:),  FlowsC(:)); 

% Extract slope/intercept to cleaner variables
aH_C = bH(1);        % intercept
mH_C = bH(2);        % slope

aL_C = bL(1);
mL_C = bL(2);

% 2. Extract residuals
resH = statsH.resid;
resL = statsL.resid;

% 3. Compute RMSE for overall discrepancy
RMSE_H = round(sqrt(mean(resH)),2);
RMSE_L = round(sqrt(mean(resL)),2);

fprintf('RMSE (Highs): \xB1%.2f N\n', RMSE_H);
fprintf('RMSE (Lows) : \xB1%.2f N\n', RMSE_L);

% 4. Plot original data and fitted lines
Fhigh_fitC = mH_C * t_C + aH_C; % y = mx + b; linear equation
Flow_fitC = mL_C * t_C + aL_C;

% Compute R² for both fits
SS_res_H = sum((FhighsC - (aH_C + mH_C*time_FhighsC)));
SS_tot_H = sum((FhighsC - mean(FhighsC)));
R2_H = 1 - SS_res_H/SS_tot_H;

SS_res_L = sum((FlowsC - (aL_C + mL_C*time_FlowsC)));
SS_tot_L = sum((FlowsC - mean(FlowsC)));
R2_L = 1 - SS_res_L/SS_tot_L;

figure('Name', 'Continuous: Robust Linear Force Fits');
hold on; grid on;

% Plot data
scatter(time_FhighsC, FhighsC, 40, 'r', 'filled');
scatter(time_FlowsC,  FlowsC,  40, 'b', 'filled');

% Plot fits
plot(t_C, Fhigh_fitC, '-g', 'LineWidth', 2);
plot(t_C, Flow_fitC,  '-m', 'LineWidth', 2);

xlabel('Time');
ylabel('Force');
title('Continuous: Robust Linear Fits for F_{high} and F_{low}', testName);

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

% --- Compute Force Amplitude ---
Famp_fitC = (Fhigh_fitC - Flow_fitC)/2;

% --- Compute Stress Amplitude ---
SampC = Famp_fitC / xarea / 1e6;  % in MPa

% --- Plot Force Amplitude ---
% figure('Name','Continuous: Force and Stress Amplitudes');
% plot(t_continuous, Famp_fitC, 'b', 'LineWidth', 2);
% title('Continuous: Force and Stress Amplitudes vs Time', testName_withDate);
% xlabel('Time (s)'); ylabel('Force Amplitude (N)');
% grid on;
% 
% yyaxis right
% plot(t_continuous, SampC, 'r', 'LineWidth', 2); grid on;
% ylabel('Stress Amplitude (MPa)');
% legend('Famp','Samp')

%--- Plot Fit Forces ---
figure('Name','Continuous: Force vs Time'); 
hold on; grid on;
plot(t_C, Fhigh_fitC, '-r', 'LineWidth', 2);
plot(t_C, Flow_fitC,  '-b', 'LineWidth', 2);
plot(t_C, Famp_fitC, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Force (N)');
title('Continuous: Fhighs, Flows, Famp vs Time', testName);
legend('Fhigh fit','Flow fit','Famp fit','Location','northwest');
hold off;

% --- Plot Stress -----
figure('Name','Continuous: Stress vs Time');
hold on; grid on;
plot(t_C, Fhigh_fitC/xarea/1e6, '-r', 'LineWidth', 2);
plot(t_C, Flow_fitC/xarea/1e6,  '-b', 'LineWidth', 2);
plot(t_C, SampC, '-k', 'LineWidth', 2);          % amplitude fit
xlabel('Time (s)'); ylabel('Stress (MPa)');
title('Continuous: Stress vs Time', testName);
legend('Shighs','Slows','Samp','Location','northwest');
hold off;

%% Continuous: d1 calculation using continuous theta

% SFnew = round(window * SF, 9);
% if mod(SFnew,2) == 0
%     SFnew = SFnew + 1; % Ensure odd number for convolution
% end

movmean_thetaC = movmean(theta_C, SFnew, 'endpoints','fill');

d1C = nan(size(theta_C));

kd = (SFnew-1)/2;
for k = (SFnew):length(theta_C)-(SFnew-1)
    d1C(k) = rho * C * (((movmean_thetaC(k+kd) - movmean_thetaC(k-kd)) / (t_C(k+kd) - t_C(k-kd))) + movmean_thetaC(k)/tau);
end

d1C = d1C/1000; % Converting units into kilo

% d1C = d1C + 672; % offset in case d1 started below zero due to
% temperature issue
% if mean(theta) > 0
% Z3 = d1C(~isnan(d1C)); 
% d1C = d1C - Z3(1);
% end

figure('Name','Continuous: d1C and Avg. Theta vs Time')
plot(t_C, d1C, '.b')
title('Continuous: d1C during loading', testName)
grid on
xlabel('Time (s)')
ylabel('d1 (kW/m³)')
yyaxis right
plot(t_C, movmean_thetaC, '-r', linewidth = 3)
ylabel('\theta (K)');
legend('d1','Avg. \theta','Location', 'northwest');

D1C = d1C / LF; % Normalize by loading frequency


%% Continuous: Plotting section

% --- d1 & stress amplitude vs Time
figure('Name','Continuous: d1C and SampC vs Time')
plot(t_C, d1C, '.b', 'LineWidth', 1.5); % in kW/m3
title(sprintf('Continuous: d1, and \\sigma_{amp} vs Time\n(Window Size: %0.2fs - %s)', window, testName));
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
xlabel('Time (s)')
% hold on
% plot(t_continuous, movmean_thetaC, '-r', 'LineWidth', 1.5); % 
% xlabel('Time (s)');
% title(sprintf('Continuous: d1, Avg.\theta and \\sigma_{amp} vs Time\n(Window Size: %0.2fs - %s)', window, testName_withDate));
% ylabel('d1 (kW/m^3) / \theta (K)');
yyaxis right;
plot(t_C, SampC, '-.m', LineWidth=2)
ylabel('Stress Amplitude (MPa)');
ax = gca;
ax.YAxis(2).Color = 'm';
legend('d1', '\sigma_{amp}','Location', 'northwest');
grid on;
% legend('d1', 'Avg.\theta','\sigma_{amp}','Location', 'northwest');

% ---- d1, Theta, and Avg.Theta vs stress amplitude
figure('Name','Continuous: d1C, Theta, and Avg.Theta  vs SampC')
plot(SampC, theta_C,'-r');%, linewidth = 2)
hold on
plot(SampC, movmean_thetaC, '-g', linewidth = 1.5)
ylabel('\theta (K)')
xlabel('\sigma_{amp} (MPa)');

yyaxis right
plot(SampC, d1C, '.b');
title(sprintf('Continuous: d1C, \\theta, and Avg.\\theta vs \\sigma_{amp}\n(Window Size: %0.2fs - %s)', window, testName));
ylabel('d1 - Mechanical Dissipation (kW/m^3)');
ax = gca;
ax.YAxis(2).Color = 'b';
legend('\theta','Avg. \theta','d1','Location','northwest')
% legend('d1', '\theta','Location','northwest')
grid on;


% % ---- d1 and diff(Avg. Theta) vs stress amplitude
figure('Name','Continuous: d1C and diff(Avg.Theta) vs SampC');
plot(SampC(2:end), diff(movmean_thetaC), '-r', linewidth = 1)
ylabel('diff (Avg.\theta)  (K)')
title(sprintf('Continuous: d1 and diff (Avg.\\theta) vs \\sigma_{amp}\n(Window Size: %0.2fs - %s)', window, testName));
xlabel('\sigma_{amp} (MPa)');
yyaxis right
plot(SampC, d1C, '.b');
ylabel('d1 - Sum of Heat Sources (kW/m^3)');
ax = gca;
ax.YAxis(2).Color = 'b';
legend('diff (Avg.\theta)','d1', 'Location','northwest')
grid on;


% ---- D1, Theta, and Avg.Theta vs stress amplitude
figure('Name','Continuous: D1C, Theta, and Avg.Theta  vs SampC')
plot(SampC, theta_C,'-r');%, linewidth = 2)
hold on
plot(SampC, movmean_thetaC, '-g', linewidth = 1.5)
ylabel('\theta (K)')
xlabel('\sigma_{amp} (MPa)');

yyaxis right
plot(SampC, D1C, '.b');
title(sprintf('Continuous: D1C, \\theta, and Avg.\\theta vs \\sigma_{amp}\n(Window Size: %0.2fs - %s)', window, testName));
ylabel('Mechanical Dissipation - D1 (kJ/m^3)'); 
ax = gca;
ax.YAxis(2).Color = 'b';
legend('\theta','Avg. \theta','D1','Location','northwest')
% legend('d1', '\theta','Location','northwest')
grid on;

% ----- d1, d1C, d1-SelfHeating
% figure('Name','d1, d1-theta-selfheating, d1C vs Samp')
figure('Name','d1, d1C vs Samp')
plot(SampInterp,d1,'-b', LineWidth=2)
hold on;
% plot(SampInterp,d1_SelfHeating,'-r', LineWidth=2)
plot(SampC,d1C,'-k', LineWidth=1.5)
grid on
% title('d1, d1-self-heating, d1C vs \sigma_{amp}')
title('d1, d1C vs \sigma_{amp}')
xlabel('\sigma_{amp} (MPa)')
ylabel('d1 (kW/m³)')
% legend ('d1','d1_{SelfHeating}','d1C',Location='northwest')
legend ('d1','d1C',Location='northwest')

%% ------ Different ways to plot d1
% figure('Name','d1, d1-theta-selfheating, d1C')
% plot((SampInterp(2:end)),diff(d1),'-b', LineWidth=2)
% hold on;
% plot((SampInterp(2:end)),diff(d1_SelfHeating),'-r', LineWidth=2)
% plot((SampC(2:end)),diff(d1C),'-k', LineWidth=1.5)
% grid on
% title('d1, d1-self-heating, d1C vs \sigma_{amp}')
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d1 (kW/m³)')
% legend ('d1','d1_{SelfHeating}','d1C',Location='northwest')
% 
% % --- Rate of mechanical dissipation
% dSamp = mode(diff(SampInterp));
% d_d1 = gradient(d1_SelfHeating, dSamp);
% figure;
% plot(SampInterp, d_d1, 'm', 'LineWidth', 2);
% grid on
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d d_1 / dSamp')
% title('Rate of mechanical dissipation')
% 
% % ---- Acceleration of dissipation
% dd_d1 = gradient(gradient(d1_SelfHeating, dSamp), dSamp);
% figure;
% plot(SampInterp, dd_d1, 'm', 'LineWidth', 2);
% grid on
% xlabel('\sigma_{amp} (MPa)')
% ylabel('d^2 d_1 / dSamp^2')
% title('Acceleration of dissipation')
% 
% 
% ZZ = diff(movmean(diff(d1_SelfHeating),SF));
% figure;
% plot(SampInterp(3:end),ZZ); grid on


%% Continuous: Frequency Analysis of Theta of Loading Period
N_thetaCLoading = length(theta_C);
f = (0:floor(N_thetaCLoading/2)) * (SF / N_thetaCLoading);

% FFT computation
P1 = abs(fft(theta_C,N_thetaCLoading)) * (2/N_thetaCLoading);
P1 = P1(1 : floor(N_thetaCLoading/2)+1);
P1(1) = NaN; % Remove DC component

figure('Name', 'Continuous: Amplitude Spectrum');
plot(f, log(P1), '.r', 'MarkerSize', 5, DisplayName='theta-loading'); hold on;
title('Continuous: \theta (loading) Single-Sided Amplitude Spectrum (DC Removed)', testName);
xlabel('Frequency (Hz)');
xticks(0:LF:ceil(SF/2/100)*100)
ylabel('Amplitude (log)');
grid on;
legend

N_thetaCLoadingTrunc = N_thetaCLoading;
while mod(N_thetaCLoadingTrunc, SF/LF) >= 1e-9
    N_thetaCLoadingTrunc = N_thetaCLoadingTrunc -1;
end

Ndiff = N_thetaCLoading - N_thetaCLoadingTrunc;
thetaTruncIdx = flip(N_thetaCLoading:-1:Ndiff-1);

thetaTrunc = theta_C(thetaTruncIdx);

fTrunc = (0:floor(N_thetaCLoadingTrunc/2)) * (SF / N_thetaCLoadingTrunc);

% FFT computation
P1Trunc = abs(fft(thetaTrunc,N_thetaCLoadingTrunc)) * (2/N_thetaCLoadingTrunc);
P1Trunc = P1Trunc(1 : floor(N_thetaCLoadingTrunc/2)+1);
P1Trunc(1) = NaN; % Remove DC component

hold on
plot(fTrunc, log(P1Trunc), '.b', 'MarkerSize', 5, DisplayName='theta-loading truncated');

%% Continuous: FFT on sliding windows

N_thetaC = length(theta_C);
elements_in_window = round(SF*window);      % window length in samples
SFnew = elements_in_window; %SF*window; %round(N_theta/50);  % Define smoothing window


if mod(elements_in_window, SF/LF) >= 1e-9
    error('window size is not producing integer number of cycles!!!')
end

FL2 = 2*LF;                % 2nd harmonic [Hz]
FL3 = 3*LF;                % 3rd harmonic [Hz]

% Aliasing check
if FL3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], FL3, SF/2);
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
f = (0:elements_in_window-1) * (SF/elements_in_window);
nWin = N_thetaC - elements_in_window + 1; % # of windows in the whole theta vector
tplot = t_C(1:nWin);
% loading window
loading_start = t_C(1);%(idx_Theta_sync(1));
loading_end = t_C(end); %(temp_idxE - SF*window);
loading_window = find(tplot >= loading_start & tplot <= loading_end);

% ###########################
% ###########################
SampInterp_x = SampC (1:nWin);
SampInterp_x = SampInterp_x(:);

% ###########################
% ###########################

% --- Preallocate ---
maxAmpH1C = nan(nWin,1); maxFreqH1C = nan(nWin,1); ampAtH1C = nan(nWin,1); % ampAtH1C = Amplitude At H1 Continuous theta data 
maxAmpH2C = nan(nWin,1); maxFreqH2C = nan(nWin,1); ampAtH2C = nan(nWin,1);
maxAmpH3C = nan(nWin,1); maxFreqH3C = nan(nWin,1); ampAtH3C = nan(nWin,1);
ampAtArbitC = nan(nWin, length(arbitraryFreqs));


% --- Sliding window ---
%% --- Continuous: SHTSA FFT method
for k = 1:nWin

    end_idx = k+elements_in_window-1;
    segment = detrend(theta_C(k : end_idx), 4);
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta_C(k : end_idx);
    A = abs(fft(segment)) * (2/elements_in_window);

    idx1 = find(f >= (LF-BW) & f <= (LF+BW));
    [maxAmpH1C(k), j1] = max(A(idx1)); maxFreqH1C(k) = f(idx1(j1));
    [~, i1] = min(abs(f - LF)); ampAtH1C(k) = A(i1);

    idx2 = find(f >= (FL2-BW) & f <= (FL2+BW));
    [maxAmpH2C(k), j2] = max(A(idx2)); maxFreqH2C(k) = f(idx2(j2));
    [~, i2] = min(abs(f - FL2)); ampAtH2C(k) = A(i2);

    if FL3<SF/2
        idx3 = find(f >= (FL3-BW) & f <= (FL3+BW));
        [maxAmpH3C(k), j3] = max(A(idx3)); maxFreqH3C(k) = f(idx3(j3));
        [~, i3] = min(abs(f - FL3)); ampAtH3C(k) = A(i3);
    end

    for j = 1:length(arbitraryFreqs)
        [~, idx] = min(abs(f - arbitraryFreqs(j)));
        ampAtArbitC(k, j) = A(idx);
    end

end

% --- Construct central time reference for overlaying theta ---
winCentreIdx = (1:nWin) + floor(elements_in_window/2);

%% --- Continuous: Plots of Amplitudes from FFT method ---

% -- Harmonic Amplitudes and Theta vs Time
figure('Name','Continuous: Harmonic Amplitudes and Theta vs Time'); %,'NumberTitle','off');

nn = 3;
if FL3>SF/2
    nn = 2;
end

subplot(nn,2,1); % ---- in this subplot no average of amplitude as the amplitud is not very noisy
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx), '-b'); 
ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, ampAtH1C, 'k', 'LineWidth', 3);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', LF)); grid on;
xlabel('Time (s)')
legend('\theta','Amp', 'Location', 'northwest');
% legend('Amp', 'Avg. \theta','Location', 'northwest');

subplot(nn,2,2); % ---- in this subplot no average of amplitude as the amplitud is not very noisy
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx), '-b'); 
ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, maxAmpH1C, 'k', 'LineWidth', 3);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
xlabel('Time (s)')
legend('\theta','Amp', 'Location', 'northwest');


subplot(nn,2,3);
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, ampAtH2C, 'g', 'LineWidth', 2);
hold on;
plot(tplot, movmean(ampAtH2C, SFnew, 'Endpoints', 'fill'), 'm-', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', FL2)); grid on;
xlabel('Time (s)')
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


subplot(nn,2,4);
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right
ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, maxAmpH2C, 'm', 'LineWidth', 2);
hold on; plot(tplot, movmean(maxAmpH2C, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', FL2, BW)); grid on;
xlabel('Time (s)')
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if FL3<SF/2
    subplot(nn,2,5);
    yyaxis left
    % plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, theta_C(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(tplot, ampAtH3C, 'y', 'LineWidth', 2);
    hold on; plot(tplot, movmean(ampAtH3C, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Amp @ %.f Hz', FL3)); grid on;
    xlabel('Time (s)')
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


    subplot(nn,2,6);
    yyaxis left
    % plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, theta_C(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(tplot, maxAmpH3C, 'c', 'LineWidth', 2);
    hold on; plot(tplot, movmean(maxAmpH3C, SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', FL3, BW)); grid on;
    xlabel('Time (s)')
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sgtitle(sprintf('Continuous: %.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', window,testName));


% -- Continuous: Harmonic Amplitudes and Theta vs Stress amplitude
figure('Name','Continuous: Harmonic Amplitudes and Theta vs Stress Amp'); %);%,'NumberTitle','off');

subplot(nn,2,1);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, ampAtH1C(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', LF)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp', 'Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,2,2);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, maxAmpH1C(loading_window), 'k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', LF, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Avg. \theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,2,3);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, ampAtH2C(loading_window), 'g', 'LineWidth', 2);
hold on;
plot(SampInterp_x, movmean(ampAtH2C(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Amp @ %.f Hz', FL2)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

subplot(nn,2,4);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, maxAmpH2C(loading_window), 'm', 'LineWidth', 2);
hold on; plot(SampInterp_x, movmean(maxAmpH2C(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
ylabel('Amp (K)');
title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', FL2, BW)); grid on;
xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if FL3<SF/2
    subplot(nn,2,5);
    yyaxis left
    % plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(SampInterp_x, ampAtH3C(loading_window), 'y', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(ampAtH3C(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Amp @ %.f Hz', FL3 )); grid on;
    xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


    subplot(nn,2,6);
    yyaxis left
    % plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
    plot(SampInterp_x, maxAmpH3C(loading_window), 'c', 'LineWidth', 2);
    hold on; plot(SampInterp_x, movmean(maxAmpH3C(loading_window), SFnew, 'Endpoints', 'fill'), '-k', 'LineWidth', 2);
    ylabel('Amp (K)');
    title(sprintf('Continuous: Max Amp %.f\\pm%.1f Hz', FL3, BW)); grid on;
    xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sgtitle(sprintf('Continuous: %.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', window,testName));


%% --- Continuous: Traditional method
% Generate reference signals
% tref_signal = (0:N_thetaC-1) / SF;
tref_signal = t_C'; %(0:dt:(length(F_continuous)-1)*dt);

% tref_signal = tref_signal(:);
X1 = cos(2 * pi * LF * tref_signal)'; %FL_analysed
Y1 = sin(2 * pi * LF * tref_signal)';

X2 = cos(2 * pi * 2*LF * tref_signal)';
Y2 = sin(2 * pi * 2*LF * tref_signal)';

X3 = cos(2 * pi * 3*LF * tref_signal)';
Y3 = sin(2 * pi * 3*LF * tref_signal)';

for k = 1:nWin

    end_idx = k+elements_in_window-1;

    if end_idx > N_thetaC
        break;
    end

    segment = detrend(theta_C(k : end_idx), 6); % - mean(theta(start_idx : end_idx)); Detrend removed the mean of theta
    % segment = detrend(theta(k : end_idx), 1);
    % segment = theta_C(k : end_idx);    
    
    H1_cosC(k) = sum(segment .* X1(k : end_idx)) / ((elements_in_window)/2);
    H1_sinC(k) = sum(segment .* Y1(k : end_idx)) / ((elements_in_window)/2);

    H2_cosC(k) = sum(segment .* X2(k : end_idx)) / ((elements_in_window)/2);
    H2_sinC(k) = sum(segment .* Y2(k : end_idx)) / ((elements_in_window)/2);

    H3_cosC(k) = sum(segment .* X3(k : end_idx)) / ((elements_in_window)/2);
    H3_sinC(k) = sum(segment .* Y3(k : end_idx)) / ((elements_in_window)/2);

    % T_mean(k) = mean(T_0D_segment);
    AmpH1_windowC(k) = sqrt(H1_sinC(k)^2 + H1_cosC(k)^2);
    AmpH2_windowC(k) = sqrt(H2_sinC(k)^2 + H2_cosC(k)^2);
    AmpH3_windowC(k) = sqrt(H3_sinC(k)^2 + H3_cosC(k)^2);
end

% --- plots

% tplot = tTheta_sync(winCentreIdx);
% tplot = t_continuous(1:nWin);
% tplot = t_continuous(winCentreIdx);
% Combined figure with three subplots for H1, H2, H3 amplitudes
figure('Name','Continuous: Harmonic Amplitudes and Theta vs time'); %,'NumberTitle','off');
subplot(nn,1,1);
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx),'-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(tplot, AmpH1_windowC, LineWidth=2); grid on; title(sprintf('Continuous: H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(tplot, movmean(AmpH1_windowC, smoothing, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
% legend('Amp','Avg. \theta','Location', 'northwest');
% legend('Amp','\theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');

subplot(nn,1,2);
yyaxis left
% plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(tplot, theta_C(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k'; 
plot(tplot, AmpH2_windowC); grid on; title(sprintf('Continuous: H2 Amplitude at %.f Hz', FL2));
hold on;
plot(tplot, movmean(AmpH2_windowC, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('Time (s)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');

if FL3<SF/2
    subplot(nn,1,3);
    yyaxis left
    % plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(tplot, theta_C(winCentreIdx), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k'; 
    plot(tplot, AmpH3_windowC); grid on; title(sprintf('Continuous: H3 Amplitude at %.f Hz', FL3));
    hold on;
    plot(tplot, movmean(AmpH3_windowC, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('Time (s)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sgtitle(sprintf('Continuous: %.1fs Sliding-Window Harmonic Analysis using Reference Signals\n(mean \\theta removed) - %s', window, testName));


% ----- Harmonic Amp. and Theta vs Stress Amp
% loading period in temperatue and tTemp: idx_Theta_sync(1):theta_idxE
% so the time should statrt when time is => than the time value at
% idx_Theta_sync(1) and ends at when the time value is =< theta_idxE.



AmpH1_loading = AmpH1_windowC(loading_window);
AmpH2_loading = AmpH2_windowC(loading_window);
AmpH3_loading = AmpH3_windowC(loading_window);


figure('Name','Continuous: Harmonic Amp. and Theta vs Stress Amp'); %);%,'NumberTitle','off');
subplot(nn,1,1);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, AmpH1_loading, LineWidth=2); grid on; title(sprintf('Continuous: H1 Amplitude at %.f Hz', LF));
% hold on;
% plot(SampInterp, movmean(AmpH1_loading, smoothing, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Location', 'northwest');


subplot(nn,1,2);
yyaxis left
% plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
yyaxis right; ax = gca; ax.YAxis(2).Color = 'k';
plot(SampInterp_x, AmpH2_loading); grid on; title(sprintf('Continuous: H2 Amplitude at %.f Hz', FL2));
hold on;
plot(SampInterp_x, movmean(AmpH2_loading, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
% legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
% legend('Amp','Mean Amp', '\theta','Location', 'northwest');
legend('\theta','Amp','Mean Amp', 'Location', 'northwest');


if FL3<SF/2
    subplot(nn,1,3);
    yyaxis left
    % plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    plot(SampInterp_x, theta_C(loading_window), '-b'); ylabel('\theta (K)'); ax = gca; ax.YAxis(1).Color = 'b';
    title(sprintf('Continuous: H3 Amplitude at %.f Hz', FL3));
    yyaxis right; ax = gca; ax.YAxis(2).Color = 'k'; 
    plot(SampInterp_x, AmpH3_loading, linewidth = 1.2); grid on; 
    hold on;
    plot(SampInterp_x, movmean(AmpH3_loading, SFnew, 'Endpoints', 'fill'), 'k-', 'LineWidth', 2);
    ylabel('Amp (K)'); xlabel('\sigma_{amp} (MPa)');
    % legend('Amp','Mean Amp', 'Avg. \theta','Location', 'northwest');
    % legend('Amp','Mean Amp', '\theta','Location', 'northwest');
    legend('\theta','Amp','Mean Amp', 'Location', 'northwest');
end

sgtitle(sprintf('Continuous: %.1fs Sliding-Window Harmonic Analysis using Reference Signals\n (mean \\theta removed - %s)', window,testName));


%% --- Continuous: Arbitrary Frequencies with Theta Overlay ---
% figure('Name','Continuous: All Arbitrary Frequency Amplitudes with Theta');%);%,'NumberTitle','off');
% nCols = 2; nRows = ceil(length(arbitraryFreqs) / nCols);
% for j = 1:length(arbitraryFreqs)
%     subplot(nRows, nCols, j);
%     yyaxis left; ax = gca; ax.YAxis(2).Color = 'k';
%     plot(tplot, ampAtArbitC(:, j), '--', 'LineWidth', 2);
%     ylabel('Amp (K)');
%     title(sprintf('Amp @ %.2f Hz', arbitraryFreqs(j))); grid on;
% 
%     yyaxis right
%     plot(tplot, movmean(theta_C(winCentreIdx), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
%     ylabel('\theta (K)'); xlabel('Time (s)')
%     legend('Amp','Avg. \theta','Location', 'northwest');
% end
% % sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
% sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', window,testName_withDate));
% 
% 
% % -- Arbitrary Frequencies' Amp vs Stress Amp
% figure('Name','Continuous: Arbitrary Freq Amps vs Stres Amp');%);%,'NumberTitle','off');
% nCols = 2; nRows = ceil(length(arbitraryFreqs) / nCols);
% for j = 1:length(arbitraryFreqs)
%     subplot(nRows, nCols, j);
%     yyaxis left; ax = gca; ax.YAxis(2).Color = 'k';
%     plot(SampInterp, ampAtArbitC(loading_window, j), '--', 'LineWidth', 2);
%     ylabel('Amp (K)');
%     title(sprintf('Amp @ %.2f Hz', arbitraryFreqs(j))); grid on;
% 
%     yyaxis right
%     plot(SampInterp, movmean(theta_C(loading_window), smoothing, 'Endpoints', 'fill'), 'Color', [0.85, 0.33, 0.1]);
%     ylabel('\theta (K)'); xlabel('\sigma_{amp} (MPa)');
%     legend('Amp','Avg. \theta','Location', 'northwest');
% 
% end
% % sgtitle('Amplitude at Arbitrary Frequencies with Theta Overlay');
% sgtitle(sprintf('%.1fs Sliding-Window Arbitrary Frequencies FFT Analysis\n (mean \\theta removed) - %s', window,testName_withDate));

%% ---Continuous: Frequency Peak Tracking Only ---
figure('Name','Continuous: Harmonic Peak Frequencies');%,'NumberTitle','off');

subplot(nn,1,1);
plot(tplot, maxFreqH1C,'b','LineWidth',1.2);
title(sprintf('Continuous: Peak Freq in %.f\\pm%.1f Hz', LF, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

subplot(nn,1,2);
plot(tplot, maxFreqH2C,'m','LineWidth',1.2);
title(sprintf('Continuous: Peak Freq in %.f\\pm%.1f Hz', FL2, BW));
ylabel('Freq (Hz)');
xlabel('Time (s)'); grid on;

if FL3<SF/2
    subplot(nn,1,3);
    plot(tplot, maxFreqH3C,'c','LineWidth',1.2);
    title(sprintf('Continuous: Peak Freq in %.f\\pm%.1f Hz', FL3, BW));
    ylabel('Freq (Hz)');
    xlabel('Time (s)'); grid on;
end

sgtitle(sprintf('%.1fs Sliding-Window - Peak Frequency Tracking vs. Time\n (mean \\theta removed) - %s', window,testName));


%% Saving Variables
if window ~= 3 || BW ~= 1
    error('Window size is not 3 seconds or Bandwidth is not 1.');
end

ampAtH2mean = movmean(ampAtH2, SFnew);
ampAtH3mean = movmean(ampAtH3, SFnew);

ampAtH2Cmean = movmean(ampAtH2C, SFnew);
ampAtH3Cmean = movmean(ampAtH3C, SFnew);

ampAtH1 = ampAtH1(loading_window);
maxAmpH1 = maxAmpH1(loading_window);
ampAtH2 = ampAtH2(loading_window);
maxAmpH2 = maxAmpH2(loading_window);

% List of variables to save
saveVars = {'LF','SF','Force_idxS','Force_idxE','temp_idxS','temp_idxE',...
    'SampInterp','theta', 'd1','D1', 'ampAtH1', 'maxAmpH1','ampAtH2','ampAtH2mean','maxAmpH2',... %'d1_SelfHeating', 'D1_SelfHeating', 
    'SampC','theta_C', 'd1C','D1C', 'ampAtH1C', 'maxAmpH1C','ampAtH2C','ampAtH2Cmean', 'maxAmpH2C'};

% Add H3 variables only when needed
if FL3 < SF/2
    ampAtH3 = ampAtH3(loading_window);
    maxAmpH3 = maxAmpH3(loading_window);
    saveVars = [saveVars, {'ampAtH3', 'ampAtH3mean','maxAmpH3','ampAtH3C', 'ampAtH3Cmean','maxAmpH3C'}];
end
safeTestName = strrep(testName, '-', '_');
safeTestName = regexprep(safeTestName, '[^a-zA-Z0-9_]', '_');

% Construct MAT file path
matFileName = fullfile(folderPath, ['SH_d1_' testName '.mat']);

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
F_sync_interp = F_sync_interp(:);
theta_sync_interp = theta_sync_interp(:);


% --- Find peaks ---
[Fpk, Fpk_loc] = findpeaks(F_sync_interp,'MinPeakProminence',minProminence);

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

% ==============================================================
maxN = max(segment_ends - segment_starts +1);

ForceBL = nan(maxN, N_segments);
thetaBL = nan(maxN, N_segments);
t_BL = nan(maxN, N_segments);

Force_BL_X = [];
theta_BL_X = [];
t_BL_X = [];

for s = 1:N_segments
    idx = segment_starts(s) : segment_ends(s);
    N_Rows = length(idx);

    ForceBL(1:N_Rows,s) = F_sync_interp(idx);
    thetaBL(1:N_Rows,s) = theta_sync_interp(idx);
    t_BL(1:N_Rows,s) = t_sync(idx);
    
    Force_BL_X = [Force_BL_X; F_sync_interp(idx)];
    theta_BL_X = [theta_BL_X; theta_sync_interp(idx)];
end

% ==============================================================
% NEW TIME VECTOR STARTING AT 0

dt = mode(diff(t_sync));
t_X = (0:dt:(length(theta_BL_X)-1)*dt).'; % both Force_BL_X and theta_BL_X have same length


% ============================= PLOT
figure('Name','BL Segment Assembly')
plot(t_X, Force_BL_X, 'k')
ylabel('Force (N)')
hold on
yyaxis right
plot(t_X, theta_BL_X, 'r')
ylabel('\theta (K)')
xlabel('Time (s)')
title('BL Segments: Force and \theta')
legend ('F continusou','\theta continuous', 'location','northwest')
grid on

%% Block Loading: Stress Amplitude calculation
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

d1BL = nan(maxN,N_segments);

for s = 1:N_segments

    thetaBL_s = thetaBL(~isnan(thetaBL(:,s)),s);
    movmean_thetaBL_s = movmean(thetaBL_s, SFnew, 'endpoints','fill');
    tBL_s = t_BL(~isnan(t_BL(:,s)), s);
    tBL_s = tBL_s - tBL_s(1);
    
    d1BL_s = nan(size(thetaBL_s));
    kd = (SFnew-1)/2;

    for k = (SFnew):length(thetaBL_s)-(SFnew-1)
        d1BL_s(k) = rho * C * (((movmean_thetaBL_s(k+kd) - movmean_thetaBL_s(k-kd)) / (tBL_s(k+kd) - tBL_s(k-kd))) + movmean_thetaBL_s(k)/tau);
    end

    d1BL_s = d1BL_s/1000; % Converting units into kilo

    d1BL(1:length(d1BL_s),s) = d1BL_s;
end

d1BL_mean = mean(d1BL,"omitnan");
d1BL_mean = d1BL_mean(:);
D1BL_mean = d1BL_mean / LF;

% ----- d1, d1C, d1-BL
figure('Name','d1, d1C, d1BL vs Samp')
plot(SampInterp,d1,'-b', LineWidth=2)
hold on;
plot(SampC,d1C,'-k', LineWidth=1.5)
plot(SampBL,d1BL_mean,'o-', markersize=5, LineWidth=2)
grid on
title('d1, d1C, d1BL vs \sigma_{amp}')
xlabel('\sigma_{amp} (MPa)')
ylabel('d1 (kW/m³)')
legend ('d1','d1C', 'd1BL',Location='northwest')


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
    F = detrend(F);

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

title('BL: Force Single-Sided Amplitude Spectrum per Segment (DC Removed)', testName);
legend(legTxt, 'Location','best');
grid on;

figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));




%% Block Loading: Frequency Analysis From theta data
theta = theta(:);        % Nx1 temperature signal
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
    x = detrend(x);
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
    xx = freqCell{k};
    yy = ampCell{k};
    yy(1) = NaN;
    % plot(freqCell{k}, log(ampCell{k}), 'LineWidth', 1);
    plot(xx, (yy), 'LineWidth', 1);
    legTxt{k} = sprintf('Seg %d', k);
end

xlabel('Frequency (Hz)', 'Interpreter','latex');
ylabel('Amplitude', 'Interpreter','latex');
% title('Frequency Content of All $\theta$ Segments', 'Interpreter','latex');
title('BL: \theta Single-Sided Amplitude Spectrum per Segment (DC Removed)', testName);
legend(legTxt, 'Location','best');
grid on;

figTitle = get(get(gca, 'Title'), 'String');
figureName = regexprep(figTitle, '[^\w\s-]', '');  % remove special chars (like :)
figureName = strrep(figureName, ' ', '_');           % replace spaces with underscores
saveas(gcf, fullfile(folderPath, [figureName '.fig']));

%% Block Loading: SHTSA of BL Theta (FFT method)

if mod(SFnew, SF/LF) >= 1e-9
    error('window size is not producing integer number of cycles!!!')
end

FL2 = 2*LF;                % 2nd harmonic [Hz]
FL3 = 3*LF;                % 3rd harmonic [Hz]

% Aliasing check
if FL3 > SF/2
    warning(['\n################################\n' ...
        'Third Harmonic (%.2f Hz) violates Nyquist criterion (%.2f Hz).\n' ...
        '################################'], FL3, SF/2);
end

[H1BL, H2BL, H3BL, H1maxBL, H2maxBL, H3maxBL] = deal(nan(N_segments,1));

for s = 1:N_segments
    thetaBL_s = thetaBL(~isnan(thetaBL(:,s)),s);
    N_thetaBL_s = length(thetaBL_s);

    tBL_s = t_BL(~isnan(t_BL(:,s)), s);
    tBL_s = tBL_s - tBL_s(1);


    % --- FFT frequency axis ---
    f = (0:SFnew-1) * (SF/SFnew);
    nWinBL = N_thetaBL_s - SFnew + 1; % # of windows in the whole theta vector
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

        end_idx = k+SFnew-1;
        segment = detrend(thetaBL_s(k : end_idx), 4);
        % segment = detrend(theta(k : end_idx), 1);
        % segment = theta_C(k : end_idx);
        
        A = abs(fft(segment)) * (2/SFnew);
        idx1 = find(f >= (LF-BW) & f <= (LF+BW));
        [maxAmpH1C(k), j1] = max(A(idx1)); maxFreqH1C(k) = f(idx1(j1));
        [~, i1] = min(abs(f - LF)); ampAtH1C(k) = A(i1);

        idx2 = find(f >= (FL2-BW) & f <= (FL2+BW));
        [maxAmpH2C(k), j2] = max(A(idx2)); maxFreqH2C(k) = f(idx2(j2));
        [~, i2] = min(abs(f - FL2)); ampAtH2C(k) = A(i2);

        if FL3<SF/2
            idx3 = find(f >= (FL3-BW) & f <= (FL3+BW));
            [maxAmpH3C(k), j3] = max(A(idx3)); maxFreqH3C(k) = f(idx3(j3));
            [~, i3] = min(abs(f - FL3)); ampAtH3C(k) = A(i3);
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
if FL3>SF/2
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
title(sprintf('Amp @ %.f Hz', FL2)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


subplot(nn,2,4);
% yyaxis left
plot(SampBL, H2maxBL, 'm-o', 'LineWidth', 2, markersize=5);
ylabel('Amp (K)');
hold on; 
title(sprintf('Max Amp %.f\\pm%.1f Hz', FL2, BW)); grid on;
% yyaxis right
% plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
xlabel('\sigma_{amp} (MPa)');
legend('Amp','Location', 'best');


if FL3<SF/2
    subplot(nn,2,5);
    % yyaxis left
    plot(SampBL, H3BL, 'r-o', 'LineWidth', 2, markersize=5);
    hold on; 
    ylabel('Amp (K)');
    title(sprintf('Amp @ %.f Hz', FL3 )); grid on;
    % yyaxis right
    % plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Location', 'best');

    subplot(nn,2,6);
    % yyaxis left
    plot(SampBL, H3maxBL, 'c-o', 'LineWidth', 2, markersize=5);
    hold on; 
    ylabel('Amp (K)');
    title(sprintf('Max Amp %.f\\pm%.1f Hz', FL3, BW)); grid on;
    % yyaxis right
    % plot(SampBL, thetaBL, 'Color', [0.85, 0.33, 0.1]); ylabel('\theta (K)');
    xlabel('\sigma_{amp} (MPa)');
    legend('Amp','Location', 'best');

end

sgtitle(sprintf('%.1fs Sliding-Window FFT Harmonic Analysis\n (mean \\theta removed) - %s', window,testName));

%% Block Loading: Saving Variables
if window ~= 3 || BW ~= 1
    error('Window size is not 3 seconds or Bandwidth is not 1.');
end

SampC = SampBL;
d1C = d1BL_mean;
D1C = D1BL_mean;

ampAtH1C = H1BL;
ampAtH2C = H2BL; 
ampAtH2Cmean = H2BL;

maxAmpH1C = H1maxBL;
maxAmpH2C = H2maxBL;

% List of variables to save
saveVars = {'LF','SF','Force_idxS','Force_idxE','temp_idxS','temp_idxE',...
    'SampInterp','theta', 'd1','D1', 'ampAtH1', 'maxAmpH1','ampAtH2','ampAtH2mean','maxAmpH2',... %'d1_SelfHeating', 'D1_SelfHeating', 
    'SampC','theta_C', 'd1C','D1C', 'ampAtH1C', 'maxAmpH1C','ampAtH2C','ampAtH2Cmean', 'maxAmpH2C'};

% Add H3 variables only when needed
if FL3 < SF/2
    % ampAtH3 = ampAtH3(loading_window);
    % maxAmpH3 = maxAmpH3(loading_window);
    ampAtH3C = H3BL;
    ampAtH3Cmean = H3BL;
    maxAmpH3C = H3maxBL;
    saveVars = [saveVars, {'ampAtH3', 'ampAtH3mean','maxAmpH3','ampAtH3C', 'ampAtH3Cmean','maxAmpH3C'}];
end

safeTestName = strrep(testName, '-', '_');
safeTestName = regexprep(safeTestName, '[^a-zA-Z0-9_]', '_');

% Construct MAT file path
matFileName = fullfile(folderPath, ['SH_d1_' testName '.mat']);

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