% prepare data for gauss fitting approach

win_l = 90;
win_r = 150;


signal = rdsamp('101');
signal = signal(:,1)*200;
length_of_signal = length(signal);
r_poses = rdann('101','atr');
num_of_beats = length(r_poses);

beats = zeros(win_l+win_r+1,num_of_beats);

%% FIRST MEDIAN FILTER
% Each signal was processed with a median filter of 200-ms width to remove QRS complexes and P-waves.
% 200ms at 360Hz = 72
baseline = medfilt1(signal, 72); %medfilt1(db.signals{s}, 72);

%% SECOND MEDIAN FILTER
%The resulting signal was then processed with a median filter of 600 ms width to remove T-waves.
% 600ms at 360Hz =
baseline = medfilt1(baseline, 216); %medfilt1(baseline, 216);

%% REMOVE BASELINE
% The signal resulting from the second filter operation contained the baseline of the ECG signal, which was
% then subtracted from the original signal to produce the baseline corrected ECG signal.
signal = signal - baseline;
%% spli


for i=1:num_of_beats
    if r_poses(i)-win_l<1
        beats(1-(r_poses(i)-win_l)+1:end,i) = signal(1:r_poses(i) +win_r);
        continue;
    end
    if r_poses(i)+win_l>length_of_signal
        beats(1:end - ((r_poses(i)+win_r)-length(signal)),i) = signal(r_poses(i) -win_l:end);
        continue;
    end
    beats(:,i) = signal(r_poses(i) - win_l: r_poses(i) + win_r);
end 


gaussdb.signal = signal;
gaussdb.r_poses = r_poses;
gaussdb.beats = beats;
save('gaussdb','gaussdb')
