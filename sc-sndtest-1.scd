{ [SinOsc.ar(440,0,0.25), SinOsc.ar(442,0,0.25)]}.play;

(
{             // Open the Function
    SinOsc.ar(    // Make an audio rate SinOsc
        440,     // frequency of 440 Hz, or the tuning A
        0,     // initial phase of 0, or the beginning of the cycle
        0.2)     // mul of 0.2
}.play;            // close the Function and call 'play' on it
)
(
{ var ampOsc;
    ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
    SinOsc.ar(440, 0, ampOsc);
}.play;
)

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

{ SinOsc.ar([440, 442], 0, 0.2) }.play;

{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play;

{ PinkNoise.ar(0.2) + SinOsc.ar(57.midicps, 0, 0.2) + Saw.ar(220, 0.2) }.play;

//s.boot;
(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
//s.scope; // scope so you can see the effect
x = Synth.new("tutorial-args");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;