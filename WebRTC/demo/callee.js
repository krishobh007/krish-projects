var server=null; 
var pc2=new RTCPeerConnection(server); 
var i=1;

function getOffer(){
	
	var offer=JSON.parse(localStorage.getItem('offer'));
	var type=offer.type;
	var sdp=offer.sdp;
	var offer1= new RTCSessionDescription({type:type,sdp:sdp});
	
	pc2.onicecandidate = iceCallback2;
        pc2.onaddstream = gotRemoteStream; 
	
	pc2.setRemoteDescription(offer1);
	trace("Receiving offer from caller\n--------------------------------\n");
  	console.log(offer1);
  	console.log("\n---------------------------\n");
	
}

function SendAnswer() {

  	pc2.createAnswer(gotDescription2);
  
}  

function gotRemoteStream(e){
  	vid2.src = webkitURL.createObjectURL(e.stream);
  	trace("Received remote stream");
  
}

function AttendCall(){

	for(var x=1;x<=4;x++){
		var event_caller=JSON.parse(localStorage.getItem('event_caller'+x));
		pc2.addIceCandidate(new RTCIceCandidate(event_caller));
   		trace("Local ICE candidate: \n" + event_caller.candidate);
	}
}

function gotDescription2(desc2){
  	pc2.setLocalDescription(desc2);
  	localStorage.setItem('answer', JSON.stringify(desc2));
  	console.log("sending answer from callee \n-----------------\n");
  	console.log(desc2);
  	console.log("\n------------------------------\n"); 
}

function iceCallback2(event){
  	if (event.candidate) {
  		console.log("callback-2"+i);
    		localStorage.setItem('event_callee'+i,JSON.stringify(event.candidate));
		i++;
  	}
}


