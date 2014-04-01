require 'bunny'

messages = []
Work.all.each do |w|
  fileUri = ''
  w.descMetadata.ng_xml.css('mods>location>url').each do |e| 
    if (e.text.end_with?('.pdf')) 
	fileUri = e.text
    end
  end
  message = {}
  message['Files'] = fileUri
  message['UUID'] = w.uuid
  message['Dissemination_type'] = 'BifrostBøger'
  message['Type'] = w.pid
  message['MODS'] = w.descMetadata.content
  messages << message
end
puts messages.to_json
