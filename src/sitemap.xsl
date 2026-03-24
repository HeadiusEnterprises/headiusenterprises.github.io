<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:s="http://www.sitemaps.org/schemas/sitemap/0.9">

  <xsl:output method="html" encoding="UTF-8" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Sitemap — <xsl:value-of select="count(s:urlset/s:url)" /> URLs</title>
        <style>
          body { font-family: 'JetBrains Mono', monospace; color: #f5f0ea; background: #0e0b0c; max-width: 960px; margin: 2rem auto; padding: 0 1rem; }
          h1 { font-size: 1.5rem; margin-bottom: 0.25rem; }
          p { color: #8a7f78; margin-bottom: 1.5rem; }
          table { width: 100%; border-collapse: collapse; }
          th { text-align: left; border-bottom: 2px solid #6c071e; padding: 0.5rem; font-size: 0.85rem; color: #8a7f78; }
          td { border-bottom: 1px solid #2a2425; padding: 0.5rem; font-size: 0.85rem; }
          a { color: #b83050; }
          tr:hover td { background: #181415; }
        </style>
      </head>
      <body>
        <h1>Sitemap</h1>
        <p><xsl:value-of select="count(s:urlset/s:url)" /> URLs</p>
        <table>
          <tr>
            <th>URL</th>
            <th>Last Modified</th>
          </tr>
          <xsl:for-each select="s:urlset/s:url">
            <tr>
              <td><a href="{s:loc}"><xsl:value-of select="s:loc" /></a></td>
              <td><xsl:value-of select="substring(s:lastmod, 1, 10)" /></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
