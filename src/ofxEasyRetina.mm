

#include "ofxEasyRetina.h"


ofxEasyRetina::ofxEasyRetina(){
	ofDisableSetupScreen();
	scaleFactor = ofxiPhoneGetOFWindow()->isRetinaEnabled() ? 2 : 1;
}

void ofxEasyRetina::setDeviceScaleFactor(float factor_){
	scaleFactor = factor_;
}

float ofxEasyRetina::getScaleFactor(){
	return  scaleFactor;
}

void ofxEasyRetina::setNearestMagnification(){
	//make retina devices upscale with nearest (not default linear), just to clearly see the difference
	EAGLView * view = ofxiPhoneGetGLView();
	view.layer.magnificationFilter = kCAFilterNearest;
}


void ofxEasyRetina::setLinearMagnification(){
	//make retina devices upscale with nearest (not default linear), just to clearly see the difference
	EAGLView * view = ofxiPhoneGetGLView();
	view.layer.magnificationFilter = kCAFilterLinear;
}

void ofxEasyRetina::loadMatrix (const ofMatrix4x4 & m){
	loadMatrix( m.getPtr() );
}

//----------------------------------------------------------
void ofxEasyRetina::loadMatrix (const float *m){
	glLoadMatrixf(m);
}


//----------------------------------------------------------
void ofxEasyRetina::setupScreenPerspective(float width, float height, ofOrientation orientation, bool vFlip, float fov, float nearDist, float farDist) {
	if(width == 0) width = ofGetWidth();
	if(height == 0) height = ofGetHeight();

	float viewW = ofGetViewportWidth() / scaleFactor; // uri added scale (retina)
	float viewH = ofGetViewportHeight() / scaleFactor;

	float eyeX = viewW / 2;
	float eyeY = viewH / 2;
	float halfFov = PI * fov / 360;
	float theTan = tanf(halfFov);
	float dist = eyeY / theTan;
	float aspect = (float) viewW / viewH;

	if(nearDist == 0) nearDist = dist / 10.0f;
	if(farDist == 0) farDist = dist * 10.0f;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
		
	ofMatrix4x4 persp;
	persp.makePerspectiveMatrix(fov, aspect, nearDist, farDist);
	loadMatrix( persp );
	//gluPerspective(fov, aspect, nearDist, farDist);


	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	ofMatrix4x4 lookAt;
	lookAt.makeLookAtViewMatrix( ofVec3f(eyeX, eyeY, dist),  ofVec3f(eyeX, eyeY, 0),  ofVec3f(0, 1, 0) );
	loadMatrix( lookAt );
	//gluLookAt(eyeX, eyeY, dist, eyeX, eyeY, 0, 0, 1, 0);

	//note - theo checked this on iPhone and Desktop for both vFlip = false and true
	if(ofDoesHWOrientation()){
		if(vFlip){
			glScalef(1, -1, 1);
			glTranslatef(0, -height, 0);
		}
	}else{
		if( orientation == OF_ORIENTATION_UNKNOWN ) orientation = ofGetOrientation();
		switch(orientation) {
			case OF_ORIENTATION_180:
				glRotatef(-180, 0, 0, 1);
				if(vFlip){
					glScalef(1, -1, 1);
					glTranslatef(-width, 0, 0);
				}else{
					glTranslatef(-width, -height, 0);
				}

				break;

			case OF_ORIENTATION_90_RIGHT:
				glRotatef(-90, 0, 0, 1);
				if(vFlip){
					glScalef(-1, 1, 1);
				}else{
					glScalef(-1, -1, 1);
					glTranslatef(0, -height, 0);
				}
				break;

			case OF_ORIENTATION_90_LEFT:
				glRotatef(90, 0, 0, 1);
				if(vFlip){
					glScalef(-1, 1, 1);
					glTranslatef(-width, -height, 0);
				}else{
					glScalef(-1, -1, 1);
					glTranslatef(-width, 0, 0);
				}
				break;

			case OF_ORIENTATION_DEFAULT:
			default:
				if(vFlip){
					glScalef(1, -1, 1);
					glTranslatef(0, -height, 0);
				}
				break;
		}
	}

}

//----------------------------------------------------------
void ofxEasyRetina::setupScreenOrtho(float width, float height, ofOrientation orientation, bool vFlip, float nearDist, float farDist) {
	if(width == 0) width = ofGetWidth();
	if(height == 0) height = ofGetHeight();
	 
	float viewW = ofGetViewportWidth() / scaleFactor; // uri added scale (retina)
	float viewH = ofGetViewportHeight() / scaleFactor;
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	ofSetCoordHandedness(OF_RIGHT_HANDED);
#ifndef TARGET_OPENGLES
	if(vFlip) {
		ofSetCoordHandedness(OF_LEFT_HANDED);
	}

	if(nearDist == -1) nearDist = 0;
	if(farDist == -1) farDist = 10000;
	
	glOrtho(0, viewW, 0, viewH, nearDist, farDist);

#else
	if(vFlip) {
		ofMatrix4x4 ortho = ofMatrix4x4::newOrthoMatrix(0, width, height, 0, nearDist, farDist);
		ofSetCoordHandedness(OF_LEFT_HANDED);
	}
	
	ofMatrix4x4 ortho = ofMatrix4x4::newOrthoMatrix(0, viewW, 0, viewH, nearDist, farDist);
	glMultMatrixf(ortho.getPtr());	
#endif

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	//note - theo checked this on iPhone and Desktop for both vFlip = false and true
	if(ofDoesHWOrientation()){
		if(vFlip){
			glScalef(1, -1, 1);
			glTranslatef(0, -height, 0);
		}
	}else{
		if( orientation == OF_ORIENTATION_UNKNOWN ) orientation = ofGetOrientation();
		switch(orientation) {
			case OF_ORIENTATION_180:
				glRotatef(-180, 0, 0, 1);
				if(vFlip){
					glScalef(1, -1, 1);
					glTranslatef(-width, 0, 0);
				}else{
					glTranslatef(-width, -height, 0);
				}

				break;

			case OF_ORIENTATION_90_RIGHT:
				glRotatef(-90, 0, 0, 1);
				if(vFlip){
					glScalef(-1, 1, 1);
				}else{
					glScalef(-1, -1, 1);
					glTranslatef(0, -height, 0);
				}
				break;

			case OF_ORIENTATION_90_LEFT:
				glRotatef(90, 0, 0, 1);
				if(vFlip){
					glScalef(-1, 1, 1);
					glTranslatef(-width, -height, 0);
				}else{
					glScalef(-1, -1, 1);
					glTranslatef(-width, 0, 0);
				}
				break;

			case OF_ORIENTATION_DEFAULT:
			default:
				if(vFlip){
					glScalef(1, -1, 1);
					glTranslatef(0, -height, 0);
				}
				break;
		}
	}

}