@ead

Feature: EAD display
  In order to view finding aids in Blacklight
  As a public user
  I should see properly formatted web page

  Scenario: Biographical Note and Administrative History (BL-5)
    Given I am on the ead page for ARC-0105
    Then I should see "1911 May 18"
    And I should see "Born Joseph Vernon Turner, Jr. in Kansas City, Mo."
    And I should see "1939"
    And I should see "Releases first single"
    And I should see "With Albert Ammons and Meade Lux Lewis, begins a five-year residency at New York's Cafe Society"
    And I should see "Big Joe Turner was among the first to mix R&B with boogie-woogie"
    And I should see "In the 1960s, after the first wave of rock and roll had died down"
    And I should see "Sources"
    And I should see "Big Joe Turner Biography"

  Scenario: Date Expression in first component level (BL-9)
    Given I am on the ead page for ARC-0105ref45
    Then I should see "Business papers, 1945-1946"
    And I should see "Flyers, 1983-1984"

  Scenario: Names (BL-7, BL-147)
    Given I am on the ead page for ARC-0058
    Then I should see "Alternative rock music"

  Scenario: Dimensions note (see BL-124)
    Given I am on the ead page for ARC-0065ref10
    Then I should see "Limited Print Run"
    And I should see "Non-numbered edition of 200"
    And I should see "Dimensions"
    Given I am on the ead page for ARC-0065ref88
    And I should see "ChromaDepth 3D image with required glass for viewing"

  Scenario: I need to see all sub-components (BL-58)
    Given I am on the ead page for ARC-0065ref42
    Then I should see "Psycotic Pineapple, 1980 August 4-1980 September 15"
    And I should see "Ultras with Dick Dale, 1992 August 1"

  @future-work
  Scenario: EAD that has no collection headings (BL-60)
    Given I am on the ead page for RG-0001
    Then I should not see "Controlled Access Headings"

  Scenario: Show accession numbers (BL-118) Note: this is revoked from BL-49
    Given I am on the ead page for ARC-0058
    Then I should see "A2005.31.15"

  Scenario: Displaying italics (BL-33)
    Given I am on the ead page for ARC-0058
    Then I should see "New Musical Express" in italics
    And I should see "Love" in italics
    Given I am on the ead page for ARC-0105
    Then I should see "Blues Train" in italics

  Scenario: Separated materials notes (BL-43)
    Given I am on the ead page for ARC-0105
    Then I should see "Separated Materials"
    And I should see "Biographical Note"

  Scenario: Related materials and accruals (BL-115)
    Given I am on the ead page for ARC-0006
    Then I should see "Related materials providing content on Alan Freed may be found in the following collections"

  Scenario: Separated materials and access restrictions (BL-116)
    Given I am on the ead page for ARC-0003
    Then I should see "Some print and audiovisual materials have been transferred to the library collection"
    And I should see "Collection is open for research"

  Scenario: Existence and Location of Originals (BL-117)
    Given I am on the ead page for ARC-0006ref641
    Then I should see "original plaque"

  Scenario: Physical description (BL-119)
    Given I am on the ead page for ARC-0006ref725
    Then I should see "Trimmed"

  Scenario: Language of Materials, Museum Acc. #, Separated Materials (BL-118)
    Given I am on the ead page for ARC-0006ref690
    Then I should see "Material is in French."
    And I should see "A2010.1.18"
    And I should see "Item on exhibit. Consult the Library and Archives staff in advance of your visit for additional information."

  Scenario: Custodial history (BL-120, BL-130)
    Given I am on the ead page for ARC-0037
    Then I should see "The Jeff Gold Collection was received by the Rock and Roll Hall of Fame Museum"
    And I should not see "Provenance"
    And I should not see "Immediate Source of Acquisition note"
    And I should see "Custodial History"
    Given I am on the ead page for ARC-0067
    Then I should see "The Curtis Mayfield Collection was received from Mayfield on December 1994."
    And I should see "Custodial History"

  Scenario: Publisher note in finding aids (BL-142)
    Given I am on the ead page for ARC-0006
    Then I should not see "Publisher"

  Scenario: Order and titles of EAD fields as they appear in Blacklight (BL-147)
    Given I am on the ead page for ARC-0003
    Then I should see "Dates:"
    And I should see "Bulk, 1938-1969; Inclusive, 1928-2006, undated"
    And I should see "Custodial History"
    And I should not see "Custodial History note"
    And I should see "Subject Headings"
    And I should not see "Controlled Access Headings"

  Scenario: Date expression (BL-164) and Accruals note (BL-155)
    Given I am on the ead page for ARC-0037
    Then I should see the field content "blacklight-ead_date_display" contain "1938-2010, undated"
    And I should not see "Accruals note"
    And I should see "Accruals"

  Scenario: Displaying multiple copies of an archival item (BL-202)
    Given I am on the ead page for ARC-0006ref213
    Then I should see "Box: 5, Folder: 1, Object: 1-2 (Original Copy)"
    And I should see "Box: 1B, Folder: 22, Object: 1-2 (Access Copy)"
    And I should not see "Box: 1B, Folder: 22, Object: 3, Box: 5, Folder: 1, Object: 3"

  Scenario: Processing information note (BL-196)
    Given I am on the ead page for ARC-0003
    Then I should see "Processing Information"
    And I should not see "Processing Information note"

  Scenario: AT genre facet display (BL-195)
    Given I am on the ead page for ARC-0005
    Then I should see "Clippings (Books, newspapers, etc.)"
    And I should see "Photographs"

  Scenario: Additional chronologies (BL-194)
    Given I am on the ead page for ARC-0005
    Then I should see "First meeting of the Organization"
    And I should see "Incorporated as a Minnesota non-profit organization"
    And I should see "Holds first annual Eddie Cochran Weekend in Alberta Lea, Minn"

  @future-work
  Scenario: Displaying text in bold
    Given I am on the ead page for ARC-0005
    Then I should see "EDDIE COCHRAN" in "bold"
    And I should see "EDDIE COCHRAN HISTORICAL ORGANIZATION" in "bold"

  Scenario: Title nodes in ead (BL-209)
    Given I am on the ead page for ARC-0026
    Then I should see "Normal As The Next Guy" in italics with a span tag

  Scenario: Showing the full ead for collections with no series level components (BL-270)
    Given I am on the ead page for ARC-0060
    Then I should see "Collection Inventory"
    And I should see "Green, Al, 1983 August 24"
    And I should not see "Full view"

  Scenario: XML display (BL-219)
    Given I am on the ead page for ARC-0005
    When I follow "XML view"
    Then I should see "Eddie Cochran Historical Organization Collection"

  Scenario: Redirects for non-existent ead xml files (BL-219)
    Given I am on the ead xml page for ARC-BOGUS
    Then I should see "XML file for ARC-BOGUS was not found or is unavailable"

  Scenario: Hide contents heading when there are no children (BL-275)
    Given I am on the ead page for ARC-0006ref1150
    Then I should not see "Contents"

  @javascript
  Scenario: EAD navigation (BL-276, BL-281)
    Given I am on the ead page for ARC-0037
    When I follow "Collection Overview"
    Then I should see "The Jeff Gold Collection"
    When I follow "Series I: Artist Files"
    Then I should see "Adams, Ryan, undated"
    When I follow "Beach Boys"
    Then I should see "General, 1969-1975, undated"
    And I should see "Beatles"
    And I should see "Carpenters"
    When I follow "Accruals"
    Then I should see "Accruals"
    When I follow "Series V: Posters"
    Then I should see "Series V: Posters"
    When I follow "XML view"
    Then I should see "Jeff Gold Collection"

  Scenario: EAD components need a default title, if there isn't one (BL-274)
    Given I am on the ead page for ARC-0006ref1207
    Then I should see "Alan Freed Collection >> Series VII: 2011 Accrual [CLOSED] >> Yearbook - Quaker Annual >> 1940"
    Then I should see the field content "blacklight-unitdate_display" contain "1940"

  @javascript
  Scenario: Collections with mixed item and series first-level components  (BL-283)
    Given I am on the ead page for ARC-0029
    Then I should see "Series I: Papers"
    And I should see "Series III: Photographs"