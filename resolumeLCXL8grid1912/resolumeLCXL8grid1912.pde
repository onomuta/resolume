//import java.util.Map;
import oscP5.*;
import netP5.*;
import themidibus.*; //Import the library

OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress DMXLocation;
MidiBus lcBus;
MidiBus lpBus;
//使用するレイヤーを指定します。（6レイヤー?）
int[] layers = new int[]{ 1, 2, 3, 4, 5, 6}; 
float[] layerOpacitys = new float[]{1.0, 1.0, 1.0, 1.0, 1.0, 1.0};

// DMX用の変数
float[] strobeColors = new float[]{1.0, 1.0, 1.0};
float strobeSpeed = 0.;

//HashMap<String,Integer> hm = new HashMap<String,Integer>();

//launchPadのモード
int lpMode = 0;
int[] lpColorize = new int[]{ 0, 0, 0, 0, 0, 0}; 

void setup() {
  //size(400, 400);
  frameRate(30);
  background(0);
  //noStroke();
  oscP5 = new OscP5(this, 12000);
  //OSC送信先のIPアドレスとポートを指定
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  //DMX用の送信ポートを指定
  DMXLocation = new NetAddress("127.0.0.1", 7700);

  MidiBus.list(); 
  lcBus = new MidiBus(this, "Launch Control XL", "Launch Control XL", "lcBus");
  lpBus = new MidiBus(this, "LPMiniMK3 MIDI Out", "LPMiniMK3 MIDI In", "lpBus");


  //launchpad //////////////////////////////////////////////

  lpLed(0);
}
int number = 0; //テスト用

void draw() {
  rect(0, frameCount%height, width, 2);
}

void noteOn(int channel, int pitch, int velocity, long timestamp, String bus_name) {
  // side btns
  // comp Effect
  if (bus_name== "lcBus") {
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
    }
    if (pitch == 92) { 
      strobe(1);
    }
  }

  //launchpad//////////////////////////////////////////////

  if (bus_name== "lpBus" && velocity==127) {
    if (lpMode == 0) {
      clipSelect((int) pitch/10, pitch%10);
      lpBus.sendNoteOn(0, pitch, 5);
      lpBus.sendNoteOn(2, pitch-1, 5);
      lpBus.sendNoteOn(2, pitch+1, 5);
      lpBus.sendNoteOn(2, pitch-10, 5);
      lpBus.sendNoteOn(2, pitch+10, 5);
    } else if (lpMode == 1) {
      if (pitch%10 <= 6) {
        if (lpColorize[(pitch%10)-1] == (int)pitch/10) {
          lpColorize[(pitch%10)-1] = 0;
          oscSend(1, "/composition/layers/"+(pitch%10)+"/video/effects/colorize/bypassed");
        } else {
          lpColorize[(pitch%10)-1] = (int)pitch/10;
          oscSend(0, "/composition/layers/"+(pitch%10)+"/video/effects/colorize/bypassed");
          oscSendInt((int)pitch/10-1, "/composition/layers/"+(pitch%10)+"/video/effects/colorize/effect/color/palette/colors");
        }
      }
      lpLed(lpMode);
    }
  }
}

void clipSelect(int layer, int cell) {
  oscSend(1, "/composition/layers/"+ layer +"/clips/"+((scrollStep *9)+1+ cell)+"/connect");
}

float scrollPosition = 0;
int scrollStep =0;
void mousePressed() {

  lpMode ++;
  lpMode = lpMode%2;
  lpLed(lpMode);
  //oscSend(1, "/composition/layers/"+1+"/clips/"+((scrollStep *9)+2)+"/connect");
}
void noteOff(int channel, int pitch, int velocity, long timestamp, String bus_name) {
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
  }
  if (pitch == 60) { 
    strobeWhite(0);
  }
  if (pitch == 92) { 
    strobe(0);
  }

  //launchpad//////////////////////////////////////////////////////
  if (bus_name== "lpBus") {
    if (lpMode == 0) {
      lpLed(lpMode);
    }
  }
}

void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
  if (bus_name== "lcBus"){
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
    }
    //Comp hue rotate ////////////////
    if (number == 20) { 
      compHueRotate(value);
    }
  
    //blank  ///////////////////
    //if        (number == 29) {
    //} else if (number == 30) {
    //} else if (number == 31) {
    //} else if (number == 32) {
    //} else if (number == 33) {
    //} else if (number == 34) {
    //} else if (number == 35) {
    //}
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


  //launchPad /////////////////////////////////////////////////////////////
  if (bus_name== "lpBus" && value==127) {
    if (lpMode == 0 || lpMode ==1){
      if (number == 19) {
        noteLedFill(3);
        oscSend(0, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 29) {
        noteLedFill(72);
        oscSend(0, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 39) {
        noteLedFill(96);
        oscSend(0.08, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 49) {
        noteLedFill(13);
        oscSend(0.168, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 59) {
        noteLedFill(25);
        oscSend(0.33, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 69) {
        noteLedFill(79);
        oscSend(0.6666, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 79) {
        noteLedFill(80);
        oscSend(0.75, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      } else if (number == 89) {
        noteLedFill(95);
        oscSend(0.88, "/composition/video/effects/solidcoloreffect2/effect/color/hue");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/effect/color/saturation");
        oscSend(0, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(0, "/composition/video/effects/invertrgb/bypassed");
        oscSend(0, "/composition/video/effects/colorize/bypassed");
      }
    }
    if (lpMode == 0) {
      if (number == 91) {
        oscSend(1, "/composition/selectedlayer/clear");
      } else if (number == 93) {
        scrollStep += 10;
      } else if (number == 94) {
        scrollStep ++;
      }
    }else if(lpMode == 1){
      if (number == 91) {
        lpColorize = new int[]{ 0, 0, 0, 0, 0, 0};
        for(int i= 1; i < 9;i++){
          oscSend(1, "/composition/layers/"+i+"/video/effects/colorize/bypassed");
        }
        lpLed(lpMode);
      }
    }
    
    if (number == 96) {
      lpModeChange(0);
    } else if (number == 97) {
      lpModeChange(1);
    } else if (number == 98) {
      lpModeChange(2);
    }
    scrollStep = scrollStep %11;
    scrollPosition = scrollStep * (9./117.);
    oscSend(scrollPosition, "application/ui/clipsscrollhorizontal");
    
  }else if(bus_name== "lpBus" && value==0){
    if (lpMode == 0|| lpMode == 1) {
      if (number%10 == 9) {
        lpLed(0);
        oscSend(1, "/composition/video/effects/colorize/bypassed");
        oscSend(1, "/composition/video/effects/solidcoloreffect2/bypassed");
        oscSend(1, "/composition/video/effects/invertrgb/bypassed");
      }
    }
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

// OSC送信(Resolume)
void oscSend2(String val, String pass) {
  OscMessage msg = new OscMessage(pass);
  msg.add(val); 
  oscP5.send(msg, myRemoteLocation);
}
void oscSendInt(int val, String pass) {
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
      lcBus.sendNoteOn(0, layerBtnNotes[i], 127);
    } else {
      lcBus.sendNoteOn(0, layerBtnNotes[i], 30);
    }
  }
}



void lpModeChange(int mode) {
  lpMode = mode;
  lpLed(mode);
}

void lpLed(int mode) {
  if (mode == 0) {
    for (int i = 11; i < 90; i++) {
      //lpBus.sendNoteOn(0, i, (frameCount +i)%127); 
      lpBus.sendNoteOn(0, i, 0); 

      if (i/10 < 5) {
        if (i%10 < 5) {
          lpBus.sendNoteOn(0, i, 2);
        } else if (i%10 < 9) {
          lpBus.sendNoteOn(0, i, 45);
        }
      } else {
        if (i%10 < 5) {
          lpBus.sendNoteOn(0, i, 45);
        } else if (i%10 < 9) {
          lpBus.sendNoteOn(0, i, 2);
        }
      }
    }
    lpBus.sendNoteOn(0, 91, 72); 
    lpBus.sendNoteOn(0, 92, 0); 
    lpBus.sendNoteOn(0, 93, 76); 
    lpBus.sendNoteOn(0, 94, 76); 
    lpBus.sendNoteOn(0, 95, 0);

    lpBus.sendNoteOn(2, 96, 57);
    lpBus.sendNoteOn(0, 97, 76);
    lpBus.sendNoteOn(0, 98, 76);

    lpBus.sendNoteOn(0, 19, 1);
    lpBus.sendNoteOn(0, 29, 72);
    lpBus.sendNoteOn(0, 39, 96);
    lpBus.sendNoteOn(0, 49, 13);
    lpBus.sendNoteOn(0, 59, 25);
    lpBus.sendNoteOn(0, 69, 79);
    lpBus.sendNoteOn(0, 79, 80);
    lpBus.sendNoteOn(0, 89, 95);
  } else if (mode == 1) {
    lpBus.sendNoteOn(0, 18, 0);
    lpBus.sendNoteOn(0, 28, 0);
    lpBus.sendNoteOn(0, 38, 0);
    lpBus.sendNoteOn(0, 48, 0);
    lpBus.sendNoteOn(0, 58, 0);
    lpBus.sendNoteOn(0, 68, 0);
    lpBus.sendNoteOn(0, 78, 0);
    lpBus.sendNoteOn(0, 88, 0);
    lpBus.sendNoteOn(0, 17, 0);
    lpBus.sendNoteOn(0, 27, 0);
    lpBus.sendNoteOn(0, 37, 0);
    lpBus.sendNoteOn(0, 47, 0);
    lpBus.sendNoteOn(0, 57, 0);
    lpBus.sendNoteOn(0, 67, 0);
    lpBus.sendNoteOn(0, 77, 0);
    lpBus.sendNoteOn(0, 87, 0);



    for (int i = 1; i <= 6; i++) {
      lpBus.sendNoteOn(0, 10 + i, 1);
      lpBus.sendNoteOn(0, 20 + i, 72);
      lpBus.sendNoteOn(0, 30 + i, 96);
      lpBus.sendNoteOn(0, 40 + i, 13);
      lpBus.sendNoteOn(0, 50 + i, 25);
      lpBus.sendNoteOn(0, 60 + i, 79);
      lpBus.sendNoteOn(0, 70 + i, 80);
      lpBus.sendNoteOn(0, 80 + i, 95);
    }
    lpBus.sendNoteOn(0, 91, 72); 
    lpBus.sendNoteOn(0, 92, 0); 
    lpBus.sendNoteOn(0, 93, 0); 
    lpBus.sendNoteOn(0, 94, 0); 
    lpBus.sendNoteOn(0, 95, 0);
    lpBus.sendNoteOn(0, 96, 76);
    lpBus.sendNoteOn(2, 97, 57);
    lpBus.sendNoteOn(0, 98, 76);
    for (int i = 0; i < 6; i++) {
      lpBus.sendNoteOn(2, lpColorize[i]*10 +i +1, 3);
    }
  } else if (mode == 2) {
    for (int i = 11; i < 90; i++) {
      lpBus.sendNoteOn(0, i, (int)random(4));
    }
    lpBus.sendNoteOn(0, 96, 76);
    lpBus.sendNoteOn(0, 97, 76);
    lpBus.sendNoteOn(2, 98, 57);
  }
}

void noteLedFill(int ledColor){
  for (int i = 11; i < 90; i++) {
    if(i%10 != 9){
      lpBus.sendNoteOn(0, i, ledColor);
    }
  }
}
