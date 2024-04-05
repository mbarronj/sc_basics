s.boot
s.reboot
// hello world
{SinOsc.ar(440,0,0.5)!2}.play

{SinOsc.ar(XLine.kr(60,400,4,0.5,0,2),0,0.5)!2}.play

// Awesome modulation sound

{SinOsc.ar(SinOsc.kr(20,1,100,200),0,0.5)!2}.play
{SinOsc.ar(SinOsc.kr(40,1,100,200),0,0.5)!2}.play
{SinOsc.ar(SinOsc.kr(60,1,100,200),0,0.5)!2}.play

// Bass like a trashcan
{LFTri.ar(SinOsc.kr(40,1,100,200),0,0.5)!2}.play


// Weirdest phone call ever
{LFTri.ar(SinOsc.kr(40,1,20,300),0,0.5)!2}.play

// filtered fm
(
SynthDef(\fmsyn,{
	|out=0, freq=440, amp=0.5, modrate=20, mod_width=20, mod_avg=100,
	lfo_rate=10, lfo_width = 20, lfo_avg = 100,
	filter_q = 1|
	var modulator = SinOsc.kr(modrate,0,mod_width,mod_avg);
	var carrier = SinOsc.ar(modulator,0,amp);
	var lfo = SinOsc.kr(lfo_rate,0,lfo_width,lfo_avg);
	var voice = BPF.ar(carrier,lfo,filter_q,amp);
    Out.ar(out, Pan2.ar(voice,0,1));
}).add;
)


x= Synth.new("fmsyn",[\freq,300,\modrate,5,\mod_avg,200,\mod_width,5,\lfo_rate,1,\lfo_width,10,\lfo_avg,100,\filter_q,0.1]);
x.free

(
SynthDef(\fmtri,{
	|out=0, freq=440, amp=0.5, modrate=20, mod_width=20, mod_avg=100,
	lfo_rate=10, lfo_width = 20, lfo_avg = 100,
	filter_q = 1|
	var modulator = LFTri.kr(modrate,0,mod_width,mod_avg);
	var carrier = SinOsc.ar(modulator,0,amp);
	var lfo = SinOsc.kr(lfo_rate,0,lfo_width,lfo_avg);
	var voice = BPF.ar(carrier,lfo,filter_q,amp);
    Out.ar(out, Pan2.ar(voice,0,1));
}).add;
)

y= Synth.new("fmtri",[\freq,300,\modrate,5,\mod_avg,200,\mod_width,5,\lfo_rate,1,\lfo_width,10,\lfo_avg,100,\filter_q,0.1]);
y.free


s.scope; // scope so you can see the effect
s.meter;


currentEnvironment.clear;
