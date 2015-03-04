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
  parser = MotionTube::Parser.new
  parser.parse(source: {url: "https://www.youtube.com/watch?v=_S1S1gGS3lU"} ) do |result|
    puts result[:title]
    BW::Media.play_modal result[:media]["mp4"].last
  end
```

To get back a playlist

```
  parser = MotionTube::Parser.new
  parser.parse(source: {playlist: "PL7QBhjs24ko_dq2Nm1NovIqIAr7kAuWJb"}) do |result|
    puts result
  end
  => {"Alphablocks Series 3"=>[{"title"=>"Alphablocks Series 3 - Ants", "href"=>"http://www.youtube.com/watch?v=pzr4uMCUMX0&feature=youtube_gdata"}]}
    ...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
