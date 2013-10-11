# add a new method to xmlsimple
# parse only strings and avoid reading files for security reasons
class XmlSimple
  def parse_string(string = nil, options = nil)
    handle_options('in', options)

    @doc = parse(string)

    result = collapse(@doc.root)
    result = @options['keeproot'] ? merge({}, @doc.root.name, result) : result
    result
  end
end