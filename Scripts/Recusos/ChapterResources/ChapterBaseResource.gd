extends Resource
class_name ChapterBaseResource

func Save(_slot: int) -> bool:
	push_warning("Save() não implementado em: " + str(get_class()))
	return false

func Load(_slot: int) -> bool:
	push_warning("Load() não implementado em: " + str(get_class()))
	return false
