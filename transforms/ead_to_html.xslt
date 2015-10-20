<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:php="http://php.net/xsl"
  xsl:extension-element-prefixes="php"
>
  <xsl:param name="container_string">Containers</xsl:param>

  <xsl:template match="/">
    <div class="ead">
      <h3>Collection Guide</h3>
      <xsl:apply-templates select="//ead:archdesc"/>
    </div>
  </xsl:template>

  <xsl:template match="ead:accessrestrict">
    <fieldset class="ead-component collapsible collapsed ead-component-accessrestrict">
    <legend><span class="fieldset-legend">Access</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>  

  <xsl:template match="ead:userestrict">
    <fieldset class="ead-component collapsible collapsed ead-component-userestrict">
    <legend><span class="fieldset-legend">Publication Rights</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:prefercite">
    <fieldset class="ead-component collapsible collapsed ead-component-prefercite">
    <legend><span class="fieldset-legend">Preferred Citation</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:acqinfo">
    <fieldset class="ead-component collapsible collapsed ead-component-acqinfo">
    <legend><span class="fieldset-legend">Acquisition Information</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

<!-- FIXME - This element is not transferring into the HTML!  -->
  <xsl:template match="ead:processinfo">
    <fieldset class="ead-component collapsible collapsed ead-component-processinfo">
    <legend><span class="fieldset-legend">Processing History</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:bioghist">
    <fieldset class="ead-component collapsible collapsed ead-component-bioghist">
    <legend><span class="fieldset-legend">Biography</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:scopecontent">
    <fieldset class="ead-component collapsible collapsed ead-component-scopecontent">
    <legend><span class="fieldset-legend">Scope and Content</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:relatedmaterial">
    <fieldset class="ead-component collapsible collapsed ead-component-relatedmaterial">
    <legend><span class="fieldset-legend">Related Material</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

<!-- FIXME: Need separate templates for outer and inner instances of this element -->
  <xsl:template match="ead:controlaccess">
    <fieldset class="ead-component collapsible collapsed ead-component-controlaccess">
    <legend><span class="fieldset-legend">Indexing Terms</span></legend>
      <div class="fieldset-wrapper">
        <xsl:apply-templates select="ead:p"/>
      </div>
    </fieldset>
  </xsl:template>

<!-- This is just to handle the "Container List" heading --> 
  <xsl:template match="ead:dsc/ead:head">
      <h3>
        Container List
      </h3>
<!--    <xsl:apply-templates/>   -->
  </xsl:template>

   
<xsl:template match="ead:processinfo"/>

  <!--
    Helper template to allow the use of IDs from EAD.

    IDs generated with generate-id() will be different between different
    renderings of the document.
  -->
  <xsl:template name="get_id">
    <xsl:param name="element" select="current()"/>
    <xsl:choose>
      <xsl:when test="$element[@id]">
        <xsl:value-of select="$element/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($element)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- General display -->
  <xsl:template match="ead:c | ead:c01 | ead:c02 | ead:c03">
    <fieldset>
      <xsl:attribute name="class">
        <xsl:text>ead-component collapsible collapsed </xsl:text>
        <xsl:value-of select="concat('ead-component-', local-name())"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="concat('ead-component-type-', @level)"/>
      </xsl:attribute>
      <legend>
        <span class="fieldset-legend">
          <xsl:apply-templates select="ead:did/ead:unittitle"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="ead:did/ead:unitdate"/>
        </span>
      </legend>
      <div class="fieldset-wrapper">
        <!-- This id should be on the fieldset semantically but is here to appease Drupal. -->
        <xsl:attribute name="id">
          <xsl:call-template name="get_id"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </div>
    </fieldset>
  </xsl:template>

  <xsl:template match="ead:did">
    <xsl:variable name="contents">
      <xsl:call-template name="archdesc_did"/>
      <xsl:call-template name="container"/>
    </xsl:variable>
    <xsl:if test="normalize-space($contents)">
      <dl>
        <xsl:copy-of select="$contents"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- Handle top level did. -->
  <xsl:template name="archdesc_did">
    <xsl:if test="not(ead:container[@parent])">
      <fieldset class="ead-component collapsible collapsed ead-component-did">
      <legend><span class="fieldset-legend">Descriptive Summary</span></legend>
      <div class="fieldset-wrapper">
	<xsl:for-each select="*">
        <p>
          <xsl:apply-templates select="."/>
        </p>
      </xsl:for-each>
      </div>
      </fieldset>
    </xsl:if>
  </xsl:template>

  <!-- build definition list containing container searches. -->
  <xsl:template name="container">
    <xsl:variable name="contents">
      <xsl:choose>
        <xsl:when test="ead:container[@parent]">
          <xsl:apply-templates select="ead:container[@parent]" mode="parent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="flat_container"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="normalize-space($contents)">
      <dt>
        <xsl:value-of select="$container_string"/>
      </dt>
      <xsl:copy-of select="$contents"/>
    </xsl:if>
  </xsl:template>


<!-- The creation of folder links was originally done via a php fucntion call,
     commented out below.  Here we do it in a much simpler way, by parsing the
     "type=folder" attribute of the container element.  NOTE: FIXME: This 
     won't work if there are more than 9 series or 9 boxes!    -->
  <xsl:template name="flat_container">
    <xsl:variable name="folder_value">
      <xsl:apply-templates select="ead:container"/>    
      <xsl:value-of select="@folder"/>
    </xsl:variable>
    <xsl:variable name="pbm_id">
      <xsl:value-of select="concat(substring($folder_value,1,1),'_',substring($folder_value,3,1),'_',substring($folder_value,4))"/>
    </xsl:variable>
    <dd>
      <a>
        <xsl:attribute name="href">
          http://maccready-dev.library.caltech.edu/islandora/search/mods_identifier_ms:(PBM_<xsl:copy-of select="$pbm_id"/>)
          <!--
          <xsl:copy-of select="php:function('islandora_manuscript_build_flat_query_url', ead:container)"/>
          -->
	</xsl:attribute>
        <xsl:apply-templates select="ead:container[1]" mode="flat_text"/>
      </a>
    </dd>
  </xsl:template>


  <xsl:template match="ead:container" mode="flat_text">
    <xsl:value-of select="@type"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:variable name="sibling_content">
      <xsl:apply-templates select="following-sibling::ead:container[1]" mode="flat_text"/>
    </xsl:variable>
    <xsl:if test="normalize-space($sibling_content)">
      <xsl:text>, </xsl:text>
      <xsl:copy-of select="$sibling_content"/>
    </xsl:if>
  </xsl:template>
 
  
  <xsl:template match="ead:container" mode="parent">
    <xsl:variable name="containers" select="//ead:container"/>
    <dd>
      <a>
        <xsl:attribute name="href">
          <xsl:copy-of select="php:function('islandora_manuscript_build_parented_query_url', current(), $containers)"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="parent_text"/>
      </a>
    </dd>
  </xsl:template>
  <xsl:template match="ead:container" mode="parent_text">
    <xsl:variable name="parent" select="@parent"/>
    <xsl:variable name="parents">
      <xsl:apply-templates select="//ead:container[$parent = @id]" mode="parent_text"/>
    </xsl:variable>
    <xsl:if test="normalize-space($parents) != ''">
      <xsl:value-of select="$parents"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="@type"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()" mode="did_list"/>


  <!-- end of did/definition list stuff -->

  <xsl:template match="ead:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="ead:extref">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:value-of select="text()"/>
    </a>
  </xsl:template>
  <!-- end of general display stuff -->
</xsl:stylesheet>
