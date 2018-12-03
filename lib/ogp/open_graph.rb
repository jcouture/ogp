require 'nokogiri'
require 'ostruct'

REQUIRED_ATTRIBUTES = %w(title type image url).freeze

module OGP
  class OpenGraph
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

      self.images = []
      self.audios = []
      self.locales = []
      self.videos = []

      document = Nokogiri::HTML.parse(source)
      document.encoding = 'utf-8'
      check_required_attributes(document)
      parse_attributes(document)
    end

    def image
      return if images.nil?
      images.first
    end

  private

    def check_required_attributes(document)
      REQUIRED_ATTRIBUTES.each do |attribute_name|
        raise MissingAttributeError, "Missing required attribute: #{attribute_name}" unless attribute_exists(document, attribute_name)
      end
    end

    def parse_attributes(document)
      document.xpath('//head/meta[starts-with(@property, \'og:\')]').each do |node|
        attribute_name = node.attribute('property').to_s.downcase.gsub('og:', '').tr('-', '_')
        content = node.attribute('content').to_s
        case attribute_name
          when /^image$/i
            images << OpenStruct.new(url: content)
          when /^image:(.+)/i
            images.last[Regexp.last_match[1]] = content
          when /^audio$/i
            audios << OpenStruct.new(url: content)
          when /^audio:(.+)/i
            audios.last[Regexp.last_match[1]] = content
          when /^locale/i
            locales << content
          when /^video$/i
            videos << OpenStruct.new(url: content)
          when /^video:(.+)/i
            videos.last[Regexp.last_match[1]] = content
          else
            instance_variable_set("@#{attribute_name}", content)
        end
      end
    end

    def attribute_exists(document, name)
      document.xpath("boolean(//head/meta[@property='og:#{name}'])")
    end
  end

  class MissingAttributeError < StandardError
  end

  class MalformedSourceError < StandardError
  end
end
