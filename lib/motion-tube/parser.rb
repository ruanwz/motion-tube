module MotionTube
  class Parser
    attr_accessor :rest_client, :url, :response
    def initialize(url)
      @url = url
      @rest_client = AFMotion::Client.build("http://www.youtube.com") do
        header "Accept", "application/json"
        response_serializer :json
      end
    end

    def parse(&block)
      if block
        get_response(&block)
      else
        raise "need a block to parse result"
      end
    end

    private

    def id
      if url =~ /(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/
        url.scan(/(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/)[0][0]
      elsif url =~ /\/embed\//
        url.scan(/embed\/([^.|&]+)/)[0][0]
      else
        url
      end
    end

    def cover
      response.scan(/thumbnail_url=([^&]+)/)[0][0].unescape_url.gsub("default.jpg","")+"0.jpg"
    end

    def title
      @response.scan(/title=([^&]+)/)[0][0].unescape_url
    end


    def media
      stream = (response.scan(/url_encoded_fmt_stream_map=([^&]+)/)[0][0]).unescape_url
      media = stream.scan(/url=([^&]+)/)
      sig = stream.scan(/sig=([^&]+)/)
      type = stream.scan(/type=([^&]+)/)
      vedio_list = {}
      media.zip(sig, type).each do |m|
        m_type = m[2][0].match(/(flv|mp4|webm|3gp)/)[0]
        u = (m[0][0])
        if m[1]
          u += "&signature=" + m[1][0]
        end
        if vedio_list[m_type].nil?
          vedio_list[m_type] = []
          vedio_list[m_type] << u
        else
          vedio_list[m_type] << u
        end
      end
      return vedio_list
    end

    def get_response(&result_callback)

      rest_client.post("get_video_info", video_id: id) do |result|
        @response = result.body
        hash = {
          id: id,
          title: title,
          cover: cover,
          media: media
        }
        result_callback.call hash
      end
    end
  end
end
