class ErrorSerializer
  include JSONAPI::Serializer
  attributes :error, :status
end
