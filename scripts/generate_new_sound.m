function [mySound_binaural, TimeOnset, TimeOffset] = generate_new_sound(rpf, position, path)
    % set source settings
    rpf.setSourcePositions(position);
    % run simulation
    rpf.run
    
    % Llamar al audio monofónico
    mySound = ita_read(path);

    % generar la respuesta a impulso
    global RECIEVER
    switch RECIEVER
        case 'mono'
            IR = rpf.getImpulseResponseItaAudio(); % mono IR
            mySoundConvolved = ita_convolve(mySound, IR.ch(1));% audio ya convolucionado, pero un poco más largo

        case 'stereo'
            IR = rpf.getBinauralImpulseResponseItaAudio();
            mySoundConvolved = ita_convolve(mySound, IR);% audio ya convolucionado, pero un poco más largo

        case 'binaural'
            IR = rpf.getBinauralImpulseResponseItaAudio(); % binaural IR
            mySoundConvolved = ita_convolve(mySound, IR);% audio ya convolucionado, pero un poco más largo
        
        case 'ambisonics'
            IR = rpf.getAmbisonicsImpulseResponseItaAudio;
            mySoundConvolved = ita_convolve(mySound, IR);% audio ya convolucionado, pero un poco más largo
    end
    
    mySoundConvolved_cortado = ita_time_crop(mySoundConvolved,[0 mySound.trackLength],'time');% el audio anterior se corta al largo del audio monofónico original
    
    % set length to 10s
    [mySound_binaural, TimeOnset, TimeOffset] = mySound_time_structure(mySoundConvolved_cortado, true, false);
end
