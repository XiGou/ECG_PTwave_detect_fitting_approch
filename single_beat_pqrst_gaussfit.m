function  res = single_beat_pqrst_gaussfit(beat, drawgraph)
% beat is one heartbeat signal only, It is a row vector
drawgraph = true;
remove_baseline = true;

% tic;



% Set up gauss fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-inf 0 0];
% opts.Upper = [inf inf inf];


% opts.StartPoint = [1 170 1];

%% fit the whole beat data to locate QRS wave and  find out the start and the end of it
x = 1:length(beat);
if iscolumn(beat)
    beat = beat';
end
[xData, yData] = prepareCurveData( x, beat);



% find QRS complex
% Exclude1 = abs(yData) < max(abs(yData))/20;
% opts.Exclude = Exclude1;
% fitresult1 = fit( xData, abs(yData), ft,opts  );
% fitted_R_peak = round(fitresult1.b1);
% fitted_sigma1 = fitresult1.c1/1.414;


%supporse that QRS is already detected
fitted_R_peak = 91;
%% 
may_have_pwave = yData(1:70);
may_have_pwave_x=( 1:length(may_have_pwave))';
% do integral on the interval may have p wave
% if it is positive , the peak heading top
% else heading bottom
int_pwave_interval = sum(may_have_pwave);

if int_pwave_interval>=0
    [maxval maxpos]=max(may_have_pwave);
    opts.StartPoint = [1 maxpos 1];
else
    [minval minpos]=min(may_have_pwave);
    opts.StartPoint = [-1 minpos 1];
end 
    

Exclude2 = abs(may_have_pwave) < max(abs(may_have_pwave))/20;
opts.Exclude = Exclude2;
fitresult2 = fit( may_have_pwave_x, (may_have_pwave), ft,opts  );
% fitted_Q_peak = round(fitresult2.b1);
% fitted_sigma2 = fitresult2.c1/1.414;

a = round(fitresult2.a1);
b = round(fitresult2.b1);
c = round(fitresult2.c1);

res.p_pos = b;
res.pS =b - c*sqrt(log(sign(a)*a/5));  % lower than 5 means the wave is started or ended 
res.pE =b + c*sqrt(log(sign(a)*a/5));

if b>=may_have_pwave_x(1) && b< may_have_pwave_x(end) && res.pE-res.pE < length(may_have_pwave)
else
    res.p_pos =-1;
    res.pS = -1;
    res.pE = -1;
end

%% 
may_have_twave = yData(150:end);
may_have_twave_x= (150:length(yData))';
% do integral on the interval may have p wave
% if it is positive , the peak heading top
% else heading bottom
int_twave_interval = sum(may_have_twave);

if int_twave_interval>=0
    [maxval maxpos]=max(may_have_twave);
    opts.StartPoint = [1 maxpos+150 1];
else
    [minval minpos]=min(may_have_twave);
    opts.StartPoint = [-1 minpos+150 1];
end 

Exclude3 = abs(may_have_twave) < max(abs(may_have_twave))/20;
opts.Exclude = Exclude3; 
fitresult3 = fit( may_have_twave_x, (may_have_twave), ft,opts  );
% fitted_t_peak =round( fitresult3.b1);
% fitted_sigma3 = fitresult3.c1/1.414;

a = round(fitresult3.a1);
b = round(fitresult3.b1);
c = round(fitresult3.c1);

res.t_pos = b;
res.tS =b - c*sqrt(log(sign(a)*a/5));
res.tE =b + c*sqrt(log(sign(a)*a/5));
%validate the result  
if b>=may_have_twave_x(1) && b<may_have_twave_x(end) && res.tE-res.tE < length(may_have_twave)
else
    res.t_pos =-1;
    res.tS = -1;
    res.tE = -1;
end

% todo: validate the result  

% fitresult1
% fitresult2
% fitresult3
% toc;





%%
if drawgraph
    % Plot fit with data.
%     figure( 'Name', 'untitled fit 1' );
    fig = figure('Visible','off');
%     subplot(2,2,1);
%     h = plot( fitresult1, xData, yData,Exclude1 );
    
    subplot(2,1,1);
    h = plot( fitresult2, xData, yData,Exclude2 );
    hold on;
    plot([res.pS,res.pE],[0 0],'or');
    
    subplot(2,1,2);
    plot_exclude3 = false(1,length(beat));
    plot_exclude3(150:end)=Exclude3;
    h = plot( fitresult3, xData, (yData),plot_exclude3 );
    hold on;
    plot([res.tS,res.tE],[0 0],'or');
%     legend( h, 'rbeat vs. xr', 'untitled fit 1', 'Location', 'NorthEast' );
    % Label axes
%     xlabel xr
%     ylabel rbeat
    grid on

%     saveas(fig, ("output_pic\111.jpg"));
    res.fig = fig;
    
end




end