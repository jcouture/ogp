require 'oga'

REQUIRED_ATTRIBUTES = %w(title type image url)

module OGP
  class OpenGraph
    attr_accessor :title, :type, :image, :url

    def initialize(source)
      if source.nil? || source.empty?
        raise ArgumentError.new('`source` cannot be nil or empty.')
      end

      if !source.include?('</html>')
        raise MalformedSourceError
      end

      document = Oga.parse_html(source)
      check_required_attributes(document)
      parse_required_attributes(document)
    end

    private

    def check_required_attributes(document)
      REQUIRED_ATTRIBUTES.each do |attribute_name|
        if !attribute_exists(document, attribute_name)
          raise MissingAttributeError.new("Missing required attribute: #{attribute_name}")
        end
      end
    end

    def parse_required_attributes(document)
      REQUIRED_ATTRIBUTES.each do |attribute_name|
        instance_variable_set("@#{attribute_name}", parse_attribute(document, attribute_name))
      end
    end

    def parse_attribute(document, name)
      document.at_xpath("//head/meta[@property='og:#{name}']").get('content')
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
