# Stolen from Rails 3

# Copyright (c) 2005-2009 David Heinemeier Hansson
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Module
  attr_accessor :_setup_block
  attr_accessor :_dependencies
  
  def setup(&blk)
    @_setup_block = blk
  end
  
  def use(mod)
    return if self < mod
    
    (mod._dependencies || []).each do |dep|
      use dep
    end
    # raise "Circular dependencies" if self < mod
    include mod
    extend mod.const_get("ClassMethods") if mod.const_defined?("ClassMethods")
    class_eval(&mod._setup_block) if mod._setup_block
  end
  
  def depends_on(mod)
    return if self < mod
    @_dependencies ||= []
    @_dependencies << mod
  end
end