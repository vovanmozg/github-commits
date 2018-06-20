require 'json'
require 'rest-client'

def get_page
	last_id = IO.read('data/last_id.txt')

	repos = RestClient.get("https://api.github.com/repositories?since=#{last_id}")
	repos = JSON.parse(repos)

	repos.each do |repo| 
		cmd = "./get-repo-commits.sh #{repo['html_url']}"
		code = repo['full_name'].gsub('/','-')
		json_file = "data/commits/#{code}.json"

		if File.exist? json_file
			p "skip #{repo['html_url']}"
		else
			`#{cmd}`
			File.open(json_file, 'w') { |f| f.write(JSON.pretty_generate(repo)) }
		end
		IO.write('data/last_id.txt', repo['id'])
	end
end

while(true) do
	get_page	
end
