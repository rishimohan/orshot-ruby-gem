# Orshot Node.js API SDK

View on Rubygems: rubygems.org/gems/orshot

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'orshot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orshot

## Usage

If you don't have your API key, get one from [orshot.com](https://orshot.com/).

### Initialise a client

```ruby
require 'orshot'

client = Orshot::Client.new('os-ha2jdus1cbz1dpt4mktgjyvx')
```

### Generate image

```ruby
response = client.render_from_template({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From ruby sdk new'}, 'response_type' => 'base64', 'response_format' => 'png'})
puts response['data']
```

### Generate signed URL

```ruby
response = client.generate_signed_url({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From ruby sdk new'}, 'render_type' => 'images', 'response_format' => 'png', 'expires_at': 1744276943})
puts response['data']
```

## Example

### `Base64` response format

```ruby
require 'orshot'

client = Orshot::Client.new('os-ha2jdus1cbz1dpt4mktgjyvx')

response = client.render_from_template({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From ruby sdk new'}, 'response_type' => 'base64', 'response_format' => 'png'})
puts response['data']
```

Output

```
{"content"=>"data:image/png;base64,iVBORw0KGgoAA...", "format"=>"png", "type"=>"base64", "responseTime"=>3357.47}
```

### `Binary` response format

```ruby
require 'orshot'

client = Orshot::Client.new('os-ha2jdus1cbz1dpt4mktgjyvx')

File.open("og.png", "w") do |file|
  response = client.render_from_template({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From ruby sdk new'}, 'response_type' => 'binary', 'response_format' => 'png'})
  file.binmode
  file.write(response)
end
```

Data is written to the file `og.png`

### `URL` response format

```ruby
require 'orshot'

client = Orshot::Client.new('os-ha2jdus1cbz1dpt4mktgjyvx')

response = client.render_from_template({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From python sdk new'}, 'response_type' => 'url', 'response_format' => 'png'})
puts response['data']
```

Output

```
{"content"=>"https://storage.orshot.com/00632982-fd46-44ff-9a61-f52cdf1b8e62/images/nNSTZlMHFkr.png", "type"=>"url", "format"=>"png", "responseTime"=>3950.87}
```

### Signed URL

```ruby
require 'orshot'

client = Orshot::Client.new('os-ha2jdus1cbz1dpt4mktgjyvx')

response = client.generate_signed_url({'template_id' => 'open-graph-image-1', 'modifications' => {'title': 'From python sdk new'}, 'render_type' => 'images', 'response_format' => 'png', 'expires_at' => 1744276943})
puts response['data']
```

Output

```
{"url"=>"https://api.orshot.com/v1/generate/images?expiresAt=1744276943&id=37&templateId=open-graph-image-1&title=From%20python%20sdk%20new&signature=1225f4b65dd19ce6ac6f03c5fq6e42cfb7e254fac26492b35d58e2e2d65c7021"}
```

## renderFromTemplate

Use this function to render an image/pdf. Render template takes in 4 options passed as an object

| key | required | description |
|----------|----------|-------------|
| `template_id` | Yes | ID of the template (`open-graph-image-1`, `tweet-image-1`, `beautify-screenshot-1`, ...) |
| `modifications` | Yes | Modifications for the selected template. |
| `response_type` | No | `base64`, `binary`, `url` (Defaults to `base64`). |
| `response_format` | No | `png`, `webp`, `pdf`, `jpg`, `jpeg` (Defaults to `png`). |

For available templates and their modifications refer [Orshot Templates Page](https://orshot.com/templates)

## generateSignedUrl

Use this function to generate signed URL.

| key | required | description |
|----------|----------|-------------|
| `template_id` | Yes | ID of the template (`open-graph-image-1`, `tweet-image-1`, `beautify-screenshot-1`, ...) |
| `modifications` | Yes | Modifications for the selected template. |
| `expires_at` | Yes | Expires at in unix timestamp (Number). |
| `render_type` | No | `images`, `pdfs` (Defaults to `images`). |
| `response_format` | No | `png`, `webp`, `pdf`, `jpg`, `jpeg` (Defaults to `png`). |

## Development

Run `bundle install`

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in the Orshot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/orshot/blob/main/CODE_OF_CONDUCT.md).
