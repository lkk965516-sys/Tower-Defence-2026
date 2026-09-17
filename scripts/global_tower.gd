extends Node
const target_priority_dictionary_forward = {
	"first":"last",
	"last":"closest",
	"closest":"farthest",
	"farthest":"strongest",
	"strongest":"weakest",
	"weakest":"first"
}

const target_priority_dictionary_backward = {
	"last":"first",
	"closest":"last",
	"farthest":"closest",
	"strongest":"farthest",
	"weakest":"strongest",
	"first":"weakest"
}
