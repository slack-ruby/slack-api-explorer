module Shellwords
  # returns args, pipe
  def self.parse(expression)
    tokens, pipe = expression.split('|', 2)
    pipe = pipe.strip.tr('‘', "'").tr('“', '"') if pipe
    [Shellwords.shellwords(tokens), pipe]
  end
end
