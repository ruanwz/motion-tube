# motion-tube
[![Build
Status](https://travis-ci.org/ruanwz/motion-tube.svg)](https://travis-ci.org/ruanwz/motion-tube)
TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'motion-tube'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-tube

## Usage

To play a youtube video can be as simple as:

```
  (main)> parser = MotionTube::Parser.new
  "https://www.youtube.com/watch?v=_S1S1gGS3lU"
  => #<MotionTube::Parser:0x10ef5e8b0
  @url="https://www.youtube.com/watch?v=_S1S1gGS3lU"
  @rest_client=#<AFHTTPRequestOperationManager:0x10ef5fdd0>>
  (main)> parser.parse do |result|
  (main)>   puts result[:title]
  (main)>   BW::Media.play_modal result[:media]["mp4"].last
  (main)> end
  => #<AFHTTPRequestOperation:0x10ec3faa0>
  (main)> CoreDataQuery+(CDQ)+In+Action
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
