//Scales
Scale.directory
~pat = Scale.saba.degrees;

Scale.major.degreeToFreq(2, 60.midicps, 1);        // 659.25511...
Scale.major(\just).degreeToFreq(2, 60.midicps, 1);    // 654.06391...


// Generic sound
(
SynthDef(\smooth, { |out, freq = 440, sustain = 1, amp = 0.5|
    var sig;
    sig = LFTri.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2)
}).add;
)

// Pbind, Pbindef (for modifying live), Pseq, Pser, Prand

// Note: the tilde '~' lets us define and use a variable, outside of a function
(
~p1 = Pbind(\instrument,\smooth,
	\freq, Pseq(~pat + 60,2).midicps
)
)
// midicps makes midi note "numbers" correctly become frequencies.
// I'm not sure what midiratio does rn, but it makes a good bass above lol.
// The + 60 puts this scale at middle C
// the .as(List) is not specifically needed - works without for scales
~p1.play
~p1.stop

(
var midi, dur;
midi = Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 1).asStream; // note
dur = Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1).asStream; //time

// SynthDef(\smooth, { |out, freq = 440, sustain = 1, amp = 0.5|
// 	var sig;
// 	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
// 	Out.ar(out, sig ! 2)
// }).add;

r = Task({
    var delta;
    while {
        delta = dur.next;
        delta.notNil
    } {
        Synth(\smooth, [freq: midi.next.midicps, sustain: delta]);
        delta.yield;
    }
}).play(quant: TempoClock.default.beats + 1.0);
)




// Prand can return whole intact sequences Prand(a, b, Pseq([1,2,3])) will always produce members of that Pseq in order as
// a Unit. Depending on context, maybe not all would be emitted.

// tilde is how you use new synths in pbinds - as a created variable
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

).play

)

~mykick.play
~mykick.stop


// creating a clock
~t = TempoClock.new(80/60,0,0)
~t.play({Synth.new(\kick,[\f1,500,\amp,1]);})
~t.stop