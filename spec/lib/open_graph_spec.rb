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
        expect(open_graph.images[0].url).to eql('http://ia.media-imdb.com/images/rock.jpg')
      end
    end

    context 'with missing one of the required attributes' do
      it 'should raise an error' do
        content = File.read("#{File.dirname(__FILE__)}/../view/missing_required_attributes.html")
        
        expect{OGP::OpenGraph.new(content)}.to raise_error(OGP::MissingAttributeError)
      end
    end

    context 'with nil source' do
      it 'should raise an error' do
        expect{OGP::OpenGraph.new(nil)}.to raise_error(ArgumentError)
      end
    end

    context 'with empty source' do
      it 'should raise an error' do
        expect{OGP::OpenGraph.new('')}.to raise_error(ArgumentError)
      end
    end

    context 'with malformed source' do
      it 'should raise an error' do
        expect{OGP::OpenGraph.new('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')}.to raise_error(OGP::MalformedSourceError)
      end
    end

    context 'with optional attributes' do
      it 'should create a proper OpenGraph object' do
        content = File.read("#{File.dirname(__FILE__)}/../view/optional_attributes.html")
        open_graph = OGP::OpenGraph.new(content)

        expect(open_graph.audios[0].url).to eql('http://example.com/bond/theme.mp3')
        expect(open_graph.description).to eql('Sean Connery found fame and fortune as the suave, sophisticated British agent, James Bond.')
        expect(open_graph.determiner).to eql('the')
        expect(open_graph.locales).to match_array(%w(en_GB fr_FR es_ES))
        expect(open_graph.site_name).to eql('IMDb')
        expect(open_graph.videos[0].url).to eql('http://example.com/bond/trailer.swf')
      end
    end

    context 'with image structured attributes' do
      it 'should create a proper OpenGraph object' do
        content = File.read("#{File.dirname(__FILE__)}/../view/image_structured_attributes.html")
        open_graph = OGP::OpenGraph.new(content)

        expect(open_graph.images[0].url).to eql('http://example.com/ogp.jpg')
        expect(open_graph.images[0].secure_url).to eql('https://secure.example.com/ogp.jpg')
        expect(open_graph.images[0].type).to eql('image/jpeg')
        expect(open_graph.images[0].width).to eql('400')
        expect(open_graph.images[0].height).to eql('300')
        expect(open_graph.images[0].alt).to eql('A shiny red apple with a bite taken out')
      end
    end

    context 'with audio structured attributes' do
      it 'should create a proper OpenGraph object' do
        content = File.read("#{File.dirname(__FILE__)}/../view/audio_structured_attributes.html")
        open_graph = OGP::OpenGraph.new(content)

        expect(open_graph.audios[0].url).to eql('http://example.com/sound.ogg')
        expect(open_graph.audios[0].secure_url).to eql('https://secure.example.com/sound.ogg')
        expect(open_graph.audios[0].type).to eql('audio/ogg')
      end
    end

    context 'with video structured attributes' do
      it 'should create a proper OpenGraph object' do
        content = File.read("#{File.dirname(__FILE__)}/../view/video_structured_attributes.html")
        open_graph = OGP::OpenGraph.new(content)

        expect(open_graph.videos[0].url).to eql('http://example.com/movie.swf')
        expect(open_graph.videos[0].secure_url).to eql('https://secure.example.com/movie.swf')
        expect(open_graph.videos[0].type).to eql('application/x-shockwave-flash')
        expect(open_graph.videos[0].width).to eql('400')
        expect(open_graph.videos[0].height).to eql('300')
      end
    end
  end
end
