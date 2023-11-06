class_name Objects

static func is_empty(object: Variant) -> bool:
	if null == object:
		return true
		
	match typeof(object):
		TYPE_NIL:
			return true
		TYPE_INT:
			var int_object := object as int
			return int_object == 0
		TYPE_ARRAY:
			var array_object := object as Array
			return array_object.size() == 0
		TYPE_STRING:
			var string_object := object as String
			if len(string_object) == 0: 
				return true
			else:
				return false
		_: 
			return false

static func is_not_empty(object: Variant) -> bool:
	return !is_empty(object)
