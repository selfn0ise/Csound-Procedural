<CsoundSynthesizer>
<CsOptions>
-odac ;-Ma -m1
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1


gifn		ftgen	0,0, 257, 9, .5,1,270, 1.5
giscale	ftgen	0,0,-5,-2, 36, 38, 40, 42, 28
giAmp		ftgen	0,0,-5,-2, -16, -18, -10, -20, -18
giSeq		ftgen	0,0,-8,-2, 1, 1, 1, 0, 1, 1, 0, 1

gasendL,gasendR, gadelL, gadelR init 0

alwayson "trigger"
alwayson "reverb"
alwayson "del"

instr trigger

	kRate = 10
	kTrig metro kRate
	kMin = 1/kRate
	kMax = 4
	kWhen = 0
	kDur = 1/kRate

	schedkwhen kTrig, kMin, kMax, "Strange_Bass", kWhen, kDur 

endin

gindex3 init 0

instr Strange_Bass

	;index3 = index3

	index1 random 0, ftlen(giscale)
    	index1 = int(index1)	 
	iNote table index1, giscale, 0, 0, 1
	
	index2 random 0, ftlen(giAmp)
    	index2 = int(index2)	 
	iAmp table index2, giAmp, 0, 0, 1
	iAmp = 0.5;ampdbfs(iAmp)
	
	iMute table gindex3, giSeq, 0, 0, 1 
	;iNote  = p4	;root note
	kCf = 5000	;moog ladder cut off

	iMode = 0
	
	;print iMute
	
	;amplitude envelope
	kEnvA adsr p3*0.05, p3*0.1, 0.5, p3*0.3

	;Oscillators
	a1 vco2	kEnvA*iAmp, cpsmidinn(iNote-12), iMode
	a2 vco2	kEnvA*iAmp, cpsmidinn(iNote+12)*0.991, iMode
	a3 vco2	kEnvA*iAmp, cpsmidinn(iNote+12), iMode
	
	;summing the oscillators
	aMix = a1 + a2 + (a3*0.5)
	
	;filter section
	kEnvF adsr p3*0.03, p3*0.2, 0.4, p3*0.3
	aFil moogvcf2 aMix, kCf*kEnvF, 0.4
	aFil2 butlp aFil, 7000 

	;some extra spice
	aDist distort aFil2, 0.4, gifn
	
	aOut = (aDist*0.3)*iMute 
	
	outs aOut, aOut
	
	gasendL+=aOut*0.3
	gasendR+=aOut*0.3
	
	gindex3+=1

endin


instr reverb

 	aL,aR reverbsc gasendL,gasendR,0.5,17000
 	outs aL,aR
  	
  	clear(gasendL,gasendR)
  
endin

instr del ;dedicated delay instrument

	 iMax = 1
	 kFB = 0.8
	 iOff = 0.01
	
	 aDL    delayr  iMax
	 a2L    deltapi 0.20
	 a1L    deltapi 0.16
	        delayw gadelL + ((a1L+a2L)*kFB)
	        
	 aDR    delayr  iMax
	 a2R    deltapi 0.20+iOff
	 a1R    deltapi 0.16+iOff
	        delayw gadelR + ((a1R+a2R)*kFB)
	        
	 aMixL = a1L+a2L
	 aMixR = a1R+a2R
	 
	 outs aMixL*0.5, aMixR*0.5
	 
	 clear gadelL ;clear the bus for the next pass
	 clear gadelR ;clear the bus for the next pass

endin



</CsInstruments>
<CsScore>
;
;r10
;
;
;i "Strange_Bass" 0 		2.5			36	
;i "Strange_Bass" + 		1.2			38
;i "Strange_Bass" 3.5	 2.5			40	
;i "Strange_Bass" 7 		3			36	
;i "Strange_Bass" 10 	4			28





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
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
