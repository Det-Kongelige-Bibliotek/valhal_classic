# -*- encoding : utf-8 -*-
module Datastreams
  # Datastream for the descriptive metadata for a Work.
  class WorkDescMetadata < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(:path=>'fields')
      t.title()
      t.subTitle()

      t.genre()
      t.identifier()
      t.topic()
      t.note()


      t.alternativeTitle do
        t.title()
        t.subTitle()
        t.lang()
        t.type()
      end
    end

    define_template :alternativeTitle do |xml, val|
      xml.alternativeTitle() {
        xml.title {xml.text(val['title'])}
        xml.subTitle {xml.text(val['subTitle'])}
        xml.lang {xml.text(val['lang'])}
        xml.type {xml.text(val['type'])}
      }
    end

    # @param val Must be a Hash containing at least 'title'.
    def insert_alternative_title(val)
      raise ArgumentError.new 'Can only create the alternative title from a Hash map' unless val.is_a? Hash
      raise ArgumentError.new 'Requires a \'title\' field in the Hash map to create the alternative title element' if val['title'].blank?
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

    def self.xml_template
      Nokogiri::XML.parse '
        <fields>
          <title></title>
          <subTitle></subTitle>

          <genre></genre>
          <identifier></identifier>
          <topic></topic>
          <note></note>

          <alternativeTitle>
            <title/>
            <subTitle/>
            <lang/>
            <type/>
          </alternativeTitle>
        </fields>'
    end
  end
end
