module ApplicationHelper

	def nav_link(name, path)
		classes = nav_link_class(path)
		link_to name, path, class: classes
	end

	private

	def nav_link_class(path)
		base = "transition text-[16px] font-medium"
		active = "text-primary font-semibold underline"
		inactive = "text-muted hover:text-primary hover:underline"

		current_page?(path) ? "#{base} #{active}" : "#{base} #{inactive}"
	end
end
