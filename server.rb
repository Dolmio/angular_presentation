Bundler.require

COMPILERS = Hash.new([]).merge(
  js: {coffee: -> js { CoffeeScript.compile js }},
  html: {haml: -> html { Haml::Engine.new(html, format: :html5).render }},
  css: {scss: -> css { Sass.compile(css, syntax: :scss) }, sass: -> css { Sass.compile(css, syntax: :sass) }}
)
TYPES = Hash.new("text/plain").merge(
  js: "application/javascript", html: "text/html", css: "text/css"
)

get '/*' do
  filename = File.basename(params[:captures].first)
  filename = "index.html" if filename.empty?
  type, content = pull_from_gist(filename)
  if type && content
    content_type type
    content
  else
    status 404
  end
end

def pull_from_gist(filename)
  extension = File.extname(filename).sub(/^\./,'')

  if files.keys.include? filename
    [TYPES[extension.to_sym], files[filename]['content']]
  else
    compiler, source = COMPILERS[extension.to_sym].map do |source_ext, compiler|
      found_sources = files.keys & ["#{File.basename(filename,".*")}.#{source_ext}", "#{filename}.#{source_ext}"]
      found_sources.empty? ? nil : [compiler, found_sources.first]
    end.compact.first
    if compiler && source
      [TYPES[extension.to_sym],compiler[files[source]['content']]]
    end
  end
end

def files
  @files ||= Hash[*Dir.glob(File.dirname(__FILE__) + "/source/*").map { |f| [File.basename(f),{'content' => File.read(f)}] }.flatten]
rescue KeyError
  {}
end
