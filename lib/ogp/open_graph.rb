require 'oga'
require 'ostruct'

REQUIRED_ATTRIBUTES = %w(title type image url)

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
        raise ArgumentError.new('`source` cannot be nil or empty.')
      end

      if !source.include?('</html>')
        raise MalformedSourceError
      end

      self.images = []
      self.audios = []
      self.locales = []
      self.videos = []

      document = Oga.parse_html(source)
      check_required_attributes(document)
      parse_attributes(document)
    end

    def image
      return if self.images.nil?
      return self.images.first
    end

    private

    def check_required_attributes(document)
      REQUIRED_ATTRIBUTES.each do |attribute_name|
        if !attribute_exists(document, attribute_name)
          raise MissingAttributeError.new("Missing required attribute: #{attribute_name}")
        end
      end
    end

    def parse_attributes(document)
      document.xpath('//head/meta[starts-with(@property, \'og:\')]').each do |attribute|
        attribute_name = attribute.get('property').downcase.gsub('og:', '')
        case attribute_name
        when /^image$/i
          self.images << OpenStruct.new(url: attribute.get('content').to_s)
        when /^image:(.+)/i
          self.images.last[$1.gsub('-','_')] = attribute.get('content').to_s
        when /^audio$/i
          self.audios << OpenStruct.new(url: attribute.get('content').to_s)
        when /^audio:(.+)/i
          self.audios.last[$1.gsub('-','_')] = attribute.get('content').to_s
        when /^locale/i
          self.locales << attribute.get('content').to_s
        when /^video$/i
          self.videos << OpenStruct.new(url: attribute.get('content').to_s)
        when /^video:(.+)/i
          self.videos.last[$1.gsub('-','_')] = attribute.get('content').to_s
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
