s.boot;
s.meter;
s.plotTree;
(
SynthDef(\kick,{
	arg f1 = 500, f2 = 50, f3 = 10, df1 = 0.01, df2 = 1,el1 = 0, el2 = 1, el3 = 0,
	atk = 0.01, rel = 0.2, amp = 0.8, c1 = 1, c2 = (-1), pan = 0, out = 0, ce2 = (-12);
	var sig, env,  freqSweep;
	freqSweep = Env([f1,f2,f3],[df1,df2],[c1,c2]).ar;
	env = Env([el1,el2,el3],[atk,rel],[c1,ce2]).kr(2);
	sig = SinOsc.ar(freqSweep,pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig,pan,amp);
	Out.ar(out,sig);
}
).add;
)

~mykick = Synth.new(\kick,[\f1,500,\amp,1]);

(
~mykick = Pbind(\instrument,\kick,
	\dur, Pseq([0.25,0.25,0.25,0.25],inf),
	\f1, Pmeanrand(400,500,inf)
).play

)
~mykick.play
~mykick.stop

(
Pbindef(\mykick,
	\instrument,\kick,
	\dur, Pseq([0.5,0.25,0.25,0.25],inf),
	\f1, Pmeanrand(400,500,inf)
).play
)

s.reboot