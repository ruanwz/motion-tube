module MotionTube
  class Parser
    attr_accessor :rest_client, :gdata_client, :url, :response, :options
    def initialize(options = {})
      self.options = options
      set_clients
    end

    def parse(options, &block)
      self.options.merge! options
      if block
        get_response(&block)
      else
        raise "need a block to parse result"
      end
    end

    private

    def id
      url = options[:source][:url]
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
      response.scan(/title=([^&]+)/)[0][0].unescape_url
    end


    def media
      stream = (response.scan(/url_encoded_fmt_stream_map=([^&]+)/)[0][0]).unescape_url
      media = stream.scan(/url=([^&]+)/)
      sig = stream.scan(/sig=([^&]+)/)
      type = stream.scan(/type=([^&]+)/)
      vedio_list = {}
      media.zip(sig, type).each do |m|
        m_type = m[2][0].match(/(flv|mp4|webm|3gp)/)[0]
        u = (m[0][0]).unescape_url
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
      if options[:source][:url]
        get_video_info_from_id id, &result_callback
      elsif playlist = options[:source][:playlist]
        get_video_info_from_playlist playlist, &result_callback
      end
    end

    def set_clients
      url = "http://www.youtube.com"
      gdata_url = "http://gdata.youtube.com"
      self.rest_client = AFMotion::Client.build(url) do
        header "Accept", "application/json"
        response_serializer :json
      end

      self.gdata_client = AFMotion::Client.build(gdata_url) do
        header "Accept", "application/json"
        response_serializer :json
      end
    end

    def get_video_info_from_playlist(playlist, &result_callback)
      path = "/feeds/api/playlists/#{playlist}?v=2&alt=json&max-results=50"
      gdata_client.get(path) do |result|
        self.response = result.body

        hash = result.object
        entry = hash["feed"]["entry"]
        youtube_playlist_title = hash["feed"]["title"]["$t"]

        video_list = entry.map do |e|
          e_hash = {}
          e_hash["title"] = e["title"]["$t"]
          e_hash["href"] = e["link"][0]["href"]
          e_hash
        end

        result_hash = {}
        result_hash[youtube_playlist_title] = video_list
        result_callback.call result_hash
      end
    end

    def get_video_info_from_id(video_id, &result_callback)
      rest_client.post("get_video_info", video_id: video_id) do |result|
        self.response = result.body
        hash = {
          "id" => id,
          "title" => title,
          "cover" => cover,
          "media" => media
        }
        result_callback.call hash
      end
    end

  end
end
