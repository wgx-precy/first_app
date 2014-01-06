class Assessment
  include MongoMapper::Document
  many :questions, dependent: :destroy
  key :title, String
  key :created_at, Time
  timestamps!
  validates_presence_of :title
end