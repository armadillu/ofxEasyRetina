#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

//include both these files!
#include "ofxEasyRetina.h"
#include "ofxiOSEAGLView+retinaPatch.h"

class testApp : public ofxiOSApp{
	
    public:
        void setup();
		void update(){};
        void draw();
	
        void touchDown(ofTouchEventArgs & touch);

		ofImage img;

		//declare an ofxEasyRetina instance
		ofxEasyRetina retina;

		vector<ofVec2f> touches;

};


