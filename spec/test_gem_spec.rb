require 'spec_helper'

describe TestGem do
  describe '#parse' do
    let(:html_fixture)      { File.join(__dir__, 'fixtures', 'test.html') }
    let(:json_fixture)      { File.join(__dir__, 'fixtures', 'test.json') }

    before(:each) do
      stub_request(:get, /http:\/\/test\.com(.*)/).to_return(body: File.read(html_fixture))
      stub_request(:get, 'https://test.com').to_return(body: File.read(html_fixture))
      stub_request(:get, 'error.com').to_return(body: File.read(json_fixture))
    end

    it 'correct parsing site without protocol' do
      expect(TestGem.parse('test.com')).to match_array(['http://google.com/1.png', 'http://test.com/2.png'])
    end

    it 'correct parsing site with http' do
      expect(TestGem.parse('http://test.com')).to match_array(['http://google.com/1.png', 'http://test.com/2.png'])
    end

    it 'correct parsing site with http 8080' do
      expect(TestGem.parse('http://test.com:8080')).to match_array(['http://google.com/1.png', 'http://test.com:8080/2.png'])
    end

    it 'correct parsing site page with http' do
      expect(TestGem.parse('http://test.com/page')).to match_array(['http://google.com/1.png', 'http://test.com/2.png'])
    end

    it 'correct parsing site with https' do
      expect(TestGem.parse('https://test.com')).to match_array(['http://google.com/1.png', 'https://test.com/2.png'])
    end

    it 'incorrect body while parsing site' do
      expect(TestGem.parse('http://error.com')).to match_array([])
    end
  end
end
