class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :image, :username, :profile, :address, :confirmed_at, :updated_at
end
