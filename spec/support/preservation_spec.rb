shared_examples 'a preservable element' do
  let(:element) { subject }

  describe 'preservation metadata' do
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
end