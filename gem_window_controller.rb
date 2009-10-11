# gem_window_controller.rb
# GemManage
#
# Created by Luke van der Hoeven on 10/10/09.
# Copyright 2009 HungerAndThirst Productions. All rights reserved.

class GemWindowController < NSWindowController

  #windows for the application
	attr_accessor :add_sheet, :info_sheet, :main_window		
  #gem list table
	attr_accessor :gemTableView
  #inputs for adding a gem
	attr_accessor :add_name, :add_version, :add_source, :add_docs
  #outputs for
	attr_accessor:info_name, :info_curr_ver, :info_vers, :gem_nums
	
	def awakeFromNib
		get_all_gems
		@gem_nums.stringValue = @gem_nums.stringValue.sub("x", @gems.size.to_s)
	end
  
  # when the window is being closed, close the game
  # this is called because we setup a delegation from the window to this controller
  def windowWillClose(sender)
   exit
  end
	
	def get_all_gems
		@gems = Gem.cache.map{|gem_data| GemInfo.new(gem_data)}
		@gemTableView.dataSource = self
	end
	
	def info(sender)
		select = @gems[@gemTableView.selectedRow]
		@info_name.stringValue = select.name
		@info_curr_ver.stringValue = select.version
		@info_vers.stringValue = select.versions
	
		NSApp.beginSheet(@info_sheet, 
			modalForWindow:@main_window, 
			modalDelegate:self, 
			didEndSelector:"gem_info",
			contextInfo:nil)			
	end

	def add(sender)
		NSApp.beginSheet(@add_sheet, 
			modalForWindow:@main_window, 
			modalDelegate:self, 
			didEndSelector:"added_gem",
			contextInfo:nil)
	end
	
	def close_info(sender)
		@info_sheet.orderOut(nil)
    NSApp.endSheet(@info_sheet)
	end

	def close_add(sender)
		get_all_gems
		@add_sheet.orderOut(nil)
    NSApp.endSheet(@add_sheet)
	end
	
	def gem_info
   # temp hack
	end
	
	def update(sender)
		select_name = @gems[@gemTableView.selectedRow].name
		output = `gem update #{select_name}`
		puts output
		
		get_all_gems
	end
	
	def added_gem
		gem_name = @add_name.stringValue
		version = "--version \"= #{@add_version.stringValue}\""
		source = "--source #{@add_source.stringValue}"
		@add_docs.stringValue == "1" ? docs = "" : docs = "--no-rdoc --no-ri"

		action_str = "#{gem_name} #{docs}" 

		if version != "--version "
			action_str += " #{version}"
		end
		
		if source != "--source "
			action_str += " #{source}"
		end
		
		output = `macgem install #{action_str}`
		puts output
	end

	def numberOfRowsInTableView(view)
    @gems.size
  end

  def tableView(view, objectValueForTableColumn:column, row:index)
    gem = @gems[index]
    puts @gems[index]
    case column.identifier
      when 'name'
        gem.name
      when 'version'
        gem.version
    end
  end
	
	def remove(sender)
		select_name = @gems[@gemTableView.selectedRow].name
		`gem uninstall #{select_name}`
	end
end