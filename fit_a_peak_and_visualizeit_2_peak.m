function fit_a_peak_and_visualizeit(series)


% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.DiffMaxChange = 10;
opts.Display = 'Off';
opts.Lower = [1 0 0 -Inf 0 0];
opts.StartPoint = [13 80 4.7308 -10 60 5.78464133172168];
opts.Upper = [Inf Inf Inf -1 Inf Inf];

%% fit the whole beat data to locate QRS wave and  find out the start and the end of it
x = 1:length(series);
[xData, yData] = prepareCurveData( x, series);


fitresult1 = fit( xData, yData, ft,opts  )
figure;
plot( fitresult1, xData, yData );


end