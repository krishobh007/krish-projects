
Backbone.sync = function(method, model, options) {
	console.log("sync");
	if (method == "read") {
		console.log("method is read");
		if (model.id) {
			var model = getmodel(model.id);
			if (model) {
				options.success(model, 200, null);
			} else {
				options.error("not found");
			}
		}
		else {
			console.log("no id");
			var collection = getCollection();
			if (collection) {
				options.success(collection, 200, null);
			} else {
				options.error("unknown");
			}
		}
	} /*else if (method == "create") {	
		console.log("method is create");
		options.success(createPersonInServer(model.toJSON()), 200, null);
	} else if (method == "update") {
		console.log("method is update");
		var person = updatePersonInServer(model.toJSON());
		if (person) {
			options.success(person, 200, null);
		} else {
			options.error("not found");
		}
	}*/
};

//mock server calls
function getCollection() {
	var sampledata = [{id: 1, dealName: "Stay"}, 
 						{id: 2, dealName: "Dine"}, 
						{id: 3, dealName: "Shop"}];
	window.localStorage.setItem("sample", JSON.stringify(sampledata));
	
	var data = window.localStorage.getItem("sample");
	return JSON.parse(data);
}

function getmodel(id) {
	/*// call server, return person
	return _.find(peopleServer, function(storedPerson) { 
			return storedPerson.id == id; 
		}
	);*/
}

/*function createPersonInServer(person) {
	// call server, save new person
	var getNextId = function() { return ++sequence; };	//get next id [sequence]
	person.id = getNextId();
	peopleServer.push(person);
	return person;
}

function updatePersonInServer(person) {
	// call server, save edited person
	var changedPerson = _.find(peopleServer, function(storedPerson) { 
			return storedPerson.id == person.id; 
		});
	if (changedPerson) {
		var idx = _.indexOf(peopleServer, changedPerson);
		peopleServer[idx] = person;
		return person;
	}
	return changedPerson;
}
*/