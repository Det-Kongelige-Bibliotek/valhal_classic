class Constants
  # The name on the button for performing the preservation
  PERFORM_PRESERVATION_BUTTON = 'Perform preservation'
  # The state for when the preservation has been initiated on Valhal-side (e.g. preservation message sent)
  PRESERVATION_STATE_INITIATED = 'Preservation initiated'

  # The name of the datastreams, which are not to be retrieved for messages.
  # DC = The Fedora internal Dublin-Core.
  # RELS_EXT = The Fedora datastream for relationships.
  # content = The content file, e.g. for BasicFile. (This has to be downloaded separately.)
  # thumbnail = The thumbnail content file for a image file. (Not preservable.)
  # rightsMetadata = The Hydra rights metadata format (Not preservable).
  NON_RETRIEVABLE_DATASTREAM_NAMES = ['DC', 'RELS-EXT', 'content', 'rightsMetadata', 'thumbnail'];
end