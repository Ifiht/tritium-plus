require 'fox16'
require './cpu.rb'

include Fox

def loadIcon(filename)
	begin
		filename = File.join(".", "icons", filename)
		icon = nil
		File.open(filename, "rb") { |f|
		  icon = FXPNGIcon.new(getApp(), f.read)
		}
		icon
	rescue
		raise RuntimeError, "Couldn't load icon: #{filename}"
	end
end

class EightBitVM < FXMainWindow

	def initialize(app)
		# Invoke the base class initialize first
		super(app, "8-bit VM", :opts => DECOR_TITLE|DECOR_CLOSE|DECOR_BORDER|DECOR_MENU, :width => 800, :height => 700)
		@inst_mem = "".rjust(19683, '0')
		@data_mem = "".rjust(19683, '0')
		@prog_mem = @inst_mem + "101010101" + @data_mem
		@newicon = loadIcon("blind.png")
		# Make menu bar
		menubar = FXMenuBar.new(self, LAYOUT_FILL_X)
		filemenu = FXMenuPane.new(self)
		helpmenu = FXMenuPane.new(self)
		FXMenuTitle.new(menubar, "&File", nil, filemenu)
		FXMenuTitle.new(menubar, "&Help", nil, helpmenu, LAYOUT_RIGHT)
		FXMenuCommand.new(filemenu, "&Quit\tCtl-Q", nil, getApp(), FXApp::ID_QUIT)
		FXMenuCommand.new(helpmenu, "&About 8-bit VM").connect(SEL_COMMAND) {
			FXMessageBox.information(self, MBOX_OK, "About 8-bit VM",
				"A simple 8 bit machine to execute a minimal instruction set\n")
		}

		# Splitter
		splitter_v = FXSplitter.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		splitter_h = FXSplitter.new(splitter_v, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_HORIZONTAL|SPLITTER_TRACKING)
		
		# Add a left panel
		lpanel = FXHorizontalFrame.new(splitter_h, 
			FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)

		splitter_lpanel = FXSplitter.new(lpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)

		FXLabel.new(splitter_lpanel, "|%==========[ CODE EDITOR ]==========%|", :opts => JUSTIFY_CENTER_X ).setFont(FXFont.new(getApp(), "Consolas", 14, FONTWEIGHT_BOLD))
		@input_text = FXText.new(splitter_lpanel, self, 
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, :height => 450)#400,400,400,400, 0,0,0,0)
		FXLabel.new(splitter_lpanel, "|%===============[ OUTPUT ]==============%|", :opts => JUSTIFY_CENTER_X ).setFont(FXFont.new(getApp(), "Consolas", 12, FONTWEIGHT_BOLD))
		@output_text = FXText.new(splitter_lpanel, self,
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X, :height => 300)

		# Center Button
		btn = FXButton.new(splitter_h, "=>\nRUN\n=>", nil,
			self, (ICON_ABOVE_TEXT|BUTTON_TOOLBAR|FRAME_RAISED|LAYOUT_TOP|LAYOUT_LEFT))

		# Add a right panel
		rpanel = FXHorizontalFrame.new(splitter_h, FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		reg_splitter = FXSplitter.new(rpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		FXLabel.new(reg_splitter, "Reg $B:")
		$reg_B = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $C:")
		$reg_C = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $D:")
		$reg_D = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $E:")
		$reg_E = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $F:")
		$reg_F = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $G:")
		$reg_G = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $K:")
		$reg_K = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $O:")
		$reg_O = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $P:")
		$reg_P = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $Y:")
		$reg_Y = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
			FXLabel.new(reg_splitter, "Reg $Z:")
		$reg_Z = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
    	 	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
		FXHorizontalSeparator.new(reg_splitter, SEPARATOR_NONE|LAYOUT_FILL_Y)
		splitter_rpanel = FXSplitter.new(rpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		FXLabel.new(splitter_rpanel, "Memory contents (data<0, inst>0):", :opts => JUSTIFY_CENTER_X ).setFont(FXFont.new(getApp(), "Consolas", 11, FONTWEIGHT_BOLD))
		@tx_memory = FXText.new(splitter_rpanel, self, TEXT_READONLY|TEXT_WORDWRAP|
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,300,300, 0,0,0,0)

		$reg_B.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_C.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_D.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_E.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_F.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_G.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_K.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_O.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_P.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_Y.setFont(FXFont.new(getApp(), "Consolas", 7))
		$reg_Z.setFont(FXFont.new(getApp(), "Consolas", 7))

		$reg_B.text = trans10to3($regB.vlu)
		$reg_C.text = trans10to3($regC.vlu)
		$reg_D.text = trans10to3($regD.vlu)
		$reg_E.text = trans10to3($regE.vlu)
		$reg_F.text = trans10to3($regF.vlu)
		$reg_G.text = trans10to3($regG.vlu)
		$reg_K.text = trans10to3($regK.vlu)
		$reg_O.text = trans10to3($regO.vlu)
		$reg_P.text = trans10to3($regP.vlu)
		$reg_Y.text = trans10to3($regY.vlu)
		$reg_Z.text = trans10to3($regZ.vlu)

		# Now make the directory list widget (dirlist) the message target
		# for the text field. If you type a new directory name in the text
		# field the directory list should navigate to that directory.
		@tx_memory.visibleRows = 30
		@tx_memory.selector = FXWindow::ID_SETVALUE
		@tx_memory.text = @prog_mem
		@tx_memory.textStyle = TEXT_WORDWRAP
		@tx_memory.setFont(FXFont.new(getApp(), "Consolas", 9))

		@input_text.target = @text_r
		@input_text.visibleRows = 30
		@input_text.selector = FXWindow::ID_SETVALUE
		@input_text.setFont(FXFont.new(getApp(), "Consolas", 12))

		@output_text.setFont(FXFont.new(getApp(), "Consolas", 10))

		@state = [$regB.vlu, $regC.vlu, $regD.vlu, $regE.vlu, $regF.vlu, $regG.vlu, 
    					$regK.vlu, $regO.vlu, $regP.vlu, $regY.vlu, $regZ.vlu, @inst_mem, @data_mem]

		btn.connect(SEL_COMMAND, method(:onCmdAssemble))
	end

	# Create and show the main window
	def create
		super
		show(PLACEMENT_SCREEN)
	end
end

def onCmdAssemble(sender, sel, ptr)
	# Get text from editor

  txl = @input_text.text
  @state = {"$B" => $reg_B.text, "$D" => $reg_D.text, "$F" => $reg_F.text, 
  					"$K" => $reg_K.text, "$P" => $reg_P.text, "$Y" => $reg_Y.text, 
  					"$C" => $reg_C.text, "$E" => $reg_E.text, "$G" => $reg_G.text, 
  					"$O" => $reg_O.text, "$Z" => $reg_Z.text, "IMEM" => @inst_mem, "DMEM" => @inst_mem,}

  # Strip trailing spaces
  lines = txl.split("\n")
  lines.each { |line|
  	line.sub!(/ *$/, "")
  	@state = interpret(line, @state)
    $reg_B.text = @state["$B"]; $regB = @state["$B"]
    $reg_C.text = @state["$C"]; $regB = @state["$C"]
    $reg_D.text = @state["$D"]; $regB = @state["$D"]
    $reg_E.text = @state["$E"]; $regB = @state["$E"]
    $reg_F.text = @state["$F"]; $regB = @state["$F"]
    $reg_G.text = @state["$G"]; $regB = @state["$G"]
    $reg_K.text = @state["$K"]; $regB = @state["$K"]
    $reg_O.text = @state["$O"]; $regB = @state["$O"]
    $reg_P.text = @state["$P"]; $regB = @state["$P"]
    $reg_Y.text = @state["$Y"]; $regB = @state["$Y"]
    $reg_Z.text = @state["$Z"]; $regB = @state["$Z"]
    @inst_mem = @state["IMEM"]
    @data_mem = @state["DMEM"]
  	pc_0 = trans3to10(@state["$P"])
		pc_stop = pc_0 + 27
		memout = "#{pc_0}: " + @state["IMEM"].slice(pc_0..pc_stop) + "\r\n"
		@output_text.text = @output_text.text + memout
  	@prog_mem = @data_mem + "101010101" + @inst_mem
  	@tx_memory.text = @prog_mem
  	pc_0 = pc_stop
  	@state["$P"] = trans10to3(pc_0)
  }
end