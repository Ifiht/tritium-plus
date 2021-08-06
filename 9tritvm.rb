require 'fox16'

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
		super(app, "8-bit VM", :opts => DECOR_ALL, :width => 800, :height => 600)

		@newicon = loadIcon("merry.png")
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
		splitter = FXSplitter.new(self,
			LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_HORIZONTAL|SPLITTER_TRACKING)

		# Add a left panel
		lpanel = FXHorizontalFrame.new(splitter, 
			FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		@input_text = FXText.new(lpanel, self, 
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)

		# Center Button
		btn = FXButton.new(splitter, "=>\nRUN\n=>", nil,
			self, (ICON_ABOVE_TEXT|BUTTON_TOOLBAR|FRAME_RAISED|LAYOUT_TOP|LAYOUT_LEFT))

		# Add a right panel
		rpanel = FXHorizontalFrame.new(splitter, 
			FRAME_SUNKEN|FRAME_THICK|LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)
		@reg_B = FXTextField.new(rpanel, 8, self, FRAME_SUNKEN|FRAME_THICK|
      	LAYOUT_FILL_X|LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|TEXTFIELD_READONLY)
		@tx_memory = FXText.new(rpanel, self, TEXT_READONLY|
			LAYOUT_LEFT|LAYOUT_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 400,400,400,400, 0,0,0,0)

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
    lines = txl.split('\n')
    lines.each { |line|
    	line.sub!(/ *$/, "")
    	#line.sub!(/ *\n/, "")
    }
    @tx_memory.text = lines.join('\n')
end

def run
  # Make application
  application = FXApp.new("DirList", "FoxTest")

  # Make window
  EightBitVM.new(application)

  # Create app
  application.create

  # Run
  application.run
end

run