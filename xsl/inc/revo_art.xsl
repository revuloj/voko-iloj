<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<!-- (c) 1999-2020 ĉe Wolfram Diestel  laŭ GPLv2

reguloj por la prezentado de la artikolostrukturo

-->

<xsl:variable name="mathjax-url">https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=AM_CHTML</xsl:variable>

<!-- kruda artikolstrukturo -->

<xsl:template match="/">
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="viewport" content="width=device-width,initial-scale=1"/>
      <xsl:if test="//frm[@am]">
        <script type="text/javascript" async="async" src="{$mathjax-url}"></script>
      </xsl:if>
      <xsl:if test="$aspekto='ilustrite'">
      	<link title="artikolo-stilo" type="text/css" rel="stylesheet" href="{$cssdir}/artikolo.css" />
      </xsl:if>
      <title><xsl:apply-templates select="//art/kap[1]" mode="titolo"/></title>
      <script type="text/javascript">
	<xsl:text>&lt;!--
	top.document.title = 'Reta Vortaro [</xsl:text>
	<xsl:value-of select="normalize-space(//art/kap[1])"/>
	<xsl:text>]';
	</xsl:text>
	<xsl:text>//--&gt;</xsl:text>
      </script>
     
    </head>
    <body>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="art/kap" mode="titolo">
  <xsl:apply-templates select="rad|text()"/>
</xsl:template>


<!-- art, subart -->

<xsl:template match="art">
  <header>
    <!-- flagoj de la tradukoj 
    <xsl:if test="$aspekto='ilustrite'">
      <xsl:call-template name="flagoj"/>
    </xsl:if>
    -->
  </header>

  <article>
      <section class="art">
      <xsl:choose>

        <!-- se enestas subartikoloj aŭ rekte sencoj prezentu per dl-listo -->
        <xsl:when test="subart|snc">
          <xsl:apply-templates select="kap"/>
          <dl>
            <xsl:apply-templates select="node()[not(self::kap)]"/>
          </dl>
        </xsl:when>

        <!-- prezentu la derivaĵojn ktp. -->
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>

      </xsl:choose>
    </section>

    <!-- prezentu tradukojn en propra alineo 
    <section class="tradukoj">
      <xsl:call-template name="tradukoj"/>
    </section>
    -->

    <!-- prezentu fontoreferencojn en propra alineo -->
    <section class="fontoj">
      <xsl:call-template name="fontoj"/>
    </section>

    <!-- administraj notoj -->
    <section class="admin">
      <xsl:call-template name="admin"/>
    </section>

  </article>

  <!-- piedlinio -->
  <footer>
    <hr />
    <xsl:call-template name="redakto"/>
  </footer>
</xsl:template>


<!-- subartikolo -->

<xsl:template match="subart">
  <dt class="subart">
    <xsl:if test="@mrk">
      <xsl:attribute name="id">
        <xsl:value-of select="@mrk"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:number format="I."/>
  </dt>
  <dd>
    <xsl:choose>

      <xsl:when test="snc">
        <xsl:apply-templates select="kap"/>
        <dl>
          <xsl:apply-templates select="node()[not(self::kap)]"/>
        </dl>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>

    </xsl:choose>
  </dd>
</xsl:template> 


<!-- derivajhoj -->

<xsl:template match="drv">
  <!-- xsl:apply-templates select="tez" mode="ref"/ -->
  <div class="deriv">
    <xsl:apply-templates select="kap"/>
    <div class="kasxebla">
      <xsl:apply-templates select="gra|uzo|fnt|dif|ref[@tip='dif']"/>
      <dl>
        <xsl:apply-templates select="subdrv|snc"/>
      </dl>  
      <xsl:apply-templates
        select="node()[
          not(
            self::subdrv|
            self::snc|
            self::gra|
            self::uzo|
            self::fnt|
            self::kap|
            self::dif|
            self::mlg|
            self::ref
          [@tip='dif'])]"/>
    </div>
  </div>
</xsl:template>  
	

<!-- subderivajho -->

<xsl:template match="subdrv">
  <dt>
    <xsl:if test="@mrk">
      <xsl:attribute name="id">
        <xsl:value-of select="@mrk"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:number format="A."/>

    <!-- tezauroligo -->
    <xsl:comment>[[
      ref="<xsl:value-of select="ancestor::drv/@mrk"/><xsl:number format="A"/>"
    ]]</xsl:comment>

  </dt>

  <dd>
    <xsl:apply-templates select="dif|gra|uzo|fnt|ref[@tip='dif']"/>

    <dl>
      <xsl:apply-templates select="snc"/>
    </dl>

    <xsl:apply-templates
      select="node()[
       not(
         self::snc|
         self::gra|
         self::uzo|
         self::fnt|
         self::dif|
         self::ref
       [@tip='dif'])]"/>    
  </dd>
</xsl:template>


<!-- kapvorto de derivajho -->

<xsl:template match="drv/kap">
  <h2 id="{ancestor::drv/@mrk}">
    <xsl:apply-templates/>
    <xsl:apply-templates select="../mlg"/>

    <!-- tezauroligo -->
    <xsl:comment>[[
      ref="<xsl:value-of select="ancestor::drv/@mrk"/>"
    ]]</xsl:comment>
  </h2>  
</xsl:template>

<!-- sencoj/subsencoj -->

<xsl:template match="subart" mode="number-of-ref-snc">
  <xsl:number from="subart" count="subart" format="I"/>
</xsl:template>

<xsl:template match="snc" mode="number-of-ref-snc">
  <xsl:number from="drv|subart" level="any" count="snc"/>
</xsl:template>

<xsl:template match="subsnc" mode="number-of-ref-snc">
  <xsl:number from="drv|subart" level="multiple" count="snc|subsnc"
    format="1.a"/>
</xsl:template>

<xsl:template match="rim" mode="number-of-ref-snc">
  rim. <xsl:value-of select="@num"/>
</xsl:template>


<xsl:template match="snc">
  <!-- xsl:apply-templates select="tez" mode="ref"/ -->

  <dt>
    <xsl:if test="@mrk">
      <xsl:attribute name="id">
        <xsl:value-of select="@mrk"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>

      <xsl:when test="@ref">
        <xsl:apply-templates mode="number-of-ref-snc" select="id(@ref)"/>:
      </xsl:when>

      <xsl:when test="count(ancestor::node()[self::drv or self::subart][1]//snc)>1">
        <xsl:number from="drv|subart" level="any" count="snc" format="1."/>
        <xsl:choose>

          <xsl:when test="@mrk">			       
            <xsl:comment>[[ref="<xsl:value-of select="@mrk"/>"]]</xsl:comment>
          </xsl:when>

          <xsl:otherwise>
            <xsl:comment>[[
              ref="<xsl:value-of select="ancestor::drv/@mrk"/>
              <xsl:number from="drv|subart" level="any" count="snc" format=".1"/>"
            ]]</xsl:comment>

          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

    </xsl:choose>
  </dt>

  <dd>
    <xsl:apply-templates select="gra|uzo|fnt|dif|ref[@tip='dif']"/>

    <xsl:if test="subsnc">
      <dl>
        <xsl:apply-templates select="subsnc"/>
      </dl>
    </xsl:if>

    <xsl:apply-templates
        select="node()[
          not(
           self::gra|
           self::uzo|
           self::fnt|
           self::dif|
           self::subsnc|
           self::ref
         [@tip='dif'])]"/>
  </dd>
</xsl:template>  


<xsl:template match="subsnc">
  <!-- xsl:apply-templates select="tez" mode="ref"/ -->

  <dt>
    <xsl:if test="@mrk">
      <xsl:attribute name="id">
        <xsl:value-of select="@mrk"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
       <xsl:when test="@ref">
          <xsl:apply-templates mode="number-of-ref-snc" select="id(@ref)"/>:
       </xsl:when>
       <xsl:otherwise>
         <xsl:number format="a)"/>
       </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="@mrk">			       
        <xsl:comment>[[ref="<xsl:value-of select="@mrk"/>"]]</xsl:comment>
      </xsl:when>

      <xsl:otherwise>
        <xsl:comment>[[
          ref="<xsl:value-of select="ancestor::drv/@mrk"/>
          <xsl:number format="a"/>"
        ]]</xsl:comment>
      </xsl:otherwise>

    </xsl:choose>
  </dt>
  <dd>
  <xsl:apply-templates/>
  </dd>
</xsl:template>


<xsl:template name="tezauro">
  <xsl:if test="@tez">
    &#xa0;<a href="{@tez}" class="tez-ref" target="indekso" title="al la teza&#x016d;ro">&#x219D;</a>
<!--    
      <img src="../smb/tezauro.png" class="tez" alt="TEZ" 
           title="al la teza&#x016d;ro" border="0"/>
    </a> -->
  </xsl:if>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>














