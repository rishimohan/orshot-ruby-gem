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

    def render_from_studio_template(options)
      endpoint_url = "#{base_url}/studio/render"

      response = HTTParty.post(endpoint_url.to_s,
                               body: prepare_studio_render_data(options).to_json,
                               headers: {
                                 'Authorization' => "Bearer #{@api_key}",
                                 'Content-Type' => 'application/json'
                               })

      if response.code == 200
        response_opts = options['response'] || {}
        response_type = response_opts['type'] || DEFAULT_RESPONSE_TYPE

        if %w[base64 url].include?(response_type)
          JSON.parse(response.body)
        else
          response
        end
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

    def prepare_studio_render_data(options)
      response_opts = options['response'] || {}
      response_type = response_opts['type'] || DEFAULT_RESPONSE_TYPE
      response_format = response_opts['format'] || DEFAULT_RESPONSE_FORMAT

      data = {
        'templateId' => options['template_id'],
        'source' => ORSHOT_SOURCE,
        'response' => {
          'type' => response_type,
          'format' => response_format
        }
      }

      data['modifications'] = options['modifications'] if options['modifications']

      data['response']['scale'] = response_opts['scale'] if response_opts.key?('scale')
      data['response']['includePages'] = response_opts['include_pages'] if response_opts['include_pages']
      data['response']['fileName'] = response_opts['file_name'] if response_opts['file_name']

      if options['pdf_options']
        pdf = options['pdf_options']
        data['pdfOptions'] = {}
        data['pdfOptions']['margin'] = pdf['margin'] if pdf.key?('margin')
        data['pdfOptions']['rangeFrom'] = pdf['range_from'] if pdf.key?('range_from')
        data['pdfOptions']['rangeTo'] = pdf['range_to'] if pdf.key?('range_to')
        data['pdfOptions']['colorMode'] = pdf['color_mode'] if pdf.key?('color_mode')
        data['pdfOptions']['dpi'] = pdf['dpi'] if pdf.key?('dpi')
      end

      if options['video_options']
        vid = options['video_options']
        data['videoOptions'] = {}
        data['videoOptions']['trimStart'] = vid['trim_start'] if vid.key?('trim_start')
        data['videoOptions']['trimEnd'] = vid['trim_end'] if vid.key?('trim_end')
        data['videoOptions']['muted'] = vid['muted'] if vid.key?('muted')
        data['videoOptions']['loop'] = vid['loop'] if vid.key?('loop')
      end

      if options['publish']
        pub = options['publish']
        data['publish'] = { 'accounts' => pub['accounts'] }
        data['publish']['content'] = pub['content'] if pub.key?('content')
        data['publish']['isDraft'] = pub['is_draft'] if pub.key?('is_draft')
        data['publish']['timezone'] = pub['timezone'] if pub.key?('timezone')
        data['publish']['platformOptions'] = pub['platform_options'] if pub.key?('platform_options')
        if pub['schedule']
          data['publish']['schedule'] = {}
          data['publish']['schedule']['scheduledFor'] = pub['schedule']['scheduled_for'] if pub['schedule']['scheduled_for']
        end
      end

      data
    end
  end
end
