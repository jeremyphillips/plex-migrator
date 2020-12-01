#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

options = YAML.load_file('config.yaml')

srcDir  = File.dirname(__FILE__) + options['src_dir']
destDir = File.dirname(__FILE__) + options['dest_dir']

def clean(name)
	# remove spaces. remove special chars and convert to lowercase
	clean = name.gsub(/\(.*\)/, "").gsub!(/[^0-9A-Za-z]/, '').downcase
    return clean
end

movieDirArr = {}
Dir.foreach(srcDir) do |moviePath|
	# if is dir
	if !File.directory?(moviePath) then
		cleanName = clean(File.basename(moviePath))
		fullPath = srcDir + '/' + moviePath
		# puts fullPath
		movieDirArr[cleanName] = fullPath
	end	  
end

# Loop through my txt file of movie wants and create an array of movie paths which exist in src dir
dirList = File.dirname(__FILE__) + options['dir_list']
movieExistsArr = []
movieNotExistsArr = []

File.readlines(dirList).each do |want|
	wantClean = clean(want)
	exists = movieDirArr.include? wantClean

	if exists
		movieExistsArr.push(movieDirArr[wantClean])
	else
		movieNotExistsArr.push(want)
	end	
end

# Log movies that do not exist in srcDir
p movieNotExistsArr.count.to_s + ' movies not found:'
movieNotExistsArr.each do |noMovie|
	p noMovie
end

# Log movie count that do exist in srcDir
p movieExistsArr.count.to_s + ' movies found.'

# Loop through array of movie wants which exist and recursively copy dirs to destination dir
movieExistsArr.each do |movieDir|
	destinationDir = movieDir.gsub(srcDir, destDir)
	FileUtils.copy_entry(movieDir, destinationDir )
	message = 'Copying ' + movieDir + ' to ' + destinationDir
	p message
end