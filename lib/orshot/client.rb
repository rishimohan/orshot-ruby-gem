# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'
require 'httparty'
require_relative './constants'

module Orshot
  # Client for interacting with the Orshot API
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    def render_from_template(render_options)
      endpoint_url = "#{base_url}/generate/images/#{render_options['template_id']}"

      response = HTTParty.post(endpoint_url.to_s,
                               body: prepare_render_data(render_options).to_json,
                               headers: {
                                 'Authorization' => "Bearer #{@api_key}",
                                 'Content-Type' => 'application/json'
                               })

      if response.code == 200
        if %w[base64 url].include?(render_options['response_format'])
          JSON.parse(response.body)
        else
          response
        end
      else
        response_body = JSON.parse(response.body)
        raise Error, response_body['error']
      end
    end

    def generate_signed_url(signed_url_options)
      endpoint_url = "#{base_url}/signed-url/create"

      response = HTTParty.post(endpoint_url.to_s,
                               body: prepare_signed_url_data(signed_url_options).to_json,
                               headers: {
                                 'Authorization' => "Bearer #{@api_key}",
                                 'Content-Type' => 'application/json'
                               })

      if response.code == 200
        JSON.parse(response.body)
      else
        response_body = JSON.parse(response.body)
        raise Error, response_body['error']
      end
    end

    private

    def base_url
      "#{ORSHOT_API_BASE_URL}/#{ORSHOT_API_VERSION}"
    end

    def prepare_render_data(options)
      response_type = options['response_type'] || DEFAULT_RESPONSE_TYPE
      response_format = options['response_format'] || DEFAULT_RESPONSE_FORMAT

      {
        'response' => {
          'type' => response_type,
          'format' => response_format
        },
        'modifications' => options['modifications'],
        'source' => ORSHOT_SOURCE
      }
    end

    def prepare_signed_url_data(options)
      {
        'templateId' => options['template_id'],
        'renderType' => options['render_type'] || DEFAULT_RENDER_TYPE,
        'responseFormat' => options['response_format'] || DEFAULT_RESPONSE_FORMAT,
        'modifications' => options['modifications'],
        'expiresAt' => options['expires_at'],
        'source' => ORSHOT_SOURCE
      }
    end
  end
end
