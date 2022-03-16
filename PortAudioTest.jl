# plot a real-time spectrogram. This example is adapted from the GR example
# at http://gr-framework.org/examples/audio_ex.html


using PortAudio, SampledSignals, FFTW, GR, Gtk, PyCall
include("Findpeaks.jl")
#gr()

np = pyimport("numpy")
sp = pyimport("scipy.signal")
sm = pyimport("statsmodels.api")
len = 
const N = 1024
const stream = PortAudioStream(1, 0)
const buf = read(stream, N)
const fmin = 0Hz
const fmax = 10000Hz
const fs = Float32[float(f) for f in domain(fft(buf)[fmin..fmax])]
const Threshold = .3
const sampling_frequency = 44100.0
const T = 1/sampling_frequency
const t = N / sampling_frequency


#win = GtkWindow("My First Gtk.jl Program", 400, 200)
#b = GtkButton("Click Me")
#push!(win,b)
#showall(win)


while true
    
    read!(stream, buf)  



    fftMusicRAW =  abs.(fft(buf)[fmin..fmax])

    fftMusicThresh = fftMusicRAW
    fftMusicThresh[fftMusicThresh .< Threshold] .= 1

    pitchBuf = vec(buf.data)
    add=np.array([0,0])
    pitchBuf = np.append(add, buf.data)


    auto = sm.tsa.acf(pitchBuf, nlags=2000)

    peaks = sp.find_peaks(auto)
    lag = peaks[1]

    pitch = sampling_frequency / lag 
    
    println(pitch, "\n")

    #plot(fs, fftMusicThresh,xlim = (fs[1], fs[end]), ylim = (0, 100))
    
    #x = fftMusicThresh[:, 1]
   # y = fftMusicThresh[:, 2]
   # peaks = findpeaks(y, x, min_prom=5.)
    #oscatter!(x[peaks], y[peaks])
   # oplot(fs,fftMusic2,xlim = (fs[1], fs[end]), ylim = (0, 100))
   #showall(win)
end

