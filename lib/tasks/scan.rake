namespace :scan do

	desc 'parse file'
  task :parse => :environment do
		r = Redis.new(host: Rails.configuration.redis['host'], port: Rails.configuration.redis['port'])
		key = Rails.configuration.redis['post_set_key']
    set_key = Rails.configuration.redis['tag_set_key']
    r.del(key)
    r.del(set_key)
    clear_all_tags(r)

		Dir[File.join(Rails.root, "posts", '*.md')].each do |file|
			file_name = file.split(File::SEPARATOR)[-1].sub('.md', '')
      md_content = []
      meta = {}
      File.readlines(file).each_with_index do |line, index|
        if index == 0
          meta = parse_meta(line)
          next if meta.blank? 
        else
          md_content.push line 
        end #if
      end
      unless meta.blank?
        puts "procssing #{file_name}"
        meta['file_name'] = file_name
        save_content_to_redis(r, file_name, md_content.join(), meta['tags'])
        parse_tags_and_save_to_redis(r, meta)
        r.zadd(key, File.mtime(file).to_datetime.to_i, JSON.dump(meta))
      end #unless
    end #each
  end #task

  def parse_meta(meta_str)
    required_fields = %w{title created}

    res = JSON.load(meta_str) rescue false
    if res 
      required_fields.each do |field|      
        if not res.key?(field)
          return {} 
        end #if
      end #each
    else
      return {}
    end #if 
    res
  end

  def parse_tags_and_save_to_redis(r, meta)
    puts "Parsing tags"
    set_key = Rails.configuration.redis['tag_set_key']
    meta['tags'].each do |tag|
      tag.strip!
      key = "#{Rails.configuration.redis['tag_prefix']}#{tag}"
      content = JSON.dump(meta)
      r.sadd?(key, content)
      puts("add tag #{tag} to redis")
      r.sadd?(set_key, tag)
    end #each
  end 

  def save_content_to_redis(r, file_name, content, tags)
    puts "add #{file_name}'s content to redis"
    key_prefix = Rails.configuration.redis['post_prefix']
    key = key_prefix + file_name
    r.set(key, JSON.dump({content: content, tags: tags})) 
  end

  def clear_all_tags(r)
    puts "Delete all the tags"
    pattern = "#{Rails.configuration.redis['tag_prefix']}*"
    r.keys(pattern).each do |key|
      puts "delete #{key}"
      r.del(key)
    end
  end

end
