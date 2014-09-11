# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the descriptive metadata for a Work.
  class WorkDescMetadata < ActiveFedora::OmDatastream
    ALTERNATIVE_TITLE_TYPES = ['alternative', 'abbreviated', 'translated', 'uniform', 'other']

    set_terminology do |t|
      t.root(:path=>'fields')
      t.title(index_as: :stored_searchable)
      t.subTitle(index_as: :stored_searchable)
      t.workType(index_as: :stored_searchable)

      t.cartographicsScale()
      t.cartographicsCoordinates()
      t.dateIssued()
      t.dateCreated(index_as: :stored_searchable)
      t.dateOther(index_as: :stored_searchable)
      t.genre(index_as: :stored_searchable)
      t.languageOfCataloging(index_as: :stored_searchable)
      t.recordOriginInfo(index_as: :stored_searchable)
      t.tableOfContents()
      t.nextInSequence
      t.previousInSequence
      t.topic(index_as: :stored_searchable)
      t.typeOfResource(index_as: :stored_searchable)
      t.typeOfResourceLabel(index_as: :stored_searchable)

      t.alternativeTitle do
        t.title()
        t.subTitle()
        t.lang()
        t.type()
        t.displayLabel()
      end

      t.identifier do
        t.value()
        t.displayLabel()
      end

      t.language do
        t.value()
        t.authority()
      end

      t.note do
        t.value()
        t.displayLabel()
      end

    end

    define_template :alternativeTitle do |xml, val|
      xml.alternativeTitle() {
        xml.title {xml.text(val['title'])}
        xml.subTitle {xml.text(val['subTitle'])}
        xml.lang {xml.text(val['lang'])}
        xml.type {xml.text(val['type'])}
        xml.displayLabel {xml.text(val['displayLabel'])}
      }
    end

    define_template :identifier do |xml, val|
      xml.identifier() {
        xml.value {xml.text(val['value'])}
        xml.displayLabel {xml.text(val['displayLabel'])}
      }
    end

    define_template :language do |xml, val|
      xml.language() {
        xml.value {xml.text(val['value'])}
        xml.authority {xml.text(val['authority'])}
      }
    end

    define_template :note do |xml, val|
      xml.note() {
        xml.value {xml.text(val['value'])}
        xml.displayLabel {xml.text(val['displayLabel'])}
      }
    end

    # @param val Must be a Hash containing at least 'title'.
    def insert_alternative_title(val)
      raise ArgumentError.new 'Can only create the alternative title from a Hash map' unless val.is_a? Hash
      raise ArgumentError.new 'Requires a \'title\' field in the Hash map to create the alternative title element' if val['title'].blank?
      raise ArgumentError.new "Requires a 'type' with the values #{ALTERNATIVE_TITLE_TYPES}" unless val['type'] && ALTERNATIVE_TITLE_TYPES.include?(val['type'])
      sibling = find_by_terms(:alternativeTitle).last
      node = sibling ? add_next_sibling_node(sibling, :alternativeTitle, val) :
          add_child_node(ng_xml.root, :alternativeTitle, val)
      content_will_change!
      return node
    end

    def remove_alternative_title
      nodes = find_by_terms(:alternativeTitle)
      if (nodes.size>0)
        nodes.each { |n| n.remove }
        content_will_change!
      end
    end

    def get_alternative_title
      alternative_titles = []
      nodes = find_by_terms(:alternativeTitle)
      nodes.each do |n|
        at = Hash.new
        n.children.each do |c|
           at[c.name] = c.text unless c.name == 'text'
        end
        alternative_titles << at
      end
      alternative_titles
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

    # @param val Must be a Hash containing at least 'value'
    def insert_language(val)
      raise ArgumentError.new 'Can only create the language element from a Hash map' unless val.is_a? Hash
      raise ArgumentError.new 'Requires a \'value\' field in the Hash map to create the note element' if val['value'].blank?
      sibling = find_by_terms(:language).last
      language = sibling ? add_next_sibling_node(sibling, :language, val) :
          add_child_node(ng_xml.root, :language, val)
      content_will_change!
      return language
    end

    def remove_language
      languages = find_by_terms(:language)
      if (languages.size>0)
        languages.each { |n| n.remove }
        content_will_change!
      end
    end

    def get_language
      languages = []
      nodes = find_by_terms(:language)
      nodes.each do |n|
        at = Hash.new
        n.children.each do |c|
          at[c.name] = c.text unless c.name == 'text'
        end
        languages << at
      end
      languages
    end

    def self.xml_template
      Nokogiri::XML.parse '
        <fields>
          <title />
          <workType />
        </fields>'
    end
  end
end
