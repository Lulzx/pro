require "myhtml"

html = <<-HTML
  <html>
    <body>
      <div><div> <h1>Example Domain</h1> <p>This is a paragraph</p>
      <b>some bold text</b><i>italics text</i>
</div></div>
    </body>
  </html>
HTML

myhtml = Myhtml::Parser.new(html)

puts myhtml.to_pretty_html