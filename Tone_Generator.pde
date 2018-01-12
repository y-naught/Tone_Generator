import themidibus.*;
import processing.sound.*;

PrintWriter output;

MidiBus bus;

float frequency = 10;
float offset = 1.0;
float volume = 0.25;
boolean onOff = false;

ArrayList<SinOsc> sineWaves;
int numSines = 2;

void setup(){
   size(500,500);
   background(0);
   
   output = createWriter("values.txt");
   
   bus = new MidiBus(this, "APC MINI", "APC MINI");
   
   sineWaves = new ArrayList<SinOsc>(numSines);
   
   for(int i = 0; i < numSines; i++){
    sineWaves.add(new SinOsc(this)); 
   }
   
   for(int i = 0; i < numSines; i++){
     float sineVolume = (1.0 / numSines) / (i + 1);
     SinOsc wave = sineWaves.get(i);
     //wave = new SinOsc(this);
     wave.play();
     wave.amp(sineVolume);
   }
}

void draw(){
  background(0);
  for(int i = 0; i < numSines; i++){
    float temp;
    SinOsc wave = sineWaves.get(i);
   if(onOff){
    wave.amp(volume);
   }else{
    wave.amp(0); 
   }
   temp = frequency * (i+1) + (i * offset);
   wave.freq(temp);
  }
  fill(255);
  textSize(32);
  text("Frequency: " + frequency, 80,100);
  text("Offset: " + offset, 80,200);
  text("volume: " + volume, 80, 300);
  text("Num Waves: " + numSines, 80, 375);
  text("Toggle: " + onOff, 80, 450);
}

void controllerChange(int channel, int number, int value){
   if(number == 48){
     frequency = map(value, 0 , 127, 5, 25); 
   }
   if(number == 49){
     offset = map(value, 0, 127, 0.5, 10);
   }
   if(number == 50){
     volume = map(value, 0, 127, 0, 1.0);
   }
}

void noteOn(Note note){
 if(note.pitch() == 56){
   if(onOff){
    onOff = false; 
   }else{
    onOff = true; 
   }
 }
 
 if(note.pitch() == 64){
   sineWaves.add(new SinOsc(this)); 
   numSines++;
   for(int i = 0; i < numSines; i++){
     SinOsc wave = sineWaves.get(i);
     wave.stop();
     wave.play();
    }
  }
 
  if(note.pitch() == 65){
   sineWaves.get(numSines-1).stop();
   sineWaves.remove(numSines-1); 
   numSines--;
   for(int i = 0; i < numSines; i++){
     SinOsc wave = sineWaves.get(i);
     wave.stop();
     wave.play();
   }
  }
}

void keyPressed(){
 if(key == ' '){
    output.println(frequency);
    output.println(offset);
    output.println(volume);
 }
 if(key == 'e'){
    output.flush();
    output.close();
    exit();
 }
}