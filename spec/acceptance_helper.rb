require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :api_blueprint
  config.request_body_formatter = :json
  config.api_name = "API Documentation"
end
