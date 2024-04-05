s.boot;

s.reboot;
{ SinOsc.ar(MouseX.kr(40, 10000, 1), 0, 0.1) }.play;

//Define bow synthdef
(
SynthDef(\help_dwgbowed, { |out=0, freq=440, amp=0.5,force=1, gate=1,pos=0.07,c1=0.25,c3=31,pan=0|
    var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
    var son = DWGBowed.ar(freq*vib, amp,force, gate,pos,0.1,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

Platform.userExtensionDir


{ PinkNoise.ar(EnvGen.kr(Env.perc, doneAction: Done.freeSelf)) }.play
// Play it with the mouse
{DFM.ar(PinkNoise.ar(mul: 0.5), MouseX.kr(80, 5000, 'exponential'), MouseY.kr(0.1, 1.2))}.play;

// Convolution + bonus mous control
SynthDef.new("Sawsall",{|out|
	var mixsig;
	mixsig = [Mix.fill(5,{Saw.ar(60 + 20.0.rand, 0.5, 1/5)})];
	Out.ar(out,mixsig)
});
// leave off the .play to just create the def

x = Synth.new(\Sawsall);
// No .play needed here either - synth is created+played


SynthDef("convo", {
	var input, kernel;

	input = In.ar(0,1);
	kernel = Mix.ar(LFSaw.ar([300,500,800,1000] * MouseX.kr(1.0, 2.0), 0, 1.0));

	// must have power of two framesize
	Convolution.ar(input,kernel, 1024, 0.5)
}.play;
)

// must have power of two framesize- FFT size will be sorted by Convolution to be double this
// maximum is currently a=8192 for FFT of size 16384

a = 2048;
s = Server.local;

// kernel buffer
g = Buffer.alloc(s, a, 1);
)

(

// random impulse response

g.set(0, 1.0);

100.do({ arg i; g.set(a.rand, 1.0.rand) });


{
    var input, kernel;

    input = SoundIn.ar(0);
    kernel = PlayBuf.ar(1, g.bufnum,BufRateScale.kr(g.bufnum), 1, 0, 1);

    Convolution.ar(input, kernel, 2 * a, 0.5)
}.play;

)



x.free //Close / stop the synth

b = Bus.control(s, 2); // Get a two channel control Bus
c = Bus.audio(s);     // Get a one channel private audio Bus (one is the default)


{SinOsc.ar(45,0,0.5) + Saw.ar(60,0.25)}.play;


(
    var n = 8;
    { Mix.fill(n, { SinOsc.ar(200 + 50.0.rand, 0, 1 / n) }) }.play;
)
SynthDef.new("tutorial-SinOsc", { |out| Out.ar(out, SinOsc.ar(440, 0, 0.2)) }).play;



(
f = {arg freq;
	SinOsc.ar(freq,0,0.3);}
f.set("freq",440);
f.play;
)

(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
s.scope; // scope so you can see the effect
x = Synth.new("tutorial-args");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;

currentEnvironment.clear;
// var ampOsc; and | ampOsc | are two ways to create a variable
(
{ | ampOsc |
	ampOsc = SinOsc.kr(0.5,1.5pi,0.5,0.5);
	SinOsc.ar([440, 442],0,ampOsc);
}.play;
)

(
{ var freq;
    freq = [[660, 880], [440, 660], 1320, 880].choose;
    SinOsc.ar(freq, 0, 0.2);
}.play;
)

{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;

// Mixing with addition operator
{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play;

// just use the arrow key so that when you hit ctrl- . it doesn't replace all the
// text
// combine two stereo arrays
(
{
    var a, b;
    a = [SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    b = [SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)

// Making our first synth
SynthDef.new("tutsyn", {|out| Out.ar(out, SinOsc.ar(440,0,0.25))}).play

(
SynthDef.new("tutorial-SinOsc-stereo", { |out|
    var outArray;
    outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
    Out.ar(out, outArray)
}).play;
)

x = { SinOsc.ar(660, 0, 0.2) }.play;
y = SynthDef.new("tutorial-SinOsc", { |out| Out.ar(out, SinOsc.ar(440, 0, 0.2)) }).play;
x.free;    // free just x
y.free;    // free just y

// execute first, by itself
SynthDef.new("tutorial-PinkNoise", { |out| Out.ar(out, PinkNoise.ar(0.3)) }).add;

// then:
x = Synth.new("tutorial-PinkNoise");
y = Synth.new("tutorial-PinkNoise");
x.free; y.free;

// With Rand, it works!
SynthDef("tutorial-Rand", { |out| Out.ar(out, SinOsc.ar(Rand(440, 660), 0, 0.2)) }).add;
x = Synth("tutorial-Rand");
y = Synth("tutorial-Rand");
z = Synth("tutorial-Rand");
x.free; y.free; z.free;


(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
s.scope; // scope so you can see the effect
x = Synth.new("tutorial-args");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;

(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)

// both write to bus 1, and their output is mixed
x = Synth("tutorial-args", ["out", 1, "freq", 660]);
y = Synth("tutorial-args", ["out", 1, "freq", 770]);
x.free
y.free

s.reboot; // this will restart the server and thus reset the bus allocators

b = Bus.control(s, 2);    // a 2 channel control Bus
b.index;         // this should be zero
b.numChannels         // Bus also has a numChannels method
c = Bus.control(s);
c.numChannels;        // the default number of channels is 1
c.index;        // note that this is 2; b uses 0 and 1

(
SynthDef("tutorial-Infreq", { arg bus, freqOffset = 0, out;
    // this will add freqOffset to whatever is read in from the bus
    Out.ar(out, SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5));
}).add;

SynthDef("tutorial-Outfreq", { arg freq = 400, bus;
    Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
}).add;

b = Bus.control(s,1);
)

(
x = Synth.new("tutorial-Outfreq", [\bus, b]);
y = Synth.after(x, "tutorial-Infreq", [\bus, b]);
z = Synth.after(x, "tutorial-Infreq", [\bus, b, \freqOffset, 200]);
)
x.free; y.free; z.free; b.free;

(
// the arg direct will control the proportion of direct to processed signal
SynthDef("tutorial-DecayPink", { arg outBus = 0, effectBus, direct = 0.5;
    var source;
    // Decaying pulses of PinkNoise. We'll add reverb later.
    source = Decay2.ar(Impulse.ar(1, 0.25), 0.01, 0.2, PinkNoise.ar);
    // this will be our main output
    Out.ar(outBus, source * direct);
    // this will be our effects output
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef("tutorial-DecaySin", { arg outBus = 0, effectBus, direct = 0.5;
    var source;
    // Decaying pulses of a modulating sine wave. We'll add reverb later.
    source = Decay2.ar(Impulse.ar(0.3, 0.25), 0.3, 1, SinOsc.ar(SinOsc.kr(0.2, 0, 110, 440)));
    // this will be our main output
    Out.ar(outBus, source * direct);
    // this will be our effects output
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef("tutorial-Reverb", { arg outBus = 0, inBus;
    var input;
    input = In.ar(inBus, 1);

    // a low-rent reverb
    // aNumber.do will evaluate its function argument a corresponding number of times
    // {}.dup(n) will evaluate the function n times, and return an Array of the results
    // The default for n is 2, so this makes a stereo reverb
    16.do({ input = AllpassC.ar(input, 0.04, { Rand(0.001,0.04) }.dup, 3)});

    Out.ar(outBus, input);
}).add;

b = Bus.audio(s,1); // this will be our effects bus
)

(
x = Synth.new("tutorial-Reverb", [\inBus, b]);
y = Synth.before(x, "tutorial-DecayPink", [\effectBus, b]);
z = Synth.before(x, "tutorial-DecaySin", [\effectBus, b, \outBus, 1]);
)

// Change the balance of wet to dry
y.set(\direct, 1); // only direct PinkNoise
z.set(\direct, 1); // only direct Sine wave
y.set(\direct, 0); // only reverberated PinkNoise
z.set(\direct, 0); // only reverberated Sine wave
x.free; y.free; z.free; b.free;

(
// make two control rate busses and set their values to 880 and 884.
b = Bus.control(s, 1); b.set(880);
c = Bus.control(s, 1); c.set(884);
// and make a synth with two frequency arguments
x = SynthDef("tutorial-map", { arg freq1 = 440, freq2 = 440, out;
    Out.ar(out, SinOsc.ar([freq1, freq2], 0, 0.1));
}).play(s);
)

// Now map freq1 and freq2 to read from the two busses
x.map(\freq1, b, \freq2, c);

// Now make a Synth to write to the one of the busses
y = {Out.kr(b, SinOsc.kr(1, 0, 50, 880))}.play(addAction: \addToHead);


// free y, and b holds its last value
y.free;

// use Bus-get to see what the value is. Watch the post window
b.get({ arg val; val.postln; f = val; });

// set the freq2, this 'unmaps' it from c
x.set(\freq2, f / 2);

// freq2 is no longer mapped, so setting c to a different value has no effect
c.set(200);

x.free; b.free; c.free;

//  Latency experiment
// make a Bus object and set its values
b = Bus.control(s, 1); b.set(880);

// execute this altogether
(
f = nil; // just to be sure
b.get({ arg val; f = val; });
f.postln;
)

// f equals nil, but try it again and it's as we expected!
f.postln;

x = Synth("default", [\freq, 300]);
// add a second synth immediately after x
y = Synth("default", [\freq, 450], x, \addAfter);
x.free; y.free;

(
// a stereo version
SynthDef(\tutorial_DecaySin2, { arg outBus = 0, effectBus, direct = 0.5, freq = 440;
    var source;
    // 1.0.rand2 returns a random number from -1 to 1, used here for a random pan
    source = Pan2.ar(Decay2.ar(Impulse.ar(Rand(0.3, 1), 0, 0.125), 0.3, 1,
        SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq))), Rand(-1.0, 1.0));
    Out.ar(outBus, source * direct);
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef(\tutorial_Reverb2, { arg outBus = 0, inBus;
    var input;
    input = In.ar(inBus, 2);
    16.do({ input = AllpassC.ar(input, 0.04, Rand(0.001,0.04), 3)});
    Out.ar(outBus, input);
}).add;
)

// now we create groups for effects and synths
(
~sources = Group.new;
~effects = Group.after(~sources);     // make sure it's after
~bus = Bus.audio(s, 2);         // this will be our stereo effects bus
)

// now synths in the groups. The default addAction is \addToHead
(
x = Synth(\tutorial_Reverb2, [\inBus, ~bus], ~effects);
y = Synth(\tutorial_DecaySin2, [\effectBus, ~bus, \outBus, 0], ~sources);
z = Synth(\tutorial_DecaySin2, [\effectBus, ~bus, \outBus, 0, \freq, 660], ~sources);
)

// we could add other source and effects synths here

~sources.free; ~effects.free; // this frees their contents (x, y, z) as well
~bus.free;

// remove references to ~sources and ~effects environment variables:
currentEnvironment.clear;

(
var midi, dur;
midi = Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 1).asStream;
dur = Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1).asStream;

SynthDef(\smooth, { |out, freq = 440, sustain = 1, amp = 0.5|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2)
}).add;

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

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)

SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: Done.freeSelf) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    // see below for more on .add

p = Pbind(
        // Use \harpsi, not \default
    \instrument, \harpsi,
    \degree, Pseries(0, 1, 8),
    \dur, 0.25
).play;

p.free

(
SynthDef(\trig_demo, { |out, freq = 440, gate = 1, t_trig = 1|    // t_trig here
    var    env = Decay2.kr(t_trig, 0.01, 0.1),
        sig = SinOsc.ar(freq, 0, env)
            * Linen.kr(gate, 0.01, 0.1, 0.1, doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2)
}).add;
)

(
p = Pmono(\trig_demo,
    \freq, Pexprand(200, 800, inf),
    \trig, 1,    // note that this is NOT t_trig -- just \trig
    \delta, 0.125
).play;
)

p.stop;

// Scale segments, in the sequence: up, up, down (repeat)
(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, 0.125
).play;
)

p.stop;


(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

p.stop;
// Library of named phrases, running in a random pattern
// Uses the bass SynthDef above
(
~phrases = (
    repeated: Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    octave: Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    tritone: Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    dim: Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
);

TempoClock.default.tempo = 128/60;

// the higher level control pattern is really simple now
p = Psym(Pxrand(#[repeated, octave, tritone, dim], inf), ~phrases).play;
)

p.stop;