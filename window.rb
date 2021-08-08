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
		# Add a bottom panel
		bpanel = FXHorizontalFrame.new(splitter_v, FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		@output_text = FXText.new(bpanel, self, LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 800,4,0,800, 400,400,400,0)

		# Add a left panel
		lpanel = FXHorizontalFrame.new(splitter_h, 
			FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		splitter_lpanel = FXSplitter.new(lpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		FXLabel.new(splitter_lpanel, "|%==========[ CODE EDITOR ]==========%|", :opts => JUSTIFY_CENTER_X ).setFont(FXFont.new(getApp(), "Consolas", 14, FONTWEIGHT_BOLD))

		@input_text = FXText.new(splitter_lpanel, self, 
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)

		# Center Button
		btn = FXButton.new(splitter_h, "=>\nRUN\n=>", nil,
			self, (ICON_ABOVE_TEXT|BUTTON_TOOLBAR|FRAME_RAISED|LAYOUT_TOP|LAYOUT_LEFT))

		# Add a right panel
		rpanel = FXHorizontalFrame.new(splitter_h, FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		reg_splitter = FXSplitter.new(rpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		FXLabel.new(reg_splitter, "Reg $B:")
		@reg_B = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regB.vlu)
		FXLabel.new(reg_splitter, "Reg $C:")
		@reg_C = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regC.vlu)
		FXLabel.new(reg_splitter, "Reg $D:")
		@reg_D = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regD.vlu)
		FXLabel.new(reg_splitter, "Reg $E:")
		@reg_E = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regE.vlu)
		FXLabel.new(reg_splitter, "Reg $F:")
		@reg_F = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regF.vlu)
		FXLabel.new(reg_splitter, "Reg $G:")
		@reg_G = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regG.vlu)
		FXLabel.new(reg_splitter, "Reg $K:")
		@reg_K = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regK.vlu)
		FXLabel.new(reg_splitter, "Reg $O:")
		@reg_O = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regO.vlu)
		FXLabel.new(reg_splitter, "Reg $P:")
		@reg_P = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regP.vlu)
		FXLabel.new(reg_splitter, "Reg $Y:")
		@reg_Y = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regY.vlu)
		FXLabel.new(reg_splitter, "Reg $Z:")
		@reg_Z = FXTextField.new(reg_splitter, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXT_READONLY).text = trans10to3($regZ.vlu)
		splitter_rpanel = FXSplitter.new(rpanel, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_VERTICAL|SPLITTER_TRACKING)
		FXLabel.new(splitter_rpanel, "Memory contents (data<0, inst>0):", :opts => JUSTIFY_CENTER_X ).setFont(FXFont.new(getApp(), "Consolas", 11, FONTWEIGHT_BOLD))
		@tx_memory = FXText.new(splitter_rpanel, self, TEXT_READONLY|
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,300,300, 0,0,0,0)

		# Now make the directory list widget (dirlist) the message target
		# for the text field. If you type a new directory name in the text
		# field the directory list should navigate to that directory.
		@tx_memory.visibleRows = 30
		@tx_memory.selector = FXWindow::ID_SETVALUE

		@input_text.target = @text_r
		@input_text.visibleRows = 30
		@input_text.selector = FXWindow::ID_SETVALUE

		btn.connect(SEL_COMMAND, method(:onCmdAssemble))
	end

	# Create and show the main window
	def create
		super
		show(PLACEMENT_SCREEN)
	end
end

def onCmdAssemble(sender, sel, ptr)
	#FXMessageBox.new(self, "About Image Viewer", nil, MBOX_OK|DECOR_TITLE|DECOR_BORDER).execute
	# Get text from editor
    txl = @input_text.text
    #txr = @text_r.text

    # Strip trailing spaces
    lines = txl.split("\n")
    lines.each { |line|
    	line.sub!(/ *$/, "")
    }
    interpret(lines)
    @tx_memory.text = lines.join("\r\n")
end
