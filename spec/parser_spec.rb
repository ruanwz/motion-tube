module MotionTube
  describe Parser do
    @youtube_link = "https://www.youtube.com/watch?v=_S1S1gGS3lU"
    @parser = Parser.new @youtube_link

    it "has a rest client of afmotion instance" do
      @parser.rest_client.class.should.equal AFHTTPRequestOperationManager
    end

    it "get youtube info hash from video link" do
      @parser.parse do |result|
        @result = result
        resume
      end
      wait_max 10 do
        @result.keys.should.equal [:id, :title, :cover, :media]
        @result[:title].should.equal "CoreDataQuery+(CDQ)+In+Action"
        @result[:cover].should.equal "http://i.ytimg.com/vi/_S1S1gGS3lU/0.jpg"
        @result[:media].keys.should.equal ["mp4", "webm", "flv", "3gp"]
        @result[:media]["mp4"].size.should.equal 2
      end

    end
  end
end
