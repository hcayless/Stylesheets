<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:contypes="http://schemas.openxmlformats.org/package/2006/content-types"
                xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="cp ve o r m v wp w10 w wne mml tbx iso its tei a xs pic fn xsi dc dcterms dcmitype contypes teidocx teix html cals">


    <xsl:import href="../utils/functions.xsl"/>
    <xsl:import href="../utils/variables.xsl"/>

    <xsl:import href="../utils/identity/identity.xsl"/>
    <xsl:import href="../utils/verbatim/tei-docx-verbatim.xsl"/>
    <xsl:import href="../utils/maths/mml2omml.xsl"/>

    
    <xsl:import href="parameters.xsl"/>

    <xsl:import href="placeholders.xsl"/>

    <!-- Deals with dynamic text creation such as toc -->
    <xsl:include href="dynamic/dynamic.xsl"/>
    
    <!-- Templates transforming graphic elements -->
    <xsl:include href="graphics/graphics.xsl"/>

    <xsl:include href="lists/lists.xsl"/>

    <!-- Templates transforming math elements -->
    <xsl:include href="maths/maths.xsl"/>

    <!-- Templates transforming tei milestones into sectPr -->
    <xsl:include href="wordsections/wordsections.xsl"/>

    <!-- Load stylesheets helping with the creation of special files -->
    <xsl:include href="docxfiles/application.xsl"/>
    <xsl:include href="docxfiles/content-types.xsl"/>
    <xsl:include href="docxfiles/endnotes.xsl"/>
    <xsl:include href="docxfiles/footers.xsl"/>
    <xsl:include href="docxfiles/comments.xsl"/>
    <xsl:include href="docxfiles/footnotes.xsl"/>
    <xsl:include href="docxfiles/headers.xsl"/>
    <xsl:include href="docxfiles/numbering-definition.xsl"/>
    <xsl:include href="docxfiles/relationships.xsl"/>
    <xsl:include href="docxfiles/settings.xsl"/>





    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet for making Word docx files from TEI XML </p>
         <p> 
            <h1 xmlns="">Stylesheet documentation</h1>
            
            <h2 xmlns="">template modes</h2>
            <h3 xmlns="">get-style</h3>
            
            <h1 xmlns="">License</h1>
            This library is free software; you can redistribute it and/or modify it under
            the terms of the GNU Lesser General Public License as published by the Free Software
            Foundation; either version 2.1 of the License, or (at your option) any later version.
            This library is distributed in the hope that it will be useful, but WITHOUT ANY
            WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
            PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details. You
            should have received a copy of the GNU Lesser General Public License along with this
            library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite
            330, Boston, MA 02111-1307 USA </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id$</p>
         <p>Copyright: 2008, TEI Consortium</p>
      </desc>
   </doc>


    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="tei:text"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8"/>


    <xsl:key name="FOOTERS" match="tei:fw[@type='footer']" use="@xml:id"/>
    <xsl:key name="HEADERS" match="tei:fw[@type='header']" use="@xml:id"/>
    <xsl:key name="ALLFOOTERS" match="tei:fw[@type='footer']" use="1"/>
    <xsl:key name="ALLHEADERS" match="tei:fw[@type='header']" use="1"/>

    <xsl:key name="ENDNOTES" match="tei:note[@place='end']" use="1"/>
    <xsl:key name="FOOTNOTES" match="tei:note[@place='foot' or @place='bottom' ]" use="1"/>

    <xsl:key name="IDS" match="tei:*[@xml:id]" use="@xml:id"/>

    <xsl:key name="OL" match="tei:list[@type='ordered']" use="1"/>
    <xsl:key name="BLIP" match="a:blip" use="1"/>
    <xsl:key name="Styles" match="w:style/w:name" use="@w:val"/>

    <xsl:variable name="align">right</xsl:variable>
    <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>


    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        The starting point in the conversion to docx.
    </desc>
   </doc>
    <xsl:template match="/tei:TEI">
      <xsl:call-template name="write-docxfiles"/>
      <xsl:call-template name="create-document-dot-xml"/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Calls templates that are responsible for creating all necessary files besides the
            main document.xml
    </desc>
   </doc>
    <xsl:template name="write-docxfiles">
        <!-- header and footers -->
        <xsl:call-template name="write-docxfile-header-files"/>

        <!-- footer files -->
        <xsl:call-template name="write-docxfile-footer-files"/>

        <!-- numbering file -->
        <xsl:call-template name="write-docxfile-numbering-definition"/>

        <!-- footnotes file -->
        <xsl:call-template name="write-docxfile-footnotes-file"/>

        <!-- endnotes file -->
        <xsl:call-template name="write-docxfile-endnotes-file"/>

        <!-- comments file -->
        <xsl:call-template name="write-docxfile-comments-file"/>

        <!-- main relationships -->
        <xsl:call-template name="write-docxfile-main-relationships"/>

        <!-- relationships -->
        <xsl:call-template name="write-docxfile-relationships"/>

        <!-- write Content Types -->
        <xsl:call-template name="write-docxfile-content-types"/>

        <!-- settings -->
        <xsl:call-template name="write-docxfile-settings"/>

        <!-- app files -->
        <xsl:call-template name="write-docxfile-docprops-core"/>
        <xsl:call-template name="write-docxfile-docprops-app"/>
        <xsl:call-template name="write-docxfile-docprops-custom"/>
    </xsl:template>


    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Create the contents of the main document.xml file, that contains all "real" content.
    </desc>
   </doc>
    <xsl:template name="create-document-dot-xml">
        <w:document>

            <w:body>
                <!-- Front -->
                <xsl:call-template name="write-document-dot-xml-frontmatter"/>

                <!-- Main -->
                <xsl:call-template name="write-document-dot-xml-maincontent"/>

                <!-- Back -->
                <xsl:call-template name="write-document-dot-xml-backmatter"/>

                <!-- Clearing up at the end -->
                <xsl:call-template name="write-document-dot-xml-postclearing"/>
            </w:body>
        </w:document>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Handles the front matter
    </desc>
   </doc>
    <xsl:template name="write-document-dot-xml-frontmatter">
        <!-- are there specific titlepages -->
        <xsl:call-template name="titlepages"/>

        <!-- header components -->
        <xsl:call-template name="headerParts"/>

        <!-- The front matter -->
        <xsl:apply-templates select="tei:text/tei:front"/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Handles the main content
    </desc>
   </doc>
    <xsl:template name="write-document-dot-xml-maincontent">
        <!-- document title -->
        <xsl:call-template name="document-title"/>

        <!-- Describes the main part of the document -->
        <xsl:apply-templates select="tei:text/tei:body"/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Handles the back matter
    </desc>
   </doc>
    <xsl:template name="write-document-dot-xml-backmatter">
        <!-- Describes the back matter of the document -->
        <xsl:apply-templates select="tei:text/tei:back"/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Inserts final word specific sections</p>
         <p> Inserts a final sectPr section if we need one </p>
      </desc>
   </doc>
    <xsl:template name="write-document-dot-xml-postclearing">

        <!-- write out final sectPr .. if exists -->
        <xsl:choose>
            <xsl:when test="tei:text/tei:milestone">
                <xsl:apply-templates select="tei:text/tei:milestone[1]">
                    <xsl:with-param name="final-section">true</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($defaultHeaderFooterFile)/tei:TEI/tei:text/tei:milestone">
                    <xsl:with-param name="final-section">true</xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Template used to process block elements:</p>
         <p> Template used to process block elements: 
	 <ul>
 	    <li><b>style</b>: A style for all the w:ps</li>
            <li><b>pPr</b>: An entire pPr element to use </li>
	    <li><b>nop</b>: a w:p has already been created and no new w:p is to be created </li>
	    <li><b>bookmark-id</b>: if present in conjunction with bookmark-name, a bookmark is created around the current element </li>
	    <li><b>bookmark-name</b>: see bookmark-id </li>
	 </ul>
	 </p>
      </desc>
   </doc>
    <xsl:template name="block-element">
        <xsl:param name="style"/>
        <xsl:param name="select" select="."/>
        <xsl:param name="pPr"/>
        <xsl:param name="nop"/>
        <xsl:param name="bookmark-id"/>
        <xsl:param name="bookmark-name"/>


        <xsl:for-each select="$select">
            <xsl:for-each-group select="*|processing-instruction()|text()" group-adjacent="1">
                <xsl:call-template name="_process-blockelement">
                    <xsl:with-param name="style" select="$style"/>
                    <xsl:with-param name="pPr" select="$pPr"/>
                    <xsl:with-param name="nop" select="$nop"/>
                    <xsl:with-param name="bookmark-id" select="$bookmark-id"/>
                    <xsl:with-param name="bookmark-name" select="$bookmark-name"/>
                </xsl:call-template>
            </xsl:for-each-group>
        </xsl:for-each>

    </xsl:template>
    <!-- end template block-element -->

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>
            This template processes block elements (or better to say the children of a block element)
            and should never be called directly 
            (call block-element instead). The function processes all children and puts
            all inline elements into one w:p. If it encounters a nested block element
            (e.g. a note inside a p) then it closes the previous w:p processes that block
            element and then again starts putting all following inline elements into another
            w:p element.
            
            @see block-element
        </p>
      </desc>
   </doc>
    <xsl:template name="_process-blockelement">
        <xsl:param name="style"/>
        <xsl:param name="pPr"/>
        <xsl:param name="nop"/>
        <xsl:param name="bookmark-id"/>
        <xsl:param name="bookmark-name"/>

        <!-- bookmark -->
        <xsl:if test="string-length($bookmark-name) &gt; 0 and string-length($bookmark-id) &gt; 0">
            <w:bookmarkStart w:id="{$bookmark-id}" w:name="{$bookmark-name}"/>
        </xsl:if>

        <!-- Process Child elements -->
        <xsl:for-each-group select="current-group()" group-starting-with="*[not(teidocx:is-inline(.))]">
            <xsl:choose>
                <!-- if the current item is a block element, we process that one,
                     and then take call this function recursively was all the other
                     elements -->
                <xsl:when test="self::*[not(teidocx:is-inline(.))]">
                    <!-- process block element -->
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="style" select="$style"/>
                        <xsl:with-param name="pPr" select="$pPr"/>
                        <xsl:with-param name="nop" select="$nop"/>
                    </xsl:apply-templates>

                    <!-- process all the other elements in the current group -->
                    <xsl:for-each-group select="current-group() except ." group-adjacent="1">
                        <xsl:call-template name="_process-blockelement">
                            <xsl:with-param name="style" select="$style"/>
                            <xsl:with-param name="pPr" select="$pPr"/>
                            <xsl:with-param name="nop" select="$nop"/>
                        </xsl:call-template>
                    </xsl:for-each-group>
                </xsl:when>

                <!-- we encountered an inline element. This means that the current group only
                     contains inline elements -->
                <xsl:otherwise>
                    <!-- create all text runs for each item in the current group. we will later
                         on decide whether we are grouping them together in a w:p or not. -->
                    <xsl:variable name="innerRuns">
                        <!-- add paragraph properties (if nobody else created a w:p ($nop)) -->
                        <xsl:if test="$nop!='true'">
                            <xsl:choose>
                                <xsl:when test="string-length($style) &gt; 0">
                                    <w:pPr>
				      <w:pStyle>
                                            <xsl:attribute name="w:val" select="$style"/>
                                        </w:pStyle>
                                    </w:pPr>
                                </xsl:when>
                                <xsl:when test="not(empty($pPr))">
                                    <xsl:copy-of select="$pPr"/>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:if>

                        <!-- Create text runs -->
                        <xsl:for-each select="current-group()">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="style" select="$style"/>
                                <xsl:with-param name="pPr" select="$pPr"/>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </xsl:variable>

                    <!-- write out text runs.
                         if someone has already created a w:p ($nop) we may not create another one. -->
                    <xsl:choose>
                        <xsl:when test="$nop='true'">
                            <xsl:copy-of select="$innerRuns"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:p>
                                <xsl:copy-of select="$innerRuns"/>
                            </w:p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
        <!-- end process children -->

        <!-- bookmark end-->
        <xsl:if test="string-length($bookmark-name) &gt; 0 and string-length($bookmark-id) &gt; 0">
            <w:bookmarkEnd w:id="{$bookmark-id}"/>
        </xsl:if>

    </xsl:template>
    <!-- end template _process-blockelement -->


    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        
        Template for all simple block elements.
        This template looks for a style definition template (mode="get-style") that
        matches the block element that is currently processed. If none is specified
        it copies the style definition from the parent element.
        
        If some special rendering is required you should overwrite this template.
        
    </desc>
   </doc>
    <xsl:template match="*[not(teidocx:is-inline(.))]" priority="-10">
        <xsl:param name="style"/>
        <xsl:param name="pPr"/>
        <xsl:param name="nop"/>

        <!-- calculate style definition -->
        <xsl:variable name="newStyle">
            <xsl:apply-templates select="." mode="get-style"/>
        </xsl:variable>
        <xsl:variable name="styleToPassOn">
            <xsl:choose>
                <xsl:when test="string-length($newStyle) &gt; 0">
                    <xsl:value-of select="$newStyle"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$style"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- process children  -->
        <xsl:call-template name="block-element">
            <xsl:with-param name="style" select="$styleToPassOn"/>
            <xsl:with-param name="pPr" select="$pPr"/>
            <xsl:with-param name="nop" select="$nop"/>
        </xsl:call-template>
    </xsl:template>
    <!-- end template simple block elements: *[not(teidocx:is-inline(.))] -->



    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        
            Template for all simple inline elements
            This template looks for a character style definition template (mode="get-style")
            for the currently processed element.
        
    </desc>
   </doc>
    <xsl:template match="*[teidocx:is-inline(.)]" priority="-10">
        <xsl:param name="character-style"/>

        <xsl:variable name="style">
            <xsl:apply-templates select="." mode="get-style"/>
        </xsl:variable>

        <xsl:variable name="use-style">
            <xsl:choose>
                <xsl:when test="(string-length($style) &gt; 0)">
                    <xsl:value-of select="$style"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$character-style"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates>
            <xsl:with-param name="character-style" select="$use-style"/>
        </xsl:apply-templates>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Handles text sections
    </desc>
   </doc>
    <xsl:template match="text()">
        <xsl:param name="character-style"/>
        <xsl:if test="parent::tei:head/parent::tei:div[@iso:status]">
            <w:r>
                <w:t>
                    <xsl:attribute name="xml:space">preserve</xsl:attribute>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="../../@iso:status"/>
                    <xsl:text>) </xsl:text>
                </w:t>
            </w:r>
        </xsl:if>
        <w:r>
            <!-- if no specific style is assigned we might check for any other indication to assign 
                some style ... -->
            <xsl:variable name="renderingProperties">
                <xsl:call-template name="applyRend"/>
            </xsl:variable>

            <xsl:if test="string-length($character-style) &gt; 0 or not(empty($renderingProperties))">
                <w:rPr>
                    <xsl:if test="string-length($character-style) &gt; 0">
                        <w:rStyle>
                            <xsl:attribute name="w:val" select="$character-style"/>
                        </w:rStyle>
                    </xsl:if>
		    <xsl:copy-of select="$renderingProperties"/>
		    <xsl:if test="ancestor::*[@xml:lang]">
		      <w:lang w:val="{ancestor::*[@xml:lang][1]/@xml:lang}"/>
		    </xsl:if>
                </w:rPr>
            </xsl:if>

            <xsl:call-template name="Text"/>
        </w:r>
    </xsl:template>



    <xsl:template name="Text">
        <xsl:choose>
            <xsl:when test="parent::w:body">
                <xsl:message terminate="yes">CDATA found in body! [<xsl:value-of select="."/>]</xsl:message>
            </xsl:when>
            <xsl:otherwise>
	      <xsl:variable name="out">
		<xsl:choose>
		  <xsl:when test=".=' ' or ../@xml:space='preserve'">
		    <xsl:value-of select="."/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:if test="starts-with(.,' ') or starts-with(.,'&#xA;')">
		      <xsl:text> </xsl:text>
		    </xsl:if>
		    <xsl:value-of select="normalize-space(.)"/>
		    <xsl:if test="substring(.,string-length(.),1)=' '">
		      <xsl:text> </xsl:text>
		    </xsl:if>
		    <xsl:if test="substring(.,string-length(.),1)='&#xA;'">
		      <xsl:text> </xsl:text>
		    </xsl:if>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:variable>
	      <xsl:choose>
		<xsl:when test="contains($out,'&#2011;')">
		  <w:t>
		    <xsl:attribute
			name="xml:space">preserve</xsl:attribute>
		    <xsl:value-of select="substring-before($out,'&#2011;')"/>
		  </w:t>
		  <w:noBreakHyphen/>
		  <w:t>
		    <xsl:attribute
			name="xml:space">preserve</xsl:attribute>
		    <xsl:value-of select="substring-after($out,'&#2011;')"/>
		  </w:t>
		</xsl:when>
		<xsl:otherwise>
		  <w:t>
		    <xsl:attribute
			name="xml:space">preserve</xsl:attribute>
		    <xsl:value-of select="$out"/>
		  </w:t>
		</xsl:otherwise>
	      </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        
            Style definition templates: 
            No default Style for any block or inline element
        
    </desc>
   </doc>
    <xsl:template match="*" mode="get-style"/>


    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc> 
        to a given style name, this template returns the correct style id
        looking it up in styles.xml 
    </desc>
   </doc>
    <xsl:template name="getStyleName">
        <xsl:param name="in"/>

        <xsl:for-each select="document($styleDoc,/)">
            <xsl:for-each select="key('Styles',$in)">
                <xsl:value-of select="parent::w:style/@w:styleId"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Tests whether to add rendering elements to a run.
        Word styles cannot not be added in applyRend. If you want to add
        a style go for a get-style template. The order of these
	elements in Word does matter, by the way.

     </desc>
   </doc>
    <xsl:template name="applyRend">
        <xsl:for-each select="..">
            <!-- use a custom font -->
	    <xsl:choose>
	      <xsl:when test="@iso:font">
		<w:rFonts w:ascii="{@iso:font}"
			  w:hAnsi="{@iso:font}"/>
	      </xsl:when>
	      <!-- typewriter font -->
	      <xsl:when test="contains(@rend,'typewriter') or teidocx:render-typewriter(.)">
		<w:rFonts w:ascii="Courier" w:hAnsi="Courier"/>
	      </xsl:when>
	    </xsl:choose>

            <!-- bold -->
            <xsl:choose>
                <xsl:when test="teidocx:render-bold(.)">
                    <w:b/>
                </xsl:when>
                <xsl:when test="self::tei:hi[not(@rend)]">
                    <w:b/>
                </xsl:when>
                <xsl:when test="contains(@rend,'bold')">
                    <w:b/>
		</xsl:when>
            </xsl:choose>

            <!-- italic -->
            <xsl:choose>
                <xsl:when test="contains(@rend,'italic') or teidocx:render-italic(.)">
                    <w:i/>
                </xsl:when>
                <xsl:when test="self::tei:emph">
                    <w:i/>
                </xsl:when>
            </xsl:choose>

	    <!-- small caps -->
            <xsl:if test="contains(@rend,'smallcaps')">
                <w:smallCaps/>
            </xsl:if>

	    <!-- all caps -->
            <xsl:if test="contains(@rend,'capsall')">
                <w:caps/>
            </xsl:if>

	    <!-- strikethrough -->
            <xsl:if test="contains(@rend,'strikethrough')">
	      <w:strike/>
	    </xsl:if>
            <xsl:if test="contains(@rend,'strikedoublethrough')">
	      <w:dstrike/>
	    </xsl:if>
	    
	    <!-- colour -->
	    <xsl:if test="contains(@rend,'color(')">
		<w:color w:val="{substring-before(substring-after(@rend,'color('),')')}"/>
	    </xsl:if>

	    <!-- background color -->
	    <xsl:if test="contains(@rend,'background(')">
		<w:highlight w:val="{substring-before(substring-after(@rend,'background('),')')}"/>
	    </xsl:if>

	    <!-- underline -->
            <xsl:if test="contains(@rend,'underline')">
	      <w:u w:val="single"/>
	    </xsl:if>
            <xsl:if test="contains(@rend,'underdoubleline')">
	      <w:u w:val="double"/>
	    </xsl:if>

	    <!-- sub- and superscript -->
            <xsl:if test="contains(@rend,'subscript')">
                <w:vertAlign w:val="subscript"/>
            </xsl:if>
            <xsl:if test="contains(@rend,'superscript')">
                <w:vertAlign w:val="superscript"/>
            </xsl:if>

        </xsl:for-each>
    </xsl:template>

    <!-- 
        Footnotes
    -->
    <xsl:template name="create-footnote">
        <xsl:variable name="num">
            <xsl:number count="tei:note[@place='foot' or @place='bottom' ]" level="any"/>
        </xsl:variable>
        <xsl:variable name="id" select="$num+1"/>
        <w:r>
            <w:rPr>
                <w:rStyle w:val="FootnoteReference"/>
            </w:rPr>
            <w:footnoteReference w:id="{$id}"/>
        </w:r>
        <w:r>
            <w:t xml:space="preserve"> </w:t>
        </w:r>
    </xsl:template>

    <xsl:template name="create-comment">
      <w:r>
	<w:rPr>
	  <w:rStyle w:val="CommentReference"/>
	  <w:vanish/>
	</w:rPr>
	<xsl:variable name="n">
	  <xsl:number level="any"  count="tei:note[@place='comment']" />
	</xsl:variable>
	<w:commentReference w:id="{$n - 1}"/>
      </w:r>
    </xsl:template>

    <!-- 
        Endnotes
    -->
    <xsl:template name="create-endnote">
        <xsl:variable name="num">
            <xsl:number count="tei:note[@place='end']" level="any"/>
        </xsl:variable>
        <xsl:variable name="id" select="$num+1"/>
        <w:r>
            <w:rPr>
                <w:rStyle w:val="EndnoteReference"/>
                <w:noProof/>
            </w:rPr>
            <w:endnoteReference w:id="{$id}"/>
        </w:r>
        <w:r>
            <w:t xml:space="preserve"> </w:t>
        </w:r>
    </xsl:template>


    <!--
        Headers and Sections  
    -->
    <xsl:template match="tei:head[parent::tei:div or parent::tei:div1 or parent::tei:div2 or parent::tei:div3 or parent::tei:div4 or parent::tei:div5 or parent::tei:div6 or parent::tei:div7]">

      <!-- find out what level we are at -->
      <xsl:variable name="level">
	<xsl:value-of select="count(ancestor-or-self::tei:div| ancestor-or-self::tei:div1| ancestor-or-self::tei:div2| ancestor-or-self::tei:div3| ancestor-or-self::tei:div4| ancestor-or-self::tei:div5| ancestor-or-self::tei:div6| ancestor-or-self::tei:div7)"/>
      </xsl:variable>
      
        <xsl:variable name="number">
            <xsl:number level="any"/>
        </xsl:variable>

        <xsl:call-template name="block-element">
            <!-- we want a bookmark for referencing this section -->
            <xsl:with-param name="bookmark-id">
                <xsl:value-of select="1000+$number"/>
            </xsl:with-param>
            <xsl:with-param name="bookmark-name">
                <xsl:text>_SECTION_</xsl:text>
                <xsl:value-of select="1000+$number"/>
            </xsl:with-param>

            <!-- find the correct header style -->
            <xsl:with-param name="style">
                <xsl:variable name="style" select="teidocx:get-headingstyle(.,$level)"/>
                <xsl:choose>
                    <xsl:when test="string-length($style) &gt; 0">
                        <xsl:call-template name="getStyleName">
                            <xsl:with-param name="in" select="$style"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getStyleName">
                            <xsl:with-param name="in">
                                <xsl:text>heading </xsl:text>
                                <xsl:value-of select="$level"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  
   


    <!-- quoted text -->
    <xsl:template match="tei:q">
        <w:r>
            <w:t>
                <xsl:value-of select="$preQuote"/>
            </w:t>
        </w:r>
        <xsl:apply-templates/>
        <w:r>
            <w:t>
                <xsl:value-of select="$postQuote"/>
            </w:t>
        </w:r>
    </xsl:template>

    <!-- TBX -->

    <xsl:template match="tbx:termEntry">
        <w:p>
            <w:pPr>
                <w:pStyle w:val="TermNum"/>
            </w:pPr>
            <w:r>
                <w:t>
                    <xsl:value-of select="translate(@id,'eid-','')"/>
                </w:t>
            </w:r>
        </w:p>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="Terms"/>
            </w:pPr>
            <w:r>
                <w:t>
                    <xsl:apply-templates select=".//tbx:term"/>
                </w:t>
            </w:r>
        </w:p>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="Definition"/>
            </w:pPr>
            <w:r>
                <w:t>
                    <xsl:value-of select="tbx:descrip[@type='definition']"/>
                </w:t>
            </w:r>
        </w:p>
    </xsl:template>

    <!-- 
        GI
    -->

    <xsl:template match="tei:hi[@rend='specList-elementSpec']">
        <w:r>
            <w:t>&lt;</w:t>
        </w:r>
        <xsl:apply-templates/>
        <w:r>
            <w:t>&gt;</w:t>
        </w:r>
    </xsl:template>

    <xsl:template match="tei:gi">
        <w:r>
            <w:t>&lt;</w:t>
        </w:r>
        <xsl:apply-templates/>
        <w:r>
            <w:t>&gt;</w:t>
        </w:r>
    </xsl:template>


    <!-- 
        Handle examples
    -->
    <xsl:template match="teix:egXML">
        <xsl:param name="simple">false</xsl:param>
        <xsl:param name="highlight"/>
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:cell">egXMLTable</xsl:when>
                    <xsl:otherwise>egXML</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="select">
                <tei:p>
                    <xsl:call-template name="create-egXML-section"/>
                </tei:p>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:eg">
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:cell">egXMLTable</xsl:when>
                    <xsl:otherwise>egXML</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="select">
                <tei:p>
                    <xsl:attribute name="xml:space">preserve</xsl:attribute>
                    <xsl:for-each select="tokenize(.,'\n')">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test=".='' and position()=1"/>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                                <tei:lb/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </tei:p>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <!-- 
        Handle TEI tables 
    -->
    <xsl:template match="tei:table">
        <xsl:call-template name="table-header"/>
        <w:tbl>
            <xsl:choose>
                <xsl:when test="w:tblPr">
                    <xsl:copy-of select="w:tblPr"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:tblPr>
                        <w:tblW w:w="0" w:type="auto"/>
                        <w:jc w:val="center"/>
                        <w:tblBorders>
                            <w:top w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:left w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:right w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:insideV w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:insideH w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </w:tblBorders>
                    </w:tblPr>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="html:colgroup">
                    <w:tblGrid>
                        <xsl:for-each select="html:colgroup/html:col">
                            <w:gridCol>
                                <xsl:attribute name="w:w" select="teidocx:convert-dim-pt20(@width)"/>
                            </w:gridCol>
                        </xsl:for-each>
                    </w:tblGrid>
                </xsl:when>
                <!-- if it is defined in word's namespace -->
                <xsl:when test="w:tblGrid">
                    <xsl:copy-of select="w:tblGrid"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:tblGrid>
                        <xsl:for-each select="tei:row[1]/tei:cell">
                            <w:gridCol w:w="500"/>
                            <!-- notional amount -->
                        </xsl:for-each>
                    </w:tblGrid>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="tei:row"/>
        </w:tbl>
        <w:p/>
    </xsl:template>

    <xsl:template name="table-header">
        <xsl:if test="tei:head">
            <xsl:for-each select="tei:head[1]">
                <xsl:call-template name="block-element">
                    <xsl:with-param name="style">Tabletitle</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:row">
        <w:tr>
            <xsl:choose>
                <xsl:when test="w:trPr">
                    <xsl:copy-of select="w:trPr"/>
                </xsl:when>
                <xsl:otherwise> </xsl:otherwise>
            </xsl:choose>
            <w:tblPrEx>
                <w:tblLayout w:type="autofit"/>
            </w:tblPrEx>
            <xsl:apply-templates select="tei:cell"/>
        </w:tr>
    </xsl:template>

    <xsl:template match="tei:cell">
        <w:tc>
            <xsl:choose>
                <xsl:when test="w:tcPr">
                    <xsl:copy-of select="w:tcPr"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:tcPr>
                        <!--w:tcW w:w="1915" w:type="dxa"/-->
                        <xsl:if test="@cols">
                            <w:gridSpan w:val="{@cols}"/>
                        </xsl:if>
                    </w:tcPr>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="tei:note">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="block-element">
                        <xsl:with-param name="pPr">
                            <w:pPr>
                                <xsl:choose>
                                    <xsl:when test="@rend">
                                        <xsl:variable name="sName">
                                            <xsl:call-template name="getStyleName">
                                                <xsl:with-param name="in" select="@rend"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$sName=''">
                                                <w:pStyle w:val="{$TableText}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <w:pStyle w:val="{$sName}"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <w:pStyle w:val="{$TableText}"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="@teidocx:align">
                                        <w:jc w:val="{@align}"/>
                                    </xsl:when>
                                    <xsl:when test="parent::tei:row[@role='label']          or @role='label'">
                                        <w:jc w:val="left"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with(.,'[0-9]')">
                                        <w:jc w:val="right"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <w:jc w:val="left"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </w:pPr>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <!-- If we have no children, put an empty p here -->
            <xsl:if test="not(descendant::text())">
	           <w:p>
		             <w:pPr>
		                <w:pStyle w:val="Tabletext9"/>
		             </w:pPr>
		             <w:r>
		                <w:t/>
		             </w:r>
	           </w:p>
	        </xsl:if>
        </w:tc>
    </xsl:template>

    <!-- Handle CALS tables -->
    <xsl:template match="cals:table">
        <xsl:call-template name="cals-table-header"/>
        <w:tbl>
            <w:tblPr>
                <w:tblW w:w="0" w:type="auto"/>
                <w:jc w:val="center"/>
                <w:tblBorders>
                    <xsl:choose>
                        <xsl:when test="@frame='none'">
                            <w:top w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:left w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:right w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="@frame='top'">
                            <w:top w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:left w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:right w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="@frame='bottom'">
                            <w:top w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:left w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:right w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="@frame='topbot'">
                            <w:top w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:left w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:right w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="@frame='sides'">
                            <w:top w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:left w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
                            <w:right w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="@frame='all'">
                            <w:top w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:left w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                            <w:right w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@rowsep=1">
                            <w:insideH w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:insideH w:val="none" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@colsep=1">
                            <w:insideV w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:insideV w:val="none" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:tblBorders>
                <w:tblLayout w:type="fixed"/>
            </w:tblPr>
            <xsl:choose>
                <xsl:when test="cals:tgroup/cals:colspec">
                    <w:tblGrid>
                        <xsl:for-each select="cals:tgroup/cals:colspec">
                            <w:gridCol>
                                <xsl:attribute name="w:w">
				  <xsl:choose>
				    <xsl:when test="contains(@colwidth,'*')">
				      <xsl:value-of
					  select="number($pageWidth *
						  number(substring-before(@colwidth,'*'))
						  div 10)
						  cast as
						  xs:integer"/>
				    </xsl:when>
				    <xsl:otherwise>
				      <xsl:value-of
					  select="teidocx:convert-dim-pt20(@colwidth)"/>
				    </xsl:otherwise>
				  </xsl:choose>
				</xsl:attribute>
                            </w:gridCol>
                        </xsl:for-each>
                    </w:tblGrid>
                </xsl:when>
                <xsl:otherwise>
                    <w:tblGrid>
                        <xsl:for-each select="cals:row[1]/cals:entry">
                            <w:gridCol w:w="500"/>
                            <!-- notional amount -->
                        </xsl:for-each>
                    </w:tblGrid>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="cals:tgroup"/>
        </w:tbl>
        <w:p/>
    </xsl:template>


    <xsl:template name="cals-table-header">
        <xsl:if test="cals:title">
            <xsl:for-each select="cals:title[1]">
                <xsl:call-template name="block-element">
                    <xsl:with-param name="style">Tabletitle</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="cals:tgroup">
        <xsl:variable name="TABLE">
            <xsl:copy>
                <xsl:copy-of select="cals:colspec"/>
                <cals:tbody>
                    <xsl:for-each select="cals:tbody/cals:row">
                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
                            <xsl:for-each select="cals:entry">
                                <xsl:copy>
                                    <xsl:copy-of select="@*"/>
                                    <xsl:apply-templates mode="contents" select="."/>
                                </xsl:copy>
                                <xsl:variable name="rows" select="@rowsep"/>
                                <xsl:if test="@namest">
                                    <xsl:variable name="start">
                                        <xsl:value-of select="ancestor::cals:tgroup/cals:colspec[@colname=current()/@namest]/@colnum"/>
                                    </xsl:variable>
                                    <xsl:variable name="end">
                                        <xsl:value-of select="ancestor::cals:tgroup/cals:colspec[@colname=current()/@nameend]/@colnum"/>
                                    </xsl:variable>
                                    <xsl:for-each select="ancestor::cals:tgroup/cals:colspec[position()&gt;$start        and position()&lt;=$end]">
                                        <cals:entry DUMMY="true" colname="{@colname}" rowsep="{$rows}"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:for-each>
                </cals:tbody>
            </xsl:copy>
        </xsl:variable>
	<!--
	<xsl:variable name="count">
	  <xsl:number level="any"/>
	</xsl:variable>
	  <xsl:result-document indent="yes" href="/tmp/T{$count}.xml">
	    <xsl:copy-of select="$TABLE"/>
	  </xsl:result-document>
	  -->
	  <xsl:for-each select="$TABLE/cals:tgroup">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="cals:row">
        <xsl:variable name="ROWPOS">
            <xsl:number/>
        </xsl:variable>
        <xsl:variable name="TEMPLATE">
            <xsl:for-each select="ancestor::cals:tgroup/cals:colspec">
                <CELL name="{@colname}" rowpos="{$ROWPOS}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ME" select="."/>
        <w:tr>
            <w:tblPrEx>
                <w:tblLayout w:type="autofit"/>
            </w:tblPrEx>
            <xsl:for-each select="$TEMPLATE/CELL">
                <xsl:variable name="N" select="@name"/>
                <xsl:choose>
                    <xsl:when test="$ME/cals:entry[@colname=$N and @DUMMY='true']"/>
                    <xsl:when test="$ME/cals:entry[@colname=$N]">
                        <xsl:apply-templates select="$ME/cals:entry[@colname=$N]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <w:tc>
                            <w:tcPr>
                                <w:vMerge/>
                            </w:tcPr>
                            <w:p> </w:p>
                        </w:tc>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </w:tr>
    </xsl:template>

    <xsl:template match="cals:entry">
        <xsl:variable name="colname" select="@colname"/>
        <w:tc>
            <w:tcPr>
                <xsl:if test="@namest">
                    <xsl:variable name="start">
                        <xsl:value-of select="ancestor::cals:tgroup/cals:colspec[@colname=current()/@namest]/@colnum"/>
                    </xsl:variable>
                    <xsl:variable name="end">
                        <xsl:value-of select="ancestor::cals:tgroup/cals:colspec[@colname=current()/@nameend]/@colnum"/>
                    </xsl:variable>
                    <w:gridSpan w:val="{number($end)-number($start)+1}"/>
                </xsl:if>
                <xsl:if test="@morerows">
                    <w:vMerge w:val="restart"/>
                </xsl:if>
                <!--
	    <xsl:message><xsl:value-of select="$colname"/>
	    (<xsl:value-of select="."/>):    <xsl:value-of
	    select="@rowsep"/> and <xsl:value-of
	    select="parent::cals:row/preceding-sibling::cals:row[1]/cals:entry[@colname=$colname]/@rowsep"/></xsl:message>
	    -->
                <xsl:variable name="borders">
                    <xsl:choose>
                        <xsl:when test="parent::cals:row/preceding-sibling::cals:row[1]/cals:entry[@colname=$colname]/@rowsep=0">
                            <w:top w:val="nil"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@colsep='0'">
                            <w:left w:val="nil"/>
                        </xsl:when>
                        <xsl:when test="@colsep='1'">
                            <w:left w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                        <xsl:when test="following-sibling::cals:entry[1]/@colsep=0">
                            <w:right w:val="nil"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@rowsep='0'">
                            <w:bottom w:val="nil"/>
                        </xsl:when>
                        <xsl:when test="@rowsep='1'">
                            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="auto"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$borders/*">
                    <w:tcBorders>
                        <xsl:copy-of select="$borders/w:top"/>
                        <xsl:copy-of select="$borders/w:left"/>
                        <xsl:copy-of select="$borders/w:bottom"/>
                        <xsl:copy-of select="$borders/w:right"/>
                    </w:tcBorders>
                </xsl:if>
                <xsl:if test="@rotate='1'">
                    <w:textDirection w:val="btLr"/>
                </xsl:if>
                <xsl:if test="@valign">
                    <w:vAlign>
                        <xsl:attribute name="w:val">
                            <xsl:attribute name="valign">
                                <xsl:choose>
                                    <xsl:when test="@valign='middle'">center</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@valign"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:attribute>
                    </w:vAlign>
                </xsl:if>
            </w:tcPr>
	        <xsl:copy-of select="*"/>
        </w:tc>
    </xsl:template>


    <xsl:template match="cals:entry" mode="contents">
      <xsl:call-template name="block-element">
	        <xsl:with-param name="pPr">
	           <w:pPr>
	              <xsl:choose>
	                 <xsl:when test="@rend">
		                   <xsl:variable name="sName">
		                      <xsl:call-template name="getStyleName">
		                         <xsl:with-param name="in" select="@rend"/>
		                      </xsl:call-template>
		                   </xsl:variable>
		                   <xsl:choose>
		                      <xsl:when test="$sName=''">
		                         <w:pStyle w:val="{$TableText}"/>
		                      </xsl:when>
		                      <xsl:otherwise>
		                         <w:pStyle w:val="{$sName}"/>
		                      </xsl:otherwise>
		                   </xsl:choose>
	                 </xsl:when>
	                 <xsl:otherwise>
		                   <w:pStyle w:val="{$TableText}"/>
	                 </xsl:otherwise>
	              </xsl:choose>
	              <xsl:choose>
	                 <xsl:when test="@align">
		                   <w:jc w:val="{@align}"/>
	                 </xsl:when>
	                 <xsl:when test="parent::tei:row[@role='label']    or @role='label'">
		                   <w:jc w:val="left"/>
	                 </xsl:when>
	                 <xsl:when test="starts-with(.,'[0-9]')">
		                   <w:jc w:val="right"/>
	                 </xsl:when>
	                 <xsl:otherwise>
		                   <w:jc w:val="left"/>
	                 </xsl:otherwise>
	              </xsl:choose>
	           </w:pPr>
	        </xsl:with-param>
	        <xsl:with-param name="nop">
	           <xsl:choose>
	              <xsl:when test="not(text()) and tei:note[(not(@place))]">true</xsl:when>
	              <xsl:when test="not(text()) and tei:note[@place='foot']">true</xsl:when>
	              <xsl:otherwise>false</xsl:otherwise>
	           </xsl:choose>
	        </xsl:with-param>
      </xsl:call-template>

      <!-- If we have no children, put an empty p here -->
      <xsl:choose>
	        <xsl:when test="*"/>
	        <xsl:when test="text()"/>
	        <xsl:otherwise>
	           <w:p>
	              <w:pPr>
	                 <w:pStyle w:val="Tabletext9"/>
	              </w:pPr>
	              <w:r>
	                 <w:t/>
	              </w:r>
	           </w:p>
	        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- 
	 Inline Templates:
    -->
    <xsl:template match="tei:g[@ref='x:tab']">
        <w:r>
            <w:tab/>
        </w:r>
    </xsl:template>

    <xsl:template match="tei:c[@rend='ptab']">
        <w:r>
            <w:ptab w:relativeTo="margin" w:alignment="{@type}" w:leader="none"/>
        </w:r>
    </xsl:template>


    <xsl:template match="tei:lb">
        <w:r>
            <w:br/>
        </w:r>
    </xsl:template>

    <xsl:template match="tei:cit">
      <xsl:if test="@n">
	        <w:r>
	           <w:t>
	              <xsl:text>(</xsl:text>
	              <xsl:value-of select="@n"/>
	              <xsl:text>) </xsl:text>
	           </w:t>
	        </w:r>
      </xsl:if>
      <w:r>
	        <w:rPr>
	           <w:pStyle w:val="Quote"/>
	        </w:rPr>
	        <xsl:apply-templates/>
      </w:r>
    </xsl:template>

    <!-- hyperlink -->
    <xsl:template match="tei:ptr">
        <w:r>
            <w:fldChar w:fldCharType="begin"/>
        </w:r>
        <w:r>
            <w:instrText>HYPERLINK "<xsl:value-of select="@target"/>" \h</w:instrText>
        </w:r>
        <w:r>
            <w:fldChar w:fldCharType="separate"/>
        </w:r>
        <w:r w:rsidR="00765EBE">
            <w:rPr>
                <w:rStyle w:val="Hyperlink"/>
                <w:u w:val="none"/>
            </w:rPr>
            <w:t>
                <xsl:choose>
                    <xsl:when test="starts-with(@target,'#')">
                        <xsl:apply-templates select="key('IDS',substring-after(@target,'#'))" mode="xref"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@target"/>
                    </xsl:otherwise>
                </xsl:choose>
            </w:t>
        </w:r>
        <w:r>
            <w:fldChar w:fldCharType="end"/>
        </w:r>
        <!--
      <w:r>
          <w:rPr>
            <w:rStyle w:val="Hyperlink"/>
          </w:rPr>

	<w:instrText>HYPERLINK "<xsl:value-of select="@target"/>"\h</w:instrText>
      </w:r>
-->
        <!--
	<xsl:variable name="rid">
	  <xsl:text>rId</xsl:text>
	  <xsl:variable name="n">
	    <xsl:number level="any"/>
	  </xsl:variable>
	  <xsl:value-of select="$n + 3000"/>
	</xsl:variable>
      <w:hyperlink r:id="{$rid}">
        <w:r>
          <w:rPr>
            <w:rStyle w:val="Hyperlink"/>
          </w:rPr>
          <w:t>
	    <xsl:value-of select="@target"/>
	  </w:t>
	</w:r>
      </w:hyperlink>
-->

    </xsl:template>

    <xsl:template match="tei:note|tei:figure|tei:table|tei:item" mode="xref">
        <xsl:number/>
    </xsl:template>

    <xsl:template match="tei:div" mode="xref">
        <xsl:number count="tei:div" from="tei:body|tei:front|tei:back" level="multiple"/>
    </xsl:template>

    <!-- 
       §< Handle elements from different namespaces, such as wordML, wordMathML, MathML ...
        -->


    <xsl:template match="w:drawing">
        <w:r>
            <xsl:apply-templates select="." mode="iden"/>
        </w:r>
    </xsl:template>

    <xsl:template match="iso:wordObject">
        <xsl:apply-templates/>
    </xsl:template>



    <xsl:template match="w:*">
        <xsl:if test="ancestor::w:tbl">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>


    <xsl:template match="tei:titlePage/tei:docTitle/tei:titlePart[@type='main']">
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">Title</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:titlePage/tei:docTitle/tei:titlePart[@type='sub']">
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">Subtitle</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- place holders, used by ISO profile -->


    <!-- no handling of index terms -->

    <xsl:template match="tei:index"/>
</xsl:stylesheet>