@ead

Feature: EAD display
  In order to view finding aids in Blacklight
  As a public user
  I should see properly formatted web page

  Scenario: Biographical Note and Administrative History (BL-5)
    Given I am on the ead page for ARC-0105
    When I follow "Biographical Note"
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
    Given I am on the ead page for ARC-0105
    When I follow "Collection Inventory"
    Then I should see "Oversize materials, 1977-1985, undated"

  Scenario: Date expression in sub component level (BL-9) and accession numbers
    Given I am on the ead page for ARC-0105ref42
    Then I should see "Awards and certificates"
    And I should see "Awards and certificates, 1976-1986"
    And I should see "Accession Numbers:"
    And I should see "A1994.4.10-A1994.4.22"

  Scenario: Names (BL-7, BL-147)
    Given I am on the ead page for ARC-0058
    When I follow "Subject Headings"
    Then I should see "Alternative rock music"

  Scenario: Dimensions note (see BL-124)
    Given I am on the ead page for ARC-0065ref10
    Then I should see "Limited Print Run"
    And I should see "Non-numbered edition of 200"
    And I should see "Dimensions:"
    And I should see "ChromaDepth 3D image with required glass for viewing"
    And I should see "23"
    And I should see "29"
    And I should see "Location:"
    And I should see "Drawer-Folder: FF.1.4-7, Object: 1"

  Scenario: I need to see all sub-components (BL-58)
    Given I am on the ead page for ARC-0065ref62
    Then I should see "Psycotic Pineapple, 1980 August 4-1980 September 15"
    And I should see "Ultras with Dick Dale, 1992 August 1"

  Scenario: Show accession numbers (BL-118) Note: this is revoked from BL-49
    Given I am on the ead page for ARC-0058
    Then I should see "A2005.31.15"

  Scenario: HTTP calls for components should still work (BL-55)
    Given I am on the component page for ARC-0037ref454
    Then I should see "Amnesty International tour, 1986"

  Scenario: Displaying italics (BL-33)
    Given I am on the ead page for ARC-0058
    Then I should see "New Musical Express" in "italics"
    And I should see "Esquire" in "italics"
    Given I am on the ead page for ARC-0105
    Then I should see "Blues Train" in "italics"

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

  @future-work
  Scenario: Order and titles of EAD fields as they appear in Blacklight (BL-147)
    Given I am on the ead page for ARC-0003
    Then I should see "Dates:"
    And I should see "Bulk, 1938-1969; Inclusive, 1928-2006, undated"
    And I should see "Custodial History"
    And I should not see "Custodial History note" # See IT-83 about this
    And I should see "Subject Headings"
    And I should not see "Controlled Access Headings"

  Scenario: Date expression (BL-164) and Accruals note (BL-155)
    Given I am on the ead page for ARC-0037
    Then I should see the field content "blacklight-date_display" contain "1938-2010, undated"
    And I should not see "Accruals note"
    And I should see "Accruals"

  Scenario: Displaying multiple copies of an archival item (BL-202)
    Given I am on the ead page for ARC-0006ref216
    Then I should see the field content "blacklight-location_display" contain "Box: 5, Folder: 1, Object: 4 (Original Copy)"
    Then I should see the field content "blacklight-location_display" contain "Box: 1B, Folder: 22, Object: 4 (Access Copy)"

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
    Then I should see "Normal As The Next Guy" in "italic"

  Scenario: Sidebar items (BL-295)
    Given I am on the ead page for ARC-0037
    Then I should see "Full View" in the sidebar
    And I should see "Archivist View" in the sidebar
    And I should see "General Information" in the sidebar

  Scenario: Name Headings listed as "Creator" (BL-294)
    Given I am on the ead page for ARC-0258
    Then I should see "Diltz, Henry"
    And I should not see "Subjects:"

  Scenario: corpname and persname are getting clobbered (BL-335)
    Given I am on the ead page for ARC-0058
    Then I should see "Morrison, Jim, 1943-1971"
    And I should see "Denali (Musical group)"

  Scenario: Displaying bibliographies from finding aids (BL-325)
    Given I am on the ead page for ARC-0161
    Then I should see "Bibliography"
    And I should see "All Music Guide. Accessed February 4, 2013. http://www.allmusic.com/."
    And I should see "Doo-Wop: Biography, Groups and Discography. Accessed February 4, 2013. http://doo-wop.blogg.org/."    
