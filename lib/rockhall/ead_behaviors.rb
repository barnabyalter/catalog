# Ead Behaviors
#
# A collection of instance methods used by our custom EadComponent and EadDocument
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.

module Rockhall::EadBehaviors

  # Takes an accession range and attempts to compute each individual accession number
  # so each can be indexed and searched in solr.  For example, ranges that are shown
  # in the ead as:
  #
  #   A1994.34.19-A1994.34.30
  #
  # Will be broken down into individual accession number and stored in solr as:
  #
  #   A1994.34.19
  #   A1994.34.20
  #   A1994.34.21
  #   [...]
  #   A1994.34.30
  #
  # It can also multiple ranges separated by commas:
  #
  #   A1994.34.4, A1994.34.7-A1994.34.9
  #
  # In order to work, the range must be entered into AT with no accompanying text.
  def ead_accession_range(input, results = Array.new)
    return results if input.empty?
    range = input.first

    # Catch incorrectly formatted ranges
    if range.match(/[;()B-Z]/)
      logger.warn("Bad accession range: " + input.to_s)
      return results
    end

    first, last = range.split(/-/)
    numbers = range.split(/,/)

    if numbers.length > 1
      numbers.each do |n|
      first, last = n.split(/-/)
        if last
          fparts = first.strip.split(/\./)
          lparts = last.strip.split(/\./)
          (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
        else
          results << n.strip
        end
      end
    elsif last
      fparts = first.strip.split(/\./)
      lparts = last.strip.split(/\./)
      (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
    else
      results << range.strip
    end

    return results
  end

  # Formats multiple data fields into a single field for display
  def ead_date_display(parts = Array.new)
    unless self.unitdate.empty?
      parts << self.unitdate
    else
      unless self.unitdate_inclusive.empty? and self.unitdate_bulk.empty?
        parts << "Inclusive,"
        parts << self.unitdate_inclusive
        unless self.unitdate_bulk.empty?
          parts << ";"
          parts << self.unitdate_bulk
        end
      end
    end
    return parts.join(" ")
  end

end