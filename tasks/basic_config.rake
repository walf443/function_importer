AUTHOR            = "Keiji, Yoshimi"
EMAIL             = "walf443 at gmail.com"
RUBYFORGE_PROJECT = "akasakarb"
RUBYFORGE_PROJECT_ID = 4314
HOMEPATH          = "http://walf443.github.com/function_importer/"
RDOC_OPTS = [
	"--charset", "utf-8",
	"--opname", "index.html",
	"--line-numbers",
	"--main", "README",
	"--inline-source",
  "--accessor", "has=rw",
  '--exclude', '^(example|extras)/'
]
DEFAULT_EXTRA_RDOC_FILES = ['README', 'ChangeLog']
PKG_FILES = [ 'Rakefile' ] + 
  DEFAULT_EXTRA_RDOC_FILES +
  Dir.glob('{bin,lib,test,spec,doc,bench,example,tasks,script,generator,templates,extras,website}/**/*') + 
  Dir.glob('ext/**/*.{h,c,rb}') +
  Dir.glob('examples/**/*.rb') +
  Dir.glob('tools/*.rb')

[ %r{^doc/.+\.pdf}, %r{^doc/.+\.key} ].each do |ignore|
  PKG_FILES.delete_if {|file| file =~ ignore }
end

EXTENSIONS = FileList['ext/**/extconf.rb'].to_a
