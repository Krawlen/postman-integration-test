require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :postman
  config.request_body_formatter = :json
  config.keep_source_order = true
  config.api_name = "API Documentation"
#  config.request_headers_to_include = %w[Content-Type Host]
#  config.response_headers_to_include = %w[Content-Type Host]
end
