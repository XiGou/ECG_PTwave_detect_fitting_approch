function fit_a_peak_and_visualizeit(series)

% Set up gauss fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0 0];
opts.Upper = [inf 120 inf];

%% fit the whole beat data to locate QRS wave and  find out the start and the end of it
x = 1:length(series);
[xData, yData] = prepareCurveData( x, series);


fitresult1 = fit( xData, abs(yData), ft,opts  )
figure;
plot( fitresult1, xData, (yData) );


end