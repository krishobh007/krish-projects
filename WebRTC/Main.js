
var localMediaStream;
var localstream;
var ROOM_ID="sajith123";
var remoteUser;
var isCaller=1;
var isCallerData = {"type":"flag","value":0};
var startFlag = 1;
var pc;
var isAudioMuted = false;
var isVideoMuted = false;

// Get media access.
var start = function() {
	startFlag = 0;
  	trace("Requesting local stream"+remoteUser);
  	console.log("Remote user"+remoteUser);
  	
  	// Call into getUserMedia via the polyfill (adapter.js).
 	getUserMedia({audio:true, video:true},
                gotStream, function() { console.log("failed local stream");});
}; 

// Attach media stream.
var gotStream = function(stream){
  	trace("Received local stream");
  	
 	// Call the polyfill wrapper to attach the media stream to this element.
  	attachMediaStream(vid1, stream);
  	localstream = stream;
  	localMediaStream =stream;
  	
  	var msg = {"from":USER_ID, "to":remoteUser, "message":JSON.stringify(isCallerData)};
	webSocket.send(JSON.stringify(msg));
	
	sendOffer();
	
};

// Sending offer to callee.
var sendOffer = function() {

  	trace("Starting call");
  	videoTracks = localstream.getVideoTracks();
  	audioTracks = localstream.getAudioTracks();
  	if (videoTracks.length > 0)
    		trace('Using Video device: ' + videoTracks[0].label);  
  	if (audioTracks.length > 0)
    		trace('Using Audio device: ' + audioTracks[0].label);
  	pc.onicecandidate = iceCallback; 
	pc.addStream(localstream);
	trace("Adding Local Stream to peer connection");
  	pc.createOffer(gotDescription1);
};

var gotDescription1 = function(desc){
	
  	pc.setLocalDescription(desc,function(){
  		console.log("success setlocaldescription");
  	},function(errorInformation){
  		console.log("failed setlocaldescription");
  		console.log(errorInformation);
  	});
  	
 	trace("send Offer from pc \n" + desc.sdp);
  	
 	var msg = {"from":USER_ID, "to":remoteUser, "message":JSON.stringify(desc)};
	webSocket.send(JSON.stringify(msg));
};

// Get answer from callee.
var getAnswer = function(answer){	
	
	var type=answer.type;
	var sdp=answer.sdp;
	var answer1= new RTCSessionDescription({type:type,sdp:sdp});
	
	trace("Receiving answer\n--------------------------------\n");
	console.log(answer1);
	console.log("\n---------------------------\n");
	
	pc.setRemoteDescription(answer1,function(){
  		console.log("success setremotedescription");
  	},function(errorInformation){
  		console.log("failed setremotedescription");
  		console.log(errorInformation);
  	});
};

// Adding IceCandidate. 
var call = function(event){
	pc.addIceCandidate(new RTCIceCandidate(event));
	trace("ICE candidate: \n " + event.candidate);
};

// Getting offer on callee page.
var getOffer = function(offer){
	
	var type=offer.type;
	var sdp=offer.sdp;
	var offer1= new RTCSessionDescription({type:type,sdp:sdp});
	
	pc.onicecandidate = iceCallback;
    pc.onaddstream = gotRemoteStream; 
	
	pc.setRemoteDescription(offer1);
	trace("Receiving offer from caller\n--------------------------------\n");
  	console.log(offer1);
  	console.log("\n---------------------------\n");
};

// Setting remote stream.
var gotRemoteStream = function(e){
  	vid2.src = webkitURL.createObjectURL(e.stream);
  	trace("Received remote stream");
};

// Sending answer to caller.
var sendAnswer = function() {
	
  	pc.createAnswer(gotDescription2);
};

var gotDescription2 = function(desc){
  	pc.setLocalDescription(desc);
  	
 	trace("send Answer from pc \n" + desc.sdp);
  	
 	var msg =  {"from":USER_ID, "to":remoteUser, "message":JSON.stringify(desc)};
	webSocket.send(JSON.stringify(msg));
};

// Sharing IceCandidate.
var iceCallback = function(event){
	if (event.candidate) {
		var msg =  {"from":USER_ID, "to":remoteUser,"message":JSON.stringify(event.candidate)};
		webSocket.send(JSON.stringify(msg));
	}
};

//Ending call.
var hangup = function() {
  	trace("Ending call");
  	pc.close(); 
};

//audio mute on local stream.

function toggleAudioMute() {
	
  // Call the getAudioTracks method via adapter.js.
  audioTracks = localstream.getAudioTracks();

  if (audioTracks.length === 0) {
    console.log("No local audio available.");
    return;
  }

  if(isAudioMuted) {
    for (i = 0; i < audioTracks.length; i++) {
      audioTracks[i].enabled = true;
    }
    console.log("Audio unmuted.");
  } else {
    for (i = 0; i < audioTracks.length; i++){
      audioTracks[i].enabled = false;
    }
    console.log("Audio muted.");
  }
  isAudioMuted = !isAudioMuted;  
}

//video mute on local stream.

function toggleVideoMute() {
	
  // Call the getVideoTracks method via adapter.js.
  videoTracks = localstream.getVideoTracks();

  if (videoTracks.length === 0) {
    console.log("No local video available.");
    return;
  }

  if (isVideoMuted) {
    for (i = 0; i < videoTracks.length; i++) {
      videoTracks[i].enabled = true;
    }
    console.log("Video unmuted.");
  } else {
    for (i = 0; i < videoTracks.length; i++) {
      videoTracks[i].enabled = false;
    }
    console.log("Video muted.");
  }
  isVideoMuted = !isVideoMuted;    
}