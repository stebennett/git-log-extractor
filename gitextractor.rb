#!/usr/bin/env ruby

require "optparse"
require 'git'
require 'logger'
require 'csv'

CSV_HEADERS = ["Repository", "Commit Timestamp", "Commit SHA", "Author Nme", "Author Email", "Commit Message", "Filename", "Jira Ticket"]

directory = nil
outputfile = 'output.csv'
since = '1970-01-01'
count = 1000

OptionParser.new do |parser|
  parser.banner = "Usage: jiracollector [options]"
  parser.on("-d", "--directory DIRECTORY", "The cloned repository to scan") { |d| directory = d }
  parser.on("-s", "--since TIMESTAMP", "A timestamp to fetch items from (default #{since})") { |t| since = t }
  parser.on("-c", "--count COUNT", "The number of commits to fetch (default #{count})") { |c| count = c }
  parser.on("-f", "--file FILE", "The output file (default #{outputfile})") { |f| outputfile = f }
  parser.on("-h", "--help", "Shows help") { || puts parser; exit }
end.parse!

if directory.nil?
  abort('Input directory must be specified')
end

# Get commits
g = Git.open(directory)
repository = g.remote.url
commits = g.log(count).since(since)

csvfile = CSV.open(outputfile, 'w', :force_quotes => true)
csvfile << CSV_HEADERS

$i = 0
while $i < commits.size() do
  current_commit = commits[$i]
  prev_commit = commits[$i+1]
  diff = g.diff(current_commit, prev_commit)

  diff.stats[:files].each { |file|
    jira_tickets = commits[$i].message.scan(/[A-Z]+\-[0-9]+/)
    if jira_tickets.empty?
      jira_tickets = ['']
    end
    jira_tickets.each { |jira_ticket|
      csvfile << [repository, commits[$i].author_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z'), commits[$i].sha, commits[$i].author.name, commits[$i].author.email, commits[$i].message, file[0], jira_ticket] 
      puts "Processing commit #{commits[$i].sha} on #{file[0]}"
    }
  }
  $i += 1
end