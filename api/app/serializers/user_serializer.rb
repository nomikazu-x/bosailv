class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image, :username, :profile, :address, :confirmed_at, :updated_at
end
