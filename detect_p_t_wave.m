function detect_p_t_wave(beats)
    patient_num = 101;
    num_of_beats = length(beats);
    pt_detect_res = zeros(6, num_of_beats);
    
    tic;
    for i = 1:num_of_beats
        res = single_beat_pqrst_gaussfit(beats(:,i));
        saveas(res.fig, strcat("output_pic\",string(patient_num),"_",string(i),"_th_beat.jpg"));
        
        pt_detect_res(1,i) = res.p_pos;
        pt_detect_res(2,i) = res.pS;
        pt_detect_res(3,i) = res.pE;
        pt_detect_res(4,i) = res.t_pos;
        pt_detect_res(5,i) = res.tS;
        pt_detect_res(6,i) = res.tE;
    end
    toc;
    save("pt_detect_res",'pt_detect_res')
end