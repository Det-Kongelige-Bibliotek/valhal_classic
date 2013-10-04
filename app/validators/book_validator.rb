# -*- encoding : utf-8 -*-
#Validator class for the Book model contains any custom Rails validation
class BookValidator < ActiveModel::Validator

  #Overridden from ActiveModel::Validator
  def validate(record)
    if duplicate_isbn?(record.isbn, record.id)
      record.errors[:isbn] << "cannot be duplicated"
    end
  end

  private
  # Validate that the ISBN value is unique.
  # @param isbn The ISBN value to validate.
  # @param id The id of the record.
  # @return Whether any duplicate ISBN number exists.
  def duplicate_isbn?(isbn, id)
    if isbn.blank?
      logger.debug "Returning false as the ISBN is blank"
      false
    else
      if id.eql? "__DO_NOT_USE__"
        count = Book.find_with_conditions("#{ActiveFedora::SolrService.solr_name("isbn", Solrizer::Descriptor.new(:string, :stored, :indexed))}:\"#{isbn}\"").length
      else
        count = Book.find_with_conditions("#{ActiveFedora::SolrService.solr_name("isbn", Solrizer::Descriptor.new(:string, :stored, :indexed))}:\"#{isbn}\" NOT id:\"#{id}\"").length
      end
      logger.error "duplicate ISBN count = #{count}"
      count > 0
    end
  end
end