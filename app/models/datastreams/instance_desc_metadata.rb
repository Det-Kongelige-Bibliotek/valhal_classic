# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the descriptive metadata for an Instance.
  class InstanceDescMetadata < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(:path=>'fields')
      t.shelfLocator(index_as: :stored_searchable)
      t.physicalDescriptionForm(index_as: :stored_searchable)
      t.physicalDescriptionNote(index_as: :stored_searchable)
      t.languageOfCataloging(index_as: :stored_searchable)
      t.dateCreated(index_as: :stored_searchable)
      t.dateIssued(index_as: :stored_searchable)
      t.dateOther(index_as: :stored_searchable)
      t.recordOriginInfo(index_as: :stored_searchable)
      t.tableOfContents(index_as: :stored_searchable)
      t.contentType
      t.isbn(index_as: :stored_searchable)
      t.language do
        t.value
        t.authority
      end

      t.identifier do
        t.value(index_as: :stored_searchable)
        t.displayLabel()
      end

      t.note do
        t.value()
        t.displayLabel()
      end

      t.note_value(proxy: [:note, :value])
      t.note_label(proxy: [:note, :displayLabel])
      t.language_value(proxy: [:language, :value])
      t.language_authority(proxy: [:language, :authority])
    end

    define_template :identifier do |xml, val|
      xml.identifier() {
        xml.value {xml.text(val['value'])}
        xml.displayLabel {xml.text(val['displayLabel'])}
      }
    end

    define_template :note do |xml, val|
      xml.note() {
        xml.value {xml.text(val['value'])}
        xml.displayLabel {xml.text(val['displayLabel'])}
      }
    end

    # @param val Must be a Hash containing at least 'value'
    def insert_identifier(val)
      raise ArgumentError.new 'Can only create the identifier element from a Hash map' unless val.is_a? Hash
      raise ArgumentError.new 'Requires a \'value\' field in the Hash map to create the identifier element' if val['value'].blank?
      sibling = find_by_terms(:identifier).last
      node = sibling ? add_next_sibling_node(sibling, :identifier, val) :
          add_child_node(ng_xml.root, :identifier, val)
      content_will_change!
      return node
    end

    def remove_identifier
      nodes = find_by_terms(:identifier)
      if (nodes.size>0)
        nodes.each { |n| n.remove }
        content_will_change!
      end
    end

    def get_identifier
      identifiers = []
      nodes = find_by_terms(:identifier)
      nodes.each do |n|
        at = Hash.new
        n.children.each do |c|
          at[c.name] = c.text unless c.name == 'text'
        end
        identifiers << at
      end
      identifiers
    end

    # @param val Must be a Hash containing at least 'value'
    def insert_note(val)
      raise ArgumentError.new 'Can only create the note element from a Hash map' unless val.is_a? Hash
      raise ArgumentError.new 'Requires a \'value\' field in the Hash map to create the note element' if val['value'].blank?
      sibling = find_by_terms(:note).last
      node = sibling ? add_next_sibling_node(sibling, :note, val) :
          add_child_node(ng_xml.root, :note, val)
      content_will_change!
      return node
    end

    def remove_note
      nodes = find_by_terms(:note)
      if (nodes.size>0)
        nodes.each { |n| n.remove }
        content_will_change!
      end
    end

    def get_note
      notes = []
      nodes = find_by_terms(:note)
      nodes.each do |n|
        at = Hash.new
        n.children.each do |c|
          at[c.name] = c.text unless c.name == 'text'
        end
        notes << at
      end
      notes
    end

    def self.xml_template
      Nokogiri::XML.parse '
        <fields>
        </fields>'
    end
  end
end
