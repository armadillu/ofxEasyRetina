#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	

	//If you want a landscape orientation
	ofSetOrientation(OF_ORIENTATION_90_LEFT);
	//ofSetOrientation(OF_ORIENTATION_DEFAULT);

	ofEnableAlphaBlending();
	ofBackground(32);

	retina.setNearestMagnification(); // just to make more obvious when using non-retina on a retina screen

	img.loadImage("eye.jpg");
}



//--------------------------------------------------------------
void testApp::draw(){

	//ofxEasyRetina disables OF's default ofSetupScreen()
	//we need to use ofxEasyRetina's custom one instead, as ortho or perspective

	retina.setupScreenOrtho();
	//retina.setupScreenPerspective();

	ofSetColor(255);
	img.draw( 0,0 );

	for(int i = 0; i < touches.size(); i++){
		ofSetColor(0, 64);
		ofCircle(touches[i], 20);
		ofSetColor(255);
		ofNoFill();
		ofSetColor(255,0,0);
		ofCircle(touches[i], 20);
		ofFill();
	}

	ofSetColor(255,0,0);
	ofDrawBitmapString( "retina: " + (string)(ofxiOSGetOFWindow()->isRetinaEnabled() ? "YES" : "NO"), 20,20);
	ofDrawBitmapString( "set device factor: " + ofToString(retina.getScaleFactor(),1), 20,40);
}


//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
	touches.push_back(ofVec2f(touch.x, touch.y));
}
