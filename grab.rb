require 'json'
require 'rest-client'

repos = RestClient.get('https://api.github.com/repositories')
repos = JSON.parse(repos)

repos.each do |repo| 
	cmd = "./get-repo-commits.sh #{repo['html_url']}"
	`#{cmd}`
	File.open("data/commits/#{repo['full_name'].gsub('/','-')}.json", 'w') { |f| f.write(JSON.pretty_generate(repo)) }
	
end

