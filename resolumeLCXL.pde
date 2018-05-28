import oscP5.*;
import netP5.*;
import themidibus.*; //Import the library

OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress DMXLocation;
MidiBus myBus;
//使用するレイヤーを指定します。（7レイヤー?）
int[] layers = new int[]{ 8, 9, 10, 11, 12, 13, 14}; 
float[] layerOpacitys = new float[]{1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};

// DMX用の変数
float[] strobeColors = new float[]{1.0, 1.0, 1.0};
float strobeSpeed = 0.;

void setup() {
  //size(400, 400);
  frameRate(30);
  background(0);
  oscP5 = new OscP5(this, 12000);
  //OSC送信先のIPアドレスとポートを指定
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  //DMX用の送信ポートを指定
  DMXLocation = new NetAddress("127.0.0.1", 7700);

  MidiBus.list(); 
  myBus = new MidiBus(this, "Launch Control XL", "Launch Control XL");
  //myBus = new MidiBus(this, 0, -1);
}
int number = 0; //テスト用

void draw() {
  // //MIDI点灯テスト
  // int channel = 0;
  // int pitch = 41;
  // int velocity = 127;
  // int value = 127;
  // number = (number +1)%127;
  // text(number, 10, 30); 
  // myBus.sendNoteOn(channel, number, velocity);
  // myBus.sendControllerChange(channel, number, value);
  // delay(100);
  // myBus.sendNoteOff(channel, number, velocity);
  // myBus.sendControllerChange(channel, number, 0);
  // delay(100);
  rect(0, frameCount%height, width, 2);
  if (mousePressed == true) {
    strobeInit();
    //oscSendForDMX(1, "/r");
    //oscSendForDMX(1., "/g");
    //oscSendForDMX(1., "/b");
  }
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  // side btns
  // comp Effect
  if        (pitch == 108) { 
    oscSend(0, "/composition/video/effects/strobe/bypassed");
  } else if (pitch == 107) { 
    oscSend(0, "/composition/video/effects/blow/bypassed");
  } else if (pitch == 106) { 
    oscSend(0, "/composition/video/effects/twitcheffect/bypassed");
  } else if (pitch == 105) { 
    oscSend(0, "/composition/video/effects/strobe2/bypassed");
  } 
  //  oscSend(0, "/composition/video/effects/slide/bypassed");
  //  oscSend(0, "/composition/video/effects/slide2/bypassed");
  //  oscSend(0, "/composition/video/effects/videowall/bypassed");
  //  oscSend(0, "/composition/video/effects/mirrorquad/bypassed");


  // bottom btns A /////////////////////////
  // layer Opacity Piano /////////////////// 
  if           (pitch == 41) { 
    layerOpacityPiano(layers[0], 1, 0);
  } else if (pitch == 42) { 
    layerOpacityPiano(layers[1], 1, 1);
  } else if (pitch == 43) { 
    layerOpacityPiano(layers[2], 1, 2);
  } else if (pitch == 44) { 
    layerOpacityPiano(layers[3], 1, 3);
  } else if (pitch == 57) { 
    layerOpacityPiano(layers[4], 1, 4);
  } else if (pitch == 58) { 
    layerOpacityPiano(layers[5], 1, 5);
  } else if (pitch == 59) { 
    layerOpacityPiano(layers[6], 1, 6);
  }

  if (pitch == 60) { 
    strobeWhite(1);
  };

  //bottom btns B
  //layerSelect  ///////////////////  
  if        (pitch == 73) { 
    layerSelect(layers[0]);
  } else if (pitch == 74) { 
    layerSelect(layers[1]);
  } else if (pitch == 75) { 
    layerSelect(layers[2]);
  } else if (pitch == 76) { 
    layerSelect(layers[3]);
  } else if (pitch == 89) { 
    layerSelect(layers[4]);
  } else if (pitch == 90) { 
    layerSelect(layers[5]);
  } else if (pitch == 91) { 
    layerSelect(layers[6]);
  }
  if (pitch == 92) { 
    strobe(1);
  }
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
  if        (pitch == 108) { 
    oscSend(1, "/composition/video/effects/strobe/bypassed");
  } else if (pitch == 107) { 
    oscSend(1, "/composition/video/effects/blow/bypassed");
  } else if (pitch == 106) { 
    oscSend(1, "/composition/video/effects/twitcheffect/bypassed");
  } else if (pitch == 105) { 
    oscSend(1, "/composition/video/effects/strobe2/bypassed");
  }


  // bottom btns A /////////////////////////
  // layer Opacity Piano /////////////////// 
  if           (pitch == 41) { 
    layerOpacityPiano(layers[0], 0, 0);
  } else if (pitch == 42) { 
    layerOpacityPiano(layers[1], 0, 1);
  } else if (pitch == 43) { 
    layerOpacityPiano(layers[2], 0, 2);
  } else if (pitch == 44) { 
    layerOpacityPiano(layers[3], 0, 3);
  } else if (pitch == 57) { 
    layerOpacityPiano(layers[4], 0, 4);
  } else if (pitch == 58) { 
    layerOpacityPiano(layers[5], 0, 5);
  } else if (pitch == 59) { 
    layerOpacityPiano(layers[6], 0, 6);
  } 
  if (pitch == 60) { 
    strobeWhite(0);
  }
  if (pitch == 92) { 
    strobe(0);
  }
}

void controllerChange(int channel, int number, int value) {
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);

  //layerColorize  ///////////////////
  if        (number == 13) { 
    layerColorize(layers[0], value);
  } else if (number == 14) { 
    layerColorize(layers[1], value);
  } else if (number == 15) { 
    layerColorize(layers[2], value);
  } else if (number == 16) { 
    layerColorize(layers[3], value);
  } else if (number == 17) { 
    layerColorize(layers[4], value);
  } else if (number == 18) { 
    layerColorize(layers[5], value);
  } else if (number == 19) { 
    layerColorize(layers[6], value);
  }
  //Comp hue rotate ////////////////
  if (number == 20) { 
    compHueRotate(value);
  }

  //blank  ///////////////////
  if        (number == 29) {
  } else if (number == 30) {
  } else if (number == 31) {
  } else if (number == 32) {
  } else if (number == 33) {
  } else if (number == 34) {
  } else if (number == 35) {
  }
  if        (number == 36) {
    if ( value < 0.3) {
      strobeColors[0] = 1.;
      strobeColors[1] = 0;
      strobeColors[2] = 0;
    } else if ( value < 0.6) {
      strobeColors[0] = 0.;
      strobeColors[1] = 1;
      strobeColors[2] = 0;
    } else if ( value < 1) {
      strobeColors[0] = 0.;
      strobeColors[1] = 0;
      strobeColors[2] = 1;
    }

    // strobeColors[1] = value/127.;
    strobeColors[2] = value/127.;
  }

  //layerEffect  ///////////////////
  if        (number == 49) {
    layerEffectCtrl(layers[0], value);
  } else if (number == 50) {
    layerEffectCtrl(layers[1], value);
  } else if (number == 51) {
    layerEffectCtrl(layers[2], value);
  } else if (number == 52) {
    layerEffectCtrl(layers[3], value);
  } else if (number == 53) {
    layerEffectCtrl(layers[4], value);
  } else if (number == 54) {
    layerEffectCtrl(layers[5], value);
  } else if (number == 55) {
    layerEffectCtrl(layers[6], value);
  }
  if        (number == 56) {
    strobeSpeed = value/127;
  }

  // Sliders ////////////////////////
  // Layer opacity //////////////////
  if           (number == 77) { 
    layerOpacity(layers[0], value, 0);
  } else if (number == 78) { 
    layerOpacity(layers[1], value, 1);
  } else if (number == 79) { 
    layerOpacity(layers[2], value, 2);
  } else if (number == 80) { 
    layerOpacity(layers[3], value, 3);
  } else if (number == 81) { 
    layerOpacity(layers[4], value, 4);
  } else if (number == 82) { 
    layerOpacity(layers[5], value, 5);
  } else if (number == 83) { 
    layerOpacity(layers[6], value, 6);
  }
  if (number == 84) { 
    oscSend(value/127., "/composition/master");
  }

  //NEWS btn
  if        (number == 104) {
  } else if (number == 105) {
  } else if (number == 106) {
    //scroll Left
    oscSend(0., "/application/ui/clipsscrollhorizontal");
  } else if (number == 107) {
    //scroll Right
    oscSend(1., "/application/ui/clipsscrollhorizontal");
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
// OSC送信(Resolume)
void oscSend(float val, String pass) {
  OscMessage msg = new OscMessage(pass);
  msg.add(val); 
  oscP5.send(msg, myRemoteLocation);
}
// OSC送信(QLC+)
void oscSendForDMX(float val, String pass) {
  OscMessage msg = new OscMessage(pass);
  msg.add(val); 
  oscP5.send(msg, DMXLocation);
}

//レイヤー透明度
void layerOpacity(int layer, int value, int layerNum) {
  float valf = value / 127.;
  oscSend(valf, "/composition/layers/" + layer +"/video/opacity");
  //println();
  layerOpacitys[layerNum] = valf;
}
void layerOpacityPiano(int layer, int value, int layerNum) {
  if (value == 1.) {
    oscSend(1.0, "/composition/layers/" + layer +"/video/opacity");
  } else {
    oscSend(layerOpacitys[layerNum], "/composition/layers/" + layer +"/video/opacity");
  }
}

void layerSelect(int layer) {
  oscSend(1, "/composition/layers/" + layer + "/select");
}

void layerColorize(int layer, int value) {
  float valf = value / 127.;
  if (valf > 0.07) {
    oscSend(valf, "/composition/layers/" + layer +"/video/effects/colorize/effect/color/palette/colors");
    oscSend(0, "/composition/layers/" + layer +"/video/effects/colorize/bypassed");
  } else {
    oscSend(1, "/composition/layers/" + layer +"/video/effects/colorize/bypassed");
  }
}
//レイヤーエフェクトのバイパス設定
void layerEffectCtrl(int layer, int value) {
  int[] d = new int[]{ 0, 0, 0, 0, 0 };
  float valf = value / 127.;
  if        (valf < 0.125) { 
    d = new int[]{ 1, 1, 1, 1, 1 };
  } else if (valf < 0.250) { 
    d = new int[]{ 1, 0, 1, 1, 1 };
  } else if (valf < 0.325) { 
    d = new int[]{ 0, 1, 1, 1, 1 };
  } else if (valf < 0.500) { 
    d = new int[]{ 1, 1, 1, 1, 0 };
  } else if (valf < 0.625) { 
    d = new int[]{ 0, 1, 1, 0, 0 };
  } else if (valf < 0.875) { 
    d = new int[]{ 1, 0, 0, 1, 0 };
  } else { 
    d = new int[]{ 1, 1, 0, 0, 0 };
  }
  layerEffect(layer, d);
}
void layerEffect(int layer, int vals[]) {
  oscSend(vals[0], "/composition/layers/" + layer +"/video/effects/tileeffect/bypassed");
  oscSend(vals[1], "/composition/layers/" + layer +"/video/effects/tileeffect2/bypassed");
  oscSend(vals[2], "/composition/layers/" + layer +"/video/effects/videowall/bypassed");
  oscSend(vals[3], "/composition/layers/" + layer +"/video/effects/videowall2/bypassed");
  oscSend(vals[4], "/composition/layers/" + layer +"/video/effects/mirrorquad/bypassed");
}

void compHueRotate(int value) {
  float valf = value / 127.;
  oscSend(valf, "/composition/video/effects/huerotate/effect/huerotate");
}

// for QLC+ /////////////////////////////////////////////////////////////////////
//QLC+ ストロボ操作
void strobeWhite(int value) {
  oscSendForDMX(value, "/r");
  oscSendForDMX(value, "/g");
  oscSendForDMX(value, "/b");
}
void strobe(int value) {
  oscSendForDMX(strobeColors[0]*value, "/r");
  oscSendForDMX(strobeColors[1]*value, "/g");
  oscSendForDMX(strobeColors[2]*value, "/b");
}
// strobe初期化 数値は要検討
void strobeInit() {
  oscSendForDMX(0., "/r");
  oscSendForDMX(0., "/g");
  oscSendForDMX(0., "/b");
  oscSendForDMX(0.999, "/c1");
  oscSendForDMX(0.999, "/c2");
  oscSendForDMX(0.999, "/c3");
  oscSendForDMX(0.999, "/c4");
}


//int[] layerLeds = new int[]{ 0, 0, 0, 0, 0, 0, 0}; 
int[] layerBtnNotes = new int[]{ 41, 42, 43, 44, 57, 58, 59}; 
void btnLedUpdata() {
  for (int i = 0; i < layers.length; i++) {
    // LEDの色を確認
    if (layerOpacitys[i] > 0) {
      myBus.sendNoteOn(0, layerBtnNotes[i], 127);
    } else {
      myBus.sendNoteOn(0, layerBtnNotes[i], 30);
    }
  }
}
