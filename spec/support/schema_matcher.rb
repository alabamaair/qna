RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_directory = "#{Dir.pwd}/spec/support/api/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true, list: false)
  end
end

RSpec::Matchers.define :match_response_array_schema do |schema|
  match do |response|
    schema_directory = "#{Dir.pwd}/spec/support/api/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true, list: true)
  end
end
