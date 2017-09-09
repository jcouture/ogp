require 'oga'

REQUIRED_ATTRIBUTES = %w(title type image url)

module OGP
  class OpenGraph
    attr_accessor :title, :type, :image, :url

    def initialize(source)
      document = Oga.parse_html(source)
      parse_required_attributes(document)
    end

    private

    def parse_required_attributes(document)
      REQUIRED_ATTRIBUTES.each do |attribute_name|
        instance_variable_set("@#{attribute_name}", parse_attribute(document, attribute_name))
      end
    end

    def parse_attribute(document, name)
      document.at_xpath("//head/meta[@property='og:#{name}']").get('content')
    end
  end
end
