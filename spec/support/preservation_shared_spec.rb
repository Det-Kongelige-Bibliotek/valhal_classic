shared_examples 'a preservable element' do
  let(:element) { subject }

  describe 'with initial preservation metadata' do
    it 'should have a preservation metadata stream' do
      element.save!
      element.preservationMetadata.should be_kind_of Datastreams::PreservationDatastream
    end

    it 'should have a non-empty preservation profile, both as attribute and in the metadatastream.' do
      element.save!

      element.preservation_profile.should be_kind_of String
      element.preservation_profile.should_not be_blank
      element.preservationMetadata.preservation_profile.first.should be_kind_of String
      element.preservationMetadata.preservation_profile.first.should_not be_blank
    end

    it 'should have an empty preservation comment, both as attribute and in the metadatastream.' do
      element.save!

      element.preservation_comment.should be_blank
      element.preservationMetadata.preservation_comment.should be_empty
    end

    it 'should have a non-empty preservation state, both as attribute and in the metadatastream.' do
      element.save!

      element.preservation_state.should be_kind_of String
      element.preservation_state.should_not be_blank
      element.preservationMetadata.preservation_state.first.should be_kind_of String
      element.preservationMetadata.preservation_state.first.should_not be_blank
    end

    it 'should have a non-empty preservation details, both as attribute and in the metadatastream.' do
      element.save!

      element.preservation_details.should be_kind_of String
      element.preservation_details.should_not be_blank
      element.preservationMetadata.preservation_details.first.should be_kind_of String
      element.preservationMetadata.preservation_details.first.should_not be_blank
    end

    it 'should have a non-empty preservation modify date, both as attribute and in the metadatastream.' do
      element.save!

      element.preservation_modify_date.should be_kind_of String
      element.preservation_modify_date.should_not be_blank
      element.preservationMetadata.preservation_modify_date.first.should be_kind_of String
      element.preservationMetadata.preservation_modify_date.first.should_not be_blank
    end
  end

  describe 'changing the preservation metadata' do
    it 'should be possible to assign and save a preservation profile.' do
      profile = "Preservation-Profile-#{Time.now.to_s}"
      element.preservation_profile = profile
      element.save!
      e2 = element.reload

      e2.preservation_profile.should == profile
      e2.preservationMetadata.preservation_profile.first.should == profile
    end

    it 'should be possible to assign and save a preservation state.' do
      state = "Preservation-State-#{Time.now.to_s}"
      element.preservation_state = state
      element.save!
      e2 = element.reload

      e2.preservation_state.should == state
      e2.preservationMetadata.preservation_state.first.should == state
    end

    it 'should be possible to assign and save a preservation details.' do
      details = "Preservation-Details-#{Time.now.to_s}"
      element.preservation_details = details
      element.save!
      e2 = element.reload

      e2.preservation_details.should == details
      e2.preservationMetadata.preservation_details.first.should == details
    end

    it 'should be possible to assign and save a preservation profile.' do
      comment = "Preservation-Comment-#{Time.now.to_s}"
      element.preservation_comment = comment
      element.save!
      e2 = element.reload

      e2.preservation_comment.should == comment
      e2.preservationMetadata.preservation_comment.first.should == comment
    end
  end

  describe 'using PreservationHelper' do
    include PreservationHelper

    it 'should change the preservation timestamp with #set_preservation_modified_time' do
      time = element.preservationMetadata.preservation_modify_date
      sleep 2
      set_preservation_modified_time(element)
      element.save!
      time.should_not == element.preservationMetadata.preservation_modify_date
    end

    it 'should update preservation profile with #update_preservation_profile_from_controller' do
      #update_preservation_profile_from_controller(nil, element)
    end

    describe "#update_preservation_metadata_for_element" do
      it 'should be able to update all the preservation metadata fields' do
        element.preservationMetadata.preservation_state = Constants::PRESERVATION_STATE_INITIATED.keys.first
        element.save!

        metadata = {'preservation' => {'preservation_state' => Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first,
                                      'preservation_details' => 'From preservation shared spec', 'warc_id' => 'WARC_ID'}}
        expect(update_preservation_metadata_for_element(metadata, element)).to be == true

        element.preservationMetadata.preservation_state.first.should == Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first
        element.preservationMetadata.preservation_details.first.should == 'From preservation shared spec'
        element.preservationMetadata.warc_id.first.should == 'WARC_ID'
      end


      it 'should be able to update only the preservation state' do
        element.preservationMetadata.preservation_state = Constants::PRESERVATION_STATE_INITIATED.keys.first
        element.save!

        metadata = {'preservation' => {'preservation_state' => Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first}}
        expect(update_preservation_metadata_for_element(metadata, element)).to be == true

        element.preservationMetadata.preservation_state.first.should == Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first
        element.preservationMetadata.preservation_details.first.should_not == 'From preservation shared spec'
        element.preservationMetadata.warc_id.first.should_not == 'WARC_ID'
      end


      it 'should be able to update only the preservation details' do
        element.preservationMetadata.preservation_state = Constants::PRESERVATION_STATE_INITIATED.keys.first
        element.save!

        metadata = {'preservation' => {'preservation_details' => 'From preservation shared spec'}}
        expect(update_preservation_metadata_for_element(metadata, element)).to be == true

        element.preservationMetadata.preservation_state.first.should_not == Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first
        element.preservationMetadata.preservation_details.first.should == 'From preservation shared spec'
        element.preservationMetadata.warc_id.first.should_not == 'WARC_ID'
      end

      it 'should be able to update only the warc-id' do
        element.preservationMetadata.preservation_state = Constants::PRESERVATION_STATE_INITIATED.keys.first
        element.save!

        metadata = {'preservation' => {'warc_id' => 'WARC_ID'}}
        expect(update_preservation_metadata_for_element(metadata, element)).to be == true

        element.preservationMetadata.preservation_state.first.should_not == Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first
        element.preservationMetadata.preservation_details.first.should_not == 'From preservation shared spec'
        element.preservationMetadata.warc_id.first.should == 'WARC_ID'
      end

      it 'should not be allowed when wrong preservation state' do
        element.preservationMetadata.preservation_state = Constants::PRESERVATION_STATE_NOT_STARTED.keys.first
        element.save!

        metadata = {'preservation' => {'preservation_state' => Constants::PRESERVATION_PACKAGE_UPLOAD_SUCCESS.keys.first,
                                       'preservation_details' => 'From preservation shared spec', 'warc_id' => 'WARC_ID'}}
        begin
          update_preservation_metadata_for_element(metadata, element).should be_false
          fail
        rescue ValhalErrors::InvalidStateError
          # Expected
        end
      end
    end
  end
end