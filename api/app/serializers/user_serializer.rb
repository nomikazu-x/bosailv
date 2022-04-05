class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image, :confirmed_at, :updated_at
end
