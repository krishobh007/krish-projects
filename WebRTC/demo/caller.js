var server=null; 
var pc1=new RTCPeerConnection(server);
var j=1;
var localMediaStream;
var localstream;

function gotStream(stream){
  	trace("Received local stream");
  
 	// Call the polyfill wrapper to attach the media stream to this element.
  	attachMediaStream(vid1, stream);
  	localstream = stream;
  	localMediaStream =stream;
  	btn2.disabled = false;
}

function start() {
  	trace("Requesting local stream");
  	btn1.disabled = true;
  
  	// Call into getUserMedia via the polyfill (adapter.js).
 	getUserMedia({audio:true, video:true},
                gotStream, function() { console.log("failed local stream");});
}  

function sendOffer() {
  	btn2.disabled = true;
  	trace("Starting call");
  	videoTracks = localstream.getVideoTracks();
  	audioTracks = localstream.getAudioTracks();
  	if (videoTracks.length > 0)
    		trace('Using Video device: ' + videoTracks[0].label);  
  	if (audioTracks.length > 0)
    		trace('Using Audio device: ' + audioTracks[0].label);
 	
  	pc1.onicecandidate = iceCallback1; 
	pc1.addStream(localstream);
	trace("Adding Local Stream to peer connection");
  	pc1.createOffer(gotDescription1);
   
}

function getAnswer(){	
	
	var answer=JSON.parse(localStorage.getItem('answer'));
	var type=answer.type;
	var sdp=answer.sdp;
	var answer1= new RTCSessionDescription({type:type,sdp:sdp});
	trace("Receiving answer\n--------------------------------\n");
	console.log(answer1);
	console.log("\n---------------------------\n");
	pc1.setRemoteDescription(answer1);
	
}

function call(){

	for(var x=1;x<=2;x++){

		var event_callee=JSON.parse(localStorage.getItem('event_callee'+x));
		pc1.addIceCandidate(new RTCIceCandidate(event_callee));
		trace("Remote ICE candidate: \n " + event_callee.candidate);

	}
}

function gotDescription1(desc1){
  	pc1.setLocalDescription(desc1);
 	trace("Offer from pc1 \n" + desc1.sdp);
  	console.log("sending offer from caller \n-----------------\n");
  	console.log(desc1);
 	console.log("\n------------------------------\n");
  	localStorage.setItem( 'offer', JSON.stringify(desc1));
}

function iceCallback1(event){
	if (event.candidate) {
		console.log("callback1"+j);
		localStorage.setItem('event_caller'+j,JSON.stringify(event.candidate));
		j++;
	}
}


