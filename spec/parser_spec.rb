module MotionTube
  describe Parser do
    @youtube_link = "https://www.youtube.com/watch?v=_S1S1gGS3lU"
    @youtube_playlist = "PL7QBhjs24ko_dq2Nm1NovIqIAr7kAuWJb"

    it "has a rest client of afmotion instance" do
      parser = Parser.new
      parser.rest_client.class.should.equal AFHTTPRequestOperationManager
    end

    it "get youtube info hash from video link" do
      parser = Parser.new
      parser.parse(source: {url: @youtube_link}) do |result|
        @result = result
        resume
      end
      wait_max 10 do
        @result.keys.should.equal %w[id title cover media]
        @result["title"].should.equal "CoreDataQuery+(CDQ)+In+Action"
        @result["cover"].should.equal "http://i.ytimg.com/vi/_S1S1gGS3lU/0.jpg"
        @result["media"].keys.should.equal ["mp4", "webm", "flv", "3gp"]
        @result["media"]["mp4"].size.should.equal 2
      end

    end

    it "get youtube playlist info hash from playlist" do
      parser = Parser.new
      parser.parse(source: {playlist: @youtube_playlist}) do |result|
        @result = result
        resume
      end
      wait_max 10 do
        @result.keys.should.equal ["Alphablocks Series 3"]
        @result["Alphablocks Series 3"].class.should.equal Array
        @result["Alphablocks Series 3"].first.keys.should.equal %w{ title href}
      end
    end
  end
end
