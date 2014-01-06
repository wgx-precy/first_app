class Question
	include MongoMapper::EmbeddedDocument
	embedded_in :assessment
	many :choices, dependent: :destroy
	key :questionId, Integer
	key :questionBody, String
	key :answer, Integer
	validates_presence_of :questionId
	validates_presence_of :questionBody
	validates_presence_of :answer
end