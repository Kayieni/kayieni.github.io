require 'yaml'

# Read enabled sections and personal info from _config.yml
config = YAML.load_file('_config.yml')

section_map = {
  'resume_section_experience'   => {file: 'experience.yml',   title: 'Experience'},
  'resume_section_education'    => {file: 'education.yml',    title: 'Education'},
  'resume_section_skills'       => {file: 'skills.yml',       title: 'Skills'},
  'resume_section_projects'     => {file: 'projects.yml',     title: 'Projects'},
  'resume_section_recognition'  => {file: 'recognitions.yml', title: 'Recognitions'},
  'resume_section_links'        => {file: 'links.yml',        title: 'Links'},
  'resume_section_associations' => {file: 'associations.yml', title: 'Associations'},
  'resume_section_interests'    => {file: 'interests.yml',    title: 'Interests'}
}

def load_yaml(file)
  YAML.load_file(File.join('_data', file))
end

# Build header from config
output = []
output << "# #{config['resume_name'] || 'Name'}"
output << "**#{config['resume_title']}**" if config['resume_title']
output << ""
if config['resume_header_contact_info']
  output << config['resume_header_contact_info']
end
if config['resume_contact_email'] || config['resume_contact_telephone'] || config['resume_contact_address']
  output << ""
  output << "**Email:** #{config['resume_contact_email']}" if config['resume_contact_email']
  output << "**Phone:** #{config['resume_contact_telephone']}" if config['resume_contact_telephone']
  output << "**Address:** #{config['resume_contact_address']}" if config['resume_contact_address']
end
output << ""
if config['resume_header_intro']
  # Remove HTML tags for Markdown output
  intro = config['resume_header_intro'].gsub(/<[^>]+>/, '')
  output << intro
  output << ""
end

# Social links
if config['resume_social_links']
  social = config['resume_social_links']
  links = []
  links << "[GitHub](#{social['resume_github_url']})" if social['resume_github_url']
  links << "[LinkedIn](#{social['resume_linkedin_url']})" if social['resume_linkedin_url']
  links << "[Website](#{social['resume_website_url']})" if social['resume_website_url']
  links << "[Medium](#{social['resume_medium_url']})" if social['resume_medium_url']
  output << "**Social:** " + links.join(' | ') unless links.empty?
  output << ""
end

section_map.each do |config_key, info|
  enabled = config[config_key]
  next unless enabled == true || enabled == 'true'
  file = info[:file]
  title = info[:title]
  next unless File.exist?(File.join('_data', file))
  data = load_yaml(file)
  output << "## #{title}\n"
  case file
  when 'experience.yml'
    data.each do |job|
      output << "### #{job['position']} at #{job['company']}"
      output << "*#{job['duration']}*  "
      output << job['summary'].to_s
      output << ""
    end
  when 'education.yml'
    data.each do |edu|
      output << "### #{edu['degree']}"
      output << "#{edu['uni']}  "
      output << "*#{edu['year']}*  "
      output << edu['summary'].to_s
      output << ""
    end
  when 'skills.yml'
    data.each do |skill|
      output << "- **#{skill['skill']}**: #{skill['description']}"
    end
    output << ""
  when 'projects.yml'
    data.each do |proj|
      output << "- **#{proj['project']}**: #{proj['description']}"
    end
    output << ""
  when 'recognitions.yml'
    data.each do |rec|
      output << "- **#{rec['award']}** (#{rec['year']}), #{rec['organization']}: #{rec['summary']}"
    end
    output << ""
  when 'associations.yml'
    data.each do |assoc|
      output << "- **#{assoc['organization']}** (#{assoc['year']}), #{assoc['role']}: #{assoc['summary']}"
    end
    output << ""
  when 'interests.yml'
    data.each do |interest|
      output << "- #{interest['description']}"
    end
    output << ""
  when 'links.yml'
    data.each do |link|
      output << "- [#{link['description']}](#{link['url']})"
    end
    output << ""
  end
end

File.write('cv.md', output.join("\n"))
puts "cv.md generated!"