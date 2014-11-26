class User
  include DataMapper::Resource

  property :id, Serial
  property :name, Text
  property :opcional, Text
  property :email, Text
  property :nickname, Text
  property :idF, String   #O el token
  property :idG, String
  property :idT, String
end

class Facebook
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :token, String

  belongs_to  :User
end

class Twitter
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :token, String

  belongs_to  :User
end

class Google
  include DataMapper::Resource
  property  :id, Serial
  property  :name, String
  property  :token, String

  belongs_to  :User
end

#En este modelo un Usuario tendria cuentas asociadas de facebook, twitter y google en una relacion 1:1
#Si se quisiera crear una relacion N:M deberia crearse una tabla intermedia y asociar la ID de usuario a las distintas ID de cuentas