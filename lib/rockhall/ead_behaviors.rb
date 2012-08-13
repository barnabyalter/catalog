module Rockhall::EadBehaviors

  def ead_accession_range(input, results = Array.new)

    return results if input.empty?
    range = input.first

    # Catch incorrectly formatted ranges
    if range.match(";")
      raise "Bad accession range"
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