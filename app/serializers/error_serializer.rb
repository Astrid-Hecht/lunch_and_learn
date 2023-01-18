class ErrorSerializer
  include JSONAPI::Serializer

  set_id { nil }
  attributes :status, :msg
end
