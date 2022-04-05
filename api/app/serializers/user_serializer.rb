class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :nickname, :image, :confirmed_at, :updated_at
end
