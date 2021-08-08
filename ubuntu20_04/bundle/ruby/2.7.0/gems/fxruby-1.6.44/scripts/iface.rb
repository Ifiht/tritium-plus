#! /usr/bin/env ruby

require "getoptlong"

##
# IFace data stucture
#
class IFace
	attr_accessor :cat

	def initialize
		@cat = []
		changeCat(nil)
	end

	def changeCat(_name)
		@currentCat = IFaceCat.new(_name)
		@cat << @currentCat
	end

	def addEmpty
		@currentCat.addEntry(IFaceEmpty.new)
	end

	def addComment(_text)
		@currentCat.addEntry(IFaceComment.new(_text))
	end

	def addVal(_name, _code)
		@currentCat.addEntry(IFaceVal.new(_name, _code))
	end

	def addFun(_name, _code, _return, _args)
		@currentCat.addEntry(IFaceFun.new(_name, _code, _return, _args))
	end

	def addGet(_name, _code, _return, _args)
		@currentCat.addEntry(IFaceGet.new(_name, _code, _return, _args))
	end

	def addSet(_name, _code, _return, _args)
		@currentCat.addEntry(IFaceSet.new(_name, _code, _return, _args))
	end

	def addEvt(_name, _code, _return, _args)
		@currentCat.addEntry(IFaceEvt.new(_name, _code, _return, _args))
	end
end

class IFaceCat
	attr_reader :name, :entries

	def initialize(_name)
		@name = _name
		@entries = []
	end

	def addEntry(_entry)
		@entries << _entry
	end
end

class IFaceEmpty
	def accept(visitor)
		visitor.visitIFaceEmpty(self)
	end
end

class IFaceComment
	attr_reader :text

	def initialize(_text)
		@text = _text
	end

	def accept(visitor)
		visitor.visitIFaceComment(self)
	end
end

class IFaceVal
	attr_reader :name, :code

	def initialize(_name, _code)
		@name = _name
		@code = _code
	end

	def accept(visitor)
		visitor.visitIFaceVal(self)
	end
end

class IFaceFunArg
	attr_reader :name, :type
	def initialize(_name, _type)
		@name = _name
		@type = _type
	end
end

class IFaceFun < IFaceVal
	attr_reader :return, :args

	def initialize(_name, _code, _return, _args)
		super(_name, _code)
		@return = _return
		@args = []
		_args.each do |arg|
			@args << IFaceFunArg.new(arg[1], arg[0])
		end
	end

	def accept(visitor)
		visitor.visitIFaceFun(self)
	end
end

class IFaceGet < IFaceFun
	def initialize(_name, _code, _return, _args)
		super
	end

	def accept(visitor)
		visitor.visitIFaceGet(self)
	end
end

class IFaceSet < IFaceFun
	def initialize(_name, _code, _return, _args)
		super
	end

	def accept(visitor)
		visitor.visitIFaceSet(self)
	end
end

class IFaceEvt < IFaceFun
	def initialize(_name, _code, _return, _args)
		super
	end

	def accept(visitor)
		visitor.visitIFaceEvt(self)
	end
end

##
# IFace parser
#
class IFaceParser
	def initialize(_input, _output)
		@input = _input
		@output = _output
		@iface = IFace.new
	end

	def process
		@input.each_line do |line|
			case line
			when /^##/
			when /^$/
				processEmpty
			when /^#(.*)/
				processComment $1
			else
				command, args = line.split(/\s+/, 2)
				processCommand(command, args)
			end
		end
		@iface
	end

	def processEmpty
		@iface.addEmpty
	end

	def processComment(_comment)
		@iface.addComment(_comment)
	end

	def processCommand(_cmd, _args)
		unless _cmd.empty?
			process = "process" + _cmd[0..0].upcase + _cmd[1..-1]
			if respond_to?(process)
				method(process).call(_args)
			else
				puts "*** Unknown cmd: #{_cmd} #{_args}"
			end
		end
	end

	def processCat(_cat)
		@iface.changeCat(_cat)
	end

	def processVal(_val)
		name, value = _val.split(/\s*=\s*/)
		@iface.addVal(name, value)
	end

	def parseFun(_fun)
		returnType, _fun = _fun.split(/\s+/, 2)
		name, _fun = _fun.split(/\s*=\s*/, 2)
		_fun =~ /(\d+)\s*\((.*)\)/
		code = $1
		_fun = $2.split(/\s*,\s*/, -1)
		args = _fun.collect do |arg|
			argType, argName = arg.split
			argType, argName = nil, nil if argName == ""
			[argType, argName]
		end
		[name, code, returnType, args]
	end

	def processFun(_fun)
		name, code, returnType, args = parseFun(_fun)
		@iface.addFun(name, code, returnType, args)
	end

	def processGet(_fun)
		name, code, returnType, args = parseFun(_fun)
		@iface.addGet(name, code, returnType, args)
	end

	def processSet(_fun)
		name, code, returnType, args = parseFun(_fun)
		@iface.addSet(name, code, returnType, args)
	end

	def processEvt(_fun)
		name, code, returnType, args = parseFun(_fun)
		@iface.addEvt(name, code, returnType, args)
	end

	def processEnu(_enu)
	end

	def processLex(_lex)
	end
end

##
# Code to generate Scintilla.rb from an IFace data structure
#
class ScintillaIFaceToRuby
	def initialize(_iface, _output)
		@iface = _iface
		@output = _output
		@reserved = Hash["end", "last", "setFocus", "setFocusFlag"]
	end

	def generateHeader
		@output.puts("# This file is automatically generated from Scintilla.iface")
		@output.puts("# DO NOT MODIFY")
		@output.puts
	end

	def generate
		generateHeader
		@output.puts("module Fox")
		@output.puts("  class FXScintilla")
		@iface.cat.each do |cat|
			@output.puts("    # #{cat.name}")
			cat.entries.each do |entry|
				entry.accept(self)
			end
		end
		@output.puts("  end")
		@output.puts("end")
	end

	def visitIFaceEmpty(_empty)
		@output.puts
	end

	def visitIFaceComment(_comment)
		@output.puts("    ##{_comment.text}")
	end

	def visitIFaceVal(_val)
		return if _val.name == "KeyMod"
		return if _val.name == "Lexer"
		@output.puts("    #{name(_val.name)} = #{_val.code}")
	end

	def visitIFaceFun(_fun)
		stringresult = _fun.args[1].type == "stringresult" and _fun.return == "int"
		stringresult1 = (stringresult and _fun.args[0].name == nil)

		name = name(_fun.name[0..0].downcase + _fun.name[1..-1])
		@output.print("    def #{name}")
		args = _fun.args.collect do |arg|
			if stringresult and arg.type == "stringresult"
				nil
			else
				name(arg.name)
			end
		end
		args.compact!
		@output.print("(#{args.join(', ')})") unless args.empty?
		@output.puts

		if stringresult and !stringresult1
			@output.puts("      buffer = \"\".ljust(#{_fun.args[0].name})")
		end

		returnValue = "sendMessage(#{_fun.code}"
		_fun.args.each do |arg|
			if stringresult and !stringresult1 and arg.type == "stringresult"
				returnValue += ", buffer"
			else
				returnValue += ", #{arg.name ? typeArg(arg.type, name(arg.name)) : 0}"
			end
		end
		returnValue += ")"

		if stringresult and !stringresult1
			@output.puts("      #{returnValue}")
			@output.puts("      buffer")
		else
			@output.puts("      #{typeRet(_fun.return, returnValue)}")
		end
		@output.puts("    end")
	end

	def visitIFaceGet(_get)
		visitIFaceFun(_get)
	end

	def visitIFaceSet(_set)
		visitIFaceFun(_set)
	end

	def visitIFaceEvt(_evt)
		name = "SCN_" + _evt.name.upcase
		@output.puts("    #{name} = #{_evt.code}")
	end

	def typeArg(_type, _value)
		case _type
		when "colour"
			"#{_value} & 0xffffff"
		else
			_value
		end
	end

	def typeRet(_type, _value)
		case _type
		when "bool"
			"#{_value} == 1 ? true : false"
		else
			_value
		end
	end

	def name(_name)
		name = @reserved[_name]
		name ? name : _name
	end
end

def main
	options = GetoptLong.new(["-i", GetoptLong::REQUIRED_ARGUMENT],
													 ["-o", GetoptLong::REQUIRED_ARGUMENT])

	input = output = nil
	options.each do |opt, arg|
		case opt
		when "-i"
			input = File.open(arg, File::RDONLY)
		when "-o"
			output = File.open(arg, File::CREAT|File::WRONLY|File::TRUNC)
		end
	end
	input = $stdin unless input
	output = $stdout unless output

	parser = IFaceParser.new(input, output)
	iface = parser.process

	gen = ScintillaIFaceToRuby.new(iface, output)
	gen.generate
ensure
	input.close
	output.close
end

main
