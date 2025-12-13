
project = Project.find_by(slug: '최애의-사인')
doc = project.blog_posts.find_by(category: 'overview')
content = doc.content

# Regex to find the 2-column layout block
# Matches <div class="layout-row"> ... </div>
# We assume the structure is fairly standard based on previous inspection
regex = /<div class="layout-row">\s*<div class="layout-col">\s*(.*?)\s*<\/div>\s*<div class="layout-col">\s*(.*?)\s*<\/div>\s*<\/div>/m

if match = content.match(regex)
  full_match = match[0]
  col1_content = match[1]
  col2_content = match[2]

  # In col2, separate the image from the text
  # Assume image is first: ![Image](url)
  # Then text follows
  img_regex = /(!\[.*?\]\(.*?\))/m
  
  if img_match = col2_content.match(img_regex)
    img = img_match[1]
    text = col2_content.sub(img_regex, '').strip
    
    # Reconstruct
    new_block = <<~HTML
    <div class="layout-row">
    <div class="layout-col">
    #{col1_content}
    </div>
    <div class="layout-col">
    #{img}
    </div>
    </div>
    
    #{text}
    HTML
    
    new_content = content.replace(full_match, new_block.strip)
    doc.update!(content: new_content)
    puts "Successfully moved text out of column."
  else
    puts "Could not find image in col2"
  end
else
  puts "Could not match layout-row structure"
  puts content.inspect
end
