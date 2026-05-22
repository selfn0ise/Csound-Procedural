<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 96000
ksmps = 64
nchnls = 2
0dbfs = 1

seed 0
;
;giscale	ftgen	0,0,-10,-2, 53, 55, 56, 60, 61, 65, 67, 68, 72, 73 //hirojoshi scale, two octaves
;giscale	ftgen	0,0,-10,-2, 53, 55, 56, 60, 62, 65, 67, 68, 72, 74 //kumoi scale, two octaves
;giscale	ftgen	0,0,-16,-2, 53, 54, 56, 58, 60, 61, 63, 65, 65, 66, 68, 70, 72, 73, 75, 77 //phrygian scale, two octaves
;giscale	ftgen	0,0,-14,-2, 53, 54, 56, 60, 61, 63, 65, 65, 66, 68, 72, 73, 75, 77 //pelog scale, two octaves
giscale	ftgen	0,0,-14,-2, 53, 55, 56, 59, 60, 64, 65, 65, 67, 68, 71, 72, 76, 77 //enigmatic minor scale, two octaves


alwayson "reverb"
gasendL,gasendR init 0



instr trigger
	
	iCnt init 0
	
	kDur rspline 8, 16, 0.5, 2 
	if iCnt == 0 then
		kMin = 0
		kWhen = 0
	else
		kMin	rspline 10, 15, 0.5, 2
		kWhen rspline 0, 5, 1, 3 
	endif 
	
	kWhen rspline 0, 5, 1, 3
	
	kNum	rspline 5, 10, 0.5, 2 	
	kFreq	rspline 0.05, 0.5, 0.1, 1
	 
	ktrig metro kFreq
	schedkwhen ktrig, kMin, kNum, "glass", 0, kDur 
	iCnt=1
	
endin

instr glass

	 ;aIn mpulse 2, 0
	 
	 kJit jspline 0.002, 50, 200
	 //printk2 kJit
	 
	 kJit+=1
	 kQ rspline 800, 4000, .2, .3
	 
	 //kQ chnget "Q"
	 //kExc chnget "Exc"
	 
	 iExc random 1, 3
	 iExc = int(iExc)
	 //print iExc
	 
	 index random 0, ftlen(giscale)
    index = int(index)
	 
	 iNote table index, giscale, 0, 0, 1
	 
	 ifreq  mtof iNote+12
	 //ifreq = 200
	 
	 if1 = ifreq*1
	 if2 = ifreq*2.506
	 if3 = ifreq*4.569
	 if4 = ifreq*6.674
	 if5 = ifreq*8.914
	 if6 = ifreq*9.354
	 
	 
	 krate = 0.05
    ;krate randomh 0.1, 0.05, 0.01
    iCoin random 0, 2
    iCoin = int(iCoin)
    
	 
	 if iExc == 1 then
	 ; resonate
	    iRes ftgen 0, 0, 4096, 9, if1, 1, 0, if2, 1, 0, if3, 1, 0, if4, 1, 0, if5, 1, 0, if6, 1, 0 
	    aEnv linseg 0,p3*0.2,0.5,p3*0.4,0.5,p3*0.2,0
	    aIn poscil 0.001*aEnv, kJit, iRes
	    
	 elseif iExc == 2 then
	 ; strike
	 	if iCoin == 1 then
	 		kIntvl rspline 0.01, 0.05, .2, .6
	 	else
	 		kIntvl rspline 0.1, 0.5, 2, 6
	 	endif
	 	printk2 kIntvl
	 	aIn mpulse 0.07, kIntvl
	 endif
	 
	 
	 if if1 > sr/$M_PI then
	    if1 = 0
	 endif
	 
	 if if2 > sr/$M_PI then
	    if2 = 0
	 endif
	 
	 if if3 > sr/$M_PI then
	    if3 = 0
	 endif
	 
	 if if4 > sr/$M_PI then
	    if4 = 0
	 endif
	 
	 if if5 > sr/$M_PI then
	    if5 = 0
	 endif
	 
	 if if6 > sr/$M_PI then
	    if6 = 0
	 endif
	 
	 a1 mode aIn*ampdb(-33), if1*kJit, kQ
	 a2 mode aIn*ampdb(-24), if2*kJit, kQ
	 a3 mode aIn*ampdb(-24), if3*kJit, kQ
	 a4 mode aIn*ampdb(-31), if4*kJit, kQ
	 a5 mode aIn*ampdb(-20), if5*kJit, kQ
	 a6 mode aIn*ampdb(-29), if6*kJit, kQ
	 
	 aMix sum a1, a2, a3, a4, a5, a6
	 
	 itypea random -3, 3
    itypeb random -3, 3
    itypea = int(itypea)
    itypeb = int(itypeb)
	 idur1 random 0.1, 0.9
    idur2 = 1 - idur1
    ;print idur1
    ;print idur2

    kOut transeg 0.001, p3*idur1, itypea, 1, p3*idur2, itypeb, 0.0001
	 
	 aOut = (aMix)*kOut
	 kPan rspline 0,1,0.1,1
	 aL, aR pan2 aOut, kPan
	 


	 
	 outs aL, aR
  gasendL += aL
  gasendR += aR

endin


instr reverb

  aL,aR reverbsc gasendL,gasendR,0.85,17000
  outs aL,aR
  clear(gasendL,gasendR)
  
endin



</CsInstruments>
<CsScore>
i "trigger" 0 360000
</CsScore>
</CsoundSynthesizer>


<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>177</width>
 <height>336</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>Q</objectName>
  <x>153</x>
  <y>201</y>
  <width>20</width>
  <height>100</height>
  <uuid>{564a2d98-0aff-4210-9e29-0b7dbf3bee7a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>100.00000000</minimum>
  <maximum>10000.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>151</x>
  <y>304</y>
  <width>26</width>
  <height>32</height>
  <uuid>{a56139a8-f175-4a07-b572-0b0388e390fc}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Q</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
