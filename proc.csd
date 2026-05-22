<CsoundSynthesizer>
<CsOptions>
-b1024 -B4096 -odac0  ;-o Enoish.wav;-odac ;-v
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 5

;NEED TO TIDY UP THE LOW END HERE AND ADD SOME TWINKLY BITS

;seed 0

;giscale	ftgen	0,0,-9,-2,1,1.25992,1.49831,1.88775,2.0000,2.25992,2.49831,2.88775,3.0000;Maj pent
giscale	ftgen	0,0,-5,-2,1,1.49831,2.0000,2.49831,3.0000;Maj pent
gindex init 0

;waveforms
giv1 ftgen 1,0,16384,10,1,1/2,1/3,1/4,1/5,1/6,1/7,1/8,1/9,1/10 ;sawtooth
giv2 ftgen 2,0,16384,10,1,0,1/3,0,1/5,0,0,1/8,0,1/10 ;square
giv3 ftgen 3, 0, 16384, 10, 1

;global variables
gaoutL init 0
gaoutR init 0
garevL init 0
garevR init 0

gkcoin init 1

gktime times


instr sine

    gktime1 timeinsts

    index random 0, 9
    index = int(index)

    ia random 100, 500
    ib random 500, 1000
    idur random 1, 5
    irand random 0, 24


    iat random 0.001, 1
    idec random 0.001, 1
    irel random 0.001, 1
    islev random 0.2, 0.9
    irand random 1, 35

    kcps = (228/4)*p4
    iamp1 random 0.1, 0.5
    iamp2 random 0.1, 0.5
    iamp3 random 0.1, 0.5
    iamp4 random 0.1, 0.5

    inote table index, giscale, 0, 0, 1

    kfreq1 linseg ia, idur, ib
    kfreq2 linseg ia, idur*0.5, ib, idur*0.5, ia
    kfreq3 linseg ia, idur*0.25, ib, idur*0.25, ia, idur*0.25, ib, idur*0.25, ia
    iband random 10, 800

    kEnv madsr     iat, idec, 0.9, irel

    if (irand <= 10) then
        kfreq = kfreq1
    elseif (irand <= 20) && (irand >= 11) then
        kfreq = kfreq2
    else
        kfreq = kfreq3
    endif

    kcps = kcps *inote

    ifn1 random 1, 4
    ifn1 = int(ifn1)
    ifn2 random 1, 4
    ifn2 = int(ifn2)
    ifn3 random 1, 4
    ifn3 = int(ifn3)
    ifn4 random 1, 4
    ifn4 = int(ifn4)
    ;a1 poscil iamp1, kcps, giv2
    ;a2 poscil iamp2, (kcps*2), giv2
    ;a3 poscil iamp3, (kcps*0.5), giv1
    ;a4 poscil iamp4, (kcps*0.5), giv3

    a1 poscil iamp1, kcps, ifn1
    a2 poscil iamp2, (kcps*2), ifn2
    a3 poscil iamp3, (kcps*0.5), ifn3
    a4 poscil iamp4, (kcps*0.5), ifn4

    asum sum a1, a2, a3, a4

    afil moogvcf2 asum, kfreq, 0.5
    abal balance afil, asum

    ipan random 0, 1
    aL, aR pan2 afil, ipan

    irandL random 1, 25
    irandR random 1, 25

    itypea random -3, 3
    itypeb random -3, 3
    itypea = int(itypea)
    itypeb = int(itypeb)
    ;print itypea
    idur1 random 0.1, 0.9
    idur2 = 1 - idur1
    ;print idur1
    ;print idur2

    kout transeg 0.001, p3*idur1, itypea, 1, p3*idur2, itypeb, 0.0001

    ;outs (aoutL+adL)*kout, (aoutR+adR)*kout
    garevL += (aL)*kout
    garevR += (aR)*kout

endin



instr trig

    krate = 0.05
    ;krate randomh 0.1, 0.05, 0.01
    gkcoin randomh 1, 5, krate
    gkcoin = int(gkcoin)
    ;printk2 kcoin

    ;printk 1, krate
    kdur = 1/krate
    ;printk 1, kdur
    ktrig metro krate

    if trigger(ktrig, 0.5, 0) == 1 then
        event "i", "sine", 0, kdur, 1
        event "i", "sine", kdur/4, kdur, 1
        event "i", "sine", kdur/2, kdur, 1
    endif

    if trigger(ktrig, 0.5, 0) == 1 && (gktime > 60) then
        event "i", "sine", 0, kdur, 2
        event "i", "sine", kdur/4, kdur, 2
        event "i", "sine", kdur/2, kdur, 2
    endif

endin



instr out;15

    ;fout "Kinesia_Mermaid(7).wav", 4, gaoutL, gaoutR
    ;fsig pvsanal ain, ifftsize, ioverlap, iwinsize, iwintype [, iformat] [, iinit]
    ;fsig pvsfreeze fsigin, kfreeza, kfreezf
    ;asig flooper2 kamp, kpitch, kloopstart, kloopend, kcrossfade, ifn \ [, istart, imode, ifenv, iskip]

    out gaoutL*4, gaoutR*4
    clear gaoutL
    clear gaoutR

endin



instr reverb

    krand1 rspline 0.5, 0.9, 0.05, 0.1

    aoutL, aoutR reverbsc garevL, garevR, krand1, 8000

    gaoutL = (aoutL*0.5)+gaoutL
    gaoutR = (aoutL*0.5)+gaoutR

    clear garevL
    clear garevR

endin


</CsInstruments>
<CsScore>
f0 z
i "trig" 0 -1
i "out" 0 -1
i "reverb" 0 -1
</CsScore>
</CsoundSynthesizer>










<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
