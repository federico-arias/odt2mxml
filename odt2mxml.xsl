<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
  xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
  exclude-result-prefixes="text xsl fo office style table draw xlink form script config number svg">

<xsl:output indent="yes"
    omit-xml-declaration="no"
    />
<xsl:strip-space elements="*" />
  
<xsl:key name="respuestas" match="text:list[not(following-sibling::*[1][self::text:list])]" use="generate-id(preceding-sibling::text:p[1])" />

<xsl:template match="/">
	<quiz>
        <xsl:apply-templates select="office:document/office:body/office:text" />
	</quiz>
</xsl:template>
  
<!--<question type="multichoice|truefalse|shortanswer|matching|cloze|essay|numerical|description">-->

<!-- every paragraph followed by a list -->
<xsl:template match="office:text/text:p[following-sibling::*[1][self::text:list]]">
    <question type="multichoice">
        <!--<xsl:attribute name="type">
            </xsl:attribute>
        -->
      <xsl:variable name="alternativas" select="key('respuestas', generate-id(current()))" />
         <name>
             <text> <xsl:value-of select="concat('Pregunta ', count(preceding-sibling::text:p[following-sibling::*[1][self::text:list]]) + 1)"/></text>
         </name>
         <questiontext format="html">
             <text>
                 <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                     <!--get previous paragraph -->
                     <xsl:if test="preceding-sibling::*[1][self::text:p]">
                         <xsl:value-of select="preceding-sibling::*[1][self::text:p]" />
                     </xsl:if>

                     <xsl:if test="not(draw:frame)">
                         <xsl:value-of select="." />
                     </xsl:if>

                     <!-- Type K items -->
                     <xsl:if test="following-sibling::text:list[2][preceding-sibling::text:p[1] = current()]">
                             <ol style="list-style-type:upper-roman;">
                                 <xsl:apply-templates select="following-sibling::text:list[1]/text:list-item" mode="makehtml" />
                             </ol>
                     </xsl:if>

                     <xsl:if test="draw:frame">
                         <xsl:variable name="base64" select="draw:frame/draw:image/office:binary-data"/>
                         <img>
                             <xsl:attribute name="src">
                                 <xsl:value-of select="concat('data:;base64,', $base64)"/>
                             </xsl:attribute>
                         </img>
                     </xsl:if>

                 <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
             </text>
         </questiontext>

         <xsl:apply-templates select="key('respuestas', generate-id(current()))" />

         <single>
             <!--
           <xsl:choose>
             <xsl:when test="count($alternativas/text:list-item/text:p/emphasis[1]) > 1">
                 <xsl:text>true</xsl:text>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:text>false</xsl:text>
             </xsl:otherwise>
           </xsl:choose>
           -->
            <xsl:text>true</xsl:text>
         </single> 
      
        <shuffleanswers>1</shuffleanswers>
        <answernumbering>abc</answernumbering>
    </question>

</xsl:template>

<xsl:template match="text:list" name="answers">
     
         <xsl:apply-templates select="text:list-item" />
     
</xsl:template>

<xsl:template match="text:list-item" >
  <answer>
         <xsl:attribute name="fraction">
             <xsl:choose>
                 <xsl:when test="text:p/text:span[@text:style-name = 'Emphasis' or @text:style-name = 'Énfasis']">
                     <xsl:text>100</xsl:text>
                </xsl:when>
             <xsl:otherwise>
                     <xsl:text>0</xsl:text>
             </xsl:otherwise>
           </xsl:choose>
         </xsl:attribute>
         <text><xsl:value-of select="text:p" /></text>
  </answer>
</xsl:template>

<xsl:template match="text:list-item" mode="makehtml">
    <li>
        <xsl:value-of select="." />
    </li> 
</xsl:template>

</xsl:stylesheet>
