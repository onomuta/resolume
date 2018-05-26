import oscP5.*;
import netP5.*;
import themidibus.*; //Import the library

OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus;

void setup() {
  //size(400, 400);
  frameRate(60);
  background(0);
  oscP5 = new OscP5(this, 12000);
  //OSC送信先のIPアドレスとポートを指定
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);

  MidiBus.list(); 
  //myBus = new MidiBus(this, "Launch Control XL", "Launch Control XL");
  myBus = new MidiBus(this, 0, -1);
}
int number = 0;

 int[] layers = new int[]{ 9, 10, 11, 12, 13, 14,15 };
 
void draw() {

  int channel = 0;
  int pitch = 41;
  int velocity = 127;

  number = (number +1)%127;
  int value = 127;

  myBus.sendNoteOn(channel, number, velocity); // Send a Midi noteOn
  myBus.sendControllerChange(channel, number, value);
  delay(100);
  myBus.sendNoteOff(channel, number, velocity); // Send a Midi nodeOff



  myBus.sendControllerChange(channel, number, 0); // Send a controllerChange
  delay(100);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);


  // comp Effect
  if (pitch == 108) {
    oscSend(0, "/composition/video/effects/strobe2/bypassed");
  } else if (pitch == 107) {
    oscSend(0, "/composition/video/effects/blow/bypassed");
  } else if (pitch == 106) {
    oscSend(0, "/composition/video/effects/twitcheffect/bypassed");
  } else if (pitch == 105) {
    oscSend(0, "/composition/video/effects/strobe/bypassed");
  } 
  //if (pitch == 1) {
  //  oscSend(0, "/composition/video/effects/slide/bypassed");
  //} else if (pitch == 1) {
  //  oscSend(0, "/composition/video/effects/slide2/bypassed");
  //} else if (pitch == 1) {
  //  oscSend(0, "/composition/video/effects/videowall/bypassed");
  //} else if (pitch == 1) {
  //  oscSend(0, "/composition/video/effects/mirrorquad/bypassed");
  //}

  //btn
  
  if (pitch == 41) {
  } else if (pitch == 42) {
  }
  //41,42,43,44,57,58,59,60
  //73,74,75,76,89,90,91,92
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  // comp Effect
  if (pitch == 108) {
    oscSend(1, "/composition/video/effects/strobe2/bypassed");
  } else if (pitch == 107) {
    oscSend(1, "/composition/video/effects/blow/bypassed");
  } else if (pitch == 106) {
    oscSend(1, "/composition/video/effects/twitcheffect/bypassed");
  } else if (pitch == 105) {
    oscSend(1, "/composition/video/effects/strobe/bypassed");
  }
}

void controllerChange(int channel, int number, int value) {
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);

  //layerEffect  ///////////////////
  if (number == 49) {
    layerEffectCtrl(8, value);
  } else if (number == 50) {
    layerEffectCtrl(9, value);
  } else if (number == 51) {
    layerEffectCtrl(10, value);
  } else if (number == 52) {
    layerEffectCtrl(11, value);
  } else if (number == 53) {
    layerEffectCtrl(12, value);
  } else if (number == 54) {
    layerEffectCtrl(13, value);
  } else if (number == 55) {
    layerEffectCtrl(14, value);
  }

  //29-36

  //colorize  ///////////////////
  if (number == 13) {
    colorize(value, 8);
  } else if (number == 14) {
    colorize(value, 9);
  } else if (number == 15) {
    colorize(value, 10);
  } else if (number == 16) {
    colorize(value, 11);
  } else if (number == 17) {
    colorize(value, 12);
  } else if (number == 18) {
    colorize(value, 13);
  } else if (number == 19) {
    colorize(value, 14);
  }
//comp hue rotate
if (number == 20) {
     oscSend(value/127., "/composition/video/effects/huerotate/effect/huerotate");
}


  //Comp hue rotate ////////////////
  if (number == 20) {
    compHueRotate(value);
  }


  //layer opacity //////////////////
  if (number == 77) {
    layerOpacity(8, value);
  } else if (number == 78) {
    layerOpacity(9, value);
  } else if (number == 79) {
    layerOpacity(10, value);
  } else if (number == 80) {
    layerOpacity(11, value);
  } else if (number == 81) {
    layerOpacity(12, value);
  } else if (number == 82) {
    layerOpacity(13, value);
  } else if (number == 83) {
    layerOpacity(14, value);
  } else if (number == 84) {
    oscSend(value/127., "/composition/master");
  }
  


  //btn
  //104,105
  //106,107
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void oscSend(float val, String pass) {
  OscMessage msg = new OscMessage(pass);
  msg.add(val); 
  oscP5.send(msg, myRemoteLocation);
}

//レイヤーエフェクトのバイパス設定
void layerEffectCtrl(int layer, int value) {
  int[] d = new int[]{ 0, 0, 0, 0, 0 };
  float valf = value / 127.;
  if (valf < 0.125) {
    d = new int[]{ 1, 1, 1, 1, 1 };
  } else if (valf < 0.25) {
    d = new int[]{ 1, 0, 1, 1, 1 };
  } else if (valf < 0.325) {     
    d = new int[]{ 0, 1, 1, 1, 1 };
  } else if (valf < 0.5) {     
    d = new int[]{ 1, 1, 1, 1, 0};
  } else if (valf < 0.625) {     
    d = new int[]{ 0, 1, 1, 0, 0};
  } else if (valf < 0.875) {     
    d = new int[]{ 1, 0, 0, 1, 0};
  } else {     
    d = new int[]{ 1, 1, 0, 0, 0};
  }

  layerEffect(d, layer);
}

void layerOpacity(int layer, int value) {
  float valf = value / 127.;
  oscSend(valf, "/composition/layers/" + layer +"/video/opacity");
}

void colorize(int value, int layer) {
  float valf = value / 127.;
  if (valf > 0.07) {
    oscSend(valf, "/composition/layers/" + layer +"/video/effects/colorize/effect/color/palette/colors");
    oscSend(0, "/composition/layers/" + layer +"/video/effects/colorize/bypassed");
  } else {
    oscSend(1, "/composition/layers/" + layer +"/video/effects/colorize/bypassed");
  }
}

void compHueRotate(int value) {
  float valf = value / 127.;
  oscSend(valf, "/composition/video/effects/huerotate/effect/huerotate");
}

void layerEffect(int vals[], int layer) {
  oscSend(vals[0], "/composition/layers/" + layer +"/video/effects/tileeffect/bypassed");
  oscSend(vals[1], "/composition/layers/" + layer +"/video/effects/tileeffect2/bypassed");
  oscSend(vals[2], "/composition/layers/" + layer +"/video/effects/videowall/bypassed");
  oscSend(vals[3], "/composition/layers/" + layer +"/video/effects/videowall2/bypassed");
  oscSend(vals[4], "/composition/layers/" + layer +"/video/effects/mirrorquad/bypassed");
}
