require 'spec_helper'

describe OGP::OpenGraph do
  describe '#initialize' do
    context 'with strictly the required attributes' do
      it 'should create a proper OpenGraph object' do
        content = File.read("#{File.dirname(__FILE__)}/../view/required_attributes.html")
        open_graph = OGP::OpenGraph.new(content)

        expect(open_graph.title).to eql('The Rock')
        expect(open_graph.type).to eql('video.movie')
        expect(open_graph.url).to eql('http://www.imdb.com/title/tt0117500/')
        expect(open_graph.image).to eql('http://ia.media-imdb.com/images/rock.jpg')
      end
    end

    context 'with missing one of the required attributes' do
      it 'should raise an error' do
        content = File.read("#{File.dirname(__FILE__)}/../view/missing_required_attributes.html")
        
        expect{OGP::OpenGraph.new(content)}.to raise_error(OGP::MissingAttributeError)
      end
    end
  end
end
