class User
  include DataMapper::Resource

  property :id, Serial
  property :name, Text
  property :mail, Text
  property :password, BCryptHash
  property :nickname, Text
end

class FacebookData
  include DataMapper::Resource
  property  :id, Serial
  property  :token, String, :length => 512

  belongs_to  :user
end

class TwitterData
  include DataMapper::Resource
  property  :id, Serial
  property  :access_token, String
  property  :access_token_secret, String

  belongs_to  :user
end

class GoogleData
  include DataMapper::Resource
  property  :id, Serial
  property  :token, String, :length => 128
  property  :id_token, String, :length => 1024
  property  :gid,String, :length => 512

  belongs_to  :user
end

class LinkedinData
  include DataMapper::Resource
  property  :id, Serial
  property  :rtoken, String
  property  :rsecret, String
  property  :atoken, String
  property  :asecret, String

  belongs_to  :user
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :nickname, String  #Se puede escoger otro campo para asociarlo
  property :text, String
  property :date, DateTime
  property :public, Boolean, :default  => true
  property :share, Integer #Numero de veces que un post ha sido compartido
  belongs_to :user
end

class LinkR
  include
  include DataMapper::Resource
  property :id, Serial
  property :link, String
  
  belongs_to :user
end


#En este modelo un Usuario tendria cuentas asociadas de facebook, twitter y google en una relacion 1:1
#Si se quisiera crear una relacion N:M deberia crearse una tabla intermedia y asociar la ID de usuario a las distintas ID de cuentas
