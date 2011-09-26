module ArchivalCollectionHelper


  def general_info
    results = String.new
    results << "<dl class=\"defList\">"
    Blacklight.config[:ead_geninfo].each do | field |
      label = get_ead_label(field.to_sym)
      unless @document[field.to_sym].nil?
         results << "<dt>#{label}:</dt>"
         results << "<dd>"
         @document[field.to_sym].each do |v|
           results << "#{v}<br/>"
         end
         results << "</dd>"
      end
    end
    results << "</dl>"
    return results.html_safe
  end


  def ead_headings
    results = String.new
    Blacklight.config[:ead_headings].each do | field |
      label = get_ead_label(field.to_sym)
      # Override display from Solr field with a method
      if self.respond_to?(field.to_sym)
        results << self.send(field.to_sym)
      else
        unless @document[field.to_s].nil?
          results << "<h2 id=\"#{field.to_s}\">#{label}</h2>"
          @document[field.to_s].each do | v|
            results << "<p>#{v}</p>"
          end
        end
      end
    end
    return results.html_safe
  end


  def ead_access_headings
    results = String.new
    unless @document["subject_topic_facet"].nil?
      results << "<h2 id=\"access_headings\">Controlled Access Headings</h2>"
      results << "<ul>"
      @document["subject_topic_facet"].sort.each do |v|
        results << "<li>#{v}</li>"
      end
      results << "</ul>"
    end
    return results.html_safe
  end


  def ead_bio_display
    results = String.new
    label = get_ead_label("ead_bio_display")
    results << "<h2 id=\"ead_bio_display\">#{label}</h2>"

    xml   = Rockhall::EadMethods.ead_xml(@document)
    list  = xml.xpath("/ead/archdesc/bioghist/chronlist")
    items = list.xpath('chronitem')

    unless list.empty?
      # Timeline table
      results << "<dl class=\"defList\">"
      items.each do |chronitem|
        results << "<dt>" + chronitem.xpath('date').first + "</dt>"
        results << "<dd>"
        chronitem.xpath('.//event').each do |chronevent|
          results << chronevent.text + "<br/>"
        end
        results << "</dd>"
      end
      results << "</dl>"
    end

    unless @document[:ead_bio_display].nil?
      @document[:ead_bio_display].each do | v|
        results << "<p>#{v}</p>"
      end
    end

    # Sources
    sources = String.new
    xml.xpath("/ead/archdesc/bioghist/list/item").each do |source|
      sources << "<p>#{source.text}</p>"
    end
    unless sources.empty?
      results << "<h3>Sources</h3>"
      results << sources
    end

    results.gsub!("<title render=\"italic\">","<i>")
    results.gsub!("</title>","</i>")

    return results.html_safe
  end


  def comma_list(args)
    fields = Array.new
    args.each do |text|
      unless text.nil?
        fields << text
      end
    end
    return fields.join(", ").html_safe
  end

  def display_field(field)
    field.join("<br/>").html_safe
  end

  def display_odd_fields(fields,labels)
    results = String.new
    if labels.length == fields.length
      last_index = labels.length - 1
      (0..last_index).each do |index|
        results << "<dt>#{labels[index]}:</dt>"
        results << "<dd class=\"odd\">#{fields[index]}</dd>"
      end
    else
      results << "Unable to display additional fields"
    end
    return results.html_safe
  end


  def ead_contents
    results = String.new
    Blacklight.config[:ead_headings].each do | f |
      # Always show the link if we're overriden it as above
      if !@document[f.to_sym].nil? or self.respond_to?(f.to_sym)
        label = get_ead_label(f.to_sym)
        results << "<li>"
        results << "<a href=\"#" + f.to_s + "\">#{label}</a>"
        results << "</li>"
      end
    end
    return results.html_safe
  end

  def get_ead_label(field)
    if Blacklight.config[:ead_fields][field.to_sym][:is_xpath]
      xml   = Rockhall::EadMethods.ead_xml(@document)
      label = xml.xpath(Blacklight.config[:ead_fields][field.to_sym][:label]).text
    else
      label = Blacklight.config[:ead_fields][field.to_sym][:label]
    end
    return label
  end

end