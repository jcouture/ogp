require 'oga'
require 'ostruct'

module OGP
  class OpenGraph
    # Accessor for storing all open graph data
    attr_accessor :data

    # Required Accessors
    attr_accessor :title, :type, :url
    attr_accessor :images

    # Optional Accessors
    attr_accessor :description, :determiner, :site_name
    attr_accessor :audios
    attr_accessor :locales
    attr_accessor :videos

    def initialize(source)
      if source.nil? || source.empty?
        raise ArgumentError, '`source` cannot be nil or empty.'
      end

      raise MalformedSourceError unless source.include?('</html>')

      source.force_encoding('UTF-8') if source.encoding != 'UTF-8'

      self.data = {}
      self.images = []
      self.audios = []
      self.locales = []
      self.videos = []

      document = Oga.parse_html(source)
      parse_attributes(document)
    end

    def image
      return if images.nil?
      images.first
    end

  private

    # rubocop:disable Metrics/CyclomaticComplexity
    def parse_attributes(document)
      document.xpath('//head/meta[starts-with(@property, \'og:\')]').each do |attribute|
        attribute_name = attribute.get('property').downcase.gsub('og:', '')

        if data.has_key?(attribute_name)
          # There can be multiple entries for the same og tag, see
          # https://open.spotify.com/album/3NkIlQR6wZwPCQiP1vPjF8 for an example
          # where there are multiple `restrictions:country:allowed` og tags.
          #
          # In this case store the content values as an array.
          if !data[attribute_name].kind_of?(Array)
            data[attribute_name] = [ data[attribute_name] ]
          end
          data[attribute_name] << attribute.get('content')
        else
          data[attribute_name] = attribute.get('content')
        end

        case attribute_name
          when /^image$/i
            images << OpenStruct.new(url: attribute.get('content').to_s)
          when /^image:(.+)/i
            images << OpenStruct.new unless images.last
            images.last[Regexp.last_match[1].gsub('-', '_')] = attribute.get('content').to_s
          when /^audio$/i
            audios << OpenStruct.new(url: attribute.get('content').to_s)
          when /^audio:(.+)/i
            audios << OpenStruct.new unless audios.last
            audios.last[Regexp.last_match[1].gsub('-', '_')] = attribute.get('content').to_s
          when /^locale/i
            locales << attribute.get('content').to_s
          when /^video$/i
            videos << OpenStruct.new(url: attribute.get('content').to_s)
          when /^video:(.+)/i
            videos << OpenStruct.new unless videos.last
            videos.last[Regexp.last_match[1].gsub('-', '_')] = attribute.get('content').to_s
          else
            begin
              instance_variable_set("@#{attribute_name}", attribute.get('content'))
            rescue NameError
              warn("Some og tag names include colons `:`, such as Spotify song
              pages (`restrictions:country:allowed`), which will result in a
              NameError. Please rely on data[attribute_name] instead. Setting
              top-level instance variables is deprecated and will be removed in
              the next major version.")
            end
        end
      end
    end

    def attribute_exists(document, name)
      document.at_xpath("boolean(//head/meta[@property='og:#{name}'])")
    end
  end

  class MissingAttributeError < StandardError
  end

  class MalformedSourceError < StandardError
  end
end
