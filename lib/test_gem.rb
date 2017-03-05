require 'test_gem/version'
require 'httparty'
require 'nokogiri'
require 'addressable'

# Test Gem module
module TestGem
  # Parsing url for image tags and return their src
  #
  # @param raw_url [String] URL
  # @return [Array<String>] Array of images
  def self.parse(raw_url)
    return [] if raw_url.to_s.empty?

    result = nil
    raw_url = "http://#{raw_url}" unless raw_url =~ %r{^([a-z]+:\/\/)}
    url = Addressable::URI.parse(raw_url)
    response = HTTParty.get(url)

    if response.body
      base_url = "#{url.scheme}://#{url.hostname}"
      base_url += ":#{url.port}" unless [nil, 80, 443].include?(url.port)

      html_doc = Nokogiri::HTML(response.body)

      result = html_doc.css('img').map do |img|
        val = img.attr('src').to_s
        val = "#{base_url}#{val}" if val[0] == '/'
        val
      end
    end

    result
  end
end
