<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:ns2="http://www.w3.org/1999/xlink">

    <!-- <xsl:strip-space elements="*"/> -->
    <xsl:output indent="yes" method="html"/>
    <!-- <xsl:include href="/Users/adamw/Projects/Rails/blacklight-app/current/blacklight-app/xsl/lookupLists.xsl"/> -->

    <!-- Creates the html partial of the finding aid.-->
    <xsl:template match="/">
      <div id="ead_body">
        <!-- General information section appears in horizontal format using <dl> -->
        <h2>General Information</h2>
        <dl class="defList">
          <dt>Title:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:unittitle"/></dd>
          <dt>Extent:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:physdesc"/></dd>
          <dt>Dates:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:unitdate"/></dd>
          <dt>Language of Finding Aid:</dt>
          <dd><xsl:apply-templates select="//ead:eadheader/ead:profiledesc/ead:langusage"/></dd>
          <dt>Language of Materials:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:langmaterial"/></dd>
          <dt>Preferred Citation:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:prefercite/ead:p"/></dd>
          <dt>Custodial History:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:custodhist/ead:p"/></dd>
          <dt>Use Restrictions:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:userestrict/ead:p"/></dd>
          <dt>Access Restrictions:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:accessrestrict/ead:p"/></dd>
          <dt>Processing Information:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:processinfo/ead:p"/></dd>
        </dl>

        <h2 id="abstract">Collection Overview</h2>
        <p><xsl:apply-templates select="//ead:archdesc/ead:did/ead:abstract"/></p>

        <xsl:apply-templates select="//ead:archdesc/ead:bioghist"/>
        <xsl:apply-templates select="//ead:archdesc/ead:relatedmaterial"/>
        <xsl:apply-templates select="//ead:archdesc/ead:separatedmaterial"/>
        <xsl:apply-templates select="//ead:archdesc/ead:accruals"/>

        <h2 id="subjects">Subject Headings</h2>
        <dl class="defList">
          <dt>Persons:</dt>
          <dd><ul>
            <xsl:apply-templates select="//ead:archdesc/ead:controlaccess/ead:persname"/>
          </ul></dd>
           <dt>Genreform:</dt>
          <dd><ul>
            <xsl:apply-templates select="//ead:archdesc/ead:controlaccess/ead:genreform"/>
          </ul></dd>
          <dt>Subjects:</dt>
          <dd><ul>
            <xsl:apply-templates select="//ead:archdesc/ead:controlaccess/ead:subject"/>
          </ul></dd>
        </dl>

        <h2 id="inventory">Collection Inventory</h2>
        <div id="dsc">
          <xsl:apply-templates select="//ead:archdesc/ead:dsc"/>
        </div>

      </div>

    </xsl:template>

    <xsl:template match="ead:head">
      <xsl:variable name="id" select="local-name(parent::*)"/>
      <xsl:choose>
        <xsl:when test="parent::ead:chronlist"><h4><xsl:apply-templates/></h4></xsl:when>
        <xsl:when test="parent::ead:list"><h4><xsl:apply-templates/></h4></xsl:when>
        <xsl:when test="ancestor::ead:c"><h5><xsl:apply-templates/></h5></xsl:when>
        <xsl:otherwise><h2 id="{$id}"><xsl:apply-templates/></h2></xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- Anything in the xml <p> tag, gets am html <p> tag -->
    <xsl:template match="ead:p">
      <xsl:choose>
        <xsl:when test="ancestor::ead:c"><p><xsl:apply-templates/></p></xsl:when>
        <xsl:otherwise><p><xsl:apply-templates/></p></xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- Format date display -->
    <xsl:template match="ead:did/ead:unitdate">
      <xsl:choose>
        <xsl:when test="@type='inclusive'">Inclusive, <xsl:apply-templates/><xsl:if test="following-sibling::ead:unitdate != ''">; </xsl:if></xsl:when>
        <xsl:when test="@type='bulk'"><xsl:apply-templates/><xsl:if test="following-sibling::ead:unitdate != ''">; </xsl:if></xsl:when>
      </xsl:choose>
    </xsl:template>

    <!-- Formats biography/history bits -->
    <xsl:template match="ead:chronlist">
      <dl class="defList"><xsl:apply-templates/></dl>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:date">
      <dt><xsl:apply-templates/></dt>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:event">
      <dd><xsl:apply-templates/></dd>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:eventgrp">
      <dd><ul><xsl:apply-templates/></ul></dd>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:eventgrp/ead:event">
      <li><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="ead:list/ead:item">
      <p class="hangingindent"><xsl:apply-templates/></p>
    </xsl:template>

    <!-- Subject headings -->
    <xsl:template match="ead:controlaccess/ead:persname">
      <li><a href="/"><xsl:apply-templates/></a></li>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:genreform">
      <li><a href="/"><xsl:apply-templates/></a></li>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:subject">
      <li><a href="/"><xsl:apply-templates/></a></li>
    </xsl:template>

    <!-- Puts a space between multiple nodes -->
    <xsl:template match="ead:extent | ead:unitdate">
      <xsl:apply-templates/>
      <xsl:text>&#160;</xsl:text>
    </xsl:template>




    <!-- Format for html display -->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><xsl:apply-templates/></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong>"<xsl:apply-templates/>"</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong>'<xsl:apply-templates/>'</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><em><xsl:apply-templates/></em></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><span class="smcaps"><xsl:apply-templates/></span></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><span class="underline"><xsl:apply-templates/></span></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>"<xsl:apply-templates/>"
    </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><em><xsl:apply-templates/></em>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>'<xsl:apply-templates/>'
    </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><span class="smcaps"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><sub><xsl:apply-templates/></sub>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><sup><xsl:apply-templates/></sup>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><span class="underline"><xsl:apply-templates/></span>
    </xsl:template>


    <!-- Non-numbered components -->

    <xsl:template match="ead:c">
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="depth" select="count(ancestor::ead:c) + 1"/>
      <div id="{$id}" class="component_part clearfix c0{$depth}"><xsl:apply-templates/></div>
    </xsl:template>


    <xsl:template match="//ead:c/ead:did/ead:unittitle">
      <h3>
        <xsl:apply-templates/>
        <xsl:if test="self::ead:unittitle != ''">, </xsl:if>
        <xsl:value-of select="following::ead:unitdate"/>
      </h3>
    </xsl:template>

    <xsl:template match="//ead:c/ead:did/ead:container">
      <xsl:if test="self::ead:container/@label != ''">
        <p>Type: <xsl:value-of select="self::ead:container/@label"/></p>
      </xsl:if>
      <xsl:value-of select="self::ead:container/@type"/>: <xsl:value-of select="self::ead:container"/>
      <xsl:if test="following-sibling::ead:container != ''">,&#160;</xsl:if></xsl:if>
    </xsl:template>

    <!-- empty template to skip unitdate since it's dealt with in unittitle -->
    <xsl:template match="//ead:c/ead:did/ead:unitdate"/>
    <!-- supress all accession numbers -->
    <!--
    <xsl:template match="//ead:c/ead:odd">
      <xsl:choose>
        <xsl:when test="contains(., 'Museum Accession Number')"> </xsl:when>
        <xsl:otherwise> <xsl:apply-templates/> </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    -->
    <!-- supress only accession numbers marked as internal -->
    <xsl:template match="//ead:c/ead:odd[@audience='internal']"/>



    <!-- Random things... -->
    <xsl:template match="text()[not(string-length(normalize-space()))]"/>

    <xsl:template match="text()[string-length(normalize-space()) > 0]">
      <xsl:value-of select="translate(.,'&#xA;&#xD;', '  ')"/>
    </xsl:template>

    <xsl:template name="print-step">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+count(preceding-sibling::*)"/>
      <xsl:text>]</xsl:text>
    </xsl:template>

</xsl:stylesheet>
