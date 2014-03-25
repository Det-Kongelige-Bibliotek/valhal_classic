require "#{Rails.root}/app/services/http_service"

class AlephService
  def initialize
    @aleph_url = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['aleph_base_url']
    @http_service = HttpService.new
  end

  # find all dod records
  # get set id from aleph
  # iterate over all records
  # return array of xml posts
  def find_all_dod_posts(max = nil)
    set_data = find_set("wbh=edod")
    fetch_size = max.nil? ? set_data[:num_entries].to_i : max.to_i
    records = []
    (1..fetch_size).each do |i|
      records << get_record(set_data[:set_num], i)
    end
    records
  end

  # given a marcxml string from aleph
  # return a queue message in format
  # {id: x, fileUri: www.kb/y.pdf, workflowId: DOD}
  def convert_marc_to_message(marcxml)
    xml = Nokogiri::XML.parse(marcxml)
    sys_num = xml.css('present record metadata oai_marc varfield[id="001"]').text.strip[4..12]
    fileUri = xml.css('present record metadata oai_marc varfield[id="URL"] subfield[label="u"]').first.text.strip
    {id: sys_num, fileUri: fileUri, workflowId: 'DOD'}.to_json
  end

  #Query Aleph X service to get the set data for a given Aleph search. This is the first POST in
  #the 2 POST process of getting Aleph DanMARC metadata for an eBook.
  #@param search_string e.g. "wbh=edod"
  #@return {aleph_set_number, num_entries} Hash
  def find_set(search_string)
    response = search_aleph(search_string)
    logger.debug "aleph response is #{response}"
    set_num = Nokogiri::XML.parse(response).xpath('/find/set_number/text()').to_s
    num_entries = Nokogiri::XML.parse(response).xpath('/find/no_entries/text()').to_s
    {set_num: set_num, num_entries: num_entries}
  end


  #Query Aleph X Service for the Aleph DanMARC record for the corresponding set number.  This is the second POST in the
  #2 POST process of getting Aleph DanMARC metadata for a book.
  #@param aleph_set_number the set_number returned by Aleph for the book barcode which is then used to get the DanMARC
  #record for the eBook.
  #@return
  def get_record(set_number, entry_num)
    @http_service.do_post(@aleph_url, params = {
        :op => "present",
        :set_no => set_number,
        :set_entry => entry_num,
        :format => "marc"}
    )
  end

  # Given an Aleph search string
  # retrieve set_data xml for the
  # corresponding result set.
  # @param search_string String e.g. "wbh=edod"
  def search_aleph(search_string)
    @http_service.do_post(@aleph_url, params = {
        :op => 'find',
        :base => 'kgl01',
        :library => 'kgl01',
        :request => search_string })
  end
end