class User
  include DataMapper::Resource

  property :id, Serial
  property :name, Text
  property :opcional, Text
  property :mail, Text
  property :password, BCryptHash
  property :nickname, Text
  property :idF, String   #O el token
  property :idG, String
  property :idT, String

end

class FacebookData
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :token, String

  belongs_to  :User
end

class TwitterData
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :access_token, String
  property  :access_token_secret, String

  belongs_to  :User
end

class GoogleData
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :token, String

  belongs_to  :User
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :nickname, String  #Se puede escoger otro campo para asociarlo
  property :text, String
  property :date, DateTime
  property :public, Boolean, :default  => true

  belongs_to :User
end


#En este modelo un Usuario tendria cuentas asociadas de facebook, twitter y google en una relacion 1:1
#Si se quisiera crear una relacion N:M deberia crearse una tabla intermedia y asociar la ID de usuario a las distintas ID de cuentas
