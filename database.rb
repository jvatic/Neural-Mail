require 'dm-core'

DataMapper.setup(:default,
  :adapter => 'mongo',
  :database => 'neural_mail'
)

class Message
  include DataMapper::Mongo::Resource

  property :id          , ObjectId
  property :received_at , Time
  property :sender      , String
  property :from        , Array, :default => []
  property :to          , Array, :default => []
  property :cc          , Array, :default => []
  property :subject     , String
  property :date        , Time
  property :body        , String
  property :html        , String
  property :attachments , Array, :default => []

  def find_attachment(digest)
    attachments.select { |a| a['digest'] == digest }.first
  end

end
