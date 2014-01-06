class Choice
	include MongoMapper::EmbeddedDocument
	embedded_in :questions
	key :choiceId, Integer
	key :choice, String
	validates_presence_of :choiceId
	validates_presence_of :choice
end