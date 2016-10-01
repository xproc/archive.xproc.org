<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
		xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:l="http://xproc.org/library"
                type="l:http-get">
  <p:output port="result"/>
  <p:option name="href" required="true"/>
  <p:option name="username"/>
  <p:option name="password"/>
  <p:option name="auth-method" select="'Basic'"/>
  <p:option name="send-authorization" select="'false'"/>
  <p:option name="override-content-type"/>

  <p:choose>
    <p:when test="p:value-available('username')">
      <p:template>
        <p:input port="template">
          <p:inline>
            <c:request method="get" href="{$href}" detailed="false" status-only="false"
                       username="{$username}" password="{$password}" auth-method="{$auth-method}"
                       send-authorization="{$send-authorization}"/>
          </p:inline>
        </p:input>
        <p:input port="source"><p:empty/></p:input>
        <p:with-param name="href" select="$href"/>
        <p:with-param name="username" select="$username"/>
        <p:with-param name="password" select="$password"/>
        <p:with-param name="auth-method" select="$auth-method"/>
        <p:with-param name="send-authorization" select="$send-authorization"/>
      </p:template>
    </p:when>
    <p:otherwise>
      <p:template>
        <p:input port="template">
          <p:inline>
            <c:request method="get" href="{$href}" detailed="false" status-only="false"/>
          </p:inline>
        </p:input>
        <p:input port="source"><p:empty/></p:input>
        <p:with-param name="href" select="$href"/>
      </p:template>
    </p:otherwise>
  </p:choose>

  <p:choose>
    <p:when test="p:value-available('override-content-type')">
      <p:add-attribute match="/c:request" attribute-name="override-content-type">
        <p:with-option name="attribute-value" select="$override-content-type"/>
      </p:add-attribute>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>

  <p:http-request/>

  <p:choose>
    <p:when test="starts-with(/c:body/@content-type,'text/html') and /c:body/@encoding = 'base64'
                  and contains(/c:body/@content-type, 'charset')">
      <p:unescape-markup content-type="text/html" encoding="base64"/>
    </p:when>
    <p:when test="starts-with(/c:body/@content-type,'text/html') and /c:body/@encoding = 'base64'">
      <!-- Per RFC 2616, the default charset for text/* types is ISO 8859-1 -->
      <p:unescape-markup content-type="text/html" encoding="base64" charset="iso-8859-1"/>
    </p:when>
    <p:when test="starts-with(/c:body/@content-type,'text/html')">
      <p:unescape-markup content-type="text/html"/>
    </p:when>
    <p:when test="/c:body/@content-type = 'application/json'">
      <p:unescape-markup content-type="application/json" encoding="base64" charset="utf-8"/>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>

  <p:choose>
    <p:when test="/c:body/*">
      <p:unwrap match="/c:body"/>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>
</p:declare-step>
