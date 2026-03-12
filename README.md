# Orshot Ruby API SDK

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

client = Orshot::Client.new('YOUR_ORSHOT_API_KEY')
```

## render_from_studio_template

Render from a custom [Studio template](https://orshot.com/features/orshot-studio). Supports image, PDF, video generation and publishing to social accounts.

### Generate Image

```ruby
response = client.render_from_studio_template({
  'template_id' => 1234,
  'modifications' => {
    'title' => 'Orshot Studio',
    'description' => 'Generate images from custom templates',
  },
  'response' => { 'type' => 'url', 'format' => 'png', 'scale' => 2 },
})
```

### Generate PDF

```ruby
response = client.render_from_studio_template({
  'template_id' => 1234,
  'modifications' => { 'title' => 'Invoice #1234' },
  'response' => { 'type' => 'url', 'format' => 'pdf' },
  'pdf_options' => {
    'margin' => '20px',
    'range_from' => 1,
    'range_to' => 2,
    'color_mode' => 'rgb',
    'dpi' => 300,
  },
})
```

### Generate Video

```ruby
response = client.render_from_studio_template({
  'template_id' => 1234,
  'modifications' => {
    'videoElement' => 'https://example.com/custom-video.mp4',
    'videoElement.trimStart' => 0,
    'videoElement.trimEnd' => 10,
  },
  'response' => { 'type' => 'url', 'format' => 'mp4' },
  'video_options' => { 'trim_start' => 0, 'trim_end' => 20, 'muted' => false, 'loop' => true },
})
```

### Publish to Social Accounts

```ruby
response = client.render_from_studio_template({
  'template_id' => 1234,
  'modifications' => { 'title' => 'Check out our latest update!' },
  'response' => { 'type' => 'url', 'format' => 'png' },
  'publish' => {
    'accounts' => [1, 2],
    'content' => 'Check out our latest design!',
  },
})
# response['publish'] => [{'platform' => 'twitter', 'username' => 'acmehq', 'status' => 'published'}, ...]
```

### Schedule a Post

```ruby
response = client.render_from_studio_template({
  'template_id' => 1234,
  'modifications' => { 'title' => 'Scheduled post' },
  'response' => { 'type' => 'url', 'format' => 'png' },
  'publish' => {
    'accounts' => [1],
    'content' => 'This will be posted later!',
    'schedule' => { 'scheduled_for' => '2026-04-01T10:00:00Z' },
    'timezone' => 'America/New_York',
  },
})
```

### Parameters

| key                              | required | description                                                                    |
| -------------------------------- | -------- | ------------------------------------------------------------------------------ |
| `template_id`                    | Yes      | ID of the Studio template (integer).                                           |
| `modifications`                  | No       | Hash of dynamic modifications for the template.                                |
| `response.type`                  | No       | `base64`, `binary`, `url` (Defaults to `url`).                                 |
| `response.format`                | No       | `png`, `webp`, `jpg`, `jpeg`, `pdf`, `mp4`, `webm`, `gif` (Defaults to `png`). |
| `response.scale`                 | No       | Scale of the output (`1` = original, `2` = double). Defaults to `1`.           |
| `response.include_pages`         | No       | Page numbers to render for multi-page templates (e.g. `[1, 3]`).               |
| `response.file_name`             | No       | Custom file name (without extension). Works with `url` and `binary` types.     |
| `pdf_options`                    | No       | `{ margin, range_from, range_to, color_mode, dpi }`                            |
| `video_options`                  | No       | `{ trim_start, trim_end, muted, loop }`                                        |
| `publish.accounts`               | No       | Array of social account IDs from your workspace.                               |
| `publish.content`                | No       | Caption/text for the social post.                                              |
| `publish.is_draft`               | No       | `true` to save as draft instead of publishing.                                 |
| `publish.schedule.scheduled_for` | No       | ISO date string to schedule the post.                                          |
| `publish.timezone`               | No       | Timezone string (e.g. `"America/New_York"`).                                   |
| `publish.platform_options`       | No       | Per-account options keyed by account ID.                                       |

---

## render_from_template

Render from a pre-built Orshot template.

```ruby
response = client.render_from_template({
  'template_id' => 'open-graph-image-1',
  'modifications' => { 'title' => 'Hello World' },
  'response_type' => 'url',
  'response_format' => 'png',
})
```

| key               | required | description                                                      |
| ----------------- | -------- | ---------------------------------------------------------------- |
| `template_id`     | Yes      | ID of the template (`open-graph-image-1`, `tweet-image-1`, etc.) |
| `modifications`   | Yes      | Modifications for the selected template.                         |
| `response_type`   | No       | `base64`, `binary`, `url` (Defaults to `url`).                   |
| `response_format` | No       | `png`, `webp`, `pdf`, `jpg`, `jpeg` (Defaults to `png`).         |

For available templates and their modifications refer [Orshot Templates Page](https://orshot.com/templates)

## generate_signed_url

Generate a signed URL for a template.

```ruby
response = client.generate_signed_url({
  'template_id' => 'open-graph-image-1',
  'modifications' => { 'title' => 'Hello World' },
  'expires_at' => 1744276943,
  'render_type' => 'images',
  'response_format' => 'png',
})
```

| key               | required | description                                              |
| ----------------- | -------- | -------------------------------------------------------- |
| `template_id`     | Yes      | ID of the template.                                      |
| `modifications`   | Yes      | Modifications for the selected template.                 |
| `expires_at`      | Yes      | Expires at in unix timestamp (Number).                   |
| `render_type`     | No       | `images`, `pdfs` (Defaults to `images`).                 |
| `response_format` | No       | `png`, `webp`, `pdf`, `jpg`, `jpeg` (Defaults to `png`). |

## Development

Run `bundle install`

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in the Orshot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/orshot/blob/main/CODE_OF_CONDUCT.md).
