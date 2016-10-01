<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:l="http://xproc.org/library"
                xpath-version="2.0"
                type="l:validator.nu">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:option name="uri" select="'http://validator.nu/'"/>
  <p:option name="out" select="'xml'"/>
  <p:option name="showsource" select="''"/>
  <p:option name="level" select="''"/>
  <p:option name="schema" select="''"/>
  <p:option name="laxtype" select="''"/>
  <p:option name="parser" select="''"/>
  <p:option name="asciiquotes" select="''"/>

  <p:variable name="href"
              select="concat($uri, '?',
                             if ($out = '') then 'out=xml' else concat('out=',$out),
                             if ($showsource = '') then '' else concat('&amp;showsource=',$showsource),
                             if ($level = '') then '' else concat('&amp;level=',$level),
                             if ($schema = '') then '' else concat('&amp;schema=',$schema),
                             if ($laxtype = '') then '' else concat('&amp;laxtype=',$laxtype),
                             if ($parser = '') then '' else concat('&amp;parser=',$parser),
                             if ($asciiquotes = '') then '' else concat('&amp;asciiquotes=',$asciiquotes))"/>

  <p:choose>
    <p:when test="/c:body">
      <p:identity/>
    </p:when>
    <p:otherwise>
      <p:wrap wrapper="c:body" match="/"/>
      <p:add-attribute match="/c:body" attribute-name="content-type" attribute-value="application/xml"/>
    </p:otherwise>
  </p:choose>

  <p:wrap wrapper="c:request" match="/"/>
  <p:add-attribute match="/c:request" attribute-name="href">
    <p:with-option name="attribute-value" select="$href"/>
  </p:add-attribute>
  <p:add-attribute match="/c:request" attribute-name="method" attribute-value="post"/>

  <p:http-request/>
</p:declare-step>
