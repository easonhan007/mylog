module ApplicationHelper
	def to_html(md_file)
    return nil if not md_file
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      tables: true,
      no_intra_emphasis: true,
      hard_wrap: true,
      underline: true,
      lax_spacing: true
    )
    markdown.render(md_file)
  end

end
