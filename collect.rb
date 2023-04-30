#require 'dbm'
require 'ruby-progressbar'
require 'mongo'
require 'digest/md5'

#db = DBM.open('data/dbm.db', 0666, DBM::WRCREAT)

Mongo::Logger.logger.level = Logger::FATAL
client = Mongo::Client.new('mongodb://127.0.0.1:27017/commits')
collection = client[:commits]


i = 0

count = Dir['data/commits/**/*'].count

progressbar = ProgressBar.create(:starting_at 	=> 0, 
					:total 			=> count,
					:format         => "%a %b\u{15E7}%i %p%% %t (%c/%C)",
                    :progress_mark  => ' ',
                    :remainder_mark => "\u{FF65}")

Dir.foreach("data/commits") do |file| 
	next if file !~ /txt$/

	content = IO.read("data/commits/#{file}")
	#p file
	content.encode('UTF-8', :invalid => :replace).split("\n").each do |line|
		#db[line] = (db[line] && db[line].to_i + 1) || 1;

		key = Digest::MD5.hexdigest(line)
		collection.update_one(
	      { key: key },
	      { '$set' => { key: key, line: line} },
	      { upsert: true }
	    )

	end
	i += 1
	#p '.' if i%100 == 0
	progressbar.increment	
end

p db.count