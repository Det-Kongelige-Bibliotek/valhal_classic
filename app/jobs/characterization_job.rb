class CharacterizationJob

  @queue = :characterization

  def self.perform(bf_pid)

    bf = BasicFile.find(bf_pid)

    Resque.logger.info "It is better to save than be sorry #{bf.pid}"
    bf.save

    Resque.logger.info "Starting work on characterization job from queue work for #{bf.pid}."

    temp_file = File.new('temp_content_file', 'w+')
    begin
      temp_file.puts bf.content.content
    rescue StandardError => re
      Resque.logger.error 'Got error writing BasicFile contents to file'
      Resque.logger.error re.to_s
      if re.to_s.match 'from ASCII-8BIT to UTF-8'
        Resque.logger.info 'ASCII file detected'
        temp_file.puts bf.content.content.force_encoding('UTF-8')
      end
    end

    f = ActionDispatch::Http::UploadedFile.new(filename: bf.content.label, type: bf.content.profile['dsMIME'], tempfile: temp_file)

    begin
      Resque.logger.info 'Generating FITS metadata XML'
      fitsMetadata = Hydra::FileCharacterization.characterize(f, f.original_filename, :fits)
    rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
      Resque.logger.error tnfe.to_s
      abort 'FITS tool not found, terminating, check FITS_HOME environment variable is set and FITS is installed'
    rescue RuntimeError => re
      Resque.logger.error 'Something went wrong with extraction of file metadata using FITS'
      Resque.logger.error re.to_s
      abort 'FITS tool not found, terminating, check FITS_HOME environment variable is set and FITS is installed'
    end
    if bf.datastreams['fitsMetadata1'].nil?
      Resque.logger.info "Creating new fitsDatastream for #{bf.pid}"
      fitsDatastream = ActiveFedora::OmDatastream.from_xml(fitsMetadata)
      fitsDatastream.digital_object = bf.inner_object

      bf.add_datastream(fitsDatastream, {:prefix => 'fitsMetadata'})
    else
      Resque.logger.info "Reusing existing fitsDatastream for #{bf.pid}"
      bf.datastreams['fitsMetadata1'].content = fitsMetadata
    end
    Resque.logger.info "Again it is better to save than be sorry #{bf.pid}"
    bf.save
    Resque.logger.info 'FITS metadata datastream added, tidying up resources used'
    temp_file.close
    FileUtils.remove_file 'temp_content_file'
    Resque.logger.info "Finished adding FITS metadata for #{bf.pid}"
    Resque.logger.info '********************************************'
  end

end