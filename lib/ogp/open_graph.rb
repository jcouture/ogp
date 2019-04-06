require 'oga'
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

      source.force_encoding('UTF-8') if source.encoding != 'UTF-8'

      self.images = []
      self.audios = []
      self.locales = []
      self.videos = []

      document = Oga.parse_html(source)
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
      document.xpath('//head/meta[starts-with(@property, \'og:\')]').each do |attribute|
        attribute_name = attribute.get('property').downcase.gsub('og:', '')
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
            instance_variable_set("@#{attribute_name}", attribute.get('content'))
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
