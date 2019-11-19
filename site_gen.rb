#!/usr/bin/env ruby
page_head = <<~HTML
<!--head-->
<html>
  <head>
    <meta charset="utf-8" />
    <link href="https://fonts.googleapis.com/css?family=IBM+Plex+Sans|IBM+Plex+Serif&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/turbolinks@5.2.0/dist/turbolinks.js" integrity="sha256-iM4Yzi/zLj/IshPWMC1IluRxTtRjMqjPGd97TZ9yYpU=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="style.css">
    <!--/head-->
HTML

page_header = <<~HTML
    <!--header-->
    <header>
      <nav>
        <ul>
          <li><a href="index.html">Introductie</a></li>
          <li><a href="turbolinks.html">Turbolinks</a></li>
          <li><a href="stimulus.html">Stimulus</a></li>
          <li><a href="totslot.html">Tot slot</a></li>
        </ul>
      </nav>
    </header>
    <!--/header-->
HTML

Dir.glob("*.html").each do |html_filename|
  file_contents = File.read(html_filename)
  file_contents = file_contents.gsub(/<!--header-->((.|\n)*)<!--\/header-->/m,page_header)
  file_contents = file_contents.gsub(/<!--head-->((.|\n)*)<!--\/head-->/m,page_head)
  File.open(html_filename, 'w+') do |f|
    f.puts(file_contents)
  end
end
